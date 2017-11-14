let s:vimlparser = vimlparser#import()

function! s:run()
  let src = [
  \  'function! s:load_on()',
  \  '  imap <expr> <Tab> neosnippet#expandable_or_jumpable() ?',
  \  '\ "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"',
  \  'endfunction',
  \]
  let r = s:vimlparser.StringReader.new(src)
  let p = s:vimlparser.VimLParser.new(0)
  let c = s:vimlparser.Compiler.new()
  let toplevel = p.parse(r)
  let func = toplevel.body[0]
  let body = s:extract_body(func, src)
  call writefile(split(body, "\n"), 'test/test_source.got')
  qall!
endfunction

function! s:extract_body(func, src)
  let pos = a:func.pos

  let endpos = a:func.endfunction.pos
  let endfunc = a:func.endfunction.ea
  let cmdlen = endfunc.argpos.i - endfunc.cmdpos.i
  let endpos.i += cmdlen

  return join(map(split(join(a:src, "\n"), '\zs'), 'v:val[pos.i : endpos.i]'), '')
endfunction

call s:run()
