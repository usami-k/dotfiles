#!/bin/zsh
diff <(brew cask list | sort) <(cat cask_list | sed "/^#/d" | sed "/^$/d" | sort)
