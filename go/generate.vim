source ./go/gocompiler.vim
source ./go/typedefs.vim

call extend(s:, g:ImportGoCompiler())

function! s:generate()
  let vimfile = 'autoload/vimlparser.vim'
  let gofile = 'go/vimlparser.go'
  let vimlfunc = 'go/vimlfunc/vimlfunc.go'
  let head = readfile(vimlfunc)
  try
    let lines = readfile(vimfile)
    unlet lines[0:index(lines, 'let s:NIL = []') - 1]
    unlet lines[index(lines, 'let s:Compiler = {}'):-1]
    let r = s:StringReader.new(lines)
    let p = s:VimLParser.new()
    let c = s:GoCompiler.new(g:ImportTypedefs())
    let lines = c.compile(p.parse(r))
    call writefile(head + lines, gofile)
  catch
    echoerr substitute(v:throwpoint, '\.\.\zs\d\+', '\=s:numtoname(submatch(0))', 'g') . "\n" . v:exception
  endtry
endfunction

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

call s:generate()
