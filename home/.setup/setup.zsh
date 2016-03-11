#!/bin/zsh

echo '## homebrew'
brew install $(cat brew_leaves | sed "/^#/d")

echo '## homebrew cask'
brew tap caskroom/cask
brew tap caskroom/fonts
brew cask install $(cat cask_list | sed "/^#/d")

echo '## gem (bundler)'
bundle install

echo '## pip'
pip install $(cat pip_list | sed "/^#/d")
