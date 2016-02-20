#!/bin/zsh

echo '## homebrew'
brew tap $(cat brew_leaves | grep ".*/" | sed "s|\(.*\)/.*|\1|")
brew install $(cat brew_leaves | sed "s|.*/||" | sed "/^#/d")

echo '## homebrew cask'
brew tap caskroom/cask
brew tap caskroom/fonts
brew cask install $(cat cask_list | sed "/^#/d")

echo '## gem (bundler)'
bundle install

echo '## pip'
pip3 install $(cat pip_list | sed "/^#/d")
