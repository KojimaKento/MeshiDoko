# Phase 1-B開発方針変更サマリー

## 変更日
2026-02-07

## 変更内容

### 開発方針の変更
**旧方針**: 外部API（ホットペッパーAPI）を最初から統合して開発

**新方針**: シードデータ方式で開発し、後から外部APIに切り替え可能な設計

### 変更理由
1. **開発スピードの向上**: APIアカウント取得の手間を省き、すぐに開発を開始できる
2. **API制限の回避**: 開発中にリクエスト制限（1日3,000件）に引っかかるリスクを回避
3. **オフライン開発**: ネットワークに依存せず開発可能
4. **テストの簡易化**: 外部APIをモック化する必要がなく、テストが簡単

### メリット
- ✅ すぐに開発を始められる
- ✅ API制限を気にせず開発できる
- ✅ オフラインでも開発可能
- ✅ 後からAPI実装に切り替えやすい設計
- ✅ テストが簡単

---

## 更新したドキュメント

### 1. 新規作成: `docs/phase-1b-development-guide.md`
Phase 1-B（検索機能実装）の詳細ガイドを作成しました。

**内容**:
- シードデータ方式の実装手順（6ステップ）
  1. 充実したシードデータの作成（50件以上）
  2. RestaurantSearchServiceクラス実装
  3. RestaurantsController更新
  4. 環境変数の設定（オプション）
  5. RSpecでのテスト実装
  6. 動作確認
- Phase 2以降の外部API統合への切り替え手順
- コードサンプル、テストコード付き

### 2. 更新: `CLAUDE.md`
プロジェクト開発ドキュメントを更新しました。

**変更箇所**:
- **Phase 1ロードマップ**:
  - 「4. 検索機能実装」をシードデータ方式に変更
  - 環境構築から「外部APIアカウント取得」を削除（オプション化）
- **次のステップ（Phase 1-B）**:
  - シードデータ方式優先に変更
  - 外部API統合はPhase 2以降で実装
- **Phase 2**:
  - 「外部API統合（ホットペッパーAPI）」を追加
- **更新履歴**:
  - 第7版として今回の変更を記録

### 3. 更新: `README.md`
プロジェクト概要ドキュメントを更新しました。

**変更箇所**:
- **ファイル構成**:
  - `docs/` ディレクトリの追加
  - `phase-1b-development-guide.md` の追加
- **ドキュメント**:
  - Phase 1-B開発ガイドへのリンク追加
- **開発ロードマップ（Phase 1）**:
  - 「5. 外部API連携」→「5. 検索機能実装（シードデータ方式）」に変更
  - 完了済み項目にチェックマーク追加
- **Phase 2**:
  - 「外部API連携」を追加
- **外部API**:
  - ホットペッパーAPIは「Phase 2以降で統合予定」と明記
  - Phase 1ではシードデータを使用することを明記

---

## 次のアクション

### Phase 1-B開発開始
`docs/phase-1b-development-guide.md` の手順に従って、以下を実施します：

1. **ステップ1**: `db/seeds.rb` に50件以上のレストランデータを作成
2. **ステップ2**: `RestaurantSearchService` クラスの実装
3. **ステップ3**: `RestaurantsController` の更新
4. **ステップ4**: 環境変数の設定（`.env`ファイル作成）
5. **ステップ5**: RSpecでのテスト実装
6. **ステップ6**: 動作確認

### Phase 2以降
Phase 1（MVP）が完成してから、以下を実施します：
- ホットペッパーAPI統合
- リアルタイムデータ取得
- 本番環境でのテスト

---

## 設計のポイント

### API/DB切り替え可能な設計

```ruby
# app/services/restaurant_search_service.rb
class RestaurantSearchService
  def self.search(params)
    if use_api?
      search_from_api(params)    # API版（Phase 2以降）
    else
      search_from_database(params) # DB版（Phase 1）
    end
  end

  private

  def self.use_api?
    ENV['USE_HOTPEPPER_API'] == 'true' && ENV['HOTPEPPER_API_KEY'].present?
  end
end
```

**環境変数で切り替え**:
- Phase 1: `USE_HOTPEPPER_API=false`（シードデータ使用）
- Phase 2以降: `USE_HOTPEPPER_API=true`（ホットペッパーAPI使用）

---

## まとめ

Phase 1-Bの開発方針をシードデータ方式に変更し、関連ドキュメントを全て更新しました。

**更新ファイル**:
1. ✅ 新規作成: `docs/phase-1b-development-guide.md`
2. ✅ 更新: `CLAUDE.md`（Phase 1ロードマップ、次のステップ、Phase 2、更新履歴）
3. ✅ 更新: `README.md`（ファイル構成、ドキュメント、開発ロードマップ、外部API）
4. ✅ 新規作成: `docs/phase-1b-update-summary.md`（このファイル）

**次のステップ**: Phase 1-B開発を開始（`docs/phase-1b-development-guide.md` を参照）
