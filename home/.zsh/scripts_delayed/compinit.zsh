# delayed : 補完設定は各種設定よりも後に行う

# fpath の重複を除去する
typeset -U fpath

# 補完関数のロード
autoload compinit
compinit -u -d "$HOME/.zsh_files/zcompdump"

# bash 互換の補完関数
autoload bashcompinit
bashcompinit

# stack の補完定義
eval "$(stack --bash-completion-script stack)"

# gibo の補完定義
source $(brew --prefix)/share/zsh/site-functions/_gibo

# dash の補完定義
compdef _man dash

