# vcs_info
autoload vcs_info
# gitとsvnのみ有効にする
zstyle ":vcs_info:*" enable git svn
# commitしていない変更をチェックする
zstyle ":vcs_info:git*:*" check-for-changes true
# gitリポジトリに対して、変更情報とリポジトリ情報を表示する
zstyle ":vcs_info:git*:*" formats "%u%c%m[%b]"
# gitリポジトリに対して、コンフリクトなどの情報を表示する
zstyle ":vcs_info:git*:*" actionformats "%u%c<%a>%m[%b]"
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
	if [ "$(git stash list)" != "" ]; then
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

# git：notesがあるかチェックする
my_git_info_notes () {
	if [ "$(git notes list)" != "" ]; then
		# notesがあることを示す文字列
		echo "(notes)"
	fi
}

# vcs_infoの出力に独自の出力を付加する
+vi-my_vcs_info () {
	hook_com[misc]="$(my_git_info_push)$(my_git_info_stash)$(my_git_info_rerere)$hook_com[misc_orig]$(my_git_info_notes)"
}

# プロンプト設定は vcs_info 設定より後に行う

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
	echo "%B[$PWD]$fill$vcs_info_msg_0_(%D{%m/%d %H:%M})%b"
}

# プロンプト定義
PROMPT=$'$(my_update_prompt)\n%# '

# プロンプト直前の出力が改行終端してなくてもクリアしない
setopt no_prompt_cr
# 直前の返り値を表示する
setopt print_exit_value
# 実行時間が長かった場合、かかった時間を表示する
REPORTTIME=3
