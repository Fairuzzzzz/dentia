class Plan < ApplicationRecord
  belongs_to :medical_record

  has_many :prescriptions, dependent: :destroy
  has_many :plan_treatments, dependent: :destroy

  accepts_nested_attributes_for :prescriptions, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :plan_treatments, allow_destroy: true, reject_if: :all_blank

  after_save :create_appointment_from_follow_up, if: -> { saved_change_to_next_visit_date? && next_visit_date.present? }

  private

  def create_appointment_from_follow_up
    patient = medical_record.visit.patient
    patient.appointments.find_or_create_by!(
      appointment_date: next_visit_date.to_datetime,
      purpose: "Kontrol lanjutan",
      status: "scheduled"
    )
  end
end
