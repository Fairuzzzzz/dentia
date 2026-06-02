class VisitsController < ApplicationController
  before_action :set_visit, only: [ :edit, :update, :update_status ]

  def index
    @visits = Visit.includes(patient: :medical_records).order(visit_date: :desc)

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
      @patient = Patient.find(params[:patient_id])
      @visit.patient = @patient
    end
  end

  def create
    @visit = Visit.new(visit_params)
    @visit.status = "registered"

    if @visit.save
      redirect_to edit_visit_path(@visit), notice: "Kunjungan berhasil dibuat"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    build_missing_components
  end

  def update
    if @visit.update(visit_params)
      redirect_to edit_visit_path(@visit), notice: "Rekam medis berhasil disimpan"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update_status
    if @visit.update(status: params[:status])
      redirect_to visits_path, notice: "Status kunjungan berhasil diperbarui"
    else
      redirect_to visits_path, alert: "Gagal memperbarui status"
    end
  end

  private

  def set_visit
    @visit = Visit.find(params[:id])
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
          :supporting_action, :lab_result_notes
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
    mr.create_assessment! unless mr.assessment
    mr.create_plan! unless mr.plan

    @visit.reload
  end
end
