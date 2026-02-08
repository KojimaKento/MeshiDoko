#!/bin/bash

# MeshiDoko Export History Organizer
# /exportで出力されたファイルを年/月フォルダに整理し、AI要約を生成します

set -e

# カラー定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# プロジェクトルートディレクトリ
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_ROOT"

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}  MeshiDoko Export History Organizer${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

# /exportで出力されたファイルを検出（conversation-*.txt または YYYY-MM-DD-*.txt）
EXPORT_FILES=()

# conversation-*.txt 形式のファイルを検出
for file in conversation-*.txt; do
    if [ -f "$file" ]; then
        EXPORT_FILES+=("$file")
    fi
done

# YYYY-MM-DD-*.txt 形式のファイルを検出（除外リストをチェック）
for file in 20[0-9][0-9]-[0-1][0-9]-[0-3][0-9]-*.txt; do
    if [ -f "$file" ]; then
        # 除外リスト（プロジェクトファイル等）
        if [[ ! "$file" =~ ^(CLAUDE|README|要件定義書) ]]; then
            EXPORT_FILES+=("$file")
        fi
    fi
done

# ファイルが存在しない場合
if [ ${#EXPORT_FILES[@]} -eq 0 ]; then
    echo -e "${YELLOW}⚠️  整理対象のファイルが見つかりませんでした${NC}"
    echo -e "${YELLOW}   /exportコマンドを実行してからこのスクリプトを実行してください${NC}"
    exit 0
fi

# 整理したファイル数をカウント
ORGANIZED_COUNT=0

# 各ファイルを処理
for file in "${EXPORT_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}📄 処理中: $file${NC}"

        # ファイル名から日付と時刻を抽出
        # 例1: conversation-2026-02-08-143000.txt → 2026-02-08-143000
        # 例2: 2026-02-08-some-description.txt → 2026-02-08-some-description
        BASENAME=$(basename "$file" .txt)

        # conversation- で始まる場合は除去
        if [[ "$BASENAME" =~ ^conversation- ]]; then
            DATE_TIME=${BASENAME#conversation-}
        else
            # YYYY-MM-DD- で始まる場合はそのまま使用
            DATE_TIME="$BASENAME"
        fi

        # 年、月、日を抽出
        YEAR=$(echo "$DATE_TIME" | cut -d'-' -f1)
        MONTH=$(echo "$DATE_TIME" | cut -d'-' -f2)
        DAY=$(echo "$DATE_TIME" | cut -d'-' -f3)

        # 時刻部分を抽出（4番目のフィールド以降）
        TIME=$(echo "$DATE_TIME" | cut -d'-' -f4-)

        # 時刻がない、または数字6桁でない場合は現在時刻を使用
        if [ -z "$TIME" ] || ! [[ "$TIME" =~ ^[0-9]{6}$ ]]; then
            TIME=$(date +%H%M%S)
        fi

        # フォルダパスを作成
        RAW_DIR="export-history/raw/$YEAR/$MONTH"
        SUMMARY_DIR="export-history/summaries/$YEAR/$MONTH"

        # フォルダを作成
        mkdir -p "$RAW_DIR"
        mkdir -p "$SUMMARY_DIR"

        # ファイル名を整形（conversation-2026-02-08-143000.txt）
        NEW_FILENAME="conversation-$YEAR-$MONTH-$DAY-$TIME.txt"
        SUMMARY_FILENAME="summary-$YEAR-$MONTH-$DAY-$TIME.md"

        # rawフォルダにファイルを移動（ルートから削除）
        mv "$file" "$RAW_DIR/$NEW_FILENAME"
        echo -e "  ${GREEN}✓${NC} ルートから削除: $file"
        echo -e "  ${GREEN}✓${NC} 移動先: $RAW_DIR/$NEW_FILENAME"

        # 要約mdファイルを生成
        SUMMARY_PATH="$SUMMARY_DIR/$SUMMARY_FILENAME"

        # ファイルの行数を取得
        LINE_COUNT=$(wc -l < "$RAW_DIR/$NEW_FILENAME")

        # 要約テンプレートを作成
        cat > "$SUMMARY_PATH" << EOF
# セッション要約: $YEAR-$MONTH-$DAY $TIME

## メタデータ
- **日付**: $YEAR年$MONTH月$DAY日
- **時刻**: ${TIME:0:2}:${TIME:2:2}:${TIME:4:2}
- **ファイル**: $NEW_FILENAME
- **総行数**: $LINE_COUNT行

---

## 要約

<!-- このセクションにAI要約を記載してください -->

**要約生成方法**:
1. このファイルをClaude Codeで開く
2. 以下のプロンプトを実行:

\`\`\`
以下のエクスポートファイルの内容を要約してください。
- 実施したタスクの概要
- 主な成果物
- 重要な決定事項
- 次のステップ（あれば）

ファイルパス: $RAW_DIR/$NEW_FILENAME
\`\`\`

---

## 会話ログの抜粋（最初の50行）

\`\`\`
$(head -n 50 "$RAW_DIR/$NEW_FILENAME")
\`\`\`

---

*このファイルは自動生成されました*
EOF

        echo -e "  ${GREEN}✓${NC} 要約テンプレート作成: $SUMMARY_PATH"
        echo ""

        ORGANIZED_COUNT=$((ORGANIZED_COUNT + 1))
    fi
done

echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}✨ 整理完了！${NC}"
echo -e "${GREEN}   $ORGANIZED_COUNT 件のファイルを整理しました${NC}"
echo -e "${GREEN}================================================${NC}"
echo ""
echo -e "${YELLOW}📝 次のステップ:${NC}"
echo -e "${YELLOW}   1. export-history/summaries/ 内の要約ファイルを開く${NC}"
echo -e "${YELLOW}   2. Claude Codeで要約を生成・追加する${NC}"
echo ""
