COMPILED_FILES:=js/vimlparser.js py/vimlparser.py

all: $(COMPILED_FILES)

js/vimlparser.js: autoload/vimlparser.vim js/jscompiler.vim js/vimlfunc.js
	scripts/jscompile.sh $< $@

py/vimlparser.py: autoload/vimlparser.vim py/pycompiler.vim py/vimlfunc.py
	scripts/pycompile.sh $< $@

clean_compiled:
	$(RM) $(COMPILED_FILES)

check: all
	git diff --exit-code $(COMPILED_FILES) || { \
	  echo 'Compiled files were updated, but should have been included/committed.'; \
	  exit 1; }

checkqa: all
	flake8 py

test:
	test/run.sh

js/test: js/vimlparser.js
	test/run_command.sh node js/vimlparser.js

py/test: py/vimlparser.py
	test/run_command.sh python py/vimlparser.py

test/node_position/test_position.out: test/node_position/test_position.vim test/node_position/test_position.ok
	vim -Nu test/vimrc -S test/node_position/test_position.vim
	diff -u test/node_position/test_position.ok test/node_position/test_position.out

.PHONY: all clean_compiled check test js/test py/test
