VIM_COMPILER:=vim -N --cmd 'set rtp+=.' -c q -u
COMPILED_FILES:=js/vimlparser.js py/vimlparser.py

all: $(COMPILED_FILES)

js/vimlparser.js: autoload/vimlparser.vim js/jscompiler.vim js/vimlfunc.js
	$(VIM_COMPILER) js/jscompiler.vim

py/vimlparser.py: autoload/vimlparser.vim py/pycompiler.vim py/vimlfunc.py
	$(VIM_COMPILER) py/pycompiler.vim

clean_compiled:
	$(RM) $(COMPILED_FILES)

check: all
	git diff --exit-code $(COMPILED_FILES) || { \
	  echo 'Compiled files were updated, but should have been included/committed.'; \
	  exit 1; }

test:
	test/run.sh

js/test: js/vimlparser.js
	test/run_command.sh node js/vimlparser.js

py/test: py/vimlparser.py
	test/run_command.sh python py/vimlparser.py
