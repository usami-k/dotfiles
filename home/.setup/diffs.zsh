#!/bin/zsh
pushd $(dirname $0)

echo '## homebrew'
diff <(brew leaves | sort) <(cat brew_leaves | sed "/^#/d" | sed "/^$/d" | sort)

echo '## homebrew cask'
diff <(brew cask list | sort) <(cat cask_list | sed "/^#/d" | sed "/^$/d" | sort)

popd
