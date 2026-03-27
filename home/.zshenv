# zsh で常に必要な最小環境設定。
# login / interactive に依存しない静的な値だけを置く。

typeset -gU path

: "${SWIFTLY_HOME_DIR:=$HOME/.swiftly}"
: "${SWIFTLY_BIN_DIR:=$SWIFTLY_HOME_DIR/bin}"
: "${SWIFTLY_TOOLCHAINS_DIR:=$HOME/Library/Developer/Toolchains}"
: "${BASH_ENV:=$HOME/.bash_env}"

export SWIFTLY_HOME_DIR
export SWIFTLY_BIN_DIR
export SWIFTLY_TOOLCHAINS_DIR
export BASH_ENV

if [ -d /opt/homebrew/bin ]; then
    path=(/opt/homebrew/bin /opt/homebrew/sbin $path)
elif [ -d /usr/local/bin ]; then
    path=(/usr/local/bin /usr/local/sbin $path)
fi

# 共通で見えていてほしいツールの PATH だけを追加する。
for dir in \
    "$HOME/.ghcup/bin" \
    "$HOME/.cargo/bin" \
    "$SWIFTLY_BIN_DIR" \
    "$HOME/.local/bin"
do
    [ -d "$dir" ] && path=("$dir" $path)
done

export PATH
