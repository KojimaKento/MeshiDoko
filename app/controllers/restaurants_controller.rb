# app/controllers/restaurants_controller.rb
# Phase 1-B: RestaurantSearchServiceを使用した検索機能

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
    # prefectureパラメータをlocationに統合
    location = params[:location].presence || params[:prefecture].presence

    params.permit(:genre, :budget, :meal_type, :is_open).merge(location: location).compact
  end

  def search_params_present?
    params[:genre].present? || params[:location].present? || params[:prefecture].present? || params[:budget].present? || params[:is_open].present?
  end
end
