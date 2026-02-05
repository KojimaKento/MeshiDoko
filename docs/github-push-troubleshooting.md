# GitHubプッシュ時のトラブルシューティング記録

**日付**: 2026-02-06
**リポジトリ**: https://github.com/KojimaKento/MeshiDoko

---

## 問題の概要

MeshiDokoプロジェクトをGitHubにプッシュする際、複数のエラーが発生しました。このドキュメントは、発生した問題、原因、解決方法を記録したものです。

---

## 発生した問題と解決方法

### 問題1: HTTP 400エラー（初回）

#### 症状
```bash
git push -u origin main
# error: RPC failed; HTTP 400 curl 22 The requested URL returned error: 400
# send-pack: unexpected disconnect while reading sideband packet
# Writing objects: 100% (2824/2824), 6.17 MiB | 4.36 MiB/s, done.
# fatal: the remote end hung up unexpectedly
# Everything up-to-date
```

#### 原因
- `.gitignore`ファイルが存在せず、`tmp/cache/`ディレクトリ（2000個以上のキャッシュファイル）が誤ってGit管理下に入っていた
- 追跡ファイル数: **2179個**（通常は100-200個程度）
- リポジトリサイズ: 6.17 MiB（キャッシュファイルを含む）

#### 調査手順
```bash
# 追跡ファイル数を確認
git ls-files | wc -l
# 2179

# キャッシュファイルを確認
git ls-files | grep "tmp/cache" | wc -l
# 2034

# Git管理されているべきでないファイルを確認
git ls-files | grep -E "^(tmp|log)" | head -20
```

#### 解決方法

**ステップ1: .gitignoreファイルを作成**
- Rails標準の`.gitignore`を作成
- 除外対象: `tmp/`, `log/`, `node_modules/`, `*.sqlite3`等

**ステップ2: キャッシュファイルをGit管理から削除**
```bash
# キャッシュディレクトリをGit管理から削除（ファイルは残す）
git rm -r --cached tmp/cache/

# コミット
git commit -m "tmp/cacheディレクトリをGit管理から完全に削除"
```

**ステップ3: 追跡ファイル数を確認**
```bash
git ls-files | wc -l
# 146（正常な数に削減）
```

**結果**: ファイル数が2179個→146個に削減されたが、まだHTTP 400エラーが継続

---

### 問題2: 認証エラー

#### 症状
```bash
git push -u origin main
# Username for 'https://github.com': KojimaKento
# Password for 'https://KojimaKento@github.com':
# remote: Invalid username or token. Password authentication is not supported for Git operations.
# fatal: Authentication failed for 'https://github.com/KojimaKento/MeshiDoko.git/'
```

#### 原因
- GitHubのログインパスワードを入力していた
- GitHubは2021年8月以降、パスワード認証を廃止
- **Personal Access Token (PAT)**が必要

#### 解決方法

**ステップ1: Personal Access Tokenを作成**
1. https://github.com/settings/tokens にアクセス
2. 「Generate new token (classic)」をクリック
3. 設定:
   - Note: `MeshiDoko`
   - Expiration: `90 days`
   - Scopes: ✅ **repo**（必須）
4. 「Generate token」をクリック
5. トークンをコピー（`ghp_` で始まる文字列）

**ステップ2: 認証情報をクリア**
```bash
# macOSのキーチェーンから古い認証情報を削除
git credential-osxkeychain erase
# 以下を入力してEnter:
# host=github.com
# protocol=https
# [Enterを2回]
```

**ステップ3: 再プッシュ**
```bash
git push -u origin main
# Username: KojimaKento
# Password: [Personal Access Tokenを貼り付け]
```

**結果**: 認証は成功したが、まだHTTP 400エラーが継続

---

### 問題3: Git履歴に残るキャッシュファイル

#### 症状
- 認証成功後もHTTP 400エラーが継続
- ファイル数は146個に削減されているが、Git履歴に古いキャッシュファイルのコミットが残っている

#### 原因
- 最初のコミット（`a12c67a`）にキャッシュファイル2000個以上が含まれていた
- `git rm --cached`で現在のファイルは削除できたが、**Git履歴には残っている**
- GitHubが大きなGit履歴を拒否している可能性

#### 調査手順
```bash
# Git履歴を確認
git log --oneline
# fa58a1a tmp/cacheディレクトリをGit管理から完全に削除
# 24826c4 .gitignoreにmockファイルを追加
# 0a18b03 .gitignoreを追加してキャッシュファイルを除外
# 56be6ec Phase 1-A: カードクリック修正とドキュメント更新
# 9ab9d74 Phase 1-A: 基本画面実装完了
# ...
# a12c67a MeshiDokoプロジェクト初期作成 ← この中に2000個のキャッシュファイル
```

#### 解決方法: クリーンな履歴で再作成

**ステップ1: 既存ブランチをバックアップ**
```bash
git branch -m main main-backup
```

**ステップ2: 新しいorphanブランチを作成**
```bash
# 履歴のない新しいブランチを作成
git checkout --orphan main
```

**ステップ3: 現在の状態をコミット**
```bash
git commit -m "MeshiDoko Phase 1-A 完了版"
# [main (root-commit) 1bf8f9c] MeshiDoko Phase 1-A 完了版
# 146 files changed, 10861 insertions(+)
```

**ステップ4: 強制プッシュ**
```bash
git push -u origin main --force
```

**結果**: まだエラーが発生（次の問題へ）

---

### 問題4: workflowスコープ不足

