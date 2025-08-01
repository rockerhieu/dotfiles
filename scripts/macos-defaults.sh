#!/usr/bin/env bash

# macOS System Preferences and Defaults

set -e

echo "Setting macOS defaults..."

# Finder preferences
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Show status bar and path bar
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true

# Show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Dock preferences
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock show-recents -bool false
# Remove all default apps from Dock (clean slate)
defaults write com.apple.dock persistent-apps -array

# Auto-hide dock with no delay
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0

# Screenshots
defaults write com.apple.screencapture location -string "${HOME}/Desktop/Screenshots"
defaults write com.apple.screencapture type -string "png"

# Trackpad
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Enable three finger drag
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

# Keyboard
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Menu bar
defaults write com.apple.menuextra.clock DateFormat -string "EEE MMM d  h:mm a"

# Full keyboard access for all controls
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Use fn key for changing keyboard input source
defaults write com.apple.HIToolbox AppleFnUsageType -int 1

# Add Vietnamese Telex input source
# Check if Vietnamese input method is already configured
if ! defaults read com.apple.HIToolbox AppleEnabledInputSources 2>/dev/null | grep -q "com.apple.inputmethod.VietnameseIM"; then
    echo "Adding Vietnamese Telex input method..."

    # Add Vietnamese Input Method
    defaults write com.apple.HIToolbox AppleEnabledInputSources -array-add '{
        "Bundle ID" = "com.apple.inputmethod.VietnameseIM";
        "InputSourceKind" = "Keyboard Input Method";
    }'

    # Add Vietnamese Telex Mode
    defaults write com.apple.HIToolbox AppleEnabledInputSources -array-add '{
        "Bundle ID" = "com.apple.inputmethod.VietnameseIM";
        "Input Mode" = "com.apple.inputmethod.VietnameseTelex";
        "InputSourceKind" = "Input Mode";
    }'

    echo "Vietnamese Telex input method added successfully."
else
    echo "Vietnamese input method already configured."
fi

echo "Restarting affected applications..."
killall Finder
killall Dock
killall SystemUIServer

echo "macOS defaults configured successfully!"