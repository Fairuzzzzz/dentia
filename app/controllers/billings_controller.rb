class BillingsController < ApplicationController
  include ActionView::Helpers::NumberHelper

  before_action :set_billing, only: [ :show, :mark_as_paid, :print_invoice ]

  def index
    @billings = Billing.joins(visit: :patient).where(patients: { user_id: current_user.id }).includes(visit: :patient).order(created_at: :desc)

    if params[:status].present?
      @billings = @billings.where(payment_status: params[:status])
    end

    if params[:search].present?
      @billings = @billings.joins(visit: :patient).where("patients.name ILIKE :q OR patients.nik ILIKE :q", q: "%#{params[:search]}%")
    end
  end

  def show
  end

  def mark_as_paid
    if @billing.update(payment_status: "paid", paid_at: Time.current, payment_method: params[:payment_method])
      redirect_to @billing, notice: t("billings.flash.paid")
    else
      redirect_to @billing, alert: t("billings.flash.paid_error")
    end
  end

  def print_invoice
    @billing = Billing.joins(visit: :patient).where(patients: { user_id: current_user.id }).includes(visit: { patient: nil }, billing_items: :plan_treatment).find(params[:id])
    @doctor = current_user
    pdf = Prawn::Document.new(page_size: "A4", margin: [ 40, 40, 40, 40 ])

    # Header Klinik
    pdf.text @doctor.clinic_name.presence || "KLINIK GIGI", size: 16, style: :bold, align: :center
    pdf.text @doctor.clinic_address, size: 10, align: :center if @doctor.clinic_address.present?
    pdf.text "Telp: #{@doctor.clinic_phone}", size: 10, align: :center if @doctor.clinic_phone.present?
    pdf.move_down 15

    pdf.text "KWITANSI PEMBAYARAN", size: 14, style: :bold, align: :center
    pdf.move_down 10
    pdf.stroke_horizontal_rule
    pdf.move_down 10

    # Info
    pdf.text "No. : #{@billing.visit.visit_number}", size: 11
    pdf.text "Tanggal : #{@billing.created_at.strftime('%d/%m/%Y')}", size: 11
    pdf.text "Pasien : #{@billing.visit.patient.name}", size: 11
    pdf.text "No. RM : #{@billing.visit.patient.patient_number}", size: 11
    pdf.move_down 10
    pdf.stroke_horizontal_rule
    pdf.move_down 10

    # Table items
    table_data = [ [ "Tindakan", "Jumlah", "Harga", "Total" ] ]
    @billing.billing_items.each do |item|
      table_data << [
        item.treatment_name,
        item.quantity.to_s,
        "Rp #{number_with_delimiter(item.unit_price.to_i)}",
        "Rp #{number_with_delimiter(item.total_price.to_i)}"
      ]
    end
    table_data << [ "TOTAL", "", "", "Rp #{number_with_delimiter(@billing.total_amount.to_i)}" ]

    pdf.table(table_data, header: true, width: pdf.bounds.width, column_widths: [ nil, 50, 90, 100 ]) do |t|
      t.row(0).font_style = :bold
      t.row(0).background_color = "eeeeee"
      t.rows(-1).font_style = :bold
      t.rows(-1).background_color = "f5f5f5"
      t.cells.borders = [ :bottom ]
      t.cells.padding = [ 5, 8, 5, 8 ]
    end

    pdf.move_down 10
    pdf.text "Metode Pembayaran: #{@billing.payment_method&.humanize || '-'}", size: 11
    pdf.move_down 10
    pdf.stroke_horizontal_rule
    pdf.move_down 30
    pdf.text "#{@doctor.name}", size: 11, align: :right

    send_data pdf.render, filename: "kwitansi-#{@billing.visit.visit_number}.pdf", type: "application/pdf"
  end

  private

  def set_billing
    @billing = Billing.joins(visit: :patient).where(patients: { user_id: current_user.id }).includes(visit: { patient: nil }, billing_items: :plan_treatment).find(params[:id])
  end
end
