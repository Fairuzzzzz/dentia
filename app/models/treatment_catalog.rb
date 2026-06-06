class TreatmentCatalog < ApplicationRecord
  belongs_to :user

  has_many :plan_treatments, dependent: :restrict_with_error

  validates :code, presence: true, uniqueness: { scope: :user_id }
  validates :name, presence: true

  scope :active, -> { where(is_active: true) }
end
