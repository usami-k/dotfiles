#!/bin/sh

# tap external repository
brew tap phinze/cask

# install package
brew update
brew install $(cat brew_leaves.txt)

# cask install package
brew cask update
for cask in $(cat brew_casklist.txt) ; do
	brew cask install $cask
done
