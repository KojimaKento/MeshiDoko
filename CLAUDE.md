# MeshiDoko

## プロジェクト概要

MeshiDokoは、条件に合ったご飯屋さんをインターネット上の情報から探し、提案してくれるアプリです。
友達とご飯に行く際の「お店選びに時間がかかる」という問題を解決し、外出先でもスムーズにお店を決められることを目指します。

## アプリのゴール

### WHO（誰のために）
- **プライマリーユーザー**: ご飯屋さんを探したい人全般
- **初期ターゲット**: 自分や友達、身近な人（20代〜30代を想定）
- **利用形態**: 個人またはグループでの利用

### WHAT（何を提供するか）
- 複数の条件に基づいた飲食店の検索機能
- 条件に合致するお店を5〜10件厳選して提案
- お店の詳細情報（写真、営業時間、予算、口コミ、SNSなど）の一覧表示
- お気に入り登録による後からの参照
- 予約サイトへのスムーズな遷移

### HOW（どのように実現するか）
- 食べログ・ホットペッパーなどの外部APIを活用した情報取得
- シンプルで直感的なUI/UXによる検索体験の提供
- 外出先でもストレスなく使えるレスポンシブデザイン
- 最小限の入力で最適な結果を提示するスマートな検索設計

## ターゲットユーザー詳細

### ユーザーペルソナ
- **年齢層**: 20代〜30代（初期）
- **利用デバイス**: スマートフォン（外出先での利用が主）
- **技術リテラシー**: 一般的なアプリ利用者レベル
- **利用頻度**: 週1〜2回程度（友達との食事の際）

### 利用シーン
1. **昼食時**: 会社の同僚や友達とランチを決める時
2. **夕食時**: 友達と遊んでいる最中に夕食のお店を探す時
3. **外出先**: 出かけている時にリアルタイムでお店を決めないといけない時

### ユーザーの課題
- 条件に合うお店を複数探すのに時間がかかる
- 複数のサイトを行き来して情報を比較するのが面倒
- その場ですぐに決めたいのに時間がかかってしまう

## 主要機能

### MVP機能（Phase 1: 最優先実装）

#### 1. お店検索機能
**説明**: 条件を入力してお店を検索できる機能

**検索条件**:
- 料理のジャンル（麺類、ご飯もの、和食、洋食、中華など）
- 場所（地名やエリアで検索）
- 値段（予算範囲）
- 営業しているか（現在営業中のみ表示するオプション）

**実装要件**:
- 各条件は任意入力（必須ではない）
- 複数条件の組み合わせ検索が可能
- 入力フォームはシンプルで分かりやすいUI

#### 2. 検索結果一覧表示
**説明**: 条件に合うお店を5〜10件一覧で表示

**表示内容**（カード形式）:
- お店の名前
- 代表写真（1枚）
- 住所
- 予算（ランチ/ディナー）
- 口コミの評価（星の数など）
- 営業時間

**実装要件**:
- スクロール可能なリスト表示
- 各カードをタップすると詳細画面へ遷移
- 結果が0件の場合は適切なメッセージを表示

#### 3. お店詳細表示機能
**説明**: 一覧から選んだお店の詳細情報を表示

**表示内容**:
- お店の名前
- 複数の写真（ギャラリー形式）
- 住所
- 地図（Google Mapsの埋め込みまたはリンク）
- 営業時間（曜日別）
- 予算（ランチ/ディナー）
- 口コミの評価
- SNSリンク（Instagram、X、Facebookなど、お店が利用している場合）
- 元の情報源へのリンク（食べログ、ホットペッパー）

**実装要件**:
- 見やすく整理されたレイアウト
- 画像は拡大表示可能
- 地図はタップでマップアプリを起動

#### 4. お気に入り登録機能
**説明**: 気に入ったお店を保存して後から見返せる機能

