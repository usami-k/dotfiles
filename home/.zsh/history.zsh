# history
HISTFILE=$HOME/Library/zsh_history/history
HISTSIZE=100000
SAVEHIST=100000

# 新しいヒストリをすぐにヒストリファイルに追加する
setopt inc_append_history
# ヒストリの重複を避ける
setopt hist_ignore_all_dups
# ヒストリで余分なスペースを削除する
setopt hist_reduce_blanks
# スペースで始まる入力はヒストリに追加しない
setopt hist_ignore_space

