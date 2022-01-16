#!/bin/sh
vim -u NONE -i NONE -E -s -N -R -X --cmd 'set rtp+=.' -c 'exe "so" argv()[0]' -c q -- js/jscompiler.vim $*
