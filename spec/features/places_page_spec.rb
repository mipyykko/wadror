require 'rails_helper'

describe "Places" do

  it "if returned by API, is shown on page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new(name: "oljenkorsi", id: 1) ]
    )
    allow(ApixuApi).to receive(:weather_in).with("kumpula").and_return( nil )

    search_for_place("kumpula")

    expect(page).to have_content "oljenkorsi"
  end

  it "if returns many, all shown on page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new(name: "oljenkorsi", id: 1), Place.new(name: "unicafe", id: 2) ]
    )
    allow(ApixuApi).to receive(:weather_in).with("kumpula").and_return( nil )

    search_for_place("kumpula")

    expect(page).to have_content "oljenkorsi"
    expect(page).to have_content "unicafe"
  end

  it "if not found, error message shown" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ ]
    )
    allow(ApixuApi).to receive(:weather_in).with("kumpula").and_return( nil )

    search_for_place("kumpula")

    expect(page).to have_content "No places in kumpula"
  end

  def search_for_place(city)
    visit places_path
    fill_in('city', with: city)
    click_button 'Search'
  end
end