# zshrc

# Check if zplug is installed
[ -d ~/.zplug ] || {
	curl -fLo ~/.zplug/zplug --create-dirs https://git.io/zplug
	source ~/.zplug/zplug && zplug update --self
}

# Essential
source ~/.zplug/zplug

# Plugins
zplug "zsh-users/zsh-completions"
zplug "b4b4r07/enhancd", of:"enhancd.sh"
zplug "mollifier/cd-gitroot"
zplug "rhysd/zsh-bundle-exec"
zplug "plugins/pod", from:oh-my-zsh
zplug "uasi/28415c76416986e81030", from:gist, of:"ghq-foreach.sh", do:"chmod +x ghq-foreach.sh", file:"ghq-foreach", as:command
zplug "usami-k/zsh-select-history"
zplug "usami-k/zsh-android-sdk"

# Plugins after compinit
zplug "zsh-users/zsh-syntax-highlighting", nice:10
zplug "$(brew --prefix)/share/zsh/site-functions", from:local, of:"_gibo", nice:10

# Personal settings
zplug "$HOME/.zsh", from:local

# Install plugins that have not been installed yet
zplug check || zplug install

# Load plugins
zplug load

