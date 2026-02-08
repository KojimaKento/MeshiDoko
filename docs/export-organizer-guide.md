# Export History Organizer - 使用ガイド

## 概要

`organize_exports.sh`は、Claude Codeの`/export`コマンドで出力されたセッション履歴ファイルを自動的に整理するシェルスクリプトです。

**対応ファイル形式**:
- `conversation-*.txt` （標準形式）
- `YYYY-MM-DD-*.txt` （日付で始まる形式）

### 主な機能

1. **ファイルの自動整理**: ルートディレクトリに散らばったエクスポートファイルを年/月フォルダに整理
2. **ルートから自動削除**: 移動（mv）によりルートディレクトリから元ファイルを削除
3. **要約テンプレート自動生成**: AI要約用のMarkdownテンプレートを自動作成
4. **メタデータ抽出**: 日付、時刻、行数などの情報を自動抽出
5. **柔軟なファイル検出**: 複数のファイル名形式に対応、除外リスト機能付き

---

## フォルダ構造

スクリプト実行後、以下の構造でファイルが整理されます：

```
MeshiDoko/
├── export-history/
│   ├── raw/                          # 元のテキストファイル保管場所
│   │   └── 2026/                     # 年フォルダ
│   │       └── 02/                   # 月フォルダ
│   │           ├── conversation-2026-02-08-143000.txt
│   │           ├── conversation-2026-02-08-150000.txt
│   │           └── ...
│   └── summaries/                    # 要約ファイル保管場所
│       └── 2026/                     # 年フォルダ
│           └── 02/                   # 月フォルダ
│               ├── summary-2026-02-08-143000.md
│               ├── summary-2026-02-08-150000.md
│               └── ...
└── scripts/
    └── organize_exports.sh           # このスクリプト
```

---

## 使用方法

### 1. /exportコマンドを実行

Claude Code内で：

```bash
/export
```

これにより、プロジェクトルートに`conversation-YYYY-MM-DD-HHMMSS.txt`ファイルが作成されます。

### 2. 整理スクリプトを実行

ターミナルで：

```bash
./scripts/organize_exports.sh
```

**実行例**:

```bash
$ ./scripts/organize_exports.sh

================================================
  MeshiDoko Export History Organizer
================================================

📄 処理中: conversation-2026-02-08-143000.txt
  ✓ ルートから削除: conversation-2026-02-08-143000.txt
  ✓ 移動先: export-history/raw/2026/02/conversation-2026-02-08-143000.txt
  ✓ 要約テンプレート作成: export-history/summaries/2026/02/summary-2026-02-08-143000.md

📄 処理中: 2026-02-08-some-description.txt
  ✓ ルートから削除: 2026-02-08-some-description.txt
  ✓ 移動先: export-history/raw/2026/02/conversation-2026-02-08-120734.txt
  ✓ 要約テンプレート作成: export-history/summaries/2026/02/summary-2026-02-08-120734.md

================================================
✨ 整理完了！
   2 件のファイルを整理しました
================================================

📝 次のステップ:
   1. export-history/summaries/ 内の要約ファイルを開く
   2. Claude Codeで要約を生成・追加する
```

### 3. AI要約を生成（任意）

要約ファイル（`summary-*.md`）には、以下が自動生成されています：

- **メタデータ**: 日付、時刻、ファイル名、行数
- **会話ログの抜粋**: 最初の50行
- **要約セクション**: 空欄（手動で追加）

#### 要約の追加方法

1. `export-history/summaries/2026/02/summary-*.md`をClaude Codeで開く
2. 以下のプロンプトを実行：

```
以下のエクスポートファイルの内容を要約してください。
- 実施したタスクの概要
- 主な成果物
- 重要な決定事項
- 次のステップ（あれば）

ファイルパス: export-history/raw/2026/02/conversation-2026-02-08-143000.txt
```

3. 生成された要約を`## 要約`セクションに貼り付け

---

## スクリプトの仕組み

### 処理フロー

