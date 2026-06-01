class Patient < ApplicationRecord
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
    self.patient_number = "RM-#{Time.current.strftime('%Y%m')}-#{(Patient.maximum(:patient_number).to_s.split('-').last.to_i + 1).to_s.rjust(4, '0')}"
  end
end
