" The main code was moved to autoload/vital/__vimlparser__/VimLParser.vim to
" make vim-vimlparser.vim vital-module.
"
" See https://github.com/vim-jp/vital.vim for vital module.

call extend(s:, vital#vimlparser#import('VimLParser').import())

" To Vim plugin developer who want to depend on vim-vimlparser:
" Please use vimlparser as vital-module instead of this autoload function.
" We do not ensure that future changes are backward compatible.
function! vimlparser#import()
  return s:
endfunction

" @brief Read input as VimScript and return stringified AST.
" @param input Input filename or string of VimScript.
" @return Stringified AST.
function! vimlparser#test(input, ...)
  try
    if a:0 > 0
      let l:neovim = a:1
    else
      let l:neovim = 0
    endif
    let i = type(a:input) == 1 && filereadable(a:input) ? readfile(a:input) : split(a:input, "\n")
    let r = s:StringReader.new(i)
    let p = s:VimLParser.new(l:neovim)
    let c = s:Compiler.new()
    echo join(c.compile(p.parse(r)), "\n")
  catch
    echoerr substitute(v:throwpoint, '\.\.\zs\d\+', '\=s:numtoname(submatch(0))', 'g') . "\n" . v:exception
  endtry
endfunction

if has('patch-7.4.1842')
  function! s:numtoname(num)
    for k in keys(s:)
      if type(s:[k]) == type({})
        for name in keys(s:[k])
          if type(s:[k][name]) == type(function('tr')) && get(s:[k][name], 'name') == a:num
            return printf('%s.%s', k, name)
          endif
        endfor
      endif
    endfor
    return a:num
  endfunction
else
  function! s:numtoname(num)
    let sig = printf("function('%s')", a:num)
    for k in keys(s:)
      if type(s:[k]) == type({})
        for name in keys(s:[k])
          if type(s:[k][name]) == type(function('tr')) && string(s:[k][name]) == sig
            return printf('%s.%s', k, name)
          endif
        endfor
      endif
    endfor
    return a:num
  endfunction
endif
