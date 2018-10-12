class Style < ApplicationRecord
  include RatingAverage

  has_many :beers
  has_many :ratings, through: :beers

  validates :name, presence: true

  def self.top(number)
    Style.all.sort_by { |b| -(b.average_rating || 0) }.first(number)
  end
end
