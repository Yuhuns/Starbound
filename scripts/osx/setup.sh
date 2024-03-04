#!/bin/sh

cd "$(dirname $0)/../.."

mkdir -p dist
cp scripts/osx/sbinit.config dist/

mkdir -p build
cd build

#Universal arch by default
CC=clang CXX=clang++ cmake \
  -DCMAKE_OSX_ARCHITECTURES=x86_64 \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=true \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DSTAR_USE_JEMALLOC=ON \
  -DCMAKE_INCLUDE_PATH=../lib/osx/include \
  -DCMAKE_LIBRARY_PATH=../lib/osx/ \
  ../source
