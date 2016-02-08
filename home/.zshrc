# zshrc

# zplug : https://github.com/b4b4r07/zplug
source ~/.zplug/zplug

if ! zplug check ; then
    zplug install
fi

zplug load

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

