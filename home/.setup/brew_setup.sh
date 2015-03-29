#!/bin/sh

# Prepare
brew tap ioszip/ioszip
brew tap thoughtbot/formulae
brew tap caskroom/cask
brew tap caskroom/fonts

# Update
brew update
brew outdated -v
brew doctor

# Install
brew install $(cat brew_leaves.txt)
brew upgrade
brew cleanup
brew leaves > brew_leaves.txt
brew cask install $(cat brew_casklist.txt)
brew cask cleanup
brew cask list > brew_casklist.txt

