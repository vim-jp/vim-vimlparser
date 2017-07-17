#!/bin/bash

if [ $# -eq 0 ]; then
  echo "USAGE: ./test/run_command.sh <vimlparser command>"
  echo "  Example: ./test/run_command.sh python3 py/vimlparser.py"
  exit 1
fi
vimlparser=$@

exit_status=0

test_file() {
  local vimfile=$1
  local base=$(basename "$vimfile" ".vim")
  local okfile="test/${base}.ok"
  local outfile="test/${base}.out"

  if [[ -f "test/${base}.skip" ]]; then
    return
  fi

  local neovim=""
  if [[ $vimfile =~ "test_neo" ]]; then
    neovim="--neovim"
  fi

  rm -f ${outfile}

  ${vimlparser} ${neovim} ${vimfile} &> ${outfile}

  diffout=$(diff -u ${outfile} ${okfile})
  if [ -n "$diffout" ]; then
    exit_status=1
    echo "${diffout}"
  fi
}

for f in test/test*.vim; do
  test_file ${f}
done

exit $exit_status
