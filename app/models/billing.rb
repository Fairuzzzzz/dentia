class Billing < ApplicationRecord
  belongs_to :visit
  has_many :billing_items, dependent: :destroy

  scope :unpaid, -> { where(payment_status: "unpaid") }
  scope :paid, -> { where(payment_status: "paid") }

  def paid?
    payment_status == "paid"
  end
end
