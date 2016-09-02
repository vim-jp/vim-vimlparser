source ./go/gocompiler.vim

call extend(s:, g:ImportGoCompiler())

function! s:generate()
  let vimfile = 'autoload/vimlparser.vim'
  let gofile = 'go/vimlparser.go'
  let vimlfunc = 'go/vimlfunc.go'
  let head = readfile(vimlfunc)
  try
    let r = s:StringReader.new(readfile(vimfile))
    let p = s:VimLParser.new()
    let c = s:GoCompiler.new()
    let lines = c.compile(p.parse(r))
    unlet lines[0 : index(lines, 'var NIL = []') - 1]
    call writefile(head + lines, gofile)
  catch
    echoerr substitute(v:throwpoint, '\.\.\zs\d\+', '\=s:numtoname(submatch(0))', 'g') . "\n" . v:exception
  endtry
endfunction

call s:generate()
