#!/bin/sh

cd "$(dirname $0)/../.."

cd build
if [ "$1" ]; then
  cmake -G "Ninja" -DCMAKE_BUILD_TYPE=$1 ..
else
  cmake -G "Ninja" ..
fi
