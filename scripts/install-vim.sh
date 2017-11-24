#!/bin/bash

set -ev

git clone --depth 1 --branch "${VIM_VERSION}" https://github.com/vim/vim /tmp/vim
cd /tmp/vim
./configure --prefix="${HOME}/vim" --with-features=huge --enable-fail-if-missing
make -j2
make install
