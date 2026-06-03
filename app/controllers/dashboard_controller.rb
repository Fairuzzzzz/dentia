class DashboardController < ApplicationController
  def index
    @today_visits = Visit.where(visit_date: Date.current.all_day).order(visit_date: :asc)
    @today_appointments = Appointment.where(appointment_date: Date.current.all_day).order(appointment_date: :asc)
    @today_visit_count = @today_visits.count
    @today_appointment_count = @today_appointments.count
    @new_patients_this_month = Patient.where("created_at >= ?", Date.current.beginning_of_month).count
    @today_revenue = Billing.where(payment_status: "paid", paid_at: Date.current.all_day).sum(:total_amount)
    @upcoming_appointments = Appointment.upcoming.limit(5)

    @visits_by_day = (6.days.ago.to_date..Date.current).map do |day|
      { date: day, count: Visit.where(visit_date: day.all_day).count }
    end

    @max_visit_count = [ @visits_by_day.map { |v| v[:count] }.max, 1 ].max
  end
end
