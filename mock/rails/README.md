# MeshiDoko - Rails版フロントエンドモック

## 概要
このディレクトリには、**Ruby on Rails + Hotwire + Tailwind CSS**を前提としたフロントエンドモック（HTML/CSS）が含まれています。実際の機能は実装されていませんが、Rails実装時のデザイン・構造の参考になります。

## オリジナル版との違い

### オリジナル版（`/mock/index.html`）
- Next.js/React向け
- カスタムCSS（CSS変数、複雑なセレクタ）
- vanilla JavaScriptでの画面遷移
- SPA（Single Page Application）風の実装

### Rails版（このディレクトリ）
- Rails + Hotwire + Tailwind CSS向け
- Tailwind CSSユーティリティクラス
- Stimulus/Turbo用のdata属性
- MPA + Turboでの部分更新を想定

---

## ファイル構成
```
mock/rails/
├── README.md          # このファイル
├── index.html         # Rails + Tailwind版モック
└── styles.css         # カスタムCSS（最小限）
```

---

## モックの確認方法

### 方法1: ブラウザで直接開く
```bash
open mock/rails/index.html
```

### 方法2: VSCodeのLive Server（推奨）
1. VSCodeで `mock/rails/index.html` を開く
2. 右クリック → "Open with Live Server"

---

## 技術的特徴

### 1. Tailwind CSS
- **CDN版を使用**（開発時）
- 本番Railsでは`tailwindcss-rails` gemを使用
- カスタムカラー（テラコッタ＆クリーム）をconfig拡張で定義

### 2. Hotwire（Turbo + Stimulus）

#### Turbo
- `data-turbo-frame` 属性で部分更新エリアを定義
- 実際のRailsでは`turbo_frame_tag`ヘルパーを使用

#### Stimulus
- `data-controller`: Stimulusコントローラーを指定
- `data-action`: イベントハンドラを定義
- `data-{controller}-target`: DOM要素を参照

例:
```html
<button
  data-controller="favorite"
  data-action="click->favorite#toggle"
  data-favorite-target="icon">
  ♡
</button>
```

### 3. ViewComponents想定
コンポーネント単位で分割しやすい構造：
- `RestaurantCardComponent`
- `SearchFormComponent`
- `FavoriteButtonComponent`

---

## デザイン仕様

### カラースキーム（Tailwind拡張）
```javascript
colors: {
  'terracotta': '#D4704C',
  'deep-orange': '#B85C3C',
  'cream': '#FFF8F0',
  'warm-white': '#FFFBF5',
  'charcoal': '#2A2520',
  'soft-black': '#3D3530',
  'accent-turquoise': '#4A9B8E',
  'gold': '#D4AF37',
  'muted-red': '#C85A4A',
}
```

### タイポグラフィ
- **ディスプレイ**: DM Serif Display
- **ボディ**: Crimson Text
- **アクセント**: Cormorant Garamond

### アニメーション
- Tailwind CSSの`transition-*`クラス
- カスタムアニメーション（styles.css）
- cubic-bezier(0.16, 1, 0.3, 1)の滑らかな動き

---

## Rails実装時の対応表

### 1. HTML → ERB変換

**モック:**
```html
<div class="restaurant-card">
  <h3>イタリア食堂 ラ・トラットリア</h3>
  <p>東京都渋谷区道玄坂1-2-3</p>
</div>
```

**Rails (ERB):**
```erb
<div class="restaurant-card">
  <h3><%= restaurant.name %></h3>
  <p><%= restaurant.address %></p>
</div>
```

### 2. Tailwindクラス → そのまま使用

モックのTailwindクラスはRailsでそのまま使えます:
```html
<button class="bg-terracotta hover:bg-deep-orange text-cream px-6 py-3 rounded-lg transition-all duration-300">
  検索する
</button>
```

### 3. Stimulus data属性 → コントローラー作成

**モック:**
```html
<button data-controller="favorite" data-action="click->favorite#toggle">
  ♡
</button>
```

**Rails (Stimulus controller):**
```javascript
// app/javascript/controllers/favorite_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle(event) {
    event.preventDefault()
    // お気に入り登録/削除のロジック
  }
}
```

