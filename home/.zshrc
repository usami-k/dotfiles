# zshrc

# Check if zplug is installed
[ -d ~/.zplug ] || {
    git clone https://github.com/zplug/zplug ~/.zplug
    source ~/.zplug/init.zsh && zplug update --self
}

# Essential
source ~/.zplug/init.zsh

# Plugins
zplug "zsh-users/zsh-completions"
zplug "b4b4r07/enhancd", use:"enhancd.sh", nice:-10
zplug "mollifier/cd-gitroot"
zplug "plugins/pod", from:oh-my-zsh
zplug "uasi/28415c76416986e81030", from:gist, use:"ghq-foreach.sh", hook-build:"chmod +x ghq-foreach.sh", rename-to:"ghq-foreach", as:command
zplug "usami-k/zsh-select-history"
zplug "usami-k/zsh-android-sdk"

# Plugins after compinit
zplug "zsh-users/zsh-syntax-highlighting", nice:10
zplug "$(brew --prefix)/share/zsh/site-functions", from:local, use:"_gibo", nice:10

# Personal settings
zplug "$HOME/.zsh", from:local

# Install plugins that have not been installed yet
zplug check || zplug install

# Load plugins
zplug load

