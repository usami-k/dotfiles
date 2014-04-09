#!/bin/sh

# update homebrew
brew update
brew upgrade

# tap external repository
brew tap phinze/cask

# install package
brew install $(cat brew_leaves.txt)

# cask install package
for cask in $(cat brew_casklist.txt) ; do
	brew cask install $cask
done

