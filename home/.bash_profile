# login bash 用の最小初期化。
# ここでは設定を重複させず、共通ブートストラップだけ読む。

if [ -r "$HOME/.bash_env" ]; then
    . "$HOME/.bash_env"
fi
