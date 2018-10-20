class BeerClub < ApplicationRecord
  has_many :memberships
  has_many :users, through: :memberships

  has_many :confirmed_users, -> { where confirmed: true }, class_name: "Membership"
  has_many :unconfirmed_users, -> { where confirmed: [false, nil] }, class_name: "Membership"

  def to_s
    name
  end
end
