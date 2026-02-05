class RestaurantsController < ApplicationController
  def index
    # 検索パラメータを取得（Phase 1-Bで外部API連携時に使用）
    @search_params = {
      genre: params[:genre],
      location: params[:location],
      budget: params[:budget],
      is_open: params[:is_open]
    }

    # Phase 1-A: サンプルデータ（Phase 1-Bで外部APIからの取得に置き換え）
    @restaurants = sample_restaurants
  end

  def show
    base_data = sample_restaurants.find { |r| r[:id] == params[:id].to_i }

    # 詳細画面用に追加情報をマージ
    @restaurant = base_data.merge(
      images: [
        "https://via.placeholder.com/150x100/FF8E8E/FFFFFF?text=1",
        "https://via.placeholder.com/150x100/FF8E8E/FFFFFF?text=2",
        "https://via.placeholder.com/150x100/FF8E8E/FFFFFF?text=3",
        "https://via.placeholder.com/150x100/FF8E8E/FFFFFF?text=4"
      ],
      opening_hours: {
        "月〜金" => "11:30〜14:30 / 17:30〜22:00",
        "土日祝" => "11:30〜22:00（通し営業）",
        "定休日" => "火曜日"
      },
      sns: {
        instagram: "#",
        twitter: "#",
        facebook: "#"
      },
      external_links: {
        tabelog: "#",
        hotpepper: "#"
      },
      review_count: 128
    )
  end

  private

  def sample_restaurants
    [
      {
        id: 1,
        name: "イタリア食堂 ラ・トラットリア",
        genre: "イタリアン",
        address: "東京都渋谷区道玄坂1-2-3",
        budget_lunch: 1500,
        budget_dinner: 3000,
        rating: 4.2,
        is_open: true,
        image_url: "https://via.placeholder.com/400x250/FF6B6B/FFFFFF?text=Restaurant+Image",
        is_favorite: false
      },
      {
        id: 2,
        name: "和食処 さくら亭",
        genre: "和食",
        address: "東京都渋谷区宇田川町5-6-7",
        budget_lunch: 1000,
        budget_dinner: 2000,
        rating: 4.8,
        is_open: true,
        image_url: "https://via.placeholder.com/400x250/4ECDC4/FFFFFF?text=Restaurant+Image",
        is_favorite: true
      },
      {
        id: 3,
        name: "中華料理 龍門",
        genre: "中華",
        address: "東京都渋谷区神南1-10-11",
        budget_lunch: 800,
        budget_dinner: 2500,
        rating: 4.5,
        is_open: true,
        image_url: "https://via.placeholder.com/400x250/FFE66D/333333?text=Restaurant+Image",
        is_favorite: false
      },
      {
        id: 4,
        name: "焼肉 牛蔵",
        genre: "焼肉",
        address: "東京都渋谷区桜丘町3-4-5",
        budget_lunch: 1200,
        budget_dinner: 4000,
        rating: 4.6,
        is_open: false,
        image_url: "https://via.placeholder.com/400x250/95E1D3/333333?text=Restaurant+Image",
        is_favorite: false
      },
      {
        id: 5,
        name: "フレンチビストロ シェ・ピエール",
        genre: "フレンチ",
        address: "東京都渋谷区恵比寿1-8-9",
        budget_lunch: 2000,
        budget_dinner: 6000,
        rating: 4.7,
        is_open: true,
        image_url: "https://via.placeholder.com/400x250/F38181/FFFFFF?text=Restaurant+Image",
        is_favorite: false
      },
      {
        id: 6,
        name: "ラーメン一番",
        genre: "麺類",
        address: "東京都渋谷区宮益坂2-3-4",
        budget_lunch: 900,
        budget_dinner: 1000,
        rating: 4.3,
        is_open: true,
        image_url: "https://via.placeholder.com/400x250/AA96DA/FFFFFF?text=Restaurant+Image",
        is_favorite: false
      },
      {
        id: 7,
        name: "居酒屋 まる八",
        genre: "居酒屋",
        address: "東京都渋谷区道玄坂2-5-6",
        budget_lunch: 0,
        budget_dinner: 3500,
        rating: 4.1,
        is_open: true,
        image_url: "https://via.placeholder.com/400x250/FCBAD3/333333?text=Restaurant+Image",
        is_favorite: false
      },
      {
        id: 8,
        name: "カレー専門店 スパイスロード",
        genre: "ご飯もの",
        address: "東京都渋谷区円山町7-8-9",
        budget_lunch: 850,
        budget_dinner: 1200,
        rating: 4.4,
        is_open: true,
        image_url: "https://via.placeholder.com/400x250/FFFAA0/333333?text=Restaurant+Image",
        is_favorite: false
      }
    ]
  end
end
