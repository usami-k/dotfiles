#!/usr/bin/env fish

# Flatten Services menu
defaults write NSGlobalDomain NSServicesMinimumItemCountForContextSubmenu -int 32

# Hide hidden files on Finder
defaults write com.apple.finder AppleShowAllFiles -bool NO

# Disable .DS_Store on network drive
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool YES

# Disable shadow on screen capture
defaults write com.apple.screencapture disable-shadow -bool YES

# Disable automatic launching Photos on connecting device
defaults write com.apple.imagecapture disableHotPlug -bool YES

# Disable creation default devices
defaults write com.apple.CoreSimulator EnableDefaultSetCreation -bool NO

# Disable automatic reopening of last project
defaults write com.apple.dt.Xcode ApplePersistenceIgnoreState -bool YES

# LaunchPad : Reset app positions
defaults write com.apple.dock ResetLaunchPad -bool YES
killall Dock
