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
        expect(assigns(:restaurants).first.genre).to include('焼肉')
      end
    end

    context '場所で検索' do
      it '検索結果が表示される' do
        get restaurants_path, params: { location: '渋谷' }
        expect(response).to have_http_status(:ok)
        expect(assigns(:restaurants)).to include(restaurant)
      end
    end

    context '予算で検索' do
      it '検索結果が表示される' do
        get restaurants_path, params: { budget: 2000 }
        expect(response).to have_http_status(:ok)
        expect(assigns(:restaurants)).not_to be_empty
      end
    end

    context '営業中フィルター' do
      before do
        create(:restaurant, :closed, name: '閉店中レストラン')
      end

      it '営業中のみ表示される' do
        get restaurants_path, params: { is_open: '1' }
        expect(response).to have_http_status(:ok)
        expect(assigns(:restaurants).all?(&:is_open)).to be true
      end
    end

    context '複数条件で検索' do
      it '全ての条件に合致する結果が表示される' do
        get restaurants_path, params: { genre: '焼肉', location: '渋谷', budget: 2000, is_open: '1' }
        expect(response).to have_http_status(:ok)
        expect(assigns(:restaurants)).not_to be_empty
      end
    end

    context '検索結果が0件の場合' do
      it 'flashメッセージが表示される' do
        get restaurants_path, params: { genre: '存在しないジャンル' }
        expect(response).to have_http_status(:ok)
        expect(flash[:notice]).to eq('条件に一致するお店が見つかりませんでした。条件を変更して再度検索してください。')
      end
    end
  end

  describe 'GET /restaurants/:id' do
    it 'レストラン詳細が表示される' do
      get restaurant_path(restaurant)
      expect(response).to have_http_status(:ok)
      expect(assigns(:restaurant)).to eq(restaurant)
    end

    it 'レストラン名が表示される' do
      get restaurant_path(restaurant)
      expect(response.body).to include(restaurant.name)
    end

    it 'ジャンルが表示される' do
      get restaurant_path(restaurant)
      expect(response.body).to include(restaurant.genre)
    end

    it '住所が表示される' do
      get restaurant_path(restaurant)
      expect(response.body).to include(restaurant.address)
    end

    context '存在しないIDの場合' do
      it 'rootにリダイレクトされる' do
        get restaurant_path(id: 99999)
        expect(response).to redirect_to(root_path)
      end

      it 'alertメッセージが表示される' do
        get restaurant_path(id: 99999)
        follow_redirect!
        expect(flash[:alert]).to eq('お店が見つかりませんでした')
      end
    end
  end
end
