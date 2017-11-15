let s:vimlparser = vimlparser#import()

function! s:run()
  let src = [
  \  'let foo = ',
  \  '\ 1',
  \]
  let r = s:vimlparser.StringReader.new(src)
  let tokens = []
  while 1
    let c = r.get()
    if c == '<EOF>'
      break
    endif
    call add(tokens, c)
  endwhile
  call writefile(split(json_encode(tokens), "\n"), 'test/test_token.got')
  qall!
endfunction

call s:run()
