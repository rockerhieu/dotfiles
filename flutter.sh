wget https://storage.googleapis.com/flutter_infra/releases/stable/macos/flutter_macos_v1.9.1+hotfix.2-stable.zip
unzip -q flutter_macos_v1.9.1+hotfix.2-stable.zip
rm flutter_macos_v1.9.1+hotfix.2-stable.zip
mkdir -p ~/Development/libraries
mv flutter ~/Development/libraries/
ln -s ~/Development/libraries/flutter /usr/local/share/flutter
