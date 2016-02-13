# alias.zsh

# ls : 隠しファイルも表示する、カラー表示する、番号でソートする
if which gls >/dev/null ; then
    alias ls="gls -A --color=auto --sort=version"
    eval $(gdircolors)
else
    echo "gls not found"
fi

# cp : 進捗を表示する
alias cp="cp -v"

# mv : 進捗を表示する
alias mv="mv -v"

# rm : 削除前に確認する、進捗を表示する
if which grm >/dev/null ; then
    alias rm="grm -I -v"
else
    echo "grm not found"
fi

# rename : zmv ベースのリネームコマンド
autoload zmv
alias rename="noglob zmv -W"

# lv : カラー表示に対応する
alias lv="lv -c"

# grep : カラー表示する
alias grep="grep --color=auto"

# diff : 常にカラー表示する、Unified形式にする
alias diff="git diff --no-index"

# jq : 常にカラー表示する
alias jq="jq -C"

# xcode
alias xcode="open -a Xcode"

