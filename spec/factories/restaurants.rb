# spec/factories/restaurants.rb
FactoryBot.define do
  factory :restaurant do
    sequence(:external_id) { |n| "test_#{sprintf('%03d', n)}" }
    sequence(:name) { |n| "テストレストラン#{n}" }
    genre { '焼肉' }
    address { '東京都渋谷区1-1-1' }
    latitude { 35.6595 }
    longitude { 139.7004 }
    budget_lunch { 1000 }
    budget_dinner { 3000 }
    rating { 4.0 }
    is_open { true }
    opening_hours do
      {
        monday: "11:00-23:00",
        tuesday: "11:00-23:00",
        wednesday: "11:00-23:00",
        thursday: "11:00-23:00",
        friday: "11:00-23:00",
        saturday: "11:00-23:00",
        sunday: "11:00-22:00"
      }
    end
    sns_instagram { 'https://instagram.com/test' }
    sns_twitter { 'https://twitter.com/test' }
    sns_facebook { nil }
    reservation_url { 'https://hotpepper.jp/test' }
    source { 'seed_data' }

    # トレイト: イタリアン
    trait :italian do
      genre { 'イタリアン' }
      name { 'イタリアンレストラン' }
    end

    # トレイト: 新宿
    trait :shinjuku do
      address { '東京都新宿区1-1-1' }
    end

    # トレイト: 営業終了
    trait :closed do
      is_open { false }
    end

    # トレイト: 高予算
    trait :expensive do
      budget_lunch { 3000 }
      budget_dinner { 8000 }
    end

    # トレイト: 低予算
    trait :cheap do
      budget_lunch { 800 }
      budget_dinner { 2000 }
    end
  end
end