#### 症状
```bash
git push -u origin main --force
# To https://github.com/KojimaKento/MeshiDoko.git
#  ! [remote rejected] main -> main (refusing to allow a Personal Access Token to create or update workflow `.github/workflows/ci.yml` without `workflow` scope)
# error: failed to push some refs to 'https://github.com/KojimaKento/MeshiDoko.git'
```

#### 原因
- Rails 8が自動生成した`.github/workflows/ci.yml`（GitHub Actions設定ファイル）が含まれていた
- Personal Access Tokenに`workflow`スコープがない
- GitHubはセキュリティ上、workflowファイルのプッシュに`workflow`スコープを要求

#### 解決方法

**オプション1: workflowスコープを追加**（将来的に推奨）
1. https://github.com/settings/tokens
2. トークンを編集
3. **workflow** スコープにチェック
4. 「Update token」

**オプション2: .githubディレクトリを削除**（今回採用）
```bash
# GitHub Actionsを今は使わないため削除
git rm -r .github
git commit -m "GitHub Actionsワークフローを一時削除"
```

**ステップ2: 再プッシュ**
```bash
git push -u origin main --force
# branch 'main' set up to track 'origin/main'.
# To https://github.com/KojimaKento/MeshiDoko.git
#  * [new branch]      main -> main
```

**結果**: ✅ **プッシュ成功！**

---

## 最終的な解決策まとめ

### 実行したコマンド（順番通り）

```bash
# 1. .gitignoreを作成（手動またはファイル作成）
# 2. キャッシュファイルを除外
git rm -r --cached tmp/cache/
git commit -m "tmp/cacheディレクトリをGit管理から完全に削除"

# 3. クリーンな履歴を作成
git branch -m main main-backup
git checkout --orphan main
git commit -m "MeshiDoko Phase 1-A 完了版"

# 4. GitHub Actionsファイルを削除
git rm -r .github
git commit -m "GitHub Actionsワークフローを一時削除"

# 5. プッシュ
git push -u origin main --force
```

### Personal Access Token設定

**必須スコープ**:
- ✅ `repo` - リポジトリへの読み書き

**オプションスコープ**（GitHub Actions使用時に必要）:
- `workflow` - GitHub Actionsワークフローの作成・更新

---

## 学んだこと・注意点

### 1. .gitignoreは最初に作成する

**問題**:
- `.gitignore`がないと、`tmp/`, `log/`, `node_modules/`等が誤ってGit管理下に

**対策**:
- プロジェクト作成直後に`.gitignore`を作成
- Railsプロジェクトの場合、`rails new`時に自動生成されるはずだが、念のため確認

### 2. Git履歴は後から修正が困難

**問題**:
- 一度コミットに含めたファイルは、`git rm --cached`で削除しても履歴に残る
- Git履歴をクリーンにするには`git filter-branch`や新規ブランチ作成が必要

**対策**:
- 初回コミット前に`.gitignore`を確認
- `git status`で不要なファイルが含まれていないか確認

### 3. Personal Access Tokenの管理

**重要**:
- GitHubパスワードではなく、Personal Access Tokenを使用
- 必要なスコープを理解する:
  - `repo`: 基本的なGit操作
  - `workflow`: GitHub Actions
  - `read:org`: Organization情報の読み取り

**セキュリティ**:
- トークンは安全に保管（パスワードマネージャー推奨）
- 有効期限を設定（90日推奨）
- 不要になったトークンは削除

### 4. GitHub Actionsとworkflowスコープ

**問題**:
- `.github/workflows/*.yml`をプッシュするには`workflow`スコープが必要
- セキュリティ上の理由（悪意のあるワークフローの実行防止）

**対策**:
- GitHub Actionsを使う場合: `workflow`スコープを追加
- 使わない場合: `.github`ディレクトリを削除または`.gitignore`に追加

---

## トラブルシューティングチェックリスト

GitHubプッシュ時にエラーが出たら、以下を確認：

### ファイル関連
- [ ] `.gitignore`が存在するか？
- [ ] `tmp/`, `log/`, `node_modules/`が追跡されていないか？
  ```bash
  git ls-files | grep -E "^(tmp|log|node_modules)"
  ```
- [ ] 追跡ファイル数が適切か？（Railsプロジェクトで100-200個程度）
  ```bash
  git ls-files | wc -l
  ```

### 認証関連
- [ ] Personal Access Tokenを使用しているか？（パスワードではない）
- [ ] トークンの有効期限は切れていないか？
- [ ] 必要なスコープ（`repo`）が付与されているか？

### Git履歴関連
- [ ] 不要なファイルが過去のコミットに含まれていないか？
  ```bash
  git log --all --pretty=format: --name-only | sort -u | grep -E "tmp|log"
  ```

### GitHub Actions関連
- [ ] `.github/workflows`が含まれている場合、`workflow`スコープがあるか？
- [ ] 今は不要なら`.github`を削除または除外

---

## 参考リンク

- [GitHub Personal Access Tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
- [Git .gitignore Templates](https://github.com/github/gitignore)
- [Rails .gitignore](https://github.com/github/gitignore/blob/main/Rails.gitignore)
- [GitHub Actions Workflow Permissions](https://docs.github.com/en/actions/security-for-github-actions/security-guides/automatic-token-authentication)

---

## 最終状態

**GitHubリポジトリ**: https://github.com/KojimaKento/MeshiDoko

**コミット履歴**:
```
291b1bf - GitHub Actionsワークフローを一時削除
1bf8f9c - MeshiDoko Phase 1-A 完了版
```

**ファイル数**: 144個

**ブランチ**: main

**ステータス**: ✅ プッシュ成功
