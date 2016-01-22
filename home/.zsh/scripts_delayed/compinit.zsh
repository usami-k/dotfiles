# delayed : 補完設定は各種設定よりも後に行う

# 補完設定ファイルを指定する（既存 fpath の前に追加する）
fpath[1,0]=$(brew --prefix)/share/zsh-completions
fpath[1,0]=$HOME/.zsh/functions
# fpath の重複を除去する
typeset -U fpath
# 存在しないディレクトリを除去する
fpath=($^fpath(N-/))

# 補完関数のロード
autoload compinit
compinit -u -d "$HOME/.zsh_files/zcompdump"

# gibo の補完定義
source $(brew --prefix)/share/zsh/site-functions/_gibo

# dash の補完定義
compdef _man dash

