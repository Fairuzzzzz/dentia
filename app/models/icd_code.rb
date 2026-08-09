class IcdCode < ApplicationRecord
  validates :code, presence: true, uniqueness: true

  scope :search_by, ->(query) {
    where("code ILIKE :q OR description ILIKE :q", q: "%#{query}%")
  }
end
