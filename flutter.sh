#!/usr/bin/env bash

brew tap leoafarias/fvm
brew install fvm
fvm install 2.2.1
fvm global 2.2.1
ln -s ~/fvm/default/bin/flutter /usr/local/bin/flutter

# accept all android licences
yes | flutter doctor --android-licenses