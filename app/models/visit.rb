class Visit < ApplicationRecord
  belongs_to :patient
  has_one :medical_record, dependent: :destroy
  has_one :billing, dependent: :destroy
  validates :visit_date, presence: true
  validates :status, inclusion: { in: %w[registered in_progress completed] }
  scope :today, -> { where(visit_date: Date.current.all_day) }
  scope :by_status, ->(status) { where(status: status) }

  before_create :generate_visit_number

  private
  def generate_visit_number
    self.visit_number = "KNJ-#{Time.current.strftime('%Y%m')}-#{(Visit.maximum(:visit_number).to_s.split('-').last.to_i + 1).to_s.rjust(4, '0')}"
  end
end
