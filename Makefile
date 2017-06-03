VIM_COMPILER:=vim -N --cmd 'set rtp+=.' -c q -u

all: js/vimlparser.js py/vimlparser.py

js/vimlparser.js: autoload/vimlparser.vim js/jscompiler.vim js/vimlfunc.js
	$(VIM_COMPILER) js/jscompiler.vim

py/vimlparser.py: autoload/vimlparser.vim py/pycompiler.vim py/vimlfunc.py
	$(VIM_COMPILER) py/pycompiler.vim
