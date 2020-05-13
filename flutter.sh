curl https://storage.googleapis.com/flutter_infra/releases/stable/macos/flutter_macos_1.17.0-stable.zip --output flutter_macos_1.17.0-stable.zip #--silent
#wget https://storage.googleapis.com/flutter_infra/releases/stable/macos/flutter_macos_1.17.0-stable.zip
unzip -q flutter_macos_1.17.0-stable.zip
rm flutter_macos_1.17.0-stable.zip
mkdir -p ~/Development/libraries
mv flutter ~/Development/libraries/
ln -s ~/Development/libraries/flutter/bin/flutter /usr/local/bin/flutter
