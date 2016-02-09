# http://oooooooo.hatenablog.com/entry/2013/06/15/162715
function geminfo() {
  if test $# -eq 1; then
    gem spec $1 summary     | ruby -pe 'gsub(/(\-\-\-|\.\.\.\n)/, "")'
    gem spec $1 description | ruby -pe 'gsub(/(\-\-\-|\.\.\.\n)/, "")'
  else
    bundle list | awk '/\* .+ / { print $2; system("gem spec "$2" summary;gem spec "$2" description") }' | ruby -pe 'gsub(/(\-\-\-|\.\.\.\n)/, "")'
  fi
}
