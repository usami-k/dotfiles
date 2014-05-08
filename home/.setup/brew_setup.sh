#!/bin/sh

# tap external repository
brew tap caskroom/cask

# install package
brew update
brew install $(cat brew_leaves.txt)

# cask install package
brew cask update
if [ -f brew_casklist.txt ]; then
	for cask in $(cat brew_casklist.txt) ; do
		brew cask install $cask
	done
fi

