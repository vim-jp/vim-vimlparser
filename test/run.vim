

let s:vimlparser = vimlparser#import()

let s:sdir = expand('<sfile>:p:h')

function! s:run()
  for vimfile in glob(s:sdir . '/test*.vim', 0, 1)
    let okfile = fnamemodify(vimfile, ':r') . '.ok'
    let outfile = fnamemodify(vimfile, ':r') . '.out'
    let src = readfile(vimfile)
    let r = s:vimlparser.StringReader.new(src)
    let p = s:vimlparser.VimLParser.new()
    let c = s:vimlparser.Compiler.new()
    try
      let out = c.compile(p.parse(r))
      call writefile(out, outfile)
    catch
      call writefile([v:exception], outfile)
    endtry
    if system(printf('diff %s %s', shellescape(okfile), shellescape(outfile))) == 0
      echo printf('%s => ok', fnamemodify(vimfile, ':t'))
    else
      echoerr printf('%s => ng', fnamemodify(vimfile, ':t'))
    endif
  endfor
endfunction

call s:run()
