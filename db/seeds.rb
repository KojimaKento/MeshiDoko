# db/seeds.rb
# Phase 1-B: シードデータ作成

# 既存データをクリア
puts "🗑️  Clearing existing data..."
Restaurant.destroy_all
Favorite.destroy_all

puts "🍽️  Creating seed restaurants..."

# ジャンルのバリエーション
genres = ['焼肉', 'イタリアン', 'そば', 'うどん', '中華', 'カフェ', 'ラーメン', '寿司', '居酒屋', 'フレンチ', '和食', '洋食']

# 場所のバリエーション
locations = [
  { ward: '渋谷区', area: '渋谷' },
  { ward: '新宿区', area: '新宿' },
  { ward: '港区', area: '六本木' },
  { ward: '目黒区', area: '中目黒' },
  { ward: '世田谷区', area: '三軒茶屋' },
  { ward: '品川区', area: '五反田' },
  { ward: '中央区', area: '銀座' }
]

# 店名のプレフィックス
name_prefixes = {
  '焼肉' => ['炎', '極上', '和牛', '本格', '高級', '特選', '黒毛', '上質'],
  'イタリアン' => ['トラットリア', 'オステリア', 'リストランテ', 'ピッツェリア', 'カーザ', 'ラ・'],
  'そば' => ['手打ち', '十割', '更科', '藪', '砂場', '信州', '出雲'],
  'うどん' => ['讃岐', '武蔵野', '稲庭', '手打ち', '丸亀', '本場'],
  '中華' => ['麻辣', '四川', '広東', '北京', '上海', '本格', '中国'],
  'カフェ' => ['モーニング', 'サンセット', 'ムーンライト', 'アロマ', 'コージー', 'ブルー'],
  'ラーメン' => ['一番', '極み', '匠', '王道', '本丸', '魂', '伝説'],
  '寿司' => ['鮨', '江戸前', '回転', '立ち食い', '高級', '本格', '職人'],
  '居酒屋' => ['炉端', '個室', 'ワイン', '日本酒', 'クラフトビール', '串焼き', '大衆'],
  'フレンチ' => ['ビストロ', 'ブラッスリー', 'オーベルジュ', 'シェ', 'ラ・', 'ル・'],
  '和食' => ['懐石', '割烹', '料亭', '定食', '旬菜', '季節', '本格'],
  '洋食' => ['グリル', '洋食屋', 'ダイナー', 'キッチン', 'ハウス', 'ビストロ']
}

# 店名のサフィックス
name_suffixes = ['亭', '屋', '処', 'や', 'ダイニング', 'キッチン', 'ハウス', 'カフェ', 'レストラン', '', '']

# 50件のレストランデータを作成
50.times do |i|
  genre = genres.sample
  location = locations.sample
  prefix = name_prefixes[genre]&.sample || ''
  suffix = name_suffixes.sample

  Restaurant.create!(
    external_id: "seed_#{sprintf('%03d', i + 1)}",
    name: "#{prefix}#{genre}#{suffix} #{location[:area]}店",
    genre: genre,
    address: "東京都#{location[:ward]}#{location[:area]}#{rand(1..5)}-#{rand(1..20)}-#{rand(1..30)}",
    latitude: 35.6 + (rand * 0.1),
    longitude: 139.6 + (rand * 0.1),
    budget_lunch: [800, 1000, 1200, 1500, 2000, 2500].sample,
    budget_dinner: [2000, 3000, 4000, 5000, 6000, 8000].sample,
    rating: (3.0 + rand * 2.0).round(1),
    is_open: [true, true, true, false].sample, # 75%の確率で営業中
    opening_hours: {
      monday: "11:00-23:00",
      tuesday: "11:00-23:00",
      wednesday: "11:00-23:00",
      thursday: "11:00-23:00",
      friday: "11:00-24:00",
      saturday: "11:00-24:00",
      sunday: "11:00-22:00"
    },
    sns_instagram: "https://instagram.com/restaurant_#{sprintf('%03d', i + 1)}",
    sns_twitter: "https://twitter.com/restaurant_#{sprintf('%03d', i + 1)}",
    sns_facebook: i.even? ? "https://facebook.com/restaurant_#{sprintf('%03d', i + 1)}" : nil,
    reservation_url: "https://www.hotpepper.jp/restaurant_#{sprintf('%03d', i + 1)}",
    source: "seed_data"
  )
end

puts "✅ Created #{Restaurant.count} restaurants!"
puts ""
puts "📊 Data Summary:"
puts "  Genres: #{Restaurant.pluck(:genre).uniq.sort.join(', ')}"
puts "  Locations: #{Restaurant.pluck(:address).map { |a| a.match(/東京都(\S+区)/)[1] }.uniq.sort.join(', ')}"
puts "  Budget Range (Lunch): ¥#{Restaurant.minimum(:budget_lunch)} - ¥#{Restaurant.maximum(:budget_lunch)}"
puts "  Budget Range (Dinner): ¥#{Restaurant.minimum(:budget_dinner)} - ¥#{Restaurant.maximum(:budget_dinner)}"
puts "  Open Now: #{Restaurant.where(is_open: true).count} / #{Restaurant.count}"
puts ""
puts "🎉 Seed data creation completed!"
