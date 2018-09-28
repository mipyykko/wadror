require 'rails_helper'

describe 'Breweries page' do
  it 'should not have anything before something created' do
    visit breweries_path
    expect(page).to have_content 'Breweries'
    expect(page).to have_content 'Number of breweries: 0'
  end

  describe 'when breweries exists' do
    before :each do
      y = 1999
      @breweries = ['asdf', 'bsdf', 'qwerty']
      @breweries.each do |b|
        FactoryBot.create(:brewery, name: b, year: y += 1)
      end

      visit breweries_path
    end
  
    it 'lists the existing breweries and count' do
      expect(page).to have_content "Number of breweries: 3"
      
      @breweries.each do |b|
        expect(page).to have_content b
      end
    end

    it 'allows user to navigate to brewery page' do
      click_link @breweries[0]

      expect(page).to have_content @breweries[0]
      expect(page).to have_content "Established in 2000"
    end
  end
end