class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [ :edit, :update, :destroy, :update_status ]

  def index
    @month = (params[:month] || Date.current.month).to_i
    @year = (params[:year] || Date.current.year).to_i
    @date = Date.new(@year, @month, 1)
    @appointments = Appointment.where("appointment_date >= ? AND appointment_date < ?", @date.beginning_of_month.beginning_of_week, @date.end_of_month.end_of_week).includes(:patient)
  end

  def new
    @appointment = Appointment.new
    @appointment.appointment_date = params[:date].presence&.to_datetime || Time.current
  end

  def create
    @appointment = Appointment.new(appointment_params)

    if @appointment.save
      redirect_to appointments_path, notice: "Penjadwalan berhasil dibuat"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @appointment.update(appointment_params)
      redirect_to appointments_path, notice: "Penjadwalan berhasil diperbarui"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @appointment.destroy!
    redirect_to appointments_path, notice: "Penjadwalan berhasil dihapus"
  end

  def update_status
    @appointment.update(status: params[:status])
    redirect_to appointments_path, notice: "Status berhasil diperbarui"
  end

  private

  def set_appointment
    @appointment = Appointment.find(params[:id])
  end

  def appointment_params
    params.require(:appointment).permit(:patient_id, :appointment_date, :purpose, :notes, :status)
  end
end
