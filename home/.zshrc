# zshrc

# PATH 設定
if [ -d /opt/local/bin ]; then path=(/opt/local/bin $path) ; fi
if [ -d /opt/local/sbin ]; then path=(/opt/local/sbin $path) ; fi
if [ -d /usr/local/bin ]; then path=(/usr/local/bin $path) ; fi
if [ -d /usr/local/sbin ]; then path=(/usr/local/sbin $path) ; fi
if [ -d /usr/local/opt/ruby/bin ]; then path=(/usr/local/opt/ruby/bin $path) ; fi
if [ -d $HOME/.cabal/bin ]; then path=($HOME/.cabal/bin $path) ; fi
if [ -d $HOME/bin ]; then path=($HOME/bin $path) ; fi

# MANPATH 設定
if [ -d /opt/local/man ]; then manpath=(/opt/local/man $manpath) ; fi

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

# ヒストリにタイムスタンプを含める
setopt extended_history
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
HISTFILE=$HOME/.zshfiles/.zhistory
HISTSIZE=100000
SAVEHIST=100000

# 実行時間が長かった場合、かかった時間を表示する
REPORTTIME=3

# 補完情報を冗長表示する
zstyle ":completion:*" verbose yes
# 補完候補をキャッシュファイルに保存する
zstyle ":completion:*" use-cache yes
# キャッシュファイルの場所指定
zstyle ":completion:*" cache-path "$HOME/.zshfiles/.zcompcache"
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

# vcs_infoの出力に独自の出力を付加する
+vi-my_vcs_info () {
	hook_com[misc]="$(my_git_info_push)$(my_git_info_stash)$hook_com[misc_orig]"
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

# 設定スクリプトを読み込む
if [ -d /opt/local/etc/profile.d/ ]; then
	for myscriptfile in /opt/local/etc/profile.d/*.zsh ; do
		source $myscriptfile
	done
	unset myscriptfile
fi
if [ -d /usr/local/etc/ ]; then
	for myscriptfile in /usr/local/etc/*.zsh ; do
		source $myscriptfile
	done
	unset myscriptfile
fi
if [ -d $HOME/.zsh/scripts/ ]; then
	for myscriptfile in $HOME/.zsh/scripts/*.zsh ; do
		source $myscriptfile
	done
	unset myscriptfile
fi

# 補完設定ファイルを指定する
if [ -d /usr/local/share/zsh-completions ]; then
	fpath=(/usr/local/share/zsh-completions $fpath)
fi
if [ -d $HOME/.zsh/functions ]; then
	fpath=($HOME/.zsh/functions $fpath)
fi

# 検索関数
function web_search {
	local url=$1       && shift
	local delimiter=$1 && shift
	local prefix=$1    && shift
	local query

	if [ -n "$1" ]; then
		query="${prefix}$1"
		shift
		while [ -n "$1" ]; do
			query="${query}${delimiter}${prefix}$1"
			shift
		done
	fi

	open "${url}${query}"
}

# google : Google検索
function google () {
	web_search "https://www.google.co.jp/search?&q=" "+" "" $*
}

# dash : Dash呼び出し
function dash () {
	web_search "dash://" " " "" $*
}

# cdg : gitトップディレクトリに移動するコマンド
cdg () {
	cd $(git rev-parse --show-toplevel)
}

# cot : CotEditor起動コマンド
cot () {
	if [ ! -z "$1" ] && [ ! -e "$1" ]; then touch $1 ; fi
	open -a CotEditor $*
}

# cp : 進捗を表示する
alias cp="cp -v"
# mv : 進捗を表示する
alias mv="mv -v"
# rm : 削除前に確認する、進捗を表示する
alias rm="grm -I -v"
# ls : 隠しファイルも表示する、カラー表示する、番号でソートする
alias ls="gls -A --color=auto --sort=version"
eval $(gdircolors)
# lv : カラー表示する
alias lv="lv -c"
# grep : カラー表示する
alias grep="grep --color=auto"
# ack : 常にカラー表示する、常にグループ表示する、ファイル名でソートする、ページャ表示する
alias ack="ack-5.12 --color --group --sort-files --pager=less"
# diff : カラー表示する、Unified形式にする
alias diff="colordiff -u"
# w3m : HTMLページャとして起動する
alias w3m="w3m -T text/html"
# rename : zmv ベースのリネームコマンド
alias rename="noglob zmv -W"
# EDITOR : CotEditorを別インスタンスで起動して終了を待つ
export EDITOR="open -W -n -F -a CotEditor"

# less : 1画面分のときは終了する、カラー表示する、行を折り返さない、画面をクリアしない
export LESS=FRSX
# less の履歴を保存しない
export LESSHISTFILE=-

# app ファイル名指定で実行できるようにする
alias -s app=open

# 補完関数のロード
autoload compinit
compinit -u -d "$HOME/.zshfiles/.zcompdump"

# dash の補完定義
compdef _man dash

