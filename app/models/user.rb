class User < ApplicationRecord
  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  include RatingAverage

  has_secure_password # validations: :github ? !:github : true

  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 30 }
  validates :password, length: { minimum: 4 },
                       format: { with: /\A
                                  (?=.*[A-Z])
                                  (?=.*\d)
                                /x }

  def favorite(criteria)
    return nil if ratings.empty?

    ratings
      .group_by { |r| r.beer.send(criteria) }
      .map do |group, ratings|
        { group: group, score: average_of(ratings) }
      end
      .max_by { |r| r[:score] }[:group]
  end

  def favorite_beer
    return nil if ratings.empty?

    ratings.max_by(&:score).beer
  end

  def favorite_style
    favorite(:style)
  end

  def favorite_brewery
    favorite(:brewery)
  end

  def average_of(ratings)
    ratings.sum(&:score).to_f / ratings.count
  end

  def to_s
    username
  end

  def self.top_raters(number)
    User.all.sort_by { |u| -u.ratings.count }.first(number)
  end
end
