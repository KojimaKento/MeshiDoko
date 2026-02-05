class FavoritesController < ApplicationController
  def index
    # Phase 1-A: サンプルデータからお気に入りのみ表示
    # Phase 1-Cで実際のお気に入り機能を実装
    @favorites = sample_favorite_restaurants
  end

  def create
    # Phase 1-Cで実装
    head :ok
  end

  def destroy
    # Phase 1-Cで実装
    head :ok
  end

  private

  def sample_favorite_restaurants
    [
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
      }
    ]
  end
end
