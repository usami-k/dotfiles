export GOPATH=$HOME/go

[ -d $GOPATH ] && {
    path=($path $GOPATH/bin)
}
