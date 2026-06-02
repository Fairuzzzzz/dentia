class Visit < ApplicationRecord
  belongs_to :patient
  has_one :medical_record, dependent: :destroy
  has_one :billing, dependent: :destroy

  accepts_nested_attributes_for :medical_record

  validates :visit_date, presence: true
  validates :status, inclusion: { in: %w[registered in_progress completed] }

  scope :today, -> { where(visit_date: Date.current.all_day) }
  scope :by_status, ->(status) { where(status: status) }

  before_create :generate_visit_number

  after_create :build_medical_record_components

  after_update :generate_billing, if: -> { saved_change_to_status? && status == "completed" }

  private

  def generate_visit_number
    last_number = Visit.maximum(:visit_number)
    seq = last_number.to_s.split("-").last.to_i + 1
    self.visit_number ="KNJ-#{Time.current.strftime("%Y%m")}-#{seq.to_s.rjust(4, "0")}"
  end

  def build_medical_record_components
    mr = build_medical_record
    mr.build_subjective_examination
    mr.build_objective_examination
    mr.build_assessment
    mr.build_plan
    mr.save!
  end

  def generate_billing
    return if billing.present?

    plan = medical_record&.plan
    return unless plan&.plan_treatments&.any?

    billing = build_billing(
      total_amount: plan.plan_treatments.sum { |pt| pt.price.to_i * pt.quantity.to_i },
      payment_status: "unpaid"
    )
    billing.save!

    plan.plan_treatments.each do |pt|
      billing.billing_items.create!(
        plan_treatment: pt,
        treatment_name: pt.treatment_catalog&.name,
        quantity: pt.quantity,
        unit_price: pt.price,
        total_price: pt.price.to_i * pt.quantity.to_i
      )
    end
  end
end
