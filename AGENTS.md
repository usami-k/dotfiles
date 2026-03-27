# リポジトリ運用メモ

## シェル方針

- このリポジトリでは `fish` を主シェルとする。
- `zsh` は自動実行、AI ツール、互換性確保のための従シェルとする。
- `bash` は最後の手段としての従シェルとする。

## 設定の優先順位

- シェルのカスタマイズは、まず `fish` への追加を優先する。
- あるツールを `zsh` でも動かす必要がある場合でも、`zsh` 側の設定は最小限に保つ。
- 本当に `zsh` 固有の事情がない限り、`fish` にない挙動を `zsh` にだけ追加しない。
- あるツールを `zsh` で有効にしたら、`fish` 側でも通常は同等に扱う。ただし `fish` では設定不要な場合を除く。
- `bash` はできるだけ小さく保つ。明確な必要がない限り、一般的なツール用の PATH 設定を追加しない。
- `bash` には安全性と互換性のために必要な最小限だけを残す。

## 現在のファイル分担

- `home/.config/fish/config.fish` は主となる interactive shell 設定。
- `home/.zshenv` には、すべての `zsh` プロセスで安全に読める静的な環境変数と PATH だけを置く。
- `home/.zprofile` には login 時だけ必要な `zsh` 初期化を置く。
- `home/.zshrc` には interactive 時だけ必要な `zsh` 初期化を置く。
- `home/.bash_env` は `bash` 用の共通初期化で、主に非対話 `bash` でも `safe-chain` を有効にするために使う。
- `home/.bash_profile` と `home/.bashrc` は薄く保ち、`home/.bash_env` を読むだけにする。

## 安全性に関する注意

- `bash` では利便性より `safe-chain` を優先する。
- シェル関連ファイルを変更するときは、`fish` は機能豊富、`zsh` は最小限、`bash` は最小限かつ安全性重視、という現在の意図を保つ。
- これらの shell dotfiles は、このリポジトリから homeshick で全面的に管理する前提で扱う。

## jj と homeshick の運用メモ

- このリポジトリは `jj` で作業していても、`homeshick check` は基盤の Git のブランチ状態を見る。
- `homeshick check` が `up to date` になるには、Git の `HEAD` が detached ではなく `master` を指しており、かつ `origin/master` と一致している必要がある。
- `jj git push` の後は、Git 側の `HEAD` が detached に戻ることがある。その場合は `git switch master` を実行してから `homeshick check` を見る。
- `jj` でコミットした内容を `homeshick check` に正しく反映させたい場合は、必要に応じて `jj bookmark set master -r @-` で `master` を進め、`jj git push --bookmark master --remote origin` で push する。
