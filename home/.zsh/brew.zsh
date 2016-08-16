# brew : 各種 *env ツールの PATH を除いて実行する
alias brew="PATH=${PATH/\/*\/*\/*env\/shims:/} brew"
