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

# 直前の返り値を表示する
setopt print_exit_value

# 実行時間が長かった場合、かかった時間を表示する
REPORTTIME=3
