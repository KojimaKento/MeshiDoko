FactoryBot.define do
  factory :restaurant do
    external_id { "MyString" }
    name { "MyString" }
    genre { "MyString" }
    address { "MyString" }
    latitude { "9.99" }
    longitude { "9.99" }
    budget_lunch { 1 }
    budget_dinner { 1 }
    rating { "9.99" }
    is_open { false }
    opening_hours { "" }
    sns_instagram { "MyString" }
    sns_twitter { "MyString" }
    sns_facebook { "MyString" }
    reservation_url { "MyString" }
    source { "MyString" }
  end
end
