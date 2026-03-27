# login 時だけ必要な zsh 初期化。

if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate zsh)"
fi
