#!/bin/sh -e

cd "`dirname \"$0\"`/../../dist"

STEAM_INSTALL_DIR="$HOME/Library/Application Support/Steam/steamapps/common/Starbound - Unstable"

if [[ ! -d "$STEAM_INSTALL_DIR" ]]; then
  echo "Steam install directory not found: $STEAM_INSTALL_DIR"
  exit 1
fi

echo "Copying files to Steam install directory: $STEAM_INSTALL_DIR"
cp ../assets/packed.pak "$STEAM_INSTALL_DIR/assets/packed.pak"
cp sbinit.config "$STEAM_INSTALL_DIR/osx/sbinit.config"
cp starbound "$STEAM_INSTALL_DIR/osx/starbound"
cp *.dylib "$STEAM_INSTALL_DIR/osx/"
