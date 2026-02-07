# app/services/restaurant_search_service.rb
# Phase 1-B: レストラン検索サービス
# データベースまたは外部APIから検索を実行

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

  # データベースから検索（Phase 1の実装）
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
