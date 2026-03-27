# interactive bash 用の最小初期化。
# bash は補助用途なので、bash 固有設定は 1 箇所に寄せる。

if [ -r "$HOME/.bash_env" ]; then
    . "$HOME/.bash_env"
fi
