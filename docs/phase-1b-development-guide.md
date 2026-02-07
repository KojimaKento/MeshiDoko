# Phase 1-B: 検索機能実装ガイド

## 概要

Phase 1-Bでは、レストラン検索機能のバックエンド実装を行います。

**開発方針**:
- **シードデータ方式**を採用し、データベースから検索する実装を優先
- 後から外部API（ホットペッパーAPI）に切り替えやすい設計
- 外部APIの制約（リクエスト制限、アカウント取得の手間）を回避し、開発スピードを優先

---

## 開発方法の選択肢

### 方法1: シードデータ方式（推奨・採用）

**メリット**:
- ✅ すぐに開発を始められる
- ✅ API制限を気にせず開発できる
- ✅ オフラインでも開発可能
- ✅ 後からAPI実装に切り替えやすい
- ✅ テストが簡単

**デメリット**:
- ❌ 実データではないため、本番環境とのギャップがある
- ❌ データの鮮度が保証されない

### 方法2: 外部API統合方式（Phase 2以降で実装予定）

**メリット**:
- ✅ リアルタイムの最新データが取得できる
- ✅ 実際のユーザー体験をテストできる

**デメリット**:
- ❌ リクエスト制限（1日3,000リクエスト）
- ❌ アカウント取得の手間
- ❌ ネットワーク依存

---

## Phase 1-B: シードデータ方式の実装手順

### ステップ1: 充実したシードデータの作成

`db/seeds.rb`に50件以上のリアルなレストランデータを追加します。

```ruby
# db/seeds.rb

# 既存データをクリア
puts "Clearing existing data..."
Restaurant.destroy_all
Favorite.destroy_all

puts "Creating seed restaurants..."

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
  '焼肉' => ['炎', '極上', '和牛', '本格', '高級'],
  'イタリアン' => ['トラットリア', 'オステリア', 'リストランテ', 'ピッツェリア'],
  'そば' => ['手打ち', '十割', '更科', '藪', '砂場'],
  'うどん' => ['讃岐', '武蔵野', '稲庭', '手打ち'],
  '中華' => ['麻辣', '四川', '広東', '北京', '上海'],
  'カフェ' => ['モーニング', 'サンセット', 'ムーンライト', 'アロマ'],
  'ラーメン' => ['一蘭', '次郎', '三郎', '四郎', '五郎'],
  '寿司' => ['鮨', '江戸前', '回転', '立ち食い', '高級'],
  '居酒屋' => ['炉端', '個室', 'ワイン', '日本酒', 'クラフトビール'],
  'フレンチ' => ['ビストロ', 'ブラッスリー', 'オーベルジュ'],
  '和食' => ['懐石', '割烹', '料亭', '定食'],
  '洋食' => ['グリル', '洋食屋', 'ダイナー']
}

# 店名のサフィックス
name_suffixes = ['亭', '屋', '処', 'や', 'ダイニング', 'キッチン', 'ハウス', 'カフェ', 'レストラン']

# 50件のレストランデータを作成
50.times do |i|
  genre = genres.sample
  location = locations.sample
  prefix = name_prefixes[genre]&.sample || ''
  suffix = name_suffixes.sample

  Restaurant.create!(
    external_id: "seed_#{i + 1}",
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
    sns_instagram: "https://instagram.com/restaurant_#{i + 1}",
    sns_twitter: "https://twitter.com/restaurant_#{i + 1}",
    sns_facebook: i.even? ? "https://facebook.com/restaurant_#{i + 1}" : nil,
    reservation_url: "https://www.hotpepper.jp/restaurant_#{i + 1}",
    source: "seed_data"
  )
end

puts "✅ Created #{Restaurant.count} restaurants!"
puts "Sample genres: #{Restaurant.pluck(:genre).uniq.join(', ')}"
puts "Sample locations: #{Restaurant.pluck(:address).map { |a| a.match(/東京都(\S+区)/)[1] }.uniq.join(', ')}"
```

シードデータを実行：

```bash
rails db:seed
```

確認：

