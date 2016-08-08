#!/bin/zsh
pushd $(dirname $0)

echo '## homebrew'
brew update
brew install $(cat brew_leaves | sed "/^#/d")
swiftenv rehash

echo '## homebrew cask'
brew tap caskroom/cask
brew tap caskroom/fonts
brew cask install $(cat cask_list | sed "/^#/d")

echo '## gem'
gem install $(cat gem_list | sed "/^#/d")
rbenv rehash

echo '## pip'
pip install $(cat pip_list | sed "/^#/d")
pyenv rehash

popd
