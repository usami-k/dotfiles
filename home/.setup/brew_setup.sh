#!/bin/sh
brew tap caskroom/cask
brew tap caskroom/fonts
brew tap ioszip/ioszip
brew tap thoughtbot/formulae
brew tap aspnet/dnx

brew update
brew install $(cat brew_leaves.txt)
brew cask install $(cat brew_cask_list.txt)