### 4. ViewComponents化

**モック:**
```html
<div class="restaurant-card">...</div>
```

**Rails (ViewComponent):**
```ruby
# app/components/restaurant_card_component.rb
class RestaurantCardComponent < ViewComponent::Base
  def initialize(restaurant:)
    @restaurant = restaurant
  end
end
```

```erb
<!-- app/components/restaurant_card_component.html.erb -->
<div class="restaurant-card">
  <h3><%= @restaurant.name %></h3>
  ...
</div>
```

---

## 実装されている画面

### 1. 検索画面（ホーム）
- 料理のジャンル選択（select）
- 場所入力（text input）
- 予算選択（select）
- 営業中フィルター（checkbox）
- 検索ボタン

### 2. 検索結果一覧画面
- レストランカード（グリッド表示）
- お気に入りボタン（Stimulus）
- 営業状態バッジ
- カードクリックで詳細画面へ

### 3. お店詳細画面
- 画像ギャラリー
- 基本情報（名前、評価、住所、営業時間、予算）
- 地図プレースホルダー
- SNSリンク
- 外部サイトリンク（食べログ、ホットペッパー）
- お気に入り・予約ボタン

### 4. お気に入り一覧画面
- 保存したお店のリスト
- 検索結果と同じカードデザイン

---

## Rails実装の推奨手順

### Phase 1: 環境構築
```bash
# Railsプロジェクト作成（PostgreSQL指定）
rails new meshidoko -d postgresql --css tailwind

# Hotwireは標準で含まれる
# Tailwind CSSも標準で含まれる
```

### Phase 2: Tailwind設定
```javascript
// config/tailwind.config.js
module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/components/**/*.rb',
  ],
  theme: {
    extend: {
      colors: {
        'terracotta': '#D4704C',
        'deep-orange': '#B85C3C',
        'cream': '#FFF8F0',
        // ... 他のカスタムカラー
      },
      fontFamily: {
        'display': ['DM Serif Display', 'serif'],
        'body': ['Crimson Text', 'serif'],
        'accent': ['Cormorant Garamond', 'serif'],
      },
    },
  },
}
```

### Phase 3: モックからの移植
1. このモック（index.html）を参照
2. 画面ごとにViewを作成
3. Tailwindクラスをそのままコピー
4. 動的データをERBに置き換え

### Phase 4: Stimulus実装
1. モックのdata属性を参照
2. 対応するStimulusコントローラーを作成
3. インタラクション実装

### Phase 5: ViewComponents化
1. 再利用可能なコンポーネントを特定
2. ViewComponent gemを導入
3. コンポーネントに分割

---

## 注意事項

### このモックについて
- 静的なHTMLであり、実際のデータ取得や保存機能はありません
- Tailwind CDNを使用（本番では`tailwindcss-rails`を使用）
- Stimulusの動作は簡易的なJavaScriptで実装
- Turbo Frameは実際には動作しません（属性のみ）

### Rails実装時の注意
- **SQLite3ではなくPostgreSQLを使用**
- Turbo Frameの動作にはRailsのバックエンドが必要
- 画像アップロードはActive Storageを使用
- 認証はDevise等のgemを使用

---

## オリジナル版との使い分け

### オリジナル版（`/mock/index.html`）を見るべき場合
- デザインコンセプトの全体像を理解したい
- アニメーションの完成形を確認したい
- Next.js実装を検討する場合

### Rails版（このディレクトリ）を見るべき場合
- Railsでの実装方法を検討したい
- Tailwind CSSのクラス名を確認したい
- Stimulus/Turboの構造を理解したい
- ViewComponents化の構造を検討したい

---

## 参考資料

- [Hotwire公式](https://hotwired.dev/)
- [Stimulus Handbook](https://stimulus.hotwired.dev/handbook/introduction)
- [Turbo Handbook](https://turbo.hotwired.dev/handbook/introduction)
- [Tailwind CSS](https://tailwindcss.com/)
- [ViewComponent](https://viewcomponent.org/)

---

## 更新履歴
- 2026-02-04: Rails版モック作成