```bash
rails console
> Restaurant.count  # => 50
> Restaurant.pluck(:genre).uniq  # => ジャンル一覧
> Restaurant.where(genre: '焼肉')  # => 焼肉のお店
```

---

### ステップ2: RestaurantSearchServiceクラスの実装

後からAPI実装に切り替えやすい設計で、まずはDB検索版を実装します。

```ruby
# app/services/restaurant_search_service.rb
class RestaurantSearchService
  # メインの検索メソッド
  # 環境変数でAPI使用/DB使用を切り替え可能
  def self.search(params)
    if use_api?
      search_from_api(params)
    else
      search_from_database(params)
    end
  end

  private

  # API使用判定
  # 環境変数 USE_HOTPEPPER_API=true かつ HOTPEPPER_API_KEY が設定されている場合のみAPI使用
  def self.use_api?
    ENV['USE_HOTPEPPER_API'] == 'true' && ENV['HOTPEPPER_API_KEY'].present?
  end

  # データベースから検索（現在の実装）
  def self.search_from_database(params)
    restaurants = Restaurant.all

    # ジャンル検索（部分一致、大文字小文字区別なし）
    if params[:genre].present?
      restaurants = restaurants.where('genre ILIKE ?', "%#{sanitize_sql_like(params[:genre])}%")
    end

    # 場所検索（住所で部分一致、大文字小文字区別なし）
    if params[:location].present?
      restaurants = restaurants.where('address ILIKE ?', "%#{sanitize_sql_like(params[:location])}%")
    end

    # 予算検索（ランチまたはディナーのいずれかが予算以下）
    if params[:budget].present?
      budget = params[:budget].to_i
      restaurants = restaurants.where('budget_lunch <= ? OR budget_dinner <= ?', budget, budget)
    end

    # 営業中フィルター
    if params[:is_open] == '1' || params[:is_open] == 'true'
      restaurants = restaurants.where(is_open: true)
    end

    # ランダムに8件取得（結果が多すぎる場合の対策）
    # 評価順やランダムなど、並び順は要件に応じて変更可能
    restaurants.limit(8).order('RANDOM()')
  end

  # 外部API（ホットペッパー）から検索（Phase 2以降で実装）
  def self.search_from_api(params)
    # TODO: FaradayでホットペッパーグルメサーチAPIにリクエスト
    # レスポンスをパースしてRestaurantオブジェクトの配列を返す
    raise NotImplementedError, "API integration is not yet implemented. Set USE_HOTPEPPER_API=false to use database search."
  end

  # SQLインジェクション対策
  def self.sanitize_sql_like(string)
    string.gsub(/[%_]/) { |m| "\\#{m}" }
  end
end
```

---

### ステップ3: RestaurantsControllerの更新

サンプルデータから`RestaurantSearchService`呼び出しに変更します。

```ruby
# app/controllers/restaurants_controller.rb
class RestaurantsController < ApplicationController
  def index
    # 検索パラメータが1つでもあれば検索実行
    if search_params_present?
      @restaurants = RestaurantSearchService.search(search_params)

      # 検索結果が0件の場合のメッセージ
      if @restaurants.empty?
        flash.now[:notice] = '条件に一致するお店が見つかりませんでした。条件を変更して再度検索してください。'
      end
    else
      # 検索前は空の配列
      @restaurants = []
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'お店が見つかりませんでした'
  end

  private

  def search_params
    params.permit(:genre, :location, :budget, :is_open)
  end

  def search_params_present?
    search_params.values.any?(&:present?)
  end
end
```

---

### ステップ4: 環境変数の設定（オプション）

将来的にAPI実装に切り替える準備として、`.env`ファイルを用意します。

#### dotenv-rails gemの追加

```ruby
# Gemfile
group :development, :test do
  gem 'dotenv-rails'
end
```

```bash
bundle install
```

#### .envファイルの作成

```bash
# .env
# Phase 1-B: シードデータ方式を使用
USE_HOTPEPPER_API=false

# Phase 2以降: API実装時に以下を設定
# USE_HOTPEPPER_API=true
# HOTPEPPER_API_KEY=your_api_key_here
```

