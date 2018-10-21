class Brewery < ApplicationRecord
  extend Top
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1040,
                                   less_than_or_equal_to: ->(_year) { Date.today.year },
                                   only_integer: true }
  # validates_numericality_of :year, less: ->(year) { 1040..Date.today.year }

  scope :active, -> { where active: true }
  scope :retired, -> { where active: [nil, false] }

  def print_report
    puts name
    puts "est. year #{year}"
    puts "# of beers #{beers.count}"
  end

  def restart
    self.year = 2018
    puts "changed to year #{year}"
  end
end
