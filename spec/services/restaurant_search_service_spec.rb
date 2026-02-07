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
        expect(results.first.genre).to include('イタリアン')
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

      it '部分一致で検索できる（区名）' do
        results = RestaurantSearchService.search(location: '渋谷区')
        expect(results).not_to be_empty
        expect(results.map(&:address)).to all(include('渋谷'))
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

      it '800円以下で検索すると結果が0件' do
        results = RestaurantSearchService.search(budget: 800)
        expect(results).to be_empty
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

      it '営業中フィルターなしの場合は全て表示' do
        results = RestaurantSearchService.search({})
        expect(results.count).to eq(3)
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

      it '場所 + 予算で検索' do
        results = RestaurantSearchService.search(location: '新宿', budget: 3000)
        expect(results).not_to be_empty
        expect(results.first.address).to include('新宿')
      end
    end

    context '結果が0件の場合' do
      it '存在しないジャンルで検索すると空配列が返る' do
        results = RestaurantSearchService.search(genre: '存在しないジャンル')
        expect(results).to be_empty
      end

      it '存在しない場所で検索すると空配列が返る' do
        results = RestaurantSearchService.search(location: '大阪')
        expect(results).to be_empty
      end
    end

    context '結果が8件を超える場合' do
      before do
        # 10件のレストランを追加作成
        10.times do |i|
          create(:restaurant, name: "追加レストラン#{i}", genre: 'ラーメン')
        end
      end

      it '最大8件のみ返る' do
        results = RestaurantSearchService.search(genre: 'ラーメン')
        expect(results.count).to be <= 8
      end
    end
  end

  describe '.use_api?' do
    context '環境変数が設定されていない場合' do
      it 'falseを返す' do
        allow(ENV).to receive(:[]).with('USE_HOTPEPPER_API').and_return(nil)
        allow(ENV).to receive(:[]).with('HOTPEPPER_API_KEY').and_return(nil)
        expect(RestaurantSearchService.send(:use_api?)).to be false
      end
    end

    context 'USE_HOTPEPPER_API=falseの場合' do
      it 'falseを返す' do
        allow(ENV).to receive(:[]).with('USE_HOTPEPPER_API').and_return('false')
        allow(ENV).to receive(:[]).with('HOTPEPPER_API_KEY').and_return('test_key')
        expect(RestaurantSearchService.send(:use_api?)).to be false
      end
    end

    context 'USE_HOTPEPPER_API=trueでAPIキーが設定されている場合' do
      it 'trueを返す' do
        allow(ENV).to receive(:[]).with('USE_HOTPEPPER_API').and_return('true')
        allow(ENV).to receive(:[]).with('HOTPEPPER_API_KEY').and_return('test_key')
        expect(RestaurantSearchService.send(:use_api?)).to be true
      end
    end
  end
end
