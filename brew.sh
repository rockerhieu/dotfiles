#!/usr/bin/env bash

# Install command-line tools using Homebrew.
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null ; brew install caskroom/cask/brew-cask 2> /dev/null

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed
# Install a modern version of Bash.
brew install bash
brew install bash-completion2

# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/bash";
fi;

# Install `wget` with IRI support.
brew install wget -- --with-iri

# Install GnuPG to enable PGP-signing commits.
brew install gnupg

# Install more recent versions of some macOS tools.
brew install vim -- --with-override-system-vi
brew install grep
brew install openssh
brew install tmux
# makes pbcopy and pbpaste work again within tmux
brew install reattach-to-user-namespace
#brew install php
brew install gmp
brew install thefuck

# Install font tools.
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2

# Node
brew install node

# Install other useful binaries.
#brew install ack
#brew install exiv2
brew install git
brew install git-lfs
brew install git-standup
brew install gs
brew install imagemagick -- --with-webp
brew install lua
brew install lynx
brew install p7zip
brew install pigz
brew install pv
brew install rename
brew install rlwrap
brew install ssh-copy-id
brew install tree
brew install vbindiff
brew install zopfli

# code search
brew install the_silver_searcher

# for highlighting code
brew install highlight

# Install Apps
# window management
brew cask install spectacle
# adjust screen color to ease your eyes
brew cask install flux
brew cask install google-chrome
brew cask install dropbox
brew cask install slack
# better terminal client for Mac
brew cask install iterm2
# gui client for git
brew cask install sourcetree
# android studio IDE
brew cask install android-studio
# spotify
brew cask install spotify
# visual studio code
brew cask install visual-studio-code
# torrent client
brew cask install transmission
# video player
brew cask install vlc
# app cleaner
brew cask install appcleaner
# vpn client
brew cask install tunnelblick
# edit and view music score
brew cask install musescore
# file download manager
brew cask install folx
# keep your mac awake
brew cask install caffeine
# Vietnamese keyboard
brew cask install openkey
# screen recorder
brew cask install kap
# calendar widget
brew cask install itsycal
# sqlite db browser
brew cask install db-browser-for-sqlite
# interactive tool to manipulate git history
brew cask install gitup
# gui tool for rar, zip, tar, 7z...
brew cask install the-unarchiver
# vysor
brew cask install vysor

# Install Android SDK
brew cask install java
brew cask install android-sdk
brew cask install android-ndk
brew cask install android-studio
touch ~/.android/repositories.cfg
brew tap dart-lang/dart
brew install dart
brew install apktool
brew install pidcat

# Remove outdated versions from the cellar.
brew cleanup

[highlight, apktool, pidcat, tmux]
[openkey, caffeine, musescore, vysor, vlc, spotify, iterm2, google-chrome, spectacle, slack, visual-studio-code, appcleaner, transmission]
