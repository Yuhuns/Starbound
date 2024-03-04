#!/bin/sh

cd "$(dirname $0)/../.."

cd build
cmake --build . --config RelWithDebInfo
