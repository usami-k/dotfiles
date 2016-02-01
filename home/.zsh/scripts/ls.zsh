# ls : 隠しファイルも表示する、カラー表示する、番号でソートする
if which gls >/dev/null ; then
    alias ls="gls -A --color=auto --sort=version"
    eval $(gdircolors)
else
    echo "gls not found"
fi
