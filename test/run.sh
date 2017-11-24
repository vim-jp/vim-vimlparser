#!/bin/sh
vim -Nu test/vimrc -S test/run.vim
EXIT=$?
[ -e test.log ] && cat test.log
exit $EXIT
