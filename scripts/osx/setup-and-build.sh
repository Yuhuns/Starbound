#!/bin/sh

cd "`dirname \"$0\"`/../.."

mkdir -p dist
cp scripts/osx/sbinit.config dist/

if [ "$1" == "build" ]; then
  if [ -d build ]; then
    echo "-- Cleaning build directory --"
    rm -rf build
  fi

  mkdir -p build
  cd build

  echo "-- Checking if brew is installed --"
  if ! command -v brew &> /dev/null; then
    echo "-- Brew is not installed --"
    echo "-- Installing brew --"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  echo "-- Updating brew --"
  if brew update &> /dev/null; then
    if brew upgrade &> /dev/null; then
      echo "-- Brew updated --"
    else
      echo "-- Brew update failed --"
    fi
  fi

  echo "-- Checking if dependencies are installed --"
  if ! brew list cmake &> /dev/null; then
    echo "-- Installing cmake --"
    brew install cmake
  elif ! brew list ninja &> /dev/null; then
    echo "-- Installing ninja --"
    brew install ninja
  elif ! brew list jemalloc &> /dev/null; then
    echo "-- Installing jemalloc --"
    brew install jemalloc
  elif ! brew list sdl2 &> /dev/null; then
    echo "-- Installing sdl2 --"
    brew install sdl2
  elif ! brew list glew &> /dev/null; then
    echo "-- Installing glew --"
    brew install glew
  elif ! brew list libvorbis &> /dev/null; then
    echo "-- Installing libvorbis --"
    brew install libvorbis
  elif ! brew list lzlib &> /dev/null; then
    echo "-- Installing lzlib --"
    brew install lzlib
  elif ! brew list libpng &> /dev/null; then
    echo "-- Installing libpng --"
    brew install libpng
  elif ! brew list freetype &> /dev/null; then
    echo "-- Installing freetype --"
    brew install freetype
  fi
  echo "-- Checking dependencies done --"

  QT5_INSTALL_PATH=/opt/homebrew/opt/qt@5
  if [ -d $QT5_INSTALL_PATH ]; then
    export PATH=$QT5_INSTALL_PATH/bin:$PATH
    export LDFLAGS=-L$QT5_INSTALL_PATH/lib
    export CPPFLAGS=-I$QT5_INSTALL_PATH/include
    export CMAKE_PREFIX_PATH=$QT5_INSTALL_PATH
    BUILD_QT_TOOLS=OFF
  else
    BUILD_QT_TOOLS=OFF
  fi

  echo "-- Choose your architecture --"
  echo "1. x86_64 (universal macs (intel, M1, M2, M3)"
  echo "2. arm64 (sillicon macs (M1, M2, M3))"
  read -p "Enter your choice: " choice
  case $choice in
    1)
      export CMAKE_OSX_ARCHITECTURES=x86_64
      export CMAKE_ARCH_INCLUDE=../lib/osx/include
      export CMAKE_ARCH_LIB=../lib/osx
      ;;
    2)
      export CMAKE_OSX_ARCHITECTURES=arm64
      export CMAKE_ARCH_INCLUDE=../lib/osx/arm64/include
      export CMAKE_ARCH_LIB=../lib/osx/arm64
      ;;
    *)
      echo "-- Invalid choice --"
      exit 1
      ;;
  esac

  echo "-- Choose your build type --"
  echo "1. Debug"
  echo "2. Release"
  echo "3. RelWithDebInfo"
  echo "4. ReleaseWithAsserts"
  read -p "Enter your choice: " choice
  case $choice in
    1)
      export CMAKE_BUILD_TYPE=Debug
      export JE_MALLOC=ON
      export COMPILE_COMMAND=ON
      ;;
    2)
      export CMAKE_BUILD_TYPE=Release
      export JE_MALLOC=OFF
      export COMPILE_COMMAND=OFF
      export STATIC=ON
      ;;
    3)
      export CMAKE_BUILD_TYPE=RelWithDebInfo
      export JE_MALLOC=ON
      export COMPILE_COMMAND=ON
      ;;
    4)
      export CMAKE_BUILD_TYPE=ReleaseWithAsserts
      export JE_MALLOC=OFF
      export COMPILE_COMMAND=ON
      ;;
    *)
      echo "-- Invalid choice --"
      exit 1
      ;;
  esac

  echo "-- Building Starbound --"

  CC=clang CXX=clang++ cmake \
    -DCMAKE_OSX_ARCHITECTURES=$CMAKE_OSX_ARCHITECTURES \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=$COMPILE_COMMAND \
    -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
    -DSTAR_BUILD_QT_TOOLS=$BUILD_QT_TOOLS \
    -DSTAR_USE_JEMALLOC=$COMPILE_COMMAND \
    -DSTAR_ENABLE_STATIC_LIBGCC_LIBSTDCXX=$STATIC \
    -DSTAR_ENABLE_STEAM_INTEGRATION=ON \
    -DSTAR_ENABLE_DISCORD_INTEGRATION=ON \
    -DCMAKE_INCLUDE_PATH=$CMAKE_ARCH_INCLUDE \
    -DCMAKE_LIBRARY_PATH=$CMAKE_ARCH_LIB \
    ../source

  mkdir -p ../dist
  cd ../dist

  echo "-- Copying resources --"

  cp ../scripts/steam_appid.txt .

  echo "-- Copying libraries --"

  cp $CMAKE_ARCH_LIB/libsteam_api.dylib .
  cp $CMAKE_ARCH_LIB/libdiscord_game_sdk.dylib .
  cp $CMAKE_ARCH_LIB/discord_game_sdk.dylib .

echo "-- Building app --"
make -j$(sysctl -n hw.logicalcpu) -C../build || exit 1
fi

echo "-- Making app bundle --"

if [ -f ./dist/starbound ];
then
  if [ -d ./dist/Starbound.app ];
  then
    echo "-- Cleaning old app bundle --"
    rm -rf ./dist/Starbound.app
  fi
  cp -r ./scripts/osx/Starbound.app dist/
  cp ./dist/starbound ./dist/Starbound.app/Contents/MacOS/
  cp ./dist/libsteam_api.dylib ./dist/Starbound.app/Contents/MacOS/
  cp ./dist/libdiscord_game_sdk.dylib ./dist/Starbound.app/Contents/MacOS/
  cp ./dist/discord_game_sdk.dylib ./dist/Starbound.app/Contents/MacOS/
  codesign --deep --force --verbose --sign "Yuhuns" ./dist/Starbound.app
  echo "-- App bundle created --"

  if [ "$1" == "zip" ];
  then
    mkdir osx
    echo "-- Zipping app bundle --"
    cp -r ./dist/Starbound.app ./osx/
    cp -r ./dist/sbinit.config ./osx/
    cp -r ./dist/steam_appid.txt ./osx/
    cp -r ./dist/starbound_server ./osx/
    cp -r ./dist/asset_packer ./osx/
    cp -r ./dist/asset_unpacker ./osx/
    zip -r game_macos.zip osx assets
    rm -rf osx
    echo "-- App bundle zipped --"
  fi
fi

echo "-- Done --"