# zshrc

# Check if zplug is installed
if [ ! -d ~/.zplug ] ; then
	git clone https://github.com/b4b4r07/zplug ~/.zplug
fi

# Essential
source ~/.zplug/zplug


# Install plugins that have not been installed yet
if ! zplug check ; then
    zplug install
fi

# Load plugins
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

