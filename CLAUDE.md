# リポジトリ運用メモ

## jj と homeshick の運用メモ

- このリポジトリは `jj` で作業していても、`homeshick check` は基盤の Git のブランチ状態を見る。
- `homeshick check` が `up to date` になるには、Git の `HEAD` が detached ではなく `main` を指しており、かつ `origin/main` と一致している必要がある。
- `jj git push` の後は、Git 側の `HEAD` が detached に戻ることがある。その場合は `git switch main` を実行してから `homeshick check` を見る。
- `jj` でコミットした内容を `homeshick check` に正しく反映させたい場合は、必要に応じて `jj bookmark set main -r @-` で `main` を進め、`jj git push --bookmark main --remote origin` で push する。
