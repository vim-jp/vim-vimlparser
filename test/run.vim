

let s:vimlparser = vimlparser#import()

let s:sdir = expand('<sfile>:p:h')

function! s:run()
  let ng = 0
  for vimfile in glob(s:sdir . '/test*.vim', 0, 1)
    let okfile = fnamemodify(vimfile, ':r') . '.ok'
    let outfile = fnamemodify(vimfile, ':r') . '.out'
    let vimokfile = fnamemodify(vimfile, ':r') . '.vimok'
    let vimoutfile = fnamemodify(vimfile, ':r') . '.vimout'
    let skip = filereadable(fnamemodify(vimfile, ':r') . '.skip')
    let src = readfile(vimfile)
    if vimfile =~# 'test_neo'
        let l:neovim = 1
    else
        let l:neovim = 0
    endif
    let p = s:vimlparser.VimLParser.new(l:neovim)
    let c = s:vimlparser.Compiler.new()
    let pr = s:vimlparser.Printer.new()
    try
      let r = s:vimlparser.StringReader.new(src)
      let out = c.compile(p.parse(r))
      call writefile(out, outfile)
    catch
      call writefile([v:exception], outfile)
    endtry
    if system(printf('diff %s %s', shellescape(okfile), shellescape(outfile))) == ""
      let line = printf('%s(compiler) => ok', fnamemodify(vimfile, ':.'))
      call append(line('$'), line)
    else
      if !skip
        let ng += 1
      endif
      let line = printf('%s(compiler) => ' . (skip ? 'skip' : 'ng'), fnamemodify(vimfile, ':.'))
      call append(line('$'), line)
      for line in readfile(outfile)
        call append(line('$'), '    ' . line)
      endfor
    endif
    if vimfile !~# 'err\|neo'
      try
        let r = s:vimlparser.StringReader.new(src)
        let vimout = pr.print(p.parse(r))
        call writefile(vimout, vimoutfile)
      catch
        call writefile([v:exception], vimoutfile)
      endtry
      if system(printf('diff %s %s', shellescape(filereadable(vimokfile) ? vimokfile : vimfile), shellescape(vimoutfile))) == ""
        let line = printf('%s(printer) => ok', fnamemodify(vimfile, ':.'))
        call append(line('$'), line)
      else
        if !skip
          let ng += 1
        endif
        let line = printf('%s(printer) => ' . (skip ? 'skip' : 'ng'), fnamemodify(vimfile, ':.'))
        call append(line('$'), line)
        for line in readfile(vimoutfile)
          call append(line('$'), '    ' . line)
        endfor
      endif
    endif
  endfor
  if $CI == 'true'
    call writefile(getline(1, '$'), 'test.log')
    if ng == 0
      quit!
    endif
    cquit!
  endif
  syntax enable
  match Error /^.* => ng$/
endfunction

call s:run()
