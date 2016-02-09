# zshrc

# Use Emacs keybind
bindkey -e

# Check if zplug is installed
[ -d ~/.zplug ] || {
	curl -fLo ~/.zplug/zplug --create-dirs https://git.io/zplug
	source ~/.zplug/zplug && zplug update --self
}

# Essential
source ~/.zplug/zplug

# Plugins
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", nice:10
zplug "peco/peco", from:gh-r, as:command
zplug "plugins/pod", from:oh-my-zsh

# Install plugins that have not been installed yet
zplug check || zplug install

# Load plugins
zplug load

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

