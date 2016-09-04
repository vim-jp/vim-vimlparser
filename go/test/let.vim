let x = 1
function! Funcname() abort
  let y = 1
  let y = 2
  let x = 1
endfunction

function! Funcname(z) abort
  let z = a:z
endfunction

function! s:VimLParser.hoge(a)
  let a = a:a
endfunction

let [b, c] = d
let [b, c] = d
let [node.pattern, b] = hoge
let [node.pattern, _] = hoge

let e = 1
if f
  let e = g
  let h = 0
  if i
    let h = 1
  endif
endif

let xs = 1
if x
  let xs[0] = 1
endif
