class Style < ApplicationRecord
  has_many :beers

  validates :name, presence: true
end
