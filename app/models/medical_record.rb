class MedicalRecord < ApplicationRecord
  belongs_to :visit
  has_one :subjective_examination, dependent: :destroy
  has_one :objective_examination, dependent: :destroy
  has_one :assessment, dependent: :destroy
  has_one :plan, dependent: :destroy
  validates :visit, uniqueness: true
end
