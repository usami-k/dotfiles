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

