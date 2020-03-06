" create builtin function table

" TODO more loose pattern?
function! s:get_parse_lines(lines) abort
  let from = match(a:lines, '\vstatic\s+funcentry_T\s+global_functions\[]\s+\=')
  if from ==# -1
    throw 'cannot parse functions'
  endif
  " find next '{'
  let from = index(a:lines, '{', from + 1)
  let to = index(a:lines, '};', from + 1)
  return a:lines[from + 1 : to - 1]
endfunction

function! s:parse(evalfunc_c) abort
  let lines = readfile(a:evalfunc_c)

  " { 'name': string, 'min_argc': integer, 'max_argc': integer }
  let funcs = []

  " TODO: f_retfunc, f_func (currently vim9script is unstable)
  for line in s:get_parse_lines(lines)
    let m = matchlist(line, '\v\{\s*"(\w+)"\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\w+)')
    if !empty(m)
      let [name, min_argc, max_argc, argtype] = m[1:4]
      call add(funcs, {
      \   'name': name,
      \   'min_argc': min_argc + 0,
      \   'max_argc': max_argc + 0,
      \   'argtype': argtype,
      \})
    endif
  endfor
  return funcs
endfunction

function! s:diff(existing, latest) abort
  let existing_names = {}
  for func in a:existing
    let existing_names[func.name] = v:true
  endfor
  return filter(copy(a:latest), {_, f -> !has_key(existing_names, f.name)})
endfunction

function! s:gen_viml(new_funcs) abort
  let lines = []
  for f in a:new_funcs
    " output items in this key order
    let lines = add(lines,
    \ printf('      \ {''name'': %s, ''min_argc'': %s, ''max_argc'': %s, ''argtype'': %s},',
    \       string(f.name), string(f.min_argc), string(f.max_argc), string(f.argtype)))
  endfor
  return join(lines, "\n")
endfunction

" -- main

" evalfunc_c: path to vim/src/evalfunc.c
function! VimLParserNewFuncs(evalfunc_c) abort
  try
    let vimlparser = vimlparser#import()
    let latest = s:parse(a:evalfunc_c)
    let new_funcs = s:diff(vimlparser#import().VimLParser.builtin_functions, latest)
    let generated_text = s:gen_viml(new_funcs)
    if generated_text ==# ''
      verbose echo 's:VimLParser.builtin_functions in autoload/vimlparser.vim is up-to-date.'
    else
      verbose echo "Append following lines to s:VimLParser.builtin_functions in autoload/vimlparser.vim\n"
      verbose echo generated_text
    endif
  catch
    " :echoerr doesn't show output
    verbose echo '[ERROR]' v:exception 'at' v:throwpoint
  endtry
endfunction