#### .gitignoreに追加

```bash
# .gitignore
.env
.env.local
```

---

### ステップ5: RSpecでのテスト実装

#### FactoryBotでテストデータ定義

```ruby
# spec/factories/restaurants.rb
FactoryBot.define do
  factory :restaurant do
    sequence(:external_id) { |n| "test_#{n}" }
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
  end
end
```

#### RestaurantSearchServiceのテスト

```ruby
# spec/services/restaurant_search_service_spec.rb
require 'rails_helper'

RSpec.describe RestaurantSearchService do
  before do
    # テストデータ作成
    create(:restaurant, name: '焼肉レストラン炎', genre: '焼肉', address: '東京都渋谷区1-1-1', budget_lunch: 1000, is_open: true)
    create(:restaurant, :italian, address: '東京都新宿区2-2-2', budget_lunch: 2000, is_open: false)
    create(:restaurant, :expensive, genre: 'フレンチ', address: '東京都港区3-3-3', is_open: true)
  end

  describe '.search' do
    context 'パラメータなしの場合' do
      it '全てのレストランが返る（最大8件）' do
        results = RestaurantSearchService.search({})
        expect(results.count).to be <= 8
        expect(results.count).to eq(3)
      end
    end

    context 'ジャンル検索' do
      it '焼肉で検索すると焼肉レストランのみ返る' do
        results = RestaurantSearchService.search(genre: '焼肉')
        expect(results.map(&:genre)).to all(include('焼肉'))
      end

      it 'イタリアンで検索するとイタリアンレストランのみ返る' do
        results = RestaurantSearchService.search(genre: 'イタリアン')
        expect(results.map(&:genre)).to all(include('イタリアン'))
      end

      it '部分一致で検索できる' do
        results = RestaurantSearchService.search(genre: 'イタ')
        expect(results).not_to be_empty
      end
    end

    context '場所検索' do
      it '渋谷で検索すると渋谷のレストランが返る' do
        results = RestaurantSearchService.search(location: '渋谷')
        expect(results.map(&:address)).to all(include('渋谷'))
      end

      it '新宿で検索すると新宿のレストランが返る' do
        results = RestaurantSearchService.search(location: '新宿')
        expect(results.map(&:address)).to all(include('新宿'))
      end
    end

    context '予算検索' do
      it '1500円以下で検索すると該当するレストランが返る' do
        results = RestaurantSearchService.search(budget: 1500)
        expect(results).not_to be_empty
        results.each do |restaurant|
          expect(restaurant.budget_lunch <= 1500 || restaurant.budget_dinner <= 1500).to be true
        end
      end

      it '5000円以下で検索すると該当するレストランが返る' do
        results = RestaurantSearchService.search(budget: 5000)
        expect(results.count).to eq(3) # 全て該当
      end
    end

    context '営業中フィルター' do
      it '営業中のみ表示（文字列"true"）' do
        results = RestaurantSearchService.search(is_open: 'true')
        expect(results.all?(&:is_open)).to be true
        expect(results.count).to eq(2)
      end

      it '営業中のみ表示（文字列"1"）' do
        results = RestaurantSearchService.search(is_open: '1')
        expect(results.all?(&:is_open)).to be true
      end
    end

    context '複数条件の組み合わせ' do
      it 'ジャンル + 場所で検索' do
        results = RestaurantSearchService.search(genre: '焼肉', location: '渋谷')
        expect(results).not_to be_empty
        expect(results.first.genre).to include('焼肉')
        expect(results.first.address).to include('渋谷')
      end

      it 'ジャンル + 予算 + 営業中で検索' do
        results = RestaurantSearchService.search(genre: '焼肉', budget: 2000, is_open: 'true')
        expect(results).not_to be_empty
        results.each do |restaurant|
          expect(restaurant.genre).to include('焼肉')
          expect(restaurant.is_open).to be true
        end
      end
    end

    context '結果が0件の場合' do
      it '存在しないジャンルで検索すると空配列が返る' do
        results = RestaurantSearchService.search(genre: '存在しないジャンル')
        expect(results).to be_empty
      end
    end
  end
end
```

