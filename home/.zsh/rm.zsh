# rm : 削除前に確認する、進捗を表示する
if which grm >/dev/null ; then
    alias rm="grm -I -v"
else
    echo "grm not found"
fi
