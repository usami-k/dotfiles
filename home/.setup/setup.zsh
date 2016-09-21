#!/bin/zsh

echo '## homebrew'
brew update
brew install $(cat $(dirname $0)/brew_leaves | sed "/^#/d")

echo '## homebrew cask'
brew tap caskroom/cask
brew tap caskroom/fonts
brew cask install $(cat $(dirname $0)/cask_list | sed "/^#/d")

echo '## gem'
rbenv rehash
gem install $(cat $(dirname $0)/gem_list | sed "/^#/d")

echo '## pip'
pyenv rehash
pip install $(cat $(dirname $0)/pip_list | sed "/^#/d")
