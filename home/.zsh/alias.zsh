# alias.zsh

# ls : 隠しファイルも表示する、カラー表示する、番号でソートする
which gls >/dev/null && alias ls="gls -A --color=auto --sort=version"
which gdircolors >/dev/null && eval $(gdircolors)

# cp : 進捗を表示する
alias cp="cp -v"

# mv : 進捗を表示する
alias mv="mv -v"

# rm : 削除前に確認する、進捗を表示する
which grm >/dev/null && alias rm="grm -I -v"

# lv : カラー表示に対応する
alias lv="lv -c"

# grep : カラー表示する
alias grep="grep --color=auto"

# diff : 常にカラー表示する、Unified形式にする
alias diff="diff --unified"
which colordiff >/dev/null && alias diff="colordiff --unified"

# jq : 常にカラー表示する
alias jq="jq -C"

# rename : zmv ベースのリネームコマンド
autoload zmv
alias rename="noglob zmv -W"

# xcode : Xcode 起動コマンド
alias xcode="open -a Xcode"

# haskell-stack : コマンドショートカット
which stack >/dev/null && {
    alias ghc="stack ghc --"
    alias ghci="stack ghc -- --interactive"
    alias runghc="stack runghc --"
}

