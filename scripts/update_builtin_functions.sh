#!/bin/bash

if [ $# -ne 1 ]; then
  echo "USAGE: ./scripts/update_builtin_functions.sh /path/to/vim/src/evalfunc.c"
  exit 1
fi

vim -u NONE -i NONE -n -N -e -s \
  --cmd "let &rtp .= ',' . getcwd()" \
  --cmd "source scripts/update_builtin_functions.vim" \
  --cmd "call VimLParserNewFuncs(expand('$1'))" \
  --cmd "qall!" 2>&1
echo
