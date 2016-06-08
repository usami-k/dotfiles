#!/bin/zsh
pushd $(dirname $0)

echo '## homebrew'
brew install $(cat brew_leaves | sed "/^#/d")
swiftenv rehash

echo '## homebrew cask'
brew tap caskroom/cask
brew tap caskroom/fonts
brew cask install $(cat cask_list | sed "/^#/d")

echo '## gem'
rbenv rehash
gem install $(cat gem_list | sed "/^#/d")

echo '## pip'
pyenv rehash
pip install $(cat pip_list | sed "/^#/d")

popd
