module Helpers

  def sign_in(creds)
    visit signin_path
    fill_in("username", with: creds[:username])
    fill_in("password", with: creds[:password])

    click_button('Log in')
  end

  def create_user(username, password = nil, password_confirmation = nil)
    User.create(username: username, password: password, password_confirmation: password_confirmation)
  end

  def create_beer_with_rating(object, score)
    beer = FactoryBot.create(:beer)
    FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
    beer
  end

  def create_beers_with_ratings(object, *scores)
    scores.each do |score|
      create_beer_with_rating(object, score)
    end
  end

  def create_beer_with_rating_and_style(object, score, style)
    beer = FactoryBot.create(:beer, style: style)
    FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
    beer
  end
end