" create builtin command table
let s:Trie = {
\   'data': {},
\ }

function! s:Trie.new() abort
  return deepcopy(self)
endfunction

function! s:Trie.add(s) abort
  let d = self.data
  for c in split(a:s, '\zs')
    if !has_key(d, c)
      let d[c] = {}
    endif
    let d = d[c]
  endfor
endfunction

function! s:Trie.in(s) abort
  let d = self.data
  for c in split(a:s, '\zs')
    if has_key(d, c)
      let d = d[c]
    else
      return v:false
    endif
  endfor
  return v:true
endfunction

function! s:Trie.common(s) abort
  let d = self.data
  let common = []
  for c in split(a:s, '\zs')
    if has_key(d, c)
      let common = add(common, c)
      let d = d[c]
    else
      break
    endif
  endfor
  return join(common, '')
endfunction

function! s:Trie.remove(s) abort
  let d = self.data
  let kss = [[]]
  for c in split(a:s, '\zs')
    if has_key(d, c)
      let kss = add(kss, copy(kss[-1]) + [c])
      let d = d[c]
    else
      return v:false
    endif
  endfor
  let kss = kss[1:]
  let kss = reverse(kss)
  for ks in kss
    let d = self.data
    for [i, k] in map(copy(ks[:-2]), {i, k->[i,k]})
      let pd = d
      let nk = ks[i+1]
      let d = d[k]
    endfor
    if empty(pd[k][nk])
      unlet pd[k][nk]
    else
      return v:true
    endif
  endfor
  return v:true
endfunction

function! s:parse(ex_cmds_h) abort
  let lines = readfile(a:ex_cmds_h)

  " { 'name': string, 'flags': string, 'minlen': int, 'parser': string}
  let cmds = []

  let trie = s:Trie.new()

  let cumname = ''
  for [i, line] in map(copy(lines), {i, l -> [i, l]})
    if line =~# '^EXCMD('
      let name = matchstr(line, '"\zs.*\ze",')
      let flags = matchstr(lines[i+1], '\t\+\zs.*\ze,$')
      let flags = substitute(flags, '\<EX_', '', 'g')
      " for :vim9script
      let flags = flags ==# '0' ? '' : flags

      let minlen = len(trie.common(name)) + 1
      call trie.add(name)

      let cmd = {
      \   'name': name,
      \   'flags': flags,
      \   'minlen': minlen,
      \ }
      call add(cmds, cmd)
    endif
  endfor
  return cmds
endfunction

function! s:diff(existing, latest) abort
  let existing_names = {}
  for cmd in a:existing
    let existing_names[cmd.name] = v:true
  endfor
  let newcmds = []
  for cmd in filter(copy(a:latest), {_, c -> !has_key(existing_names, c.name)})
    let newcmds = add(newcmds, cmd)
  endfor
  return newcmds
endfunction

function! s:gen_viml(newcmds) abort
  let lines = []
  for c in a:newcmds
    let lines = add(lines, '      \ ' . string(c) . ',')
  endfor
  return join(lines, "\n")
endfunction

" -- main

" ex_cmds_h: path to vim/src/ex_cmds.h
function! VimLParserNewCmds(ex_cmds_h) abort
  let vimlparser = vimlparser#import()
  let latest = s:parse(a:ex_cmds_h)
  let new_cmds = s:diff(vimlparser#import().VimLParser.builtin_commands, latest)
  call map(new_cmds, {_,cmd -> extend(cmd, {'parser': 'parse_cmd_common'})})
  let generated_text = s:gen_viml(new_cmds)
  if generated_text ==# ''
    verbose echo 's:VimLParser.builtin_commands in autoload/vimlparser.vim is up-to-date.'
  else
    verbose echo "Append following lines to s:VimLParser.builtin_commands in autoload/vimlparser.vim\n"
    verbose echo generated_text
  endif
endfunction
