require "rails_helper"

include Helpers

describe "User" do
  before :each do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user, username: "zxcv")
  end

  describe "who has signed up" do
    it "can sign in with right credentials" do
      sign_in(username: "asdf", password: "K1234")

      expect(page).to have_content "signed in"
      expect(page).to have_content "asdf"
    end

    it "is redirected back to sign in with wrong credentials" do
      sign_in(username: "asdf", password: "asdf")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content "does not exist or wrong password"
    end
  end

  it "can sign up with good credentials and is added" do
    visit signup_path

    fill_in("user_username", with: "qwerty")
    fill_in("user_password", with: "Q1234")
    fill_in("user_password_confirmation", with: "Q1234")

    expect {
      click_button("Create User")
    }.to change{ User.count }.by(1)
  end

end