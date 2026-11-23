#!/bin/bash

set -ev

git clone --depth 1 --branch "${VIM_VERSION}" https://github.com/vim/vim /tmp/vim
cd /tmp/vim
case "${VIM_VERSION}" in
  v7.*|v8.0.*)
    # Old Vim sources do not build with recent compilers (GCC 14+, C23).
    export CFLAGS="-O2 -std=gnu89 -Wno-error=implicit-function-declaration -Wno-error=implicit-int -Wno-error=int-conversion -Wno-error=incompatible-pointer-types"
    ;;
esac
./configure --prefix="${HOME}/vim" --with-features=huge --enable-fail-if-missing
make -j2
make install
