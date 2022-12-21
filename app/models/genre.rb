class Genre < ApplicationRecord
  has_many :characterisations, dependent: :destroy
  has_many :movies, through: :characterisations

  validates :name, presence: true, uniqueness: true
end
