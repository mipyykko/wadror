require 'rails_helper'

include Helpers

RSpec.describe User, type: :model do

  it "has username set correctly" do
    user = User.new username:"asdf"

    expect(user.username).to eq("asdf")
  end

  it "is not saved w/o password" do
    user = create_user("asdf")
    # user = User.create username:"asdf"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  it "is not saved with too short password" do
    user = create_user("asdf", "K12", "K12")

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  it "is not saved with password without numbers" do
    user = create_user("asdf", "ASDFASDF", "ASDFASDF")

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user) { FactoryBot.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings has correct avg rating" do
      rating1 = FactoryBot.create(:rating, score: 10, user: user)
      rating2 = FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for it" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "doesn't have it without ratings" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only one if only one rating" do
      beer = create_beer_with_rating({ user: user }, 49)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating" do
      create_beers_with_ratings({ user: user }, 45, 47, 40)
      best = create_beer_with_rating({ user: user }, 48)
      
      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for it" do
      expect(user).to respond_to(:favorite_style)
    end

    it "doesn't have it without ratings" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only one if only one rating" do
      beer = create_beer_with_rating_and_style({ user: user }, 49, "litku")

      expect(user.favorite_style).to eq("litku")
    end

    it "is the one with highest rating" do
      create_beers_with_ratings({ user: user }, 1, 2, 3)
      best = create_beer_with_rating_and_style({ user: user }, 33, 'paras')

      expect(user.favorite_style).to eq(best.style)
    end
  end

  describe "favorite brewery" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for it" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "doesn't have it without ratings" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only one if only one rating" do
      beer = create_beer_with_rating({ user: user }, 49)

      expect(user.favorite_brewery).to eq(beer.brewery)
    end

    it "is the one with highest rating" do
      brewery = FactoryBot.create(:brewery, name: 'best')
      create_beers_with_ratings({ user: user }, 1, 2, 3)
      best = create_beer_with_rating({ user: user }, 33)
      best.brewery = brewery
      best.save

      expect(user.favorite_brewery).to eq(brewery)
    end
  end

end
