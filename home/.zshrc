# zshrc

# Emacsキーバインドを使用する
bindkey -e

# 設定スクリプトを読み込む
myscriptdir=$HOME/.zsh/scripts
if [ -d $myscriptdir ]; then
	for myscriptfile in $myscriptdir/*.zsh ; do
		source $myscriptfile
	done
	unset myscriptfile
fi
unset myscriptdir

# delayed 設定スクリプトを読み込む
myscriptdir=$HOME/.zsh/scripts_delayed
if [ -d $myscriptdir ]; then
	for myscriptfile in $myscriptdir/*.zsh ; do
		source $myscriptfile
	done
	unset myscriptfile
fi
unset myscriptdir

