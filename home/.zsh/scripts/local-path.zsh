local_bin="$HOME/.local/bin"
if [ -d $local_bin ]; then
	path=($path $local_bin)
fi
