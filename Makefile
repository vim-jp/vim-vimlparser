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

test:
	test/run.sh

js/test: js/vimlparser.js
	test/run_command.sh node js/vimlparser.js

py/test: py/vimlparser.py
	test/run_command.sh python py/vimlparser.py

vim/test1: test/test_source.vim
	vim -u NONE -N --cmd "let &rtp .= ',' . getcwd()" -S test/test_source.vim
	diff -u test/test_source.want test/test_source.got

vim/test2: test/test_token.vim
	vim -u NONE -N --cmd "let &rtp .= ',' . getcwd()" -S test/test_token.vim
	diff -u test/test_token.want test/test_token.got

