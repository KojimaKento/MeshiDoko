# MeshiDoko

## プロジェクト概要

MeshiDokoは、条件に合ったご飯屋さんをインターネット上の情報から探し、提案してくれるアプリです。
友達とご飯に行く際の「お店選びに時間がかかる」という問題を解決し、外出先でもスムーズにお店を決められることを目指します。

## ファイル構成
```
MeshiDoko/
├── CLAUDE.md           # プロジェクト開発ドキュメント
├── README.md           # このファイル（プロジェクト概要）
├── 要件定義書.md      # 詳細な要件定義
├── docs/               # 開発ドキュメント
│   ├── phase-1a-summary.md                # Phase 1-A完了サマリー
│   ├── phase-1b-development-guide.md      # Phase 1-B実装ガイド
│   └── github-push-troubleshooting.md     # GitHubトラブルシューティング
└── mock/               # フロントエンドモック（HTML/CSS）
    ├── README.md       # オリジナル版モックの詳細説明
    ├── index.html      # オリジナル版（Next.js向け）
    ├── styles.css      # オリジナル版スタイルシート
    └── rails/          # Rails版モック
        ├── README.md   # Rails版の詳細説明
        ├── index.html  # Rails + Tailwind版
        └── styles.css  # カスタムCSS（最小限）
```

## ドキュメント

### [CLAUDE.md](./CLAUDE.md)
プロジェクトの開発ドキュメントです。以下の内容が含まれています：
- プロジェクト概要とゴール
- ターゲットユーザー
- 主要機能（MVP）
- **UI/UX方針**（デザインコンセプト、カラースキーム、タイポグラフィなど）
- 技術仕様
- 開発ロードマップ
- 成功基準

### [要件定義書.md](./要件定義書.md)
詳細な要件定義書です。以下の内容が含まれています：
- アプリ概要と目的
- ターゲットユーザー
- 利用シーン
- MVP機能の詳細
- 将来追加したい機能
- 成功指標（KPI）
- 非機能要件
- 開発スケジュール

### [docs/phase-1b-development-guide.md](./docs/phase-1b-development-guide.md)
Phase 1-B（検索機能実装）の詳細ガイドです：
- シードデータ方式の実装手順
- 外部API統合への切り替え方法（Phase 2以降）
- RestaurantSearchServiceクラスの実装
- RSpecでのテスト方法

## フロントエンドモック

`mock/` ディレクトリに、完成イメージを視覚化したフロントエンドモック（HTML/CSS）が**2バージョン**含まれています。

### オリジナル版（Next.js向け）

`mock/index.html` - Next.js/React前提のモック
- カスタムCSS（CSS変数、複雑なセレクタ）
- vanilla JavaScriptでの画面遷移
- デザインコンセプトの完全再現

**確認方法:**
```bash
open mock/index.html
```

詳細は [mock/README.md](./mock/README.md) を参照してください。

### Rails版（Rails + Hotwire + Tailwind CSS向け）

`mock/rails/index.html` - Rails実装を想定したモック
- Tailwind CSSユーティリティクラス
- Stimulus/Turbo用のdata属性
- Rails実装時の参考資料

**確認方法:**
```bash
open mock/rails/index.html
```

詳細は [mock/rails/README.md](./mock/rails/README.md) を参照してください。

### どちらを使うべきか

- **デザインの全体像を確認したい** → オリジナル版
- **Rails実装の参考にしたい** → Rails版
- **Tailwind CSSのクラス名を確認したい** → Rails版
- **Stimulus/Turboの構造を理解したい** → Rails版

## 主要機能（MVP）

### 1. お店検索機能
条件を入力してお店を検索
- 料理のジャンル（和食、中華、イタリアン、麺類など）
- 場所（地名やエリア）
- 値段（予算範囲）
- 営業しているか（現在営業中のみ表示）

### 2. 検索結果一覧表示
条件に合うお店を5〜10件一覧で表示

### 3. お店詳細表示
- お店の基本情報（名前、写真、住所、地図、営業時間、予算、口コミ）
- SNSリンク（Instagram、X、Facebook）
- 外部サイトへのリンク（食べログ、ホットペッパー）

### 4. お気に入り登録
気に入ったお店を保存して後から見返せる機能

### 5. 予約サイト連携
予約サイトへのリンクを提供

## デザインコンセプト

**「エディトリアル × 美食の世界」**

### カラースキーム（テラコッタ＆クリーム）
- プライマリー: テラコッタ (#D4704C) → ディープオレンジ (#B85C3C)
- 背景: クリーム (#FFF8F0) / ウォームホワイト (#FFFBF5)
- アクセント: ターコイズ (#4A9B8E) / ゴールド (#D4AF37)

### タイポグラフィ
- ディスプレイ: DM Serif Display
- ボディ: Crimson Text
- アクセント: Cormorant Garamond

詳細は [CLAUDE.md](./CLAUDE.md) の「UI/UX方針」セクションを参照してください。

## モック実装画面

モックでは以下の画面が実装されています：

1. **検索画面（ホーム）**: 料理のジャンル、場所、予算、営業中フィルター
2. **検索結果一覧画面**: お店のカード表示、お気に入りボタン
3. **お店詳細画面**: 写真ギャラリー、基本情報、地図、SNSリンク、予約ボタン
4. **お気に入り一覧画面**: 保存したお店のリスト

詳細は [mock/README.md](./mock/README.md) を参照してください。

## 開発ロードマップ

### Phase 0: デザインモック作成 ✅
- 静的HTML/CSSによるプロトタイプ（2バージョン）
- デザインシステムの確立
- 全画面の実装
- Rails版モック作成

### Phase 1: MVP開発（進行中） 🚀
1. **Railsプロジェクト作成**（PostgreSQL指定） ✅
2. **環境構築**（Hotwire, Tailwind CSS, RSpec） ✅
3. **データベース設計**（Restaurant, Favorite モデル） ✅
4. **基本画面実装**（Rails版モックを参考に） ✅
5. **検索機能実装**（シードデータ方式）← 次のステップ
6. **お気に入り機能実装**
7. **テスト実装**（RSpec + FactoryBot + Capybara）

### Phase 2: 機能拡張・外部API統合
- **外部API連携**（ホットペッパーAPI）
- 共有機能
- 個室検索
- ユーザー認証（Devise）

### Phase 3: 位置情報機能
- GPS連携
- 現在地から近いお店の検索

## 技術スタック（確定）

### フレームワーク
- **Ruby on Rails 7.1+**（フルスタック）

### フロントエンド
- **Hotwire**（Turbo + Stimulus）
- **Tailwind CSS**
- **ViewComponents**

### データベース
- **PostgreSQL 14+**

### テスト
- **RSpec**
- **FactoryBot**
- **Capybara**

### 外部API
- ホットペッパーグルメサーチAPI（Phase 2以降で統合予定）
- Google Maps API（地図表示用）
- ※Phase 1では、シードデータを使用して開発

### ホスティング
- Render または Fly.io

## 成功基準

### 機能面
- ユーザーが条件を入力してお店を検索できる
- 検索結果が5〜10件表示される
- お店の詳細情報が全て表示される
- お気に入りに登録・削除できる

### ユーザー体験
- お店選びにかかる時間が従来の半分以下になる
- 外出先でストレスなく検索できる
- 初見のユーザーでも説明なしで使える

### 技術面
- 検索結果の表示が3秒以内
- モバイルでのレスポンシブ対応が完璧

## ライセンス

本プロジェクトは個人開発プロジェクトです。
