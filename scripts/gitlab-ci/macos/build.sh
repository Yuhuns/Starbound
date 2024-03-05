#!/bin/sh -e

mkdir -p build
cd build

rm -f CMakeCache.txt

CC=clang CXX=clang++ cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DSTAR_ENABLE_STATIC_LIBGCC_LIBSTDCXX=ON \
  -DSTAR_USE_JEMALLOC=OFF \
  -DSTAR_OSX_ARCHITECTURES="x86_64" \
  -DSTAR_ENABLE_STEAM_INTEGRATION=ON \
  -DSTAR_ENABLE_DISCORD_INTEGRATION=ON \
  -DCMAKE_INCLUDE_PATH=../lib/osx/include \
  -DCMAKE_LIBRARY_PATH=../lib/osx \
  -DCMAKE_OSX_DEPLOYMENT_TARGET=14.1 \
  ../source

make -j$(sysctl -n hw.logicalcpu)

cd ..

mv dist macos_binaries
cp lib/osx/*.dylib macos_binaries/
