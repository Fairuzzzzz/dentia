class VisitsController < ApplicationController
  before_action :set_visit, only: [ :edit, :update, :update_status ]

  def index
    @visits = Visit.joins(:patient).where(patients: { user_id: current_user.id }).includes(patient: :medical_records).order(visit_date: :desc)

    if params[:status].present?
      @visits = @visits.where(status: params[:status])
    end

    if params[:start_date].present?
      @visits = @visits.where("visit_date >= ?", params[:start_date].to_date.beginning_of_day)
    end

    if params[:end_date].present?
      @visits = @visits.where("visit_date <= ?", params[:end_date].to_date.end_of_day)
    end

    if params[:search].present?
      @visits = @visits.joins(:patient).where("patients.name ILIKE :q OR patients.nik ILIKE :q OR visits.visit_number ILIKE :q", q: "%#{params[:search]}%")
    end
  end

  def new
    @visit = Visit.new
    @visit.visit_date = Time.current
    @visit.build_medical_record
    @visit.medical_record.build_subjective_examination
    @visit.medical_record.build_objective_examination
    @visit.medical_record.build_assessment
    @visit.medical_record.build_plan

    if params[:patient_id].present?
      @patient = current_user.patients.find(params[:patient_id])
      @visit.patient = @patient
    end
  end

  def create
    @visit = Visit.new(visit_params)
    @visit.status = "registered"

    if @visit.save
      redirect_to edit_visit_path(@visit), notice: t("visits.flash.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    build_missing_components
  end

  def update
    if @visit.update(visit_params)
      redirect_to edit_visit_path(@visit), notice: t("visits.flash.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update_status
    if @visit.update(status: params[:status])
      redirect_to visits_path, notice: t("visits.flash.status_updated")
    else
      redirect_to visits_path, alert: "Gagal memperbarui status"
    end
  end

  def print_prescription
    @visit = Visit.joins(:patient).where(patients: { user_id: current_user.id }).includes(:patient, medical_record: { plan: :prescriptions }).find(params[:id])
    @doctor = current_user
    @plan = @visit.medical_record&.plan

    pdf = Prawn::Document.new(page_size: "A5", margin: [ 30, 30, 30, 30 ])

    # Header
    pdf.text @doctor.clinic_name.presence || "KLINIK GIGI", size: 14, style: :bold
    pdf.text "SIP: #{@doctor.sip_number}" if @doctor.sip_number.present?
    pdf.text @doctor.clinic_address if @doctor.clinic_address.present?
    pdf.text "Telp: #{@doctor.clinic_phone}" if @doctor.clinic_phone.present?
    pdf.move_down 10

    # Patient info
    pdf.text "Tanggal: #{Date.current.strftime('%d/%m/%Y')}", size: 10
    pdf.text "Pasien: #{@visit.patient.name}"
    pdf.text "No. RM: #{@visit.patient.patient_number}"
    pdf.move_down 10

    # Separator
    pdf.stroke_horizontal_rule
    pdf.move_down 10

    # Prescriptions
    if @plan&.prescriptions&.any?
      @plan.prescriptions.each do |pres|
        pdf.text "R/  #{pres.drug_name} #{pres.dosage}", size: 11
        pdf.text "    #{pres.frequency} selama #{pres.duration}", size: 10, indent_paragraphs: 20
        pdf.text "    (#{pres.notes})", size: 9, indent_paragraphs: 20 if pres.notes.present?
        pdf.move_down 8
      end
    else
      pdf.text "Tidak ada resep", size: 10, style: :italic
    end

    pdf.move_down 20
    pdf.stroke_horizontal_rule
    pdf.move_down 20
    pdf.text "#{@doctor.name}", size: 11, align: :right

    send_data pdf.render, filename: "resep-#{@visit.visit_number}.pdf", type: "application/pdf"
  end

  private

  def set_visit
    @visit = Visit.joins(:patient).where(patients: { user_id: current_user.id }).find(params[:id])
  end

  def visit_params
    params.require(:visit).permit(
      :patient_id, :visit_date, :chief_complaint,
      medical_record_attributes: [
        :id,
        subjective_examination_attributes: [ :id, :chief_complaint, :present_illness_history ],
        objective_examination_attributes: [
          :id, :systole, :diastole, :heart_rate, :consciousness,
          :respiration_rate, :height, :weight, :body_temperature,
          :waist_circumference, :bmi, :physical_examination,
          :supporting_action, :lab_result_notes,
          odontogram_attributes: [:id, :teeth_data, :notes]
        ],
        assessment_attributes: [ :id, :icd_code, :diagnosis, :diagnosis_notes ],
        plan_attributes: [
          :id, :follow_up_plan, :next_visit_date,
          prescriptions_attributes: [ :id, :drug_name, :dosage, :frequency, :duration, :notes, :_destroy ],
          plan_treatments_attributes: [ :id, :treatment_catalog_id, :tooth_number, :quantity, :price, :notes, :_destroy ]
        ]
      ]
    )
  end

  def build_missing_components
    mr = @visit.medical_record || @visit.build_medical_record
    mr.save! if mr.new_record?

    mr.create_subjective_examination! unless mr.subjective_examination
    mr.create_objective_examination! unless mr.objective_examination
    mr.objective_examination.create_odontogram! unless mr.objective_examination.odontogram
    mr.create_assessment! unless mr.assessment
    mr.create_plan! unless mr.plan

    @visit.reload
  end
end
