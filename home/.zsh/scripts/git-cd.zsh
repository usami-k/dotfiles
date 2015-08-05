# cdg : gitトップディレクトリに移動するコマンド
function cdg () {
	cd $(git rev-parse --show-toplevel)
}

