class PlanTreatment < ApplicationRecord
  belongs_to :plan
  belongs_to :treatment_catalog
  has_many :billing_items, dependent: :destroy
end
