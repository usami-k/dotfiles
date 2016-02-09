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
zplug "b4b4r07/enhancd", of:"enhancd.sh"
zplug "mollifier/cd-gitroot"
zplug "peco/peco", from:gh-r, as:command
zplug "plugins/pod", from:oh-my-zsh
zplug "$(brew --prefix)/share/zsh/site-functions", from:local, of:"_gibo", nice:10
zplug "$HOME/.zsh", from:local, nice:5

# Install plugins that have not been installed yet
zplug check || zplug install

# Load plugins
zplug load

