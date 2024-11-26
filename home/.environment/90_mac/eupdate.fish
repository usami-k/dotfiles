#!/usr/bin/env fish

# Flatten Services menu
defaults write NSGlobalDomain NSServicesMinimumItemCountForContextSubmenu -int 32

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool YES

# Enable text selection on QuickLook
defaults write com.apple.finder QLEnableTextSelection -bool YES

# Disable .DS_Store on network drive
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool YES

# Disable shadow on screen capture
defaults write com.apple.screencapture disable-shadow -bool YES

# Disable automatic launching Photos on connecting device
defaults write com.apple.imagecapture disableHotPlug -bool YES

# Disable automatic reopening of last project
defaults write com.apple.dt.Xcode ApplePersistenceIgnoreState -bool YES

# LaunchPad : Reset app positions
defaults write com.apple.dock ResetLaunchPad -bool YES
killall Dock
