export PATH=$HOME/.local/bin:$HOME/.cargo/bin:/opt/homebrew/bin:$PATH
typeset -gU path

# .zshenv so mise [env] (e.g. per-dir GH_TOKEN) applies to non-interactive zsh -c too
eval "$(mise activate zsh)"
