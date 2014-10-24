#!/bin/sh

# Prepare
brew tap caskroom/cask
brew tap peco/peco
brew tap ioszip/ioszip
brew tap thoughtbot/formulae

# Check
brew doctor
brew update
brew outdated -v
brew missing

# Install
brew install $(cat brew_leaves.txt)
brew cask install $(cat brew_casklist.txt)
brew cleanup
