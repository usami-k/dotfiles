# zshrc

# ディレクトリ名のみの入力でcdを行う
setopt auto_cd
# cdをpushdにする
setopt auto_pushd
# pushdのマイナスとプラスの意味を入れかえる（マイナスのときに新しいものから数える）
setopt pushd_minus
# pushdのディレクトリスタックで重複を避ける
setopt pushd_ignore_dups

# カーソル位置で補完を行う（これをしないとカーソルが単語の後ろにあるとして補完される）
setopt complete_in_word
# 補完時にエイリアスを解釈する
setopt complete_aliases
# globの補完を有効にする
setopt glob_complete

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
# ファイル名展開でディレクトリ名の後ろにスラッシュをつける
setopt mark_dirs

# 新しいヒストリをすぐにヒストリファイルに追加する
setopt inc_append_history
# ヒストリの重複を避ける
setopt hist_ignore_all_dups
# ヒストリで余分なスペースを削除する
setopt hist_reduce_blanks
# スペースで始まる入力はヒストリに追加しない
setopt hist_ignore_space

# Ctrl-Dでログアウトしない
setopt ignore_eof
# 直前の返り値を表示する
setopt print_exit_value

# プロンプト直前の出力が改行終端してなくてもクリアしない
setopt no_prompt_cr
# プロンプト定義の中で置換を使用する
setopt prompt_subst

# Emacsキーバインドを使用する
bindkey -e

# history
HISTFILE=$HOME/Library/zsh_history/history
HISTSIZE=100000
SAVEHIST=100000

# 実行時間が長かった場合、かかった時間を表示する
REPORTTIME=3

# 補完情報を冗長表示する
zstyle ":completion:*" verbose yes
# 補完候補をキャッシュファイルに保存する
zstyle ":completion:*" use-cache yes
# キャッシュファイルの場所指定
zstyle ":completion:*" cache-path "$HOME/.zsh_files/zcompcache"
# 補完候補の重複を避ける
zstyle ":completion:*" remove-all-dups yes
# マニュアルのセクション別に補完候補を表示する
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

# zmvコマンドを有効にする
autoload zmv
# zargsコマンドを有効にする
autoload zargs

# zshフック関数（precmd、preexecなど）を使用する
autoload add-zsh-hook

# 現在のディレクトリを端末のタイトルに表示する
my_update_title_precmd () {
	echo -ne "\e]0;$(basename $PWD)\e\\"
}
add-zsh-hook precmd my_update_title_precmd

# 現在実行中のコマンドを端末のタイトルに表示する
my_update_title_preexec () {
	echo -ne "\e]0;{$1}\e\\"
}
add-zsh-hook preexec my_update_title_preexec

# vcs_info
autoload vcs_info
# gitとsvnのみ有効にする
zstyle ":vcs_info:*" enable git svn
# commitしていない変更をチェックする
zstyle ":vcs_info:git*:*" check-for-changes true
# gitリポジトリに対して、変更情報とリポジトリ情報を表示する
zstyle ":vcs_info:git*:*" formats "%u%c%m[%b](%s)"
# gitリポジトリに対して、コンフリクトなどの情報を表示する
zstyle ":vcs_info:git*:*" actionformats "%u%c<%a>%m[%b](%s)"
# addしていない変更があることを示す文字列
zstyle ":vcs_info:git*:*" unstagedstr "<U>"
# commitしていないstageがあることを示す文字列
zstyle ":vcs_info:git*:*" stagedstr "<S>"
# stgit使用時、パッチが当たっていればパッチ名を表示する
zstyle ":vcs_info:git*:*" patch-format "{%p}"
# stgit使用時、パッチが当たっていなければ何も表示しない
zstyle ":vcs_info:git*:*" nopatch-format ""
# hook関数を定義
zstyle ":vcs_info:git*+set-message:*" hooks my_vcs_info

# git：まだpushしていないcommitがあるかチェックする
my_git_info_push () {
	if [ "$(git remote 2>/dev/null)" != "" ]; then
		local head="$(git rev-parse HEAD)"
		local remote
		for remote in $(git rev-parse --remotes) ; do
			if [ "$head" = "$remote" ]; then return 0 ; fi
		done
		# pushしていないcommitがあることを示す文字列
		echo "<P>"
	fi
}

# git：stashに退避したものがあるかチェックする
my_git_info_stash () {
	if [ -f "$(git rev-parse --git-dir)/refs/stash" ]; then
		# stashがあることを示す文字列
		echo "{s}"
	fi
}

# git：rerereが有効かチェックする
my_git_info_rerere () {
	if [ "$(git config rerere.enabled)" != "true" ]; then
		# rerereが無効であることを示す文字列
		echo "{rr?}"
	fi
}

# git：user 表示
my_git_user () {
	echo "{${$(git config user.email)/*@/}}"
}

# vcs_infoの出力に独自の出力を付加する
+vi-my_vcs_info () {
	hook_com[misc]="$(my_git_info_push)$(my_git_info_stash)$(my_git_info_rerere)$hook_com[misc_orig]$(my_git_user)"
}

# プロンプト文字列を作成する
my_update_prompt () {
	vcs_info
	local promptstr="[$PWD]$vcs_info_msg_0_(mm/dd HH:MM)"
	local fillsize=$(( $COLUMNS - ${#promptstr} - 1 ))
	while [ $fillsize -le -1 ]; do
		fillsize=$(( $fillsize + $COLUMNS ))
	done
	local fill=${(l.$fillsize..-.)}
	echo "%B[$PWD]$fill$vcs_info_msg_0_(%D{%m/%d %H:%M})%b"
}

# プロンプト定義
PROMPT=$'$(my_update_prompt)\n%# '

# app ファイル名指定で実行できるようにする
alias -s app=open

# 設定スクリプトを読み込む
for myscriptdir in \
	$(brew --prefix)/etc/profile.d \
; do
	if [ -d $myscriptdir ]; then
		for myscriptfile in $myscriptdir/*.sh ; do
			source $myscriptfile
		done
		unset myscriptfile
	fi
done
unset myscriptdir

for myscriptdir in \
	$HOME/.zsh/scripts \
; do
	if [ -d $myscriptdir ]; then
		for myscriptfile in $myscriptdir/*.zsh ; do
			source $myscriptfile
		done
		unset myscriptfile
	fi
done
unset myscriptdir

# 補完設定ファイルを指定する（既存 fpath の前に追加する）
fpath[1,0]=$(brew --prefix)/share/zsh-completions
fpath[1,0]=$HOME/.zsh/functions
# fpath の重複を除去する
typeset -U fpath
# 存在しないディレクトリを除去する
fpath=($^fpath(N-/))

# path の重複を除去する
typeset -U path
# 存在しないディレクトリを除去する
path=($^path(N-/))

# 補完関数のロード
autoload compinit
compinit -u -d "$HOME/.zsh_files/zcompdump"

# dash の補完定義
compdef _man dash

