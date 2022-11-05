#!/usr/bin/env fish

# Finder : Enable text selection on QuickLook
defaults write com.apple.finder QLEnableTextSelection -bool YES

# Disable .DS_Store on network drive
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool YES

# Flatten Services menu
defaults write NSGlobalDomain NSServicesMinimumItemCountForContextSubmenu -int 32

# Photos : Disable automatic launching on connecting device
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool YES

# LaunchPad : Reset app positions
defaults write com.apple.dock ResetLaunchPad -bool YES
killall Dock
