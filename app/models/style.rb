class Style < ApplicationRecord
  extend Top
  include RatingAverage

  has_many :beers
  has_many :ratings, through: :beers

  validates :name, presence: true
end