```
1. ルートディレクトリで対象ファイルを検出
   - conversation-*.txt 形式
   - YYYY-MM-DD-*.txt 形式（除外リストをチェック）
   ↓
2. ファイル名から日付・時刻を抽出
   例1: conversation-2026-02-08-143000.txt
        → YEAR=2026, MONTH=02, DAY=08, TIME=143000
   例2: 2026-02-08-some-description.txt
        → YEAR=2026, MONTH=02, DAY=08, TIME=120734（現在時刻）
   ↓
3. 年/月フォルダを作成
   export-history/raw/2026/02/
   export-history/summaries/2026/02/
   ↓
4. ファイルを raw/ フォルダに移動（ルートから削除）
   mv コマンドで移動 = ルートから削除
   ↓
5. 要約テンプレートを summaries/ に生成
   summary-2026-02-08-143000.md
   （メタデータ + 最初の50行を含む）
   ↓
6. 処理完了を表示
```

### 主要な技術要素

#### ファイル検出（複数パターン対応）

```bash
# conversation-*.txt 形式のファイルを検出
for file in conversation-*.txt; do
    if [ -f "$file" ]; then
        EXPORT_FILES+=("$file")
    fi
done

# YYYY-MM-DD-*.txt 形式のファイルを検出（除外リストをチェック）
for file in 20[0-9][0-9]-[0-1][0-9]-[0-3][0-9]-*.txt; do
    if [ -f "$file" ]; then
        # 除外リスト（CLAUDE.md、README.md等を除外）
        if [[ ! "$file" =~ ^(CLAUDE|README|要件定義書) ]]; then
            EXPORT_FILES+=("$file")
        fi
    fi
done
```

#### ファイル名パース（柔軟な処理）

```bash
# ファイル名から日付・時刻を抽出
BASENAME=$(basename "$file" .txt)

# conversation- で始まる場合は除去
if [[ "$BASENAME" =~ ^conversation- ]]; then
    DATE_TIME=${BASENAME#conversation-}
else
    # YYYY-MM-DD- で始まる場合はそのまま使用
    DATE_TIME="$BASENAME"
fi

# 年、月、日を抽出
YEAR=$(echo "$DATE_TIME" | cut -d'-' -f1)   # 2026
MONTH=$(echo "$DATE_TIME" | cut -d'-' -f2)  # 02
DAY=$(echo "$DATE_TIME" | cut -d'-' -f3)    # 08

# 時刻部分を抽出（4番目のフィールド以降）
TIME=$(echo "$DATE_TIME" | cut -d'-' -f4-)

# 時刻がない、または数字6桁でない場合は現在時刻を使用
if [ -z "$TIME" ] || ! [[ "$TIME" =~ ^[0-9]{6}$ ]]; then
    TIME=$(date +%H%M%S)  # 例: 120734
fi
```

#### フォルダ作成

```bash
# 年/月フォルダを再帰的に作成
mkdir -p "export-history/raw/$YEAR/$MONTH"
mkdir -p "export-history/summaries/$YEAR/$MONTH"
```

#### ファイル移動（ルートから削除）

```bash
# 元のファイルを raw/ フォルダに移動（mvコマンドはコピーではなく移動）
mv "$file" "$RAW_DIR/$NEW_FILENAME"
echo -e "  ${GREEN}✓${NC} ルートから削除: $file"
echo -e "  ${GREEN}✓${NC} 移動先: $RAW_DIR/$NEW_FILENAME"
```

**重要**: `mv`コマンドは移動（move）なので、ルートディレクトリから元ファイルが削除されます。

#### 要約テンプレート生成

```bash
# ヒアドキュメントでMarkdownテンプレートを生成
cat > "$SUMMARY_PATH" << EOF
# セッション要約: $YEAR-$MONTH-$DAY $TIME

## メタデータ
- **日付**: $YEAR年$MONTH月$DAY日
...

## 要約
<!-- このセクションにAI要約を記載してください -->
...
EOF
```

---

## トラブルシューティング

### ❌ エラー: `permission denied`

**原因**: スクリプトに実行権限がない

**解決方法**:
```bash
chmod +x scripts/organize_exports.sh
```

### ⚠️ 警告: `整理対象のファイルが見つかりませんでした`

