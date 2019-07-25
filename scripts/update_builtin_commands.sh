#!/bin/bash

if [ $# -ne 1 ]; then
  echo "USAGE: ./scripts/update_builtin_commands.sh /path/to/vim/src/ex_cmds.h"
  exit 1
fi

vim -u NONE -i NONE -n -N -e -s \
  --cmd "let &rtp .= ',' . getcwd()" \
  --cmd "source scripts/update_builtin_commands.vim" \
  --cmd "call VimLParserNewCmds(expand('$1'))" \
  --cmd "qall!" 2>&1
echo
