class Appointment < ApplicationRecord
  belongs_to :patient

  validates :appointment_date, presence: true
  validates :status, inclusion: { in: %w[scheduled confirmed completed cancelled no_show] }

  scope :today, -> { where(appointment_date: Date.current.all_day) }
  scope :upcoming, -> { where("appointment_date >= ?", Time.current).order(appointment_date: :asc) }
  scope :by_date, ->(date) { where(appointment_date: date.all_day) }
end
