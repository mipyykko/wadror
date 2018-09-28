FactoryBot.define do
  factory :user do
    username { "asdf" }
    password { "K1234" }
    password_confirmation { "K1234" }
  end

  factory :brewery do
    name { "öö" }
    year { "2000" }
  end
  
  factory :beer do
    name { "ööl" }
    style { "litku" }
    brewery
  end

  factory :rating do
    beer
  end
end