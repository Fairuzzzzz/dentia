class PatientsController < ApplicationController
  before_action :set_patient, only: [ :show, :edit, :update, :destroy ]

  def index
    @patients = Patient.order(:name)

    if params[:search].present?
      @patients = @patients.search_by(params[:search])
    end
  end

  def new
    @patient = Patient.new
  end

  def create
    @patient = Patient.new(patient_params)

    if @patient.save
      redirect_to @patient, notice: "Pasien berhasil ditambahkan"
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
      redirect_to @patient, notice: "Data pasien berhasil diperbaharuis"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @patient.discard!
    redirect_to patients_path, notice: "Pasien berhasil dihapus"
  end

  private

  def set_patient
    @patient = Patient.find(params[:id])
  end

  def patient_params
    params.require(:patient).permit(:nik, :name, :birth_date, :gender, :address, :phone, :blood_type, :allergies)
  end
end
