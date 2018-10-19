require 'rails_helper'

describe "Beerlist page" do
  before :all do
    Capybara.register_driver :selenium do |app|
      capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
        chromeOptions: { args: ['headless', 'disable-gpu'] }
      )
      
      Capybara::Selenium::Driver.new app,
        browser: :chrome,
        desired_capabilities: capabilities
    end
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  before :each do
    @brewery1 = FactoryBot.create(:brewery, name:'bsdf')
    @brewery2 = FactoryBot.create(:brewery, name:'fsadf')
    @brewery3 = FactoryBot.create(:brewery, name:'gasdf')
    @style1 = Style.create name:'ösdf'
    @style2 = Style.create name:'asdf'
    @style3 = Style.create name:'bdfg'
    @beer1 = FactoryBot.create(:beer, name:'qwerty', brewery:@brewery1, style:@style1)
    @beer2 = FactoryBot.create(:beer, name:'zxcvb', brewery:@brewery2, style:@style2)
    @beer3  = FactoryBot.create(:beer, name:'hjklö', brewery:@brewery3, style:@style3)
  end

  it "shows one beer", js:true do
    visit beerlist_path
    find('table').find('tr:nth-child(1)')
    expect(page).to have_content "qwerty"
  end

  it "shows beers in alphabetical order", js:true do
    visit beerlist_path
    
    row1 = find('table').find('tr:nth-child(2)')
    row2 = find('table').find('tr:nth-child(3)')
    row3 = find('table').find('tr:nth-child(4)')

    expect(row1).to have_content "hjklö"
    expect(row2).to have_content "qwerty"
    expect(row3).to have_content "zxcvb"
  end

  it "sorts by style", js:true do
    visit beerlist_path

    click_link('style')

    row1 = find('table').find('tr:nth-child(2)')
    row2 = find('table').find('tr:nth-child(3)')
    row3 = find('table').find('tr:nth-child(4)')

    expect(row1).to have_content "asdf"
    expect(row2).to have_content "bdfg"
    expect(row3).to have_content "ösdf"
  end

  it "sorts by brewery", js:true do
    visit beerlist_path

    click_link('brewery')

    row1 = find('table').find('tr:nth-child(2)')
    row2 = find('table').find('tr:nth-child(3)')
    row3 = find('table').find('tr:nth-child(4)')

    expect(row1).to have_content "bsdf"
    expect(row2).to have_content "fsadf"
    expect(row3).to have_content "gasdf"
  end
end
