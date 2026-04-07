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

## homeshick と Git の補足

- このリポジトリは `jj` で作業していても、`homeshick check` は基盤の Git のブランチ状態を見る。
- `homeshick check` が `up to date` になるには、Git の `HEAD` が detached ではなく `main` を指しており、かつ `origin/main` と一致している必要がある。
- `jj git push` の後は、Git 側の `HEAD` が detached に戻ることがある。その場合は `git switch main` を実行してから `homeshick check` を見る。
- `jj` でコミットした内容を `homeshick check` に正しく反映させたい場合は、必要に応じて `jj bookmark set main -r @-` で `main` を進め、`jj git push --bookmark main --remote origin` で push する。