**原因**: ルートディレクトリに対象ファイルが存在しない

**対象ファイル形式**:
- `conversation-*.txt`
- `YYYY-MM-DD-*.txt`（CLAUDE.md、README.md等は除外）

**解決方法**:
1. Claude Code内で`/export`コマンドを実行
2. ファイルが作成されたことを確認
3. 再度スクリプトを実行

### 📁 複数のファイルを一度に整理したい

スクリプトは自動的に**すべての対象ファイル**を検出・整理します。

**例**:
```bash
# ルートディレクトリに複数ファイルがある場合
conversation-2026-02-08-143000.txt
conversation-2026-02-08-150000.txt
2026-02-07-some-description.txt
2026-02-05-mock.txt

# スクリプト実行で全て整理される
$ ./scripts/organize_exports.sh
📄 処理中: conversation-2026-02-08-143000.txt
  ✓ ルートから削除: conversation-2026-02-08-143000.txt
  ✓ 移動先: ...
📄 処理中: conversation-2026-02-08-150000.txt
  ✓ ルートから削除: conversation-2026-02-08-150000.txt
  ✓ 移動先: ...
📄 処理中: 2026-02-07-some-description.txt
  ✓ ルートから削除: 2026-02-07-some-description.txt
  ✓ 移動先: ...
📄 処理中: 2026-02-05-mock.txt
  ✓ ルートから削除: 2026-02-05-mock.txt
  ✓ 移動先: ...

✨ 整理完了！
   4 件のファイルを整理しました
```

---

## よくある質問

### Q1: 要約は必ず作成する必要がありますか？

**A**: いいえ、任意です。`raw/`フォルダに元ファイルが保存されているため、要約なしでも問題ありません。

### Q2: 既に整理済みのファイルを再整理できますか？

**A**: いいえ、スクリプトは**ルートディレクトリのファイルのみ**を対象とします。既に`export-history/`に移動したファイルは処理されません。

### Q3: スクリプトを自動実行できますか？

**A**: 現時点では手動実行のみです。将来的にエイリアスやClaude Codeフックを使った自動化が可能かもしれません。

### Q4: 要約を完全自動化できますか？

**A**: Anthropic APIキーを使ったPythonスクリプトで可能ですが、現在のバージョンでは手動要約を推奨しています（セキュリティとコスト管理のため）。

### Q5: ルートディレクトリから元ファイルは削除されますか？

**A**: はい、`mv`コマンドで移動するため、ルートディレクトリから元ファイルは**自動的に削除**されます。整理されたファイルは`export-history/raw/`に保存されます。

### Q6: `conversation-`で始まらないファイルも整理できますか？

**A**: はい、`YYYY-MM-DD-*.txt`形式のファイルも検出・整理します。ただし、`CLAUDE.md`、`README.md`、`要件定義書.md`などのプロジェクトファイルは除外されます。

---

## 今後の改善案

- [ ] Anthropic APIを使った完全自動要約機能
- [ ] エイリアスコマンドの設定手順
- [ ] 古いファイルの自動アーカイブ機能
- [ ] Webインターフェースでの要約閲覧

---

## 関連ドキュメント

- `/export`コマンド: Claude Code公式ドキュメント
- シェルスクリプト基礎: [Bash Scripting Tutorial](https://www.shellscript.sh/)

---

**作成日**: 2026-02-08
**最終更新**: 2026-02-08
**バージョン**: 1.1.0

---

## 更新履歴

### v1.1.0 (2026-02-08)
- **柔軟なファイル検出**: `conversation-*.txt`だけでなく、`YYYY-MM-DD-*.txt`形式も対応
- **除外リスト機能**: CLAUDE.md、README.md等のプロジェクトファイルを自動除外
- **明示的な削除メッセージ**: "ルートから削除"と"移動先"を明確に表示
- **時刻自動生成**: ファイル名に時刻がない場合、現在時刻を自動付与
- **ドキュメント更新**: 新機能に対応した説明を追加

### v1.0.0 (2026-02-08)
- 初版リリース
- 基本的な整理機能実装
- 要約テンプレート自動生成
