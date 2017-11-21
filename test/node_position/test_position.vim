let s:vimlparser = vimlparser#import()

function! s:run()
  let src = [
  \  '',
  \  'function! F()',
  \  '  let x =',
  \  '\ 1',
  \  '',
  \  '  let x = "',
  \  '  \1',
  \  '	\2 <- tab',
  \  '  \3 マルチバイト',
  \  '  \4"',
  \  'endfunction',
  \  '',
  \  '" END',
  \]
  let r = s:vimlparser.StringReader.new(src)
  let p = s:vimlparser.VimLParser.new(0)
  let c = s:vimlparser.Compiler.new()
  let toplevel = p.parse(r)
  let func = toplevel.body[0]
  let body = s:extract_body(func, src)
  call writefile(split(body, "\n"), 'test/node_position/test_position.out')
  qall!
endfunction

function! s:extract_body(func, src)
  let pos = a:func.pos

  " FIXME calculating endpos is workaround. Ideally, it should have the end
  " position of the node.

  let endpos = a:func.endfunction.pos
  let endfunc = a:func.endfunction.ea
  let cmdlen = endfunc.argpos.offset - endfunc.cmdpos.offset
  let endpos.offset += cmdlen

  return join(a:src, "\n")[pos.offset : endpos.offset]
endfunction

call s:run()
