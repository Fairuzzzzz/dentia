class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :patients, dependent: :destroy
  has_many :treatment_catalogs, dependent: :destroy
end