**機能詳細**:
- お店詳細画面または一覧画面から「お気に入り」ボタンをタップして登録
- お気に入り一覧画面で保存したお店を表示
- お気に入りから削除も可能

**実装要件**:
- ローカルストレージ（または簡易的なDB）に保存
- お気に入りの状態が視覚的に分かりやすい（ハートアイコンなど）

#### 5. 予約サイト連携
**説明**: 予約サイトへのリンクを提供

**機能詳細**:
- お店詳細画面に「予約する」ボタンを配置
- タップすると食べログやホットペッパーの予約ページへ遷移

**実装要件**:
- 外部ブラウザまたはアプリ内ブラウザで開く
- 予約可能なお店のみボタンを表示

### 将来追加機能（Phase 2以降）

#### Phase 2候補
- **友達と情報を共有する機能**: LINEやメールでお店情報を共有
- **個室の有無での検索**: 検索条件に個室フィルターを追加

#### Phase 3候補
- **現在地から近いお店を検索**: GPS情報を利用した位置ベース検索
- **地図アプリでの経路検索**: お店までのルート検索機能
- **複数人での投票機能**: グループでお店候補に投票して決める
- **検索履歴**: 過去の検索条件を保存・再利用

## UI/UX方針

### デザインコンセプト
**「エディトリアル × 美食の世界」**
- エディトリアル/マガジンスタイルをベースにした洗練されたデザイン
- 食欲をそそる暖色系のカラーパレット
- 遊び心のあるインタラクションとアニメーション
- 記憶に残る独特なビジュアル体験

### デザイン原則
1. **シンプル**: 必要最小限の情報のみを表示し、複雑さを排除
2. **直感的**: 説明不要で使えるインターフェース
3. **高速**: 検索から結果表示まで素早いレスポンス
4. **モバイルファースト**: スマートフォンでの利用を最優先に設計
5. **エディトリアルの洗練さ**: 雑誌のような高品質な見た目と体験

### 画面構成
1. **ホーム画面（検索画面）**: 検索条件入力フォーム
2. **検索結果一覧画面**: お店のカードリスト（マガジングリッド）
3. **お店詳細画面**: 詳細情報とアクション（お気に入り、予約）
4. **お気に入り一覧画面**: 保存したお店のリスト
5. **ナビゲーション**: タブ切り替え方式（検索/お気に入り）

