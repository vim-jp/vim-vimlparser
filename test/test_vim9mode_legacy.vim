" A :def function in a legacy script uses Vim9 syntax.
def g:Vim9Func(): number
  # Vim9 comment
  var n = 1 # trailing comment
  return n
enddef
function! LegacyFunc()
  " legacy comment
  try
    let x = 1
  fina
    let x = 2
  endtry
endfunction
" legacy script
def Legacy(d: dict<any> = {key: 1}, n = 1 + 1)
  echo d
enddef
