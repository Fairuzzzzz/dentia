class Billing < ApplicationRecord
  belongs_to :visit
  has_many :billing_items, dependent: :destroy
end
