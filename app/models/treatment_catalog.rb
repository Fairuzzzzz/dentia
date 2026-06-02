class TreatmentCatalog < ApplicationRecord
  has_many :plan_treatments, dependent: :restrict_with_error
  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
  scope :active, -> { where(is_active: true) }
end
