# delayed : 各種設定の後で path を整理する

# path の重複を除去する
typeset -U path
# 存在しないディレクトリを除去する
path=($^path(N-/))
