# vcs_info
autoload -Uz vcs_info

zstyle ":vcs_info:*" enable git
zstyle ":vcs_info:git:*" check-for-changes true
zstyle ":vcs_info:git:*" formats "[%b]%u%c%m"
zstyle ":vcs_info:git:*" actionformats "[%b]%u%c<%a>%m"
zstyle ":vcs_info:git:*" unstagedstr "<U>"
zstyle ":vcs_info:git:*" stagedstr "<S>"
zstyle ":vcs_info:git:*" patch-format "{%p}"
zstyle ":vcs_info:git:*" nopatch-format ""
zstyle ":vcs_info:git+set-message:*" hooks my_vcs_info

my_git_info_push () {
	[[ -n "$(git remote 2>/dev/null)" ]] && {
		local head="$(git rev-parse HEAD)"
		local remote
		for remote in $(git rev-parse --remotes) ; do
			[[ "$head" = "$remote" ]] && return 0
		done
		echo "<P>"
	}
}

my_git_info_stash () {
	[[ -n "$(git stash list 2>/dev/null)" ]] && {
		echo "{s}"
	}
}

my_git_info_rerere () {
	[[ "$(git config rerere.enabled 2>/dev/null)" != "true" ]] && {
		echo "{rr?}"
	}
}

my_git_info_notes () {
	[[ -n "$(git notes list 2>/dev/null)" ]] && {
		echo "(notes)"
	}
}

+vi-my_vcs_info () {
	hook_com[misc]="$hook_com[misc_orig]$(my_git_info_push)$(my_git_info_stash)$(my_git_info_notes)$(my_git_info_rerere)"
}
