class Plan < ApplicationRecord
  belongs_to :medical_record

  has_many :prescriptions, dependent: :destroy
  has_many :plan_treatments, dependent: :destroy

  accepts_nested_attributes_for :prescriptions, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :plan_treatments, allow_destroy: true, reject_if: :all_blank
end
