#!/bin/sh
brew tap caskroom/cask
brew tap caskroom/fonts
brew tap ioszip/ioszip
brew tap thoughtbot/formulae
brew tap aspnet/dnx
brew tap tcnksm/ghr

brew update
brew install $(cat brew_leaves.txt | sed "/^#/d")
brew cask install $(cat brew_cask_list.txt | sed "/^#/d")
