class PatientsController < ApplicationController
  before_action :set_patient, only: [ :show, :edit, :update, :destroy ]

  def index
    @patients = current_user.patients.order(:name)

    if params[:search].present?
      @patients = @patients.search_by(params[:search])
    end
  end

  def new
    @patient = current_user.patients.build
  end

  def create
    @patient = current_user.patients.build(patient_params)

    if @patient.save
      redirect_to @patient, notice: t("patients.flash.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @patient.update(patient_params)
      redirect_to @patient, notice: t("patients.flash.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @patient.discard!
    redirect_to patients_path, notice: t("patients.flash.deleted")
  end

  private

  def set_patient
    @patient = current_user.patients.find(params[:id])
  end

  def patient_params
    params.require(:patient).permit(:nik, :name, :birth_date, :gender, :address, :phone, :blood_type, :allergies)
  end
end
