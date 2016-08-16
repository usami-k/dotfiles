# history
[ -d $HOME/Library/zsh_history ] || { mkdir $HOME/Library/zsh_history }
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

# Edit the current command line in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# Ctrl-Dでログアウトしない
setopt ignore_eof

# glob時に{}内で指定した文字を展開する
setopt brace_ccl
# globで#、~、^を有効にする
setopt extended_glob
# glob時にドット始まりのファイルも対象にする
setopt glob_dots
# glob時にファイル名を数値順にソートする
setopt numeric_glob_sort
# イコールの後でもファイル名展開を行う
setopt magic_equal_subst