### カラースキーム（テラコッタ＆クリーム）
- **プライマリーカラー**: テラコッタ (#D4704C) → ディープオレンジ (#B85C3C)
- **背景**: クリーム (#FFF8F0) / ウォームホワイト (#FFFBF5)
- **テキスト**: チャコール (#2A2520) / ソフトブラック (#3D3530)
- **アクセント**: ターコイズ (#4A9B8E) / ゴールド (#D4AF37)
- **エラー/警告**: ミューテッドレッド (#C85A4A)

### タイポグラフィ
- **ディスプレイフォント**: DM Serif Display（見出し・タイトル）
- **ボディフォント**: Crimson Text（本文）
- **アクセントフォント**: Cormorant Garamond（ナビゲーション、ラベル）
- **特徴**: セリフ体を使用することでエディトリアルな印象を演出
- **サイズ**: モバイルでも読みやすいサイズ設定（最小14px以上）

### ビジュアルエフェクト
- **グラデーションメッシュ**: 背景に微細なグラデーションで深みを追加
- **ノイズテクスチャ**: 紙のような質感のオーバーレイ
- **非対称レイアウト**: カードに微妙な回転（±0.5deg）で動きを演出
- **クリップパス**: カード画像に斜めのカットを適用
- **デコラティブボーダー**: フォームやカードに装飾的な枠線
- **ドラマティックシャドウ**: 立体感のある影効果

### アニメーション
- **ページロード**: 段階的なフェードイン（animation-delay活用）
- **ホバーエフェクト**: スケール、回転、移動の組み合わせ
- **マイクロインタラクション**: ボタンのrippleエフェクト、矢印の移動
- **トランジション**: cubic-bezier(0.16, 1, 0.3, 1)で滑らかな動き

## 技術仕様

### 技術スタック（確定）
**フレームワーク**:
- Ruby on Rails 7.1+（フルスタックWebフレームワーク）

**フロントエンド**:
- Hotwire (Turbo + Stimulus)（モダンなインタラクション）
- Tailwind CSS（効率的なスタイリング）
- ViewComponents（コンポーネント化）

**データベース**:
- PostgreSQL 14+（リレーショナルデータベース）
- ※開発環境でもPostgreSQLを使用（SQLite3は使用しない）

**テストフレームワーク**:
- RSpec（単体テスト・統合テスト）
- FactoryBot（テストデータ作成）
- Capybara（E2Eテスト）

**外部API連携**:
- Faraday または HTTParty（HTTPクライアント）
- ホットペッパーグルメサーチAPI
- 食べログAPI（利用可能な場合）
- Google Maps API（地図表示用）

**認証・認可**:
- Devise（ユーザー認証）※将来的に実装

**その他のGem**:
- Kaminari（ページネーション）
- Active Storage（画像アップロード）※将来的に実装

**ホスティング**:
- Render または Fly.io（Rails対応ホスティング）
- PostgreSQLデータベース付き

### データモデル（Rails ActiveRecord）

#### お店情報（Restaurant）
```ruby
# app/models/restaurant.rb
class Restaurant < ApplicationRecord
  # 外部APIから取得したデータを保存（キャッシュ目的）
  # または、ユーザーが登録したお店情報

  # カラム定義
  # id: integer (primary key, auto increment)
  # external_id: string - 外部API（食べログ、ホットペッパー）のID
  # name: string - お店の名前
  # genre: string - 料理のジャンル
  # address: string - 住所
  # latitude: decimal - 緯度
  # longitude: decimal - 経度
  # budget_lunch: integer - ランチ予算（円）
  # budget_dinner: integer - ディナー予算（円）
  # rating: decimal - 評価（星の数）
  # is_open: boolean - 現在営業中かどうか
  # opening_hours: jsonb - 営業時間（JSON形式）
  # sns_instagram: string - InstagramのURL
  # sns_twitter: string - X（Twitter）のURL
  # sns_facebook: string - FacebookのURL
  # reservation_url: string - 予約サイトのURL
  # source: string - データソース（tabelog/hotpepper）
  # created_at: datetime
  # updated_at: datetime

  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :user

  validates :name, presence: { message: 'を入力してください' }
  validates :external_id, presence: { message: 'を入力してください' }
end
```

#### お気に入り（Favorite）
```ruby
# app/models/favorite.rb
class Favorite < ApplicationRecord
  # ユーザーとレストランの中間テーブル

  # カラム定義
  # id: integer (primary key, auto increment)
  # user_id: integer - ユーザーID（外部キー）※将来実装
  # restaurant_id: integer - レストランID（外部キー）
  # created_at: datetime
  # updated_at: datetime

  belongs_to :user, optional: true # 初期段階ではユーザー認証なし
  belongs_to :restaurant

  validates :restaurant_id, presence: { message: 'を入力してください' }
  validates :restaurant_id, uniqueness: { scope: :user_id, message: 'は既にお気に入りに登録されています' }
end
```

#### ユーザー（User）※将来実装
```ruby
# app/models/user.rb
class User < ApplicationRecord
  # Deviseで認証機能を追加予定

  # カラム定義（Devise標準）
  # id: integer (primary key, auto increment)
  # email: string
  # encrypted_password: string
  # created_at: datetime
  # updated_at: datetime

  has_many :favorites, dependent: :destroy
  has_many :favorite_restaurants, through: :favorites, source: :restaurant
end
```

### ルーティング・コントローラー設計（Rails）

#### ルーティング
```ruby
# config/routes.rb
Rails.application.routes.draw do
  root 'restaurants#index'

  # お店検索
  resources :restaurants, only: [:index, :show] do
    collection do
      get :search  # 検索実行
    end
  end

  # お気に入り
  resources :favorites, only: [:index, :create, :destroy]

  # 外部API連携（バックグラウンド処理用）
  namespace :api do
    namespace :v1 do
      resources :restaurants, only: [:index, :show]
    end
  end
end
```

#### コントローラー

**検索・一覧表示**
```ruby
# app/controllers/restaurants_controller.rb
class RestaurantsController < ApplicationController
  def index
    # 検索フォームを表示
  end

  def search
    # 検索パラメータを受け取る
    # params[:genre], params[:location], params[:budget], params[:is_open]

    # 外部API（ホットペッパー、食べログ）から検索
    @restaurants = RestaurantSearchService.search(search_params)

    # Turbo Frameで検索結果を返す
    render turbo_stream: turbo_stream.replace('search_results', partial: 'restaurants/results', locals: { restaurants: @restaurants })
  end

  def show
    # お店詳細を表示
    @restaurant = Restaurant.find(params[:id])
  end

  private

  def search_params
    params.permit(:genre, :location, :budget, :is_open)
  end
end
```

**お気に入り**
```ruby
# app/controllers/favorites_controller.rb
class FavoritesController < ApplicationController
  def index
    # お気に入り一覧を表示
    @favorites = Favorite.includes(:restaurant).all
  end

  def create
    # お気に入りに追加
    @favorite = Favorite.new(favorite_params)

    if @favorite.save
      # Stimulusでボタンの表示を切り替え
      render turbo_stream: turbo_stream.replace("favorite_#{params[:restaurant_id]}", partial: 'favorites/button', locals: { restaurant_id: params[:restaurant_id], favorited: true })
    else
      render turbo_stream: turbo_stream.replace("favorite_#{params[:restaurant_id]}_error", partial: 'shared/error', locals: { errors: @favorite.errors })
    end
  end

  def destroy
    # お気に入りから削除
    @favorite = Favorite.find(params[:id])
    restaurant_id = @favorite.restaurant_id
    @favorite.destroy

    render turbo_stream: turbo_stream.replace("favorite_#{restaurant_id}", partial: 'favorites/button', locals: { restaurant_id: restaurant_id, favorited: false })
  end

  private

  def favorite_params
    params.require(:favorite).permit(:restaurant_id)
  end
end
```

#### サービスクラス（外部API連携）
```ruby
# app/services/restaurant_search_service.rb
class RestaurantSearchService
  def self.search(params)
    # ホットペッパーAPIまたは食べログAPIから検索
    # Faradayを使ってHTTPリクエスト

    response = Faraday.get('https://api.hotpepper.jp/gourmet/v1/') do |req|
      req.params['key'] = ENV['HOTPEPPER_API_KEY']
      req.params['genre'] = params[:genre] if params[:genre].present?
      req.params['keyword'] = params[:location] if params[:location].present?
      req.params['budget'] = params[:budget] if params[:budget].present?
      # ... その他のパラメータ
    end

    # レスポンスをパースしてRestaurantオブジェクトに変換
    parse_response(response.body)
  end

  private

  def self.parse_response(body)
    # JSONをパースしてRestaurantオブジェクトの配列を返す
  end
end
```

## フロントエンドモック

### モックの概要
`mock/` ディレクトリに、完成イメージを視覚化したフロントエンドモック（HTML/CSS）を**2バージョン**作成済みです。

#### オリジナル版（Next.js向け）
`mock/index.html` - デザインコンセプトの完全版

**特徴**:
- カスタムCSS（CSS変数、複雑なセレクタ）
- vanilla JavaScriptでの画面遷移
- アニメーション・マイクロインタラクションの完全実装

詳細は `mock/README.md` を参照してください。

#### Rails版（採用版）
`mock/rails/index.html` - Rails実装を想定したバージョン

**特徴**:
- **Tailwind CSSユーティリティクラス**で実装
- **Stimulus/Turbo用のdata属性**を付与
- **ViewComponents化しやすい構造**
- Rails実装時にそのまま参考にできる

**モックの確認方法**:
- `mock/rails/index.html` をブラウザで開く
- または VSCode の Live Server で起動

**モックの役割**:
- Railsでの実装方法の参考資料
- Tailwind CSSクラス名の確認
- Stimulus/Turbo構造の理解
- ViewComponents設計の検討

詳細は `mock/rails/README.md` を参照してください。

## 開発ロードマップ

### Phase 0: デザインモック作成 ✅
**目標**: 完成イメージの可視化とデザイン方針の確定

1. **静的モックの作成** ✅
   - HTML/CSSによるプロトタイプ
   - デザインシステムの確立
   - 全画面の実装

### Phase 1: MVP開発（最優先）
**目標**: 基本的な検索・表示・お気に入り機能の実装

1. **環境構築**
   - Railsプロジェクト作成（PostgreSQL指定）
     ```bash
     rails new meshidoko -d postgresql --css tailwind
     ```
   - Hotwire（Turbo + Stimulus）の確認（Rails 7では標準搭載）
   - Tailwind CSSの設定（カスタムカラー追加）
   - RSpec, FactoryBot, Capybaraのセットアップ
   - 外部API（ホットペッパー等）のアカウント取得

2. **データベース設計・マイグレーション**
   - Restaurantモデルの作成
   - Favoriteモデルの作成
   - マイグレーション実行
   - シードデータ作成（開発用）

3. **基本画面実装（Hotwire + Tailwind CSS）**
   - Rails版モック（`mock/rails/`）を参考にView作成
   - Tailwind設定ファイルでカスタムカラー定義
   - 検索画面のUI作成（`restaurants#index`）
   - 検索結果一覧画面のUI作成（Turbo Frame使用）
   - お店詳細画面のUI作成（`restaurants#show`）
   - お気に入り一覧画面のUI作成（`favorites#index`）
   - ViewComponentsでコンポーネント化（RestaurantCard等）

4. **検索機能実装**
   - RestaurantSearchServiceクラスの実装
   - 外部API連携（Faraday使用）
   - ホットペッパーAPIからのデータ取得
   - 検索ロジックの実装
   - エラーハンドリング
   - Turbo Streamでの結果表示

5. **お気に入り機能実装**
   - Favoriteコントローラーの実装
   - お気に入り登録/削除機能（Turbo Stream使用）
   - Stimulusコントローラーでボタン制御
   - お気に入り一覧表示

6. **テスト実装（RSpec）**
   - Restaurantモデルのテスト
   - Favoriteモデルのテスト
   - RestaurantsControllerのリクエストテスト
   - FavoritesControllerのリクエストテスト
   - RestaurantSearchServiceのテスト
   - Capybaraでのシステムテスト（E2E）

7. **調整・最適化**
   - UI/UX改善
   - パフォーマンス最適化
   - バグ修正
   - レスポンシブ対応の確認

### Phase 2: 機能拡張
**目標**: 共有機能・個室検索の追加

1. 友達と情報を共有する機能
2. 個室の有無での検索条件追加
3. UI/UXの改善

### Phase 3: 位置情報機能
**目標**: 現在地ベースの検索・経路案内

1. GPS連携
2. 現在地から近いお店の検索
3. 地図アプリとの連携

## 成功基準

### Phase 1（MVP）の成功基準
- [ ] ユーザーが条件を入力してお店を検索できる
- [ ] 検索結果が5〜10件表示される
- [ ] お店の詳細情報（名前、写真、住所、地図、営業時間、予算、口コミ、SNS）が全て表示される
- [ ] お気に入りにお店を登録・削除できる
- [ ] お気に入り一覧からお店を確認できる
- [ ] 予約サイトへのリンクが正常に動作する
- [ ] スマートフォンで快適に操作できる

### ユーザー体験の成功基準
- [ ] お店選びにかかる時間が従来の半分以下になる
- [ ] 外出先でストレスなく検索できる
- [ ] 初見のユーザーでも説明なしで使える

### 技術的な成功基準
- [ ] 検索結果の表示が3秒以内
- [ ] 外部APIのエラーハンドリングが適切
- [ ] モバイルでのレスポンシブ対応が完璧
- [ ] お気に入りデータが永続化される

## 開発ガイドライン

### コーディング規約（Rails）
- **Rubyスタイルガイド**に従う（RuboCop使用）
- **Fat Model, Skinny Controller**の原則
- モデルのバリデーションは日本語エラーメッセージ
  - 例: `presence: { message: 'を入力してください' }`
- ViewComponentsで再利用可能なコンポーネント設計
- Stimulusコントローラーは小さく、単一責任
- メソッド名・変数名は分かりやすく命名（Rubyの慣習に従う）
- コメントは必要最小限（コードで意図を表現）

### テスト規約（RSpec）
- **テストは必ず書く**
- テストの構成順序:
  1. 正常系（有効なケース）
  2. 異常系（無効なケース）
  3. 境界値（制限値付近のケース）
- FactoryBotでテストデータ作成
- システムテスト（Capybara）で主要なユーザーフローを検証

### Git運用
- mainブランチは常にデプロイ可能な状態を保つ
- 機能ごとにブランチを切る（feature/xxx）
- **コミットメッセージは日本語で記述**
- コミットメッセージは明確に（何をしたか・なぜしたか）
  - 例: `Restaurantモデルにバリデーションを追加`

### テスト方針（RSpec）
- **テストは必ず書く**
- モデルテスト（RSpec）
  - バリデーションのテスト
  - アソシエーションのテスト
  - メソッドのテスト
- コントローラーテスト（Request Spec）
  - HTTPリクエスト・レスポンスのテスト
  - パラメータのテスト
- システムテスト（Capybara）
  - 主要なユーザーフローを検証
  - 検索→結果表示→詳細表示→お気に入り登録の一連の流れ
- サービステスト
  - 外部API連携部分はモック（WebMock）を活用
  - エラーハンドリングのテスト

## 注意事項

### 外部API利用に関して
- 各APIの利用規約を遵守する
- API制限（リクエスト数など）を考慮した実装
- APIキーは環境変数で管理し、Gitにコミットしない

### データ取り扱い
- お気に入りデータは適切に管理
- 個人情報は収集しない（初期段階）
- 外部サービスのデータはキャッシュのみ（永続化しない）

---

## 開発進捗（2026-02-05現在）

### 完了したセットアップ ✅

#### 1. Railsプロジェクト作成 ✅
- Ruby 3.3.10 + Rails 8.1.2
- PostgreSQL設定
- Hotwire（Turbo + Stimulus）標準搭載
- Tailwind CSS標準搭載

#### 2. PostgreSQLセットアップ ✅
- PostgreSQL 14起動
- 開発環境データベース作成（`meshi_doko_development`）
- テスト環境データベース作成（`meshi_doko_test`）

#### 3. Tailwind CSSカスタム設定 ✅
- カスタムカラー追加（テラコッタ＆クリームパレット）
  - terracotta, deep-orange, cream, warm-white, charcoal等
- カスタムフォント追加
  - DM Serif Display（ディスプレイ）
  - Crimson Text（ボディ）
  - Cormorant Garamond（アクセント）

#### 4. RSpec + FactoryBot + Fakerセットアップ ✅
- RSpec 3.13インストール
- FactoryBot設定完了
- Fakerインストール

#### 5. モデル作成 ✅
- **Restaurantモデル**
  - フィールド: external_id, name, genre, address, latitude, longitude, budget_lunch, budget_dinner, rating, is_open, opening_hours(jsonb), sns_*, reservation_url, source
  - バリデーション: name, external_id（日本語エラーメッセージ）
  - アソシエーション: has_many :favorites

- **Favoriteモデル**
  - フィールド: restaurant_id
  - バリデーション: restaurant_id（日本語エラーメッセージ）
  - アソシエーション: belongs_to :restaurant

#### 6. Gitリポジトリ管理 ✅
```
40850f8 RestaurantモデルとFavoriteモデルを作成、バリデーション追加
e8fb7f4 RSpec、FactoryBot、Fakerのセットアップ完了
a5b6d1f Tailwind CSSカスタムカラーとフォントを追加
a12c67a MeshiDokoプロジェクト初期作成
```

---

#### 7. Phase 1-A: 基本画面の実装 ✅
**完了日**: 2026-02-06

**実装内容**:
1. **ルーティング設定** ✅
   - rootパスを`search#index`に設定
   - resources :restaurants（index, show）
   - resources :favorites（index, create, destroy）

2. **コントローラー作成** ✅
   - `SearchController` - 検索フォーム表示
   - `RestaurantsController` - 検索結果一覧・詳細表示（サンプルデータ実装）
   - `FavoritesController` - お気に入り一覧表示（サンプルデータ実装）

3. **レイアウト実装** ✅
   - `app/views/layouts/application.html.erb`更新
   - Google Fonts統合（DM Serif Display, Crimson Text, Cormorant Garamond）
   - ヘッダー（MeshiDokoタイトル、グラデーション背景）
   - ナビゲーションタブ（検索/お気に入り、アクティブ状態表示）

4. **4つの主要画面のView作成** ✅
   - **検索画面**（`app/views/search/index.html.erb`）
     - ジャンル、場所、予算、営業中フィルター
     - form_withによるRailsフォーム実装
   - **検索結果一覧**（`app/views/restaurants/index.html.erb`）
     - 8件のサンプルレストランデータ表示
     - カード形式でグリッド表示
     - カード全体がクリック可能（詳細画面へ遷移）
     - お気に入りボタン（event.stopPropagation実装）
   - **レストラン詳細**（`app/views/restaurants/show.html.erb`）
     - メイン画像 + 画像ギャラリー
     - 基本情報（名前、評価、営業状況）
     - 住所・アクセス、営業時間、予算、ジャンル
     - SNSリンク、外部サイトリンク
     - お気に入り追加ボタン（Sticky Footer）
   - **お気に入り一覧**（`app/views/favorites/index.html.erb`）
     - お気に入りレストラン表示
     - 空の状態メッセージ + 検索画面へのリンク

5. **サンプルデータ実装** ✅
   - 8件のレストランデータ（ID 1-8）
   - 詳細画面用の追加情報（画像配列、営業時間、SNS、外部リンク）

6. **Tailwind CSSスタイル適用** ✅
   - モックデザインに完全準拠
   - カスタムカラー・フォントの全画面適用
   - ホバーエフェクト、トランジション実装

**動作確認**: localhost:3000で全画面表示・遷移確認済み

**Gitコミット**:
```
291b1bf GitHub Actionsワークフローを一時削除
1bf8f9c MeshiDoko Phase 1-A 完了版
```

**修正内容**（2026-02-06追加）:
- カード全体をクリック可能に変更（link_toでカード全体をラップ）
- お気に入りボタンにevent.stopPropagation()追加（カードリンクと干渉しないように）

**GitHubリポジトリ**: ✅ プッシュ完了
- リポジトリURL: https://github.com/KojimaKento/MeshiDoko
- ブランチ: main
- ファイル数: 144個
- トラブルシューティング記録: `docs/github-push-troubleshooting.md`

---

### 次のステップ（Phase 1: MVP開発継続）

#### Phase 1-B: 外部API連携 🚀（次のステップ）
1. **ホットペッパーAPI統合**
   - アカウント取得（リクルートID）
   - APIキーの環境変数設定（`.env`ファイル）
   - dotenv-rails gemの追加

2. **RestaurantSearchServiceクラス実装**
   - `app/services/restaurant_search_service.rb`作成
   - Faradayを使ったHTTPリクエスト実装
   - 検索パラメータ（genre, location, budget, is_open）をAPIリクエストに変換
   - レスポンスのパース処理（JSON → Restaurantモデル形式）
   - エラーハンドリング（タイムアウト、APIエラー、レート制限）

3. **RestaurantsController更新**
   - サンプルデータからAPI呼び出しに変更
   - 検索パラメータの処理
   - エラーメッセージの表示

4. **RSpecでのテスト**
   - WebMockでAPI通信をモック化
   - 正常系・異常系・境界値のテスト
   - VCRでのHTTP記録・再生（オプション）

#### Phase 1-C: お気に入り機能 🔄
1. **お気に入り機能のバックエンド実装**
   - FavoritesController#createアクション（POST /favorites）
   - FavoritesController#destroyアクション（DELETE /favorites/:id）
   - Turbo Streamでの動的更新
   - Restaurant保存処理（外部APIデータをDBに永続化）

2. **Stimulusコントローラー実装**
   - `app/javascript/controllers/favorite_controller.js`作成
   - お気に入りボタンのトグル機能
   - フェッチAPIでバックエンド呼び出し
   - UIの即時更新（ハートアイコンの切り替え）

3. **データ永続化**
   - レストラン情報をRestaurantテーブルに保存
   - FavoriteテーブルにRestaurant IDを保存
   - お気に入り一覧表示をDBから取得するように変更

4. **RSpecでのテスト**
   - FavoritesControllerのリクエストテスト
   - Favoriteモデルのバリデーションテスト
   - システムテスト（Capybara）でE2E確認

---

## 更新履歴
- 2026-02-06（第6版）: **GitHubリポジトリ作成・プッシュ完了**
  - GitHubリポジトリ作成: https://github.com/KojimaKento/MeshiDoko
  - トラブルシューティング実施（.gitignore作成、PAT認証、Git履歴クリーンアップ）
  - docs/github-push-troubleshooting.md作成（問題と解決方法を文書化）
  - Phase 1-A完全完了
- 2026-02-06（第5版）: **Phase 1-A完了（基本画面実装）**
  - 4つの主要画面実装完了（検索、検索結果、詳細、お気に入り）
  - レイアウト実装（ヘッダー、ナビゲーション、Google Fonts統合）
  - サンプルデータで動作確認
  - カードクリック可能化の修正
  - 開発進捗セクション更新（Phase 1-A完了を記録）
- 2026-02-05（第4版）: **初期セットアップ完了、開発進捗セクション追加**
  - Railsプロジェクト作成（PostgreSQL + Hotwire + Tailwind CSS）
  - Tailwind CSSカスタム設定完了
  - RSpec + FactoryBot + Fakerセットアップ完了
  - Restaurant, Favoriteモデル作成
  - 開発進捗セクション追加（現在の状態と次のステップを明記）
- 2026-02-04（第3版）: **技術スタック確定（Rails採用）**
  - 技術スタックをRuby on Rails + Hotwire + Tailwind CSS + PostgreSQLに確定
  - データモデルをActiveRecord形式に変更
  - ルーティング・コントローラー設計を追加
  - Rails版フロントエンドモック作成（`mock/rails/`）
  - 開発ロードマップをRails開発手順に更新
  - コーディング規約・テスト規約をRails用に更新
- 2026-02-04（第2版）: デザイン方針の確定、フロントエンドモック作成に伴う更新
  - UI/UXセクションの大幅拡充（デザインコンセプト、カラースキーム、タイポグラフィ、ビジュアルエフェクト、アニメーション）
  - フロントエンドモックセクションの追加
  - Phase 0（デザインモック作成）の追加
- 2026-02-03（初版）: 初版作成（要件定義をもとにCLAUDE.md作成）
