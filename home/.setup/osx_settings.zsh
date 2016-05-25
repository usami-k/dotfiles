#!/bin/zsh

# Disable .DS_Store on network drive
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool YES

# Flatten Services menu
defaults write NSGlobalDomain NSServicesMinimumItemCountForContextSubmenu -int 32

# Enable text selection on QuickLook
defaults write com.apple.finder QLEnableTextSelection -bool YES

# Disable Photos.app HotPlug
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool YES

