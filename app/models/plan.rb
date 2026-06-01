class Plan < ApplicationRecord
  belongs_to :medical_record
  has_many :prescriptions, dependent: :destroy
  has_many :plan_treatments, dependent: :destroy
end
