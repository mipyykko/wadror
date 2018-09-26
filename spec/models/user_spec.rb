require 'rails_helper'

RSpec.describe User, type: :model do
  it "has username set correctly" do
    user = User.new username:"asdf"

    expect(user.username).to eq("asdf")
  end

  it "is not saved w/o password" do
    #user = User.create username:"asdfg"

    #expect(user.valid?).to be(false)
    #expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user) {User.create username:"asdf", password:"S12345", password_confirmation:"S12345" }
    let(:test_brewery) { Brewery.new name: "ööö", year: "2000" }
    let(:test_beer) { Beer.new name: "ööl", style: "börsta", brewery: test_brewery }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings has correct avg rating" do
      rating1 = Rating.new score: 10, beer: test_beer
      rating2 = Rating.new score: 20, beer: test_beer

      user.ratings << rating1
      user.ratings << rating2

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(10.0)
    end
  end
end
