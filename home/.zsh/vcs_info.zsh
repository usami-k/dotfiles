# vcs_info
autoload vcs_info

# gitのみ有効にする
zstyle ":vcs_info:*" enable git
# commitしていない変更をチェックする
zstyle ":vcs_info:git:*" check-for-changes true
# gitリポジトリに対して、変更情報とリポジトリ情報を表示する
zstyle ":vcs_info:git:*" formats "%u%c%m[%b]"
# gitリポジトリに対して、コンフリクトなどの情報を表示する
zstyle ":vcs_info:git:*" actionformats "%u%c<%a>%m[%b]"
# addしていない変更があることを示す文字列
zstyle ":vcs_info:git:*" unstagedstr "<U>"
# commitしていないstageがあることを示す文字列
zstyle ":vcs_info:git:*" stagedstr "<S>"
# stgit使用時、パッチが当たっていればパッチ名を表示する
zstyle ":vcs_info:git:*" patch-format "{%p}"
# stgit使用時、パッチが当たっていなければ何も表示しない
zstyle ":vcs_info:git:*" nopatch-format ""
# hook関数を定義
zstyle ":vcs_info:git+set-message:*" hooks my_vcs_info

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