#### RestaurantsControllerのリクエストテスト

```ruby
# spec/requests/restaurants_spec.rb
require 'rails_helper'

RSpec.describe 'Restaurants', type: :request do
  let!(:restaurant) { create(:restaurant, name: 'テスト焼肉', genre: '焼肉', address: '東京都渋谷区1-1-1') }

  describe 'GET /restaurants' do
    context '検索パラメータなしの場合' do
      it 'ステータス200が返る' do
        get restaurants_path
        expect(response).to have_http_status(:ok)
      end

      it '検索結果は空' do
        get restaurants_path
        expect(assigns(:restaurants)).to be_empty
      end
    end

    context 'ジャンルで検索' do
      it '検索結果が表示される' do
        get restaurants_path, params: { genre: '焼肉' }
        expect(response).to have_http_status(:ok)
        expect(assigns(:restaurants)).not_to be_empty
      end
    end

    context '場所で検索' do
      it '検索結果が表示される' do
        get restaurants_path, params: { location: '渋谷' }
        expect(response).to have_http_status(:ok)
        expect(assigns(:restaurants)).to include(restaurant)
      end
    end
  end

  describe 'GET /restaurants/:id' do
    it 'レストラン詳細が表示される' do
      get restaurant_path(restaurant)
      expect(response).to have_http_status(:ok)
      expect(assigns(:restaurant)).to eq(restaurant)
    end

    context '存在しないIDの場合' do
      it 'rootにリダイレクトされる' do
        get restaurant_path(id: 99999)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
```

テスト実行：

```bash
bundle exec rspec spec/services/restaurant_search_service_spec.rb
bundle exec rspec spec/requests/restaurants_spec.rb
```

---

### ステップ6: 動作確認

1. **サーバー起動**

```bash
rails server
```

2. **検索機能のテスト**
   - http://localhost:3000 にアクセス
   - 各検索条件を試す
     - ジャンル: 焼肉、イタリアン、ラーメンなど
     - 場所: 渋谷、新宿、六本木など
     - 予算: 1000, 2000, 5000など
     - 営業中: チェックボックスをON

3. **検索結果の確認**
   - 8件以下の結果が表示されること
   - 条件に合致したお店のみが表示されること
   - カードをクリックして詳細画面に遷移できること

---

## Phase 2以降: 外部API統合への切り替え

シードデータ方式で開発が完了した後、実データを使いたい場合は以下の手順でAPI実装に切り替えます。

### 1. ホットペッパーAPI統合の準備

#### アカウント取得

