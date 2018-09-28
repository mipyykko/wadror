class User < ApplicationRecord
  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 30 }
  validates :password, length: { minimum: 4 },
                       format: { with: /\A
                                  (?=.*[A-Z])
                                  (?=.*\d)
                                /x }

  def favorite_beer
    return nil if ratings.empty?

    ratings.max_by(&:score).beer
  end

  def favorite_style
    return nil if ratings.empty?

    ratings
      .joins(:beer)
      .select("beers.style, avg(ratings.score) as score")
      .group("beers.style")
      .order("score DESC")
      .map(&:style)[0]
      #.map{ |s| [s.style, s.score] }[0]
  end

  def favorite_brewery
    return nil if ratings.empty?

    ratings
      .joins(:beer)
      .select("beers.brewery_id, avg(ratings.score) as score")
      .group("beers.brewery_id")
      .order("score DESC")
      .limit(1)
      .map{ |r| Brewery.find(r.brewery_id) }[0]
  end
end
