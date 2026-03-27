# interactive 時だけ必要な zsh 初期化。

if [ -r "$HOME/.safe-chain/scripts/init-posix.sh" ]; then
    . "$HOME/.safe-chain/scripts/init-posix.sh"
fi
