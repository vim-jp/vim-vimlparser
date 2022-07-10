let a =<< EOS
hello
 world
EOS
let a =<< trim EOS
	hello
world
EOS
let a =<< EOS
EOS
if v:true
	" matching leading indentation is accepted
	let a =<< trim EOS
		hello
	world
	EOS
  let a =<< trim EOS
   hello
  world
  EOS
	" but isn't required
	let a =<< trim EOS
   hello
  world
EOS
endif
" we don't actually do the trimming for trim heredocs
let a =<< trim EOS
  hello
   world
EOS
