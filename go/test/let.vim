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
