let s:vimlparser = vimlparser#import()

let s:sdir = expand('<sfile>:p:h')

function! s:run()
  enew
  set buftype=nofile
  let ng = 0
  for vimfile in glob(s:sdir . '/test*.vim', 0, 1)
    let okfile = fnamemodify(vimfile, ':r') . '.ok'
    let outfile = fnamemodify(vimfile, ':r') . '.out'
    let skip = filereadable(fnamemodify(vimfile, ':r') . '.skip')
    let src = readfile(vimfile)
    let r = s:vimlparser.StringReader.new(src)
    if vimfile =~# 'test_neo'
        let l:neovim = 1
    else
        let l:neovim = 0
    endif
    let p = s:vimlparser.VimLParser.new(l:neovim)
    let c = s:vimlparser.Compiler.new()
    try
      let out = c.compile(p.parse(r))
      call writefile(out, outfile)
    catch
      call writefile([v:exception], outfile)
    endtry
    let diff = system(printf('diff -u %s %s', shellescape(okfile), shellescape(outfile)))
    if empty(diff)
      let line = printf('%s => ok', fnamemodify(vimfile, ':.'))
      call append(line('$'), line)
    else
      if !skip
        let ng += 1
      endif
      let line = printf('%s => ' . (skip ? 'skip' : 'ng'), fnamemodify(vimfile, ':.'))
      call append(line('$'), line)
      for line in split(diff, '\n')
        call append(line('$'), '    ' . line)
      endfor
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
