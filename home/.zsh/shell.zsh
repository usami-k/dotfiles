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

# カーソル位置で補完を行う（これをしないとカーソルが単語の後ろにあるとして補完される）
setopt complete_in_word
# 補完時にエイリアスを解釈する
setopt complete_aliases
# globの補完を有効にする
setopt glob_complete

# 補完情報を冗長表示する
zstyle ":completion:*" verbose yes
# 補完候補をキャッシュファイルに保存する
zstyle ":completion:*" use-cache yes
# 補完候補の重複を避ける
zstyle ":completion:*" remove-all-dups yes
# 補完候補をセクション別に表示する
zstyle ":completion:*" separate-sections yes
# 補完候補に色をつける
zstyle ":completion:*" list-colors ""
# 補完候補をグループ表示する
zstyle ":completion:*" group-name ""
# グループ名の表示方法を指定する
zstyle ":completion:*" format "%U%d%u"
# 補完候補をカーソルキーで選択できるようにする（候補が2つ以上ある場合）
zstyle ":completion:*" menu select=2
# 補完候補がないとき大文字小文字を変えて補完候補を探す
zstyle ':completion:*' matcher-list '' '+m:{a-z}={A-Z}' '+m:{A-Z}={a-z}'
# 今いるディレクトリを補完候補から外す
zstyle ':completion:*' ignore-parents parent pwd ..

# プロンプト定義の中で置換を使用する
setopt prompt_subst

# プロンプト文字列を作成する
my_update_prompt () {
	vcs_info
	local promptstr="[$PWD]$vcs_info_msg_0_(mm/dd HH:MM)"
	local fillsize=$(( $COLUMNS - ${#promptstr} - 1 ))
	while [ $fillsize -le -1 ]; do
		fillsize=$(( $fillsize + $COLUMNS ))
	done
	local fill=${(l.$fillsize..-.)}
	echo "[$PWD]$fill$vcs_info_msg_0_(%D{%m/%d %H:%M})"
}

# プロンプト定義
PROMPT=$'%u%S$(my_update_prompt)%s\n%# '

# 直前の返り値を表示する
setopt print_exit_value

# 実行時間が長かった場合、かかった時間を表示する
REPORTTIME=3
