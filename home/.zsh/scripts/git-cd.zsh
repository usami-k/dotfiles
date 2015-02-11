# cdg : gitトップディレクトリに移動するコマンド
cdg () {
	cd $(git rev-parse --show-toplevel)
}

