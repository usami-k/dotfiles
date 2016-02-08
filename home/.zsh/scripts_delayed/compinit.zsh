# delayed : 補完設定は各種設定よりも後に行う

# fpath の重複を除去する
typeset -U fpath

# 補完関数のロード
autoload compinit
compinit -u -d "$HOME/.zsh_files/zcompdump"

# gibo の補完定義
source $(brew --prefix)/share/zsh/site-functions/_gibo

# dash の補完定義
compdef _man dash

