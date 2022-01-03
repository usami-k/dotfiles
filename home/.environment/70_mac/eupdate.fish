#!/usr/bin/env fish

# gibo : Update repository
command --query gibo ; and gibo update

# xenv : Rehash
command --query rbenv ; and rbenv rehash
command --query pyenv ; and pyenv rehash

# Finder : Enable text selection on QuickLook
defaults write com.apple.finder QLEnableTextSelection -bool YES

# Disable .DS_Store on network drive
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool YES

# Flatten Services menu
defaults write NSGlobalDomain NSServicesMinimumItemCountForContextSubmenu -int 32

# Photos : Disable automatic launching on connecting device
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool YES
