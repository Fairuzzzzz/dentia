class Patient < ApplicationRecord
  include Discard::Model
  default_scope -> { kept }

  has_many :visits, dependent: :destroy
  has_many :medical_records, through: :visits
  has_many :appointments, dependent: :destroy

  validates :name, presence: true
  validates :nik, uniqueness: true, allow_blank: true

  scope :search_by, ->(query) {
    where("name ILIKE :q OR nik ILIKE :q OR phone ILIKE :q", q: "%#{query}%")
  }

  before_create :generate_patient_number

  private

  def generate_patient_number
    loop do
      self.patient_number = "RM-#{rand(100000).to_s.rjust(5, '0')}"
      break unless Patient.with_discarded.exists?(patient_number: patient_number)
    end
  end
end
