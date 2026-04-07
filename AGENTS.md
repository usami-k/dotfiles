# AGENTS.md

このファイルは、Codex などのコーディングエージェントがこのリポジトリで安全に作業するための運用メモです。短時間で判断できるよう、実作業で効く順に整理しています。

## 指示の優先順位

- 作業を始めるときは、カレントディレクトリから親ディレクトリに向かって `AGENTS.md` と `README.md` を読む。
- より近い階層の指示を優先する。
- 同じ階層に `CLAUDE.md` があれば追加の文脈として参照してよいが、競合したら `AGENTS.md` を優先する。

## リポジトリ概要

- このリポジトリは homeshick で管理する dotfiles 集合。
- 主な管理対象は `home/` 配下にある。
- シェル設定、各種ツール設定、補助スクリプトが混在しているので、変更は対象範囲を狭く保つ。

## シェル方針

- 基本の実行シェルは `fish` とする。
- コマンド実行時は、可能なら `fish -lc '<command>'` を使う。
- `zsh` は自動実行、AI ツール、互換性確保のための従シェルとして扱う。
- `bash` は最後の手段としての従シェルとして扱う。

## シェル設定の変更ルール

- シェルのカスタマイズは、まず `fish` への追加を優先する。
- あるツールを `zsh` でも動かす必要がある場合でも、`zsh` 側の設定は最小限に保つ。
- 本当に `zsh` 固有の事情がない限り、`fish` にない挙動を `zsh` にだけ追加しない。
- あるツールを `zsh` で有効にしたら、`fish` 側でも通常は同等に扱う。ただし `fish` では設定不要な場合を除く。
- `bash` はできるだけ小さく保つ。明確な必要がない限り、一般的なツール用の PATH 設定を追加しない。
- `bash` では利便性より `safe-chain` を優先する。

## 主なファイルの責務

- `home/.config/fish/config.fish`: 主となる interactive shell 設定。
- `home/.zshenv`: すべての `zsh` プロセスで安全に読める静的な環境変数と PATH。
- `home/.zprofile`: login 時だけ必要な `zsh` 初期化。
- `home/.zshrc`: interactive 時だけ必要な `zsh` 初期化。
- `home/.bash_profile` と `home/.bashrc`: 最小限に保ち、基本は `safe-chain` 初期化のみを置く。

## ツール運用

### 検索と読み取り

- ファイル検索は `rg --files`、文字列検索は `rg` を優先する。
- 読み取りは必要な範囲だけ行い、大きいファイルを丸ごと読まない。

### 言語・パッケージ管理

- Python 関連の実行やパッケージ管理には `uv` を使う。
- セッション中に初めて `uv` を使う前に `uv safe-chain-verify` を実行し、確認が通った場合のみ `uv` を使う。
- セッション中に初めて `npm` を使う前に `npm safe-chain-verify` を実行し、確認が通った場合のみ `npm` を使う。

### プロジェクトツール

- プロジェクトごとのツール管理やタスクランナーには、できるだけ `mise` を使う。
- `mise` のコマンドは、対象の `mise.toml` があるディレクトリで実行する。

## 変更時の注意

- shell dotfiles を変更するときは、「`fish` は機能豊富、`zsh` は最小限、`bash` は最小限かつ安全性重視」という意図を保つ。
- PATH、初期化、フックの変更では、login shell と interactive shell のどちらに属するかを先に判断する。
- 影響範囲が広い変更ほど、対象ファイルを増やす前に今ある責務分担で収まらないかを確認する。
- 編集後は、変更した shell やツールに対して最小限の検証を行う。

## バージョン管理

- バージョン管理には `git` ではなく `jj` を使う。
- 意味的に 1 まとまりの作業を 1 つの change に保つ。
- 作業ディレクトリの分離には `git worktree` ではなく `jj workspace` を使う。
- 必要に応じて既存の作業ディレクトリを `jj workspace` に変換する。
- 新しい作業を始めるときは、作業コピーに前の変更が残っていない状態を基本にする。
- GitHub へ出す前に bookmark の位置を確認して `jj git push` する。

## homeshick と Git の補足

- このリポジトリは `jj` で作業していても、`homeshick check` は基盤の Git のブランチ状態を見る。
- `homeshick check` が `up to date` になるには、Git の `HEAD` が detached ではなく `main` を指しており、かつ `origin/main` と一致している必要がある。
- `jj git push` の後は、Git 側の `HEAD` が detached に戻ることがある。その場合は `git switch main` を実行してから `homeshick check` を見る。
- `jj` でコミットした内容を `homeshick check` に正しく反映させたい場合は、必要に応じて `jj bookmark set main -r @-` で `main` を進め、`jj git push --bookmark main --remote origin` で push する。
