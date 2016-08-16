# haskell-stack : コマンドショートカット
which stack >/dev/null && {
    alias ghc="stack ghc --"
    alias ghci="stack ghc -- --interactive"
    alias runghc="stack runghc --"
}
