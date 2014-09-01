#!/bin/sh
brew tap caskroom/cask
brew tap peco/peco
brew update
brew upgrade
brew install $(cat brew_leaves.txt)
brew cask install $(cat brew_casklist.txt)
brew cleanup
