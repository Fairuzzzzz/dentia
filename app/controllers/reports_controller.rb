class ReportsController < ApplicationController
  include ActionView::Helpers::NumberHelper

  def index
    @start_date = (params[:start_date].presence || Date.current.beginning_of_month).to_date
    @end_date = (params[:end_date].presence || Date.current.end_of_month).to_date

    visits = Visit.where(visit_date: @start_date.beginning_of_day..@end_date.end_of_day)
    billings = Billing.where(created_at: @start_date.beginning_of_day..@end_date.end_of_day)
    patients = Patient.where(created_at: @start_date.beginning_of_day..@end_date.end_of_day)

    @total_visits = visits.count
    @new_patients = patients.count
    @total_revenue = billings.where(payment_status: "paid").sum(:total_amount)
    @unpaid_revenue = billings.where(payment_status: "unpaid").sum(:total_amount)
    @visits_by_day = visits.group("DATE(visit_date)").count.sort.to_h
    @max_daily_visits = [ @visits_by_day.values.max, 1 ].max
    @top_treatments = PlanTreatment.joins(plan: { medical_record: :visit }).where(visits: { visit_date: @start_date.beginning_of_day..@end_date.end_of_day }).group(:treatment_catalog_id).sum(:quantity).sort_by { |_, v| -v }.first(10).map { |id, qty| [ TreatmentCatalog.find(id)&.name || "Unknown", qty ] }
  end

  def export_pdf
    @start_date = parse_date(params[:start_date], Date.current.beginning_of_month)
    @end_date = parse_date(params[:end_date], Date.current.end_of_month)
    load_report_data

    pdf = Prawn::Document.new
    title = "LAPORAN KLINIK GIGI"
    period = "Periode: #{@start_date.strftime('%d/%m/%Y')} - #{@end_date.strftime('%d/%m/%Y')}"

    pdf.text title, size: 18, style: :bold, align: :center
    pdf.text period, size: 10, align: :center
    pdf.move_down 20

    pdf.text "Ringkasan", size: 14, style: :bold
    pdf.move_down 5

    pdf.text "Total Kunjungan: #{@total_visits}", size: 11
    pdf.text "Pasien Baru: #{@new_patients}", size: 11
    pdf.text "Pendapatan Lunas: Rp #{number_with_delimiter(@total_revenue.to_i)}", size: 11
    pdf.text "Belum Dibayar: Rp #{number_with_delimiter(@unpaid_revenue.to_i)}", size: 11
    pdf.move_down 15

    pdf.text "10 Tindakan Terbanyak", size: 14, style: :bold
    pdf.move_down 5

    table_data = [ [ "No", "Tindakan", "Jumlah" ] ] + @top_treatments.each_with_index.map { |(name, qty), i| [ (i + 1).to_s, name, qty.to_s ] }
    pdf.table(table_data, header: true, width: pdf.bounds.width, column_widths: [ 30, nil, 50 ]) do |t|
      t.row(0).font_style = :bold
      t.row(0).background_color = "eeeeee"
    end

    send_data pdf.render, filename: "laporan-#{@start_date}-#{@end_date}.pdf", type: "application/pdf"
  end

  def export_excel
    @start_date = parse_date(params[:start_date], Date.current.beginning_of_month)
    @end_date = parse_date(params[:end_date], Date.current.end_of_month)
    load_report_data

    package = Axlsx::Package.new
    wb = package.workbook

    wb.add_worksheet(name: "Ringkasan") do |sheet|
      sheet.add_row [ "LAPORAN KLINIK GIGI" ]
      sheet.add_row [ "Periode: #{@start_date} - #{@end_date}" ]
      sheet.add_row []
      sheet.add_row [ "Total Kunjungan", @total_visits ]
      sheet.add_row [ "Pasien Baru", @new_patients ]
      sheet.add_row [ "Pendapatan Lunas", @total_revenue ]
      sheet.add_row [ "Belum Dibayar", @unpaid_revenue ]
    end

    wb.add_worksheet(name: "Detail Kunjungan") do |sheet|
      sheet.add_row [ "No. Kunjungan", "Pasien", "Tanggal", "Status" ]
      Visit.where(visit_date: @start_date.beginning_of_day..@end_date.end_of_day)
        .includes(:patient).find_each do |v|
        sheet.add_row [ v.visit_number, v.patient.name, v.visit_date.strftime("%d/%m/%Y %H:%M"), v.status.humanize ]
      end
    end

    wb.add_worksheet(name: "Detail Tindakan") do |sheet|
      sheet.add_row [ "Kunjungan", "Pasien", "Tindakan", "Gigi", "Qty", "Harga", "Total" ]
      PlanTreatment.joins(plan: { medical_record: :visit })
        .where(visits: { visit_date: @start_date.beginning_of_day..@end_date.end_of_day })
        .includes(plan: { medical_record: { visit: :patient } }).find_each do |pt|
        sheet.add_row [
          pt.plan.medical_record.visit.visit_number,
          pt.plan.medical_record.visit.patient.name,
          pt.treatment_catalog&.name,
          pt.tooth_number,
          pt.quantity,
          pt.price,
          pt.price.to_i * pt.quantity.to_i
        ]
      end
    end

    wb.add_worksheet(name: "Pendapatan per Tindakan") do |sheet|
      sheet.add_row [ "Tindakan", "Jumlah", "Total Pendapatan" ]
      PlanTreatment.joins(plan: { medical_record: :visit })
        .where(visits: { visit_date: @start_date.beginning_of_day..@end_date.end_of_day })
        .group(:treatment_catalog_id).sum("price * quantity").sort_by { |_, v| -v }.each do |id, total|
        sheet.add_row [ TreatmentCatalog.find(id)&.name, "", total ]
      end
    end

    send_data package.to_stream.read, filename: "laporan-#{@start_date}-#{@end_date}.xlsx"
  end

  private

  def parse_date(value, default)
    value.present? ? Date.parse(value.to_s) : default

    rescue Date::Error, ArgumentError
      default
  end

  def load_report_data
    visits = Visit.where(visit_date: @start_date.beginning_of_day..@end_date.end_of_day)
    billings = Billing.where(created_at: @start_date.beginning_of_day..@end_date.end_of_day)

    @total_visits = visits.count
    @new_patients = Patient.where(created_at: @start_date.beginning_of_day..@end_date.end_of_day).count
    @total_revenue = billings.where(payment_status: "paid").sum(:total_amount)
    @unpaid_revenue = billings.where(payment_status: "unpaid").sum(:total_amount)
    @visits_by_day = visits.group("DATE(visit_date)").count.sort.to_h
    @max_daily_visits = [ @visits_by_day.values.max, 1 ].max

    @top_treatments = PlanTreatment
      .joins(plan: { medical_record: :visit })
      .where(visits: { visit_date: @start_date.beginning_of_day..@end_date.end_of_day })
      .group(:treatment_catalog_id)
      .sum(:quantity)
      .sort_by { |_, v| -v }
      .first(10)
      .map { |id, qty| [ TreatmentCatalog.find(id)&.name || "Unknown", qty ] }
  end
end
