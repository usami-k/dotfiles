# 検索関数
function web_search {
	local url=$1       && shift
	local delimiter=$1 && shift
	local prefix=$1    && shift
	local query

	if [ -n "$1" ]; then
		query="${prefix}$1"
		shift
		while [ -n "$1" ]; do
			query="${query}${delimiter}${prefix}$1"
			shift
		done
	fi

	open "${url}${query}"
}

# google : Google検索
function google () {
	web_search "https://www.google.co.jp/search?&q=" "+" "" $*
}

# dash : Dash呼び出し
function dash () {
	web_search "dash://" " " "" $*
}

