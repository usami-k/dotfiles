# zshrc

# Check if zplug is installed
if [ ! -d ~/.zplug ] ; then
	curl -fLo ~/.zplug/zplug --create-dirs https://git.io/zplug
	source ~/.zplug/zplug && zplug update --self
fi

# Essential
source ~/.zplug/zplug

# Plugins
zplug "peco/peco", from:gh-r, as:command
zplug "plugins/pod", from:oh-my-zsh, nice:10

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