1. [リクルートWEBサービス](https://webservice.recruit.co.jp/)にアクセス
2. 「新規登録」からリクルートIDを作成（無料）
3. メール認証で本登録完了

#### APIキー取得

1. リクルートIDでログイン
2. 「ホットペッパーグルメサーチAPI」を選択
3. 利用規約に同意してAPI利用申請
4. APIキーが即座に発行される

#### 注意事項

- **リクエスト制限**: 1日3,000リクエストまで（無料プラン）
- **レスポンス形式**: JSON or XML（JSONを推奨）
- **エンドポイント**: `https://webservice.recruit.co.jp/hotpepper/gourmet/v1/`

### 2. Faraday gemの追加

```ruby
# Gemfile
gem 'faraday'
gem 'faraday-retry' # リトライ処理用（オプション）
```

```bash
bundle install
```

### 3. 環境変数の設定

```bash
# .env
USE_HOTPEPPER_API=true
HOTPEPPER_API_KEY=your_actual_api_key_here
```

### 4. RestaurantSearchService#search_from_api の実装

```ruby
# app/services/restaurant_search_service.rb（API版）
def self.search_from_api(params)
  # Faradayクライアント作成
  conn = Faraday.new(url: 'https://webservice.recruit.co.jp') do |f|
    f.request :url_encoded
    f.adapter Faraday.default_adapter
  end

  # APIリクエスト
  response = conn.get('/hotpepper/gourmet/v1/') do |req|
    req.params['key'] = ENV['HOTPEPPER_API_KEY']
    req.params['format'] = 'json'

    # ジャンルコード変換（実際のAPIに合わせて調整）
    req.params['genre'] = convert_genre_to_code(params[:genre]) if params[:genre].present?

    # 場所（キーワード検索）
    req.params['keyword'] = params[:location] if params[:location].present?

    # 予算コード変換
    req.params['budget'] = convert_budget_to_code(params[:budget]) if params[:budget].present?

    # 営業中フィルター（現在時刻で検索）
    if params[:is_open] == '1' || params[:is_open] == 'true'
      req.params['open'] = '1'
    end

    req.params['count'] = 8 # 最大8件
  end

  # レスポンスをパース
  parse_hotpepper_response(response.body)
rescue Faraday::Error => e
  Rails.logger.error("Hotpepper API Error: #{e.message}")
  [] # エラー時は空配列を返す
end

private

def self.parse_hotpepper_response(body)
  data = JSON.parse(body)
  shops = data.dig('results', 'shop') || []

  # ホットペッパーのレスポンスをRestaurantオブジェクトに変換
  shops.map do |shop|
    Restaurant.new(
      external_id: shop['id'],
      name: shop['name'],
      genre: shop.dig('genre', 'name'),
      address: shop['address'],
      latitude: shop['lat'].to_f,
      longitude: shop['lng'].to_f,
      budget_lunch: shop.dig('budget', 'average')&.to_i,
      budget_dinner: shop.dig('budget', 'average')&.to_i,
      rating: shop['rating']&.to_f || 0.0,
      is_open: shop['open'] == '営業中',
      opening_hours: shop['open'], # 要整形
      sns_instagram: nil, # ホットペッパーAPIには含まれない
      reservation_url: shop.dig('urls', 'pc'),
      source: 'hotpepper'
    )
  end
end

def self.convert_genre_to_code(genre)
  # ジャンル名からホットペッパーのジャンルコードに変換
  # 実際のマッピングはAPIドキュメント参照
  genre_mapping = {
    '焼肉' => 'G001',
    'イタリアン' => 'G006',
    'ラーメン' => 'G013',
    # ... 他のジャンル
  }
  genre_mapping[genre]
end

def self.convert_budget_to_code(budget)
  # 予算からホットペッパーの予算コードに変換
  budget_i = budget.to_i
  case budget_i
  when 0..1000 then 'B009' # ~1000円
  when 1001..2000 then 'B010' # 1001~2000円
  when 2001..3000 then 'B011' # 2001~3000円
  # ... 他の予算帯
  else 'B001' # すべて
  end
end
```

### 5. テスト（WebMock使用）

```ruby
# spec/services/restaurant_search_service_spec.rb（API版）
require 'rails_helper'
require 'webmock/rspec'

RSpec.describe RestaurantSearchService do
  describe '.search_from_api' do
    let(:api_response) do
      {
        results: {
          shop: [
            {
              id: 'J001234567',
              name: 'テストレストラン',
              genre: { name: '焼肉' },
              address: '東京都渋谷区1-1-1',
              lat: 35.6595,
              lng: 139.7004,
              budget: { average: 3000 },
              rating: 4.2,
              open: '営業中',
              urls: { pc: 'https://hotpepper.jp/test' }
            }
          ]
        }
      }.to_json
    end

    before do
      stub_request(:get, /webservice\.recruit\.co\.jp/)
        .to_return(status: 200, body: api_response)
    end

    it 'ホットペッパーAPIからレストランを取得' do
      results = RestaurantSearchService.search_from_api(genre: '焼肉')
      expect(results).not_to be_empty
      expect(results.first.name).to eq('テストレストラン')
    end
  end
end
```

---

## まとめ

### Phase 1-B（現在）
- ✅ シードデータ方式で実装
- ✅ 後からAPI切り替え可能な設計
- ✅ 開発スピード優先

### Phase 2以降
- 🔄 ホットペッパーAPI統合
- 🔄 リアルタイムデータ取得
- 🔄 本番環境でのテスト

**次のステップ**: Phase 1-C（お気に入り機能実装）に進みます。
