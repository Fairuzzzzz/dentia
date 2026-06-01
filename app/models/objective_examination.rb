class ObjectiveExamination < ApplicationRecord
  belongs_to :medical_record
  has_one :odontogram, dependent: :destroy
end
