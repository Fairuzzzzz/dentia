class TreatmentCatalog < ApplicationRecord
  has_many :plan_treatments, dependent: :restrict_with_error
end
