class MedicalRecord < ApplicationRecord
  belongs_to :visit

  has_one :subjective_examination, dependent: :destroy
  has_one :objective_examination, dependent: :destroy
  has_one :assessment, dependent: :destroy
  has_one :plan, dependent: :destroy

  validates :visit, uniqueness: true

  accepts_nested_attributes_for :subjective_examination
  accepts_nested_attributes_for :objective_examination
  accepts_nested_attributes_for :assessment
  accepts_nested_attributes_for :plan
end
