require 'rails_helper'

include Helpers

describe "Beer" do
  before :each do
    @brewery = FactoryBot.create(:brewery)
    sign_in(username: "asdf", password: "K1234")
    visit new_beer_path
  end

  it "can be added with proper name" do
    fill_in('beer[name]', with: 'asdf')
    
    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
  end

  it "can't be added with empty name" do
    click_button "Create Beer"
    
    expect(Beer.count).to eq(0)
    expect(page).to have_content "Name can't be blank"
  end
end
