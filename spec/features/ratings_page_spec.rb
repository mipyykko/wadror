require 'rails_helper'

include Helpers

describe 'Rating' do
  let!(:brewery1) { FactoryBot.create(:brewery, name: "kana") }
  let!(:brewery2) { FactoryBot.create(:brewery, name: "muna") }
  let!(:style1) { FactoryBot.create(:style, name: "lager" )}
  let!(:style2) { FactoryBot.create(:style, name: "litku" )}
  let!(:beer1) { FactoryBot.create(:beer, name: "ööö", brewery: brewery1, style: style1) }
  let!(:beer2) { FactoryBot.create(:beer, name: "ååå", brewery: brewery2, style: style2) }
  let!(:user1) { FactoryBot.create(:user) }
  let!(:user2) { FactoryBot.create(:user, username: "zxcv") }

  before :each do
    sign_in(username: "asdf", password: "K1234")
  end

  it "given is registered to user and beer" do
    visit new_rating_path

    select("ööö", from: 'rating[beer_id]')
    fill_in('rating[score]', with: '44')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user1.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(44.0)
  end

  describe "given by user" do
    before :each do
      @rating1 = FactoryBot.create(:rating, beer: beer1, score: 10, user: user1)
      FactoryBot.create(:rating, beer: beer2, score: 19, user: user1)
      FactoryBot.create(:rating, beer: beer1, score: 10, user: user2)
      FactoryBot.create(:rating, beer: beer2, score: 22, user: user2)
    end

    it "is shown in ratings page" do
      visit ratings_path
      
      expect(page).to have_content "ööö 10"
      expect(page).to have_content "ååå 19"
      expect(page).to have_content "ååå 22"
      expect(page).to have_content "Total # of ratings: 4"
    end

    it "is shown on correct user page" do
      visit user_path(user1)

      expect(page).to have_content "10"
      expect(page).to have_content "19"
      expect(page).to have_content "has made 2 ratings"
      expect(page).not_to have_content "22"
    end

    it "is deleted correctly" do
      visit user_path(user1)

      expect {
        find("a[href='/ratings/#{@rating1.id}']").click
      }.to change{Rating.count}.from(4).to(3)

      expect(page).not_to have_content "ööö 10"
    end

    it "reflect to favorite brewery" do
      visit user_path(user1)

      expect(page).to have_content "Favorite brewery: muna"
    end

    it "reflect to favorite style" do
      visit user_path(user1)

      expect(page).to have_content "Favorite style: litku"
    end
  end
end
  