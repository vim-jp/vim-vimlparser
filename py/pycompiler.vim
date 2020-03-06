
call extend(s:, vimlparser#import())

" Ignore undefined variable errors of vint
" vint: -ProhibitUsingUndeclaredVariable
let s:StringReader = s:StringReader
let s:VimLParser = s:VimLParser
let s:ExprParser = s:ExprParser
let s:NIL = s:NIL
" vint: +ProhibitUsingUndeclaredVariable

let s:opprec = {}
" vint: -ProhibitUsingUndeclaredVariable
let s:opprec[s:NODE_TERNARY] = 1
let s:opprec[s:NODE_OR] = 2
let s:opprec[s:NODE_AND] = 3
let s:opprec[s:NODE_EQUAL] = 4
let s:opprec[s:NODE_EQUALCI] = 4
let s:opprec[s:NODE_EQUALCS] = 4
let s:opprec[s:NODE_NEQUAL] = 4
let s:opprec[s:NODE_NEQUALCI] = 4
let s:opprec[s:NODE_NEQUALCS] = 4
let s:opprec[s:NODE_GREATER] = 4
let s:opprec[s:NODE_GREATERCI] = 4
let s:opprec[s:NODE_GREATERCS] = 4
let s:opprec[s:NODE_GEQUAL] = 4
let s:opprec[s:NODE_GEQUALCI] = 4
let s:opprec[s:NODE_GEQUALCS] = 4
let s:opprec[s:NODE_SMALLER] = 4
let s:opprec[s:NODE_SMALLERCI] = 4
let s:opprec[s:NODE_SMALLERCS] = 4
let s:opprec[s:NODE_SEQUAL] = 4
let s:opprec[s:NODE_SEQUALCI] = 4
let s:opprec[s:NODE_SEQUALCS] = 4
let s:opprec[s:NODE_MATCH] = 4
let s:opprec[s:NODE_MATCHCI] = 4
let s:opprec[s:NODE_MATCHCS] = 4
let s:opprec[s:NODE_NOMATCH] = 4
let s:opprec[s:NODE_NOMATCHCI] = 4
let s:opprec[s:NODE_NOMATCHCS] = 4
let s:opprec[s:NODE_IS] = 4
let s:opprec[s:NODE_ISCI] = 4
let s:opprec[s:NODE_ISCS] = 4
let s:opprec[s:NODE_ISNOT] = 4
let s:opprec[s:NODE_ISNOTCI] = 4
let s:opprec[s:NODE_ISNOTCS] = 4
let s:opprec[s:NODE_ADD] = 5
let s:opprec[s:NODE_SUBTRACT] = 5
let s:opprec[s:NODE_CONCAT] = 5
let s:opprec[s:NODE_MULTIPLY] = 6
let s:opprec[s:NODE_DIVIDE] = 6
let s:opprec[s:NODE_REMAINDER] = 6
let s:opprec[s:NODE_NOT] = 7
let s:opprec[s:NODE_MINUS] = 7
let s:opprec[s:NODE_PLUS] = 7
let s:opprec[s:NODE_SUBSCRIPT] = 8
let s:opprec[s:NODE_SLICE] = 8
let s:opprec[s:NODE_CALL] = 8
let s:opprec[s:NODE_DOT] = 8
let s:opprec[s:NODE_NUMBER] = 9
let s:opprec[s:NODE_BLOB] = 9
let s:opprec[s:NODE_STRING] = 9
let s:opprec[s:NODE_LIST] = 9
let s:opprec[s:NODE_DICT] = 9
let s:opprec[s:NODE_OPTION] = 9
let s:opprec[s:NODE_IDENTIFIER] = 9
let s:opprec[s:NODE_CURLYNAME] = 9
let s:opprec[s:NODE_ENV] = 9
let s:opprec[s:NODE_REG] = 9
" vint: +ProhibitUsingUndeclaredVariable

" Reserved Python keywords (dict for faster lookup).
let s:reserved_keywords = {
      \ 'False': 1,
      \ 'None': 1,
      \ 'True': 1,
      \ 'and': 1,
      \ 'as': 1,
      \ 'assert': 1,
      \ 'break': 1,
      \ 'class': 1,
      \ 'continue': 1,
      \ 'def': 1,
      \ 'del': 1,
      \ 'elif': 1,
      \ 'else': 1,
      \ 'except': 1,
      \ 'finally': 1,
      \ 'for': 1,
      \ 'from': 1,
      \ 'global': 1,
      \ 'if': 1,
      \ 'import': 1,
      \ 'in': 1,
      \ 'is': 1,
      \ 'lambda': 1,
      \ 'nonlocal': 1,
      \ 'not': 1,
      \ 'or': 1,
      \ 'pass': 1,
      \ 'raise': 1,
      \ 'return': 1,
      \ 'try': 1,
      \ 'while': 1,
      \ 'with': 1,
      \ 'yield': 1}

let s:PythonCompiler = {}

function s:PythonCompiler.new(...)
  let obj = copy(self)
  call call(obj.__init__, a:000, obj)
  return obj
endfunction

function s:PythonCompiler.__init__()
  let self.indent = ['']
  let self.lines = []
  let self.in_class = 0
endfunction

function s:PythonCompiler.out(...)
  if len(a:000) ==# 1
    if a:000[0] =~# '^)\+$'
      let self.lines[-1] .= a:000[0]
    else
      call add(self.lines, self.indent[0] . a:000[0])
    endif
  else
    call add(self.lines, self.indent[0] . call('printf', a:000))
  endif
endfunction

function s:PythonCompiler.emptyline()
  call add(self.lines, '')
endfunction

function s:PythonCompiler.incindent(s)
  call insert(self.indent, self.indent[0] . a:s)
endfunction

function s:PythonCompiler.decindent()
  call remove(self.indent, 0)
endfunction

" vint: -ProhibitUsingUndeclaredVariable
function s:PythonCompiler.compile(node)
  if a:node.type ==# s:NODE_TOPLEVEL
    return self.compile_toplevel(a:node)
  elseif a:node.type ==# s:NODE_COMMENT
    return self.compile_comment(a:node)
  elseif a:node.type ==# s:NODE_EXCMD
    return self.compile_excmd(a:node)
  elseif a:node.type ==# s:NODE_FUNCTION
    return self.compile_function(a:node)
  elseif a:node.type ==# s:NODE_DELFUNCTION
    return self.compile_delfunction(a:node)
  elseif a:node.type ==# s:NODE_RETURN
    return self.compile_return(a:node)
  elseif a:node.type ==# s:NODE_EXCALL
    return self.compile_excall(a:node)
  elseif a:node.type ==# s:NODE_LET
    return self.compile_let(a:node)
  elseif a:node.type ==# s:NODE_UNLET
    return self.compile_unlet(a:node)
  elseif a:node.type ==# s:NODE_LOCKVAR
    return self.compile_lockvar(a:node)
  elseif a:node.type ==# s:NODE_UNLOCKVAR
    return self.compile_unlockvar(a:node)
  elseif a:node.type ==# s:NODE_IF
    return self.compile_if(a:node)
  elseif a:node.type ==# s:NODE_WHILE
    return self.compile_while(a:node)
  elseif a:node.type ==# s:NODE_FOR
    return self.compile_for(a:node)
  elseif a:node.type ==# s:NODE_CONTINUE
    return self.compile_continue(a:node)
  elseif a:node.type ==# s:NODE_BREAK
    return self.compile_break(a:node)
  elseif a:node.type ==# s:NODE_TRY
    return self.compile_try(a:node)
  elseif a:node.type ==# s:NODE_THROW
    return self.compile_throw(a:node)
  elseif a:node.type ==# s:NODE_ECHO
    return self.compile_echo(a:node)
  elseif a:node.type ==# s:NODE_ECHON
    return self.compile_echon(a:node)
  elseif a:node.type ==# s:NODE_ECHOHL
    return self.compile_echohl(a:node)
  elseif a:node.type ==# s:NODE_ECHOMSG
    return self.compile_echomsg(a:node)
  elseif a:node.type ==# s:NODE_ECHOERR
    return self.compile_echoerr(a:node)
  elseif a:node.type ==# s:NODE_EXECUTE
    return self.compile_execute(a:node)
  elseif a:node.type ==# s:NODE_TERNARY
    return self.compile_ternary(a:node)
  elseif a:node.type ==# s:NODE_OR
    return self.compile_or(a:node)
  elseif a:node.type ==# s:NODE_AND
    return self.compile_and(a:node)
  elseif a:node.type ==# s:NODE_EQUAL
    return self.compile_equal(a:node)
  elseif a:node.type ==# s:NODE_EQUALCI
    return self.compile_equalci(a:node)
  elseif a:node.type ==# s:NODE_EQUALCS
    return self.compile_equalcs(a:node)
  elseif a:node.type ==# s:NODE_NEQUAL
    return self.compile_nequal(a:node)
  elseif a:node.type ==# s:NODE_NEQUALCI
    return self.compile_nequalci(a:node)
  elseif a:node.type ==# s:NODE_NEQUALCS
    return self.compile_nequalcs(a:node)
  elseif a:node.type ==# s:NODE_GREATER
    return self.compile_greater(a:node)
  elseif a:node.type ==# s:NODE_GREATERCI
    return self.compile_greaterci(a:node)
  elseif a:node.type ==# s:NODE_GREATERCS
    return self.compile_greatercs(a:node)
  elseif a:node.type ==# s:NODE_GEQUAL
    return self.compile_gequal(a:node)
  elseif a:node.type ==# s:NODE_GEQUALCI
    return self.compile_gequalci(a:node)
  elseif a:node.type ==# s:NODE_GEQUALCS
    return self.compile_gequalcs(a:node)
  elseif a:node.type ==# s:NODE_SMALLER
    return self.compile_smaller(a:node)
  elseif a:node.type ==# s:NODE_SMALLERCI
    return self.compile_smallerci(a:node)
  elseif a:node.type ==# s:NODE_SMALLERCS
    return self.compile_smallercs(a:node)
  elseif a:node.type ==# s:NODE_SEQUAL
    return self.compile_sequal(a:node)
  elseif a:node.type ==# s:NODE_SEQUALCI
    return self.compile_sequalci(a:node)
  elseif a:node.type ==# s:NODE_SEQUALCS
    return self.compile_sequalcs(a:node)
  elseif a:node.type ==# s:NODE_MATCH
    return self.compile_match(a:node)
  elseif a:node.type ==# s:NODE_MATCHCI
    return self.compile_matchci(a:node)
  elseif a:node.type ==# s:NODE_MATCHCS
    return self.compile_matchcs(a:node)
  elseif a:node.type ==# s:NODE_NOMATCH
    return self.compile_nomatch(a:node)
  elseif a:node.type ==# s:NODE_NOMATCHCI
    return self.compile_nomatchci(a:node)
  elseif a:node.type ==# s:NODE_NOMATCHCS
    return self.compile_nomatchcs(a:node)
  elseif a:node.type ==# s:NODE_IS
    return self.compile_is(a:node)
  elseif a:node.type ==# s:NODE_ISCI
    return self.compile_isci(a:node)
  elseif a:node.type ==# s:NODE_ISCS
    return self.compile_iscs(a:node)
  elseif a:node.type ==# s:NODE_ISNOT
    return self.compile_isnot(a:node)
  elseif a:node.type ==# s:NODE_ISNOTCI
    return self.compile_isnotci(a:node)
  elseif a:node.type ==# s:NODE_ISNOTCS
    return self.compile_isnotcs(a:node)
  elseif a:node.type ==# s:NODE_ADD
    return self.compile_add(a:node)
  elseif a:node.type ==# s:NODE_SUBTRACT
    return self.compile_subtract(a:node)
  elseif a:node.type ==# s:NODE_CONCAT
    return self.compile_concat(a:node)
  elseif a:node.type ==# s:NODE_MULTIPLY
    return self.compile_multiply(a:node)
  elseif a:node.type ==# s:NODE_DIVIDE
    return self.compile_divide(a:node)
  elseif a:node.type ==# s:NODE_REMAINDER
    return self.compile_remainder(a:node)
  elseif a:node.type ==# s:NODE_NOT
    return self.compile_not(a:node)
  elseif a:node.type ==# s:NODE_PLUS
    return self.compile_plus(a:node)
  elseif a:node.type ==# s:NODE_MINUS
    return self.compile_minus(a:node)
  elseif a:node.type ==# s:NODE_SUBSCRIPT
    return self.compile_subscript(a:node)
  elseif a:node.type ==# s:NODE_SLICE
    return self.compile_slice(a:node)
  elseif a:node.type ==# s:NODE_DOT
    return self.compile_dot(a:node)
  elseif a:node.type ==# s:NODE_CALL
    return self.compile_call(a:node)
  elseif a:node.type ==# s:NODE_NUMBER
    return self.compile_number(a:node)
  elseif a:node.type ==# s:NODE_BLOB
    return self.compile_blob(a:node)
  elseif a:node.type ==# s:NODE_STRING
    return self.compile_string(a:node)
  elseif a:node.type ==# s:NODE_LIST
    return self.compile_list(a:node)
  elseif a:node.type ==# s:NODE_DICT
    return self.compile_dict(a:node)
  elseif a:node.type ==# s:NODE_OPTION
    return self.compile_option(a:node)
  elseif a:node.type ==# s:NODE_IDENTIFIER
    return self.compile_identifier(a:node)
  elseif a:node.type ==# s:NODE_CURLYNAME
    return self.compile_curlyname(a:node)
  elseif a:node.type ==# s:NODE_ENV
    return self.compile_env(a:node)
  elseif a:node.type ==# s:NODE_REG
    return self.compile_reg(a:node)
  else
    throw self.err('Compiler: unknown node: %s', string(a:node))
  endif
endfunction
" vint: +ProhibitUsingUndeclaredVariable

function s:PythonCompiler.compile_body(body)
  let empty = 1
  for node in a:body
    call self.compile(node)
    " vint: -ProhibitUsingUndeclaredVariable
    if node.type != s:NODE_COMMENT
    " vint: +ProhibitUsingUndeclaredVariable
      let empty = 0
    endif
  endfor
  if empty
    call self.out('pass')
  endif
endfunction

function s:PythonCompiler.compile_toplevel(node)
  call self.compile_body(a:node.body)
  return self.lines
endfunction

function s:PythonCompiler.compile_comment(node)
  call self.out('#%s', a:node.str)
endfunction

function s:PythonCompiler.compile_excmd(node)
  throw 'NotImplemented: excmd'
endfunction

function s:PythonCompiler.insert_empty_lines_before_comment(count)
  " Find start of preceding comment (block).
  let comment_start = 0
  let len_lines = len(self.lines)
  if len_lines
    while 1
      let line = get(self.lines, comment_start - 1, '')
      if line !~# '^\s*#'
        break
      endif
      let comment_start -= 1
      " Adjust indentation to current level.
      let self.lines[comment_start] = substitute(line, '^\s\+', self.indent[0], '')
    endwhile

    if comment_start != 0
      let comment_start = len_lines + comment_start
    endif
  endif

  if comment_start
    for c in range(a:count)
      call insert(self.lines, '', comment_start)
    endfor
  else
    for c in range(a:count)
      call self.emptyline()
    endfor
  endif
endfunction

function s:PythonCompiler.compile_function(node)
  let left = self.compile(a:node.left)
  let rlist = map(a:node.rlist, 'self.compile(v:val)')
  if !empty(rlist) && rlist[-1] ==# '...'
    let rlist[-1] = '*a000'
  endif

  if left =~# '^\(VimLParser\|ExprTokenizer\|ExprParser\|LvalueParser\|StringReader\|Compiler\|RegexpParser\)\.'
    let left = matchstr(left, '\.\zs.*')
    if left ==# 'new'
      return
    endif
    call self.insert_empty_lines_before_comment(1)
    call insert(rlist, 'self')
    call self.out('def %s(%s):', left, join(rlist, ', '))
    call self.incindent('    ')
    call self.compile_body(a:node.body)
    call self.decindent()
  else
    if self.in_class
      let self.in_class = 0
      call self.decindent()
    endif
    call self.insert_empty_lines_before_comment(2)
    call self.out('def %s(%s):', left, join(rlist, ', '))
    call self.incindent('    ')
    call self.compile_body(a:node.body)
    call self.decindent()
  endif
endfunction

function s:PythonCompiler.compile_delfunction(node)
  throw 'NotImplemented: delfunction'
endfunction

function s:PythonCompiler.compile_return(node)
  if a:node.left is s:NIL
    call self.out('return')
  else
    call self.out('return %s', self.compile(a:node.left))
  endif
endfunction

function s:PythonCompiler.compile_excall(node)
  call self.out('%s', self.compile(a:node.left))
endfunction

function s:PythonCompiler.compile_let(node)
  let op = a:node.op
  if op ==# '.='
    let op = '+='
  endif
  let right = self.compile(a:node.right)
  if a:node.left isnot s:NIL
    let left = self.compile(a:node.left)
    if left ==# 'LvalueParser'
      let class_def = 'LvalueParser(ExprParser)'
    elseif left =~# '^\(VimLParser\|ExprTokenizer\|ExprParser\|LvalueParser\|StringReader\|Compiler\|RegexpParser\)$'
      let class_def = left
    elseif left =~# '^\(VimLParser\|ExprTokenizer\|ExprParser\|LvalueParser\|StringReader\|Compiler\|RegexpParser\)\.'
      let left = matchstr(left, '\.\zs.*')
      call self.out('%s %s %s', left, op, right)
      return
    else
      call self.out('%s %s %s', left, op, right)
      return
    endif

    if self.in_class
      call self.decindent()
    endif
    call self.insert_empty_lines_before_comment(2)
    call self.out('class %s:', class_def)
    let self.in_class = 1
    call self.incindent('    ')
  else
    let list = map(a:node.list, 'self.compile(v:val)')
    if a:node.rest isnot s:NIL
      let rest = self.compile(a:node.rest)
      call add(list, '*' . rest)
    endif
    let left = join(list, ', ')
    call self.out('%s %s %s', left, op, right)
  endif
endfunction

function s:PythonCompiler.compile_unlet(node)
  let list = map(a:node.list, 'self.compile(v:val)')
  call self.out('del %s', join(list, ', '))
endfunction

function s:PythonCompiler.compile_lockvar(node)
  throw 'NotImplemented: lockvar'
endfunction

function s:PythonCompiler.compile_unlockvar(node)
  throw 'NotImplemented: unlockvar'
endfunction

function s:PythonCompiler.compile_if(node)
  call self.out('if %s:', self.compile(a:node.cond))
  call self.incindent('    ')
  call self.compile_body(a:node.body)
  call self.decindent()
  for node in a:node.elseif
    call self.out('elif %s:', self.compile(node.cond))
    call self.incindent('    ')
    call self.compile_body(node.body)
    call self.decindent()
  endfor
  if a:node.else isnot s:NIL
    call self.out('else:')
    call self.incindent('    ')
    call self.compile_body(a:node.else.body)
    call self.decindent()
  endif
endfunction

function s:PythonCompiler.compile_while(node)
  call self.out('while %s:', self.compile(a:node.cond))
  call self.incindent('    ')
  call self.compile_body(a:node.body)
  call self.decindent()
endfunction

function s:PythonCompiler.compile_for(node)
  if a:node.left isnot s:NIL
    let left = self.compile(a:node.left)
  else
    let list = map(a:node.list, 'self.compile(v:val)')
    if a:node.rest isnot s:NIL
      let rest = self.compile(a:node.rest)
      call add(list, '*' . rest)
    endif
    let left = join(list, ', ')
  endif
  let right = self.compile(a:node.right)
  call self.out('for %s in %s:', left, right)
  call self.incindent('    ')
  call self.compile_body(a:node.body)
  call self.decindent()
endfunction

function s:PythonCompiler.compile_continue(node)
  call self.out('continue')
endfunction

function s:PythonCompiler.compile_break(node)
  call self.out('break')
endfunction

function s:PythonCompiler.compile_try(node)
  call self.out('try:')
  call self.incindent('    ')
  call self.compile_body(a:node.body)
  call self.decindent()
  for node in a:node.catch
    if node.pattern isnot s:NIL
      call self.out('except:')
      call self.incindent('    ')
      call self.compile_body(node.body)
      call self.decindent()
    else
      call self.out('except:')
      call self.incindent('    ')
      call self.compile_body(node.body)
      call self.decindent()
    endif
  endfor
  if a:node.finally isnot s:NIL
    call self.out('finally:')
    call self.incindent('    ')
    call self.compile_body(a:node.finally.body)
    call self.decindent()
  endif
endfunction

function s:PythonCompiler.compile_throw(node)
  call self.out('raise VimLParserException(%s)', self.compile(a:node.left))
endfunction

function s:PythonCompiler.compile_echo(node)
  let list = map(a:node.list, 'self.compile(v:val)')
  call self.out('print(%s)', join(list, ', '))
endfunction

function s:PythonCompiler.compile_echon(node)
  let list = map(a:node.list, 'self.compile(v:val)')
  call self.out('print(%s)', join(list, ', '))
endfunction

function s:PythonCompiler.compile_echohl(node)
  throw 'NotImplemented: echohl'
endfunction

function s:PythonCompiler.compile_echomsg(node)
  let list = map(a:node.list, 'self.compile(v:val)')
  call self.out('print(%s)', join(list, ', '))
endfunction

function s:PythonCompiler.compile_echoerr(node)
  let list = map(a:node.list, 'self.compile(v:val)')
  call self.out('raise VimLParserException([%s]))', join(list, ', '))
endfunction

function s:PythonCompiler.compile_execute(node)
  throw 'NotImplemented: execute'
endfunction

function s:PythonCompiler.compile_ternary(node)
  let cond = self.compile(a:node.cond)
  if s:opprec[a:node.type] >= s:opprec[a:node.cond.type]
    let cond = '(' . cond . ')'
  endif
  let left = self.compile(a:node.left)
  if s:opprec[a:node.type] >= s:opprec[a:node.left.type]
    let left = '(' . left . ')'
  endif
  let right = self.compile(a:node.right)
  return printf('%s if %s else %s', left, cond, right)
endfunction

function s:PythonCompiler.compile_or(node)
  return self.compile_op2(a:node, 'or')
endfunction

function s:PythonCompiler.compile_and(node)
  return self.compile_op2(a:node, 'and')
endfunction

function s:PythonCompiler.compile_equal(node)
  return self.compile_op2(a:node, '==')
endfunction

function s:PythonCompiler.compile_equalci(node)
  return printf('viml_equalci(%s, %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function s:PythonCompiler.compile_equalcs(node)
  return self.compile_op2(a:node, '==')
endfunction

function s:PythonCompiler.compile_nequal(node)
  return self.compile_op2(a:node, '!=')
endfunction

function s:PythonCompiler.compile_nequalci(node)
  return printf('not viml_equalci(%s, %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function s:PythonCompiler.compile_nequalcs(node)
  return self.compile_op2(a:node, '!=')
endfunction

function s:PythonCompiler.compile_greater(node)
  return self.compile_op2(a:node, '>')
endfunction

function s:PythonCompiler.compile_greaterci(node)
  throw 'NotImplemented: >?'
endfunction

function s:PythonCompiler.compile_greatercs(node)
  throw 'NotImplemented: >#'
endfunction

function s:PythonCompiler.compile_gequal(node)
  return self.compile_op2(a:node, '>=')
endfunction

function s:PythonCompiler.compile_gequalci(node)
  throw 'NotImplemented: >=?'
endfunction

function s:PythonCompiler.compile_gequalcs(node)
  throw 'NotImplemented: >=#'
endfunction

function s:PythonCompiler.compile_smaller(node)
  return self.compile_op2(a:node, '<')
endfunction

function s:PythonCompiler.compile_smallerci(node)
  throw 'NotImplemented: <?'
endfunction

function s:PythonCompiler.compile_smallercs(node)
  throw 'NotImplemented: <#'
endfunction

function s:PythonCompiler.compile_sequal(node)
  return self.compile_op2(a:node, '<=')
endfunction

function s:PythonCompiler.compile_sequalci(node)
  throw 'NotImplemented: <=?'
endfunction

function s:PythonCompiler.compile_sequalcs(node)
  throw 'NotImplemented: <=#'
endfunction

function s:PythonCompiler.compile_match(node)
  return printf('viml_eqreg(%s, %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function s:PythonCompiler.compile_matchci(node)
  return printf('viml_eqregq(%s, %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function s:PythonCompiler.compile_matchcs(node)
  return printf('viml_eqregh(%s, %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function s:PythonCompiler.compile_nomatch(node)
  return printf('not viml_eqreg(%s, %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function s:PythonCompiler.compile_nomatchci(node)
  return printf('not viml_eqregq(%s, %s, flags=re.IGNORECASE)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function s:PythonCompiler.compile_nomatchcs(node)
  return printf('not viml_eqregh(%s, %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function s:PythonCompiler.compile_is(node)
  return self.compile_op2(a:node, 'is')
endfunction

function s:PythonCompiler.compile_isci(node)
  throw 'NotImplemented: is?'
endfunction

function s:PythonCompiler.compile_iscs(node)
  return self.compile_op2(a:node, 'is')
endfunction

function s:PythonCompiler.compile_isnot(node)
  return self.compile_op2(a:node, 'is not')
endfunction

function s:PythonCompiler.compile_isnotci(node)
  throw 'NotImplemented: isnot?'
endfunction

function s:PythonCompiler.compile_isnotcs(node)
  return self.compile_op2(a:node, 'is not')
endfunction

function s:PythonCompiler.compile_add(node)
  return self.compile_op2(a:node, '+')
endfunction

function s:PythonCompiler.compile_subtract(node)
  return self.compile_op2(a:node, '-')
endfunction

function s:PythonCompiler.compile_concat(node)
  return self.compile_op2(a:node, '+')
endfunction

function s:PythonCompiler.compile_multiply(node)
  return self.compile_op2(a:node, '*')
endfunction

function s:PythonCompiler.compile_divide(node)
  return self.compile_op2(a:node, '/')
endfunction

function s:PythonCompiler.compile_remainder(node)
  return self.compile_op2(a:node, '%')
endfunction

function s:PythonCompiler.compile_not(node)
  return self.compile_op1(a:node, 'not ')
endfunction

function s:PythonCompiler.compile_plus(node)
  return self.compile_op1(a:node, '+')
endfunction

function s:PythonCompiler.compile_minus(node)
  return self.compile_op1(a:node, '-')
endfunction

function s:PythonCompiler.compile_subscript(node)
  let left = self.compile(a:node.left)
  let right = self.compile(a:node.right)
  if left ==# 'self'
    return printf('getattr(%s, %s)', left, right)
  else
    return printf('%s[%s]', left, right)
  endif
endfunction

function s:PythonCompiler.compile_slice(node)
  throw 'NotImplemented: slice'
endfunction

function s:PythonCompiler.compile_dot(node)
  let left = self.compile(a:node.left)
  let right = self.compile(a:node.right)
  return printf('%s.%s', left, right)
endfunction

function s:PythonCompiler.compile_call(node)
  let rlist = map(a:node.rlist, 'self.compile(v:val)')
  let left = self.compile(a:node.left)
  if left ==# 'map'
    let r = s:StringReader.new([eval(rlist[1])])
    let p = s:ExprParser.new(r)
    let n = p.parse()
    return printf('[%s for vval in %s]', self.compile(n), rlist[0])
  elseif left ==# 'call' && rlist[0][0] =~# '[''"]'
    return printf('viml_%s(*%s)', rlist[0][1:-2], rlist[1])
  endif
  if left =~# '\.new$'
    let left = matchstr(left, '.*\ze\.new$')
  endif
  if index(s:viml_builtin_functions, left) != -1
    let left = printf('viml_%s', left)
  endif
  return printf('%s(%s)', left, join(rlist, ', '))
endfunction

function s:PythonCompiler.compile_number(node)
  return a:node.value
endfunction

function s:PythonCompiler.compile_string(node)
  if a:node.value[0] ==# "'"
    let s = substitute(a:node.value[1:-2], "''", "'", 'g')
    return '"' . escape(s, '\"') . '"'
  else
    return a:node.value
  endif
endfunction

function s:PythonCompiler.compile_list(node)
  let value = map(a:node.value, 'self.compile(v:val)')
  if empty(value)
    return '[]'
  else
    return printf('[%s]', join(value, ', '))
  endif
endfunction

function s:PythonCompiler.compile_dict(node)
  let value = map(a:node.value, 'self.compile(v:val[0]) . ": " . self.compile(v:val[1])')
  if empty(value)
    return 'AttributeDict({})'
  else
    return printf('AttributeDict({%s})', join(value, ', '))
  endif
endfunction

function s:PythonCompiler.compile_option(node)
  throw 'NotImplemented: option'
endfunction

function s:PythonCompiler.compile_identifier(node)
  let name = a:node.value
  if name ==# 'a:000'
    let name = 'a000'
  elseif name ==# 'v:val'
    let name = 'vval'
  elseif name =~# '^[sa]:'
    let name = name[2:]
  endif
  if has_key(s:reserved_keywords, name)
    let name .= '_'
  endif
  return name
endfunction

function s:PythonCompiler.compile_curlyname(node)
  throw 'NotImplemented: curlyname'
endfunction

function s:PythonCompiler.compile_env(node)
  throw 'NotImplemented: env'
endfunction

function s:PythonCompiler.compile_reg(node)
  throw 'NotImplemented: reg'
endfunction

function s:PythonCompiler.compile_op1(node, op)
  let left = self.compile(a:node.left)
  if s:opprec[a:node.type] > s:opprec[a:node.left.type]
    let left = '(' . left . ')'
  endif
  return printf('%s%s', a:op, left)
endfunction

function s:PythonCompiler.compile_op2(node, op)
  let left = self.compile(a:node.left)
  if s:opprec[a:node.type] > s:opprec[a:node.left.type]
    let left = '(' . left . ')'
  endif
  let right = self.compile(a:node.right)
  if s:opprec[a:node.type] > s:opprec[a:node.right.type]
    let right = '(' . right . ')'
  endif
  return printf('%s %s %s', left, a:op, right)
endfunction


let s:viml_builtin_functions = map(copy(s:VimLParser.builtin_functions), 'v:val.name')

let s:script_dir = expand('<sfile>:h')
function! s:convert(in, out)
  let vimlfunc = fnamemodify(s:script_dir . '/vimlfunc.py', ':p')
  let head = readfile(vimlfunc) + ['', '']
  try
    let r = s:StringReader.new(readfile(a:in))
    let p = s:VimLParser.new()
    let c = s:PythonCompiler.new()
    let lines = c.compile(p.parse(r))
    unlet lines[0 : index(lines, 'NIL = []') - 1]
    let tail = [
    \   '',
    \   '',
    \   'if __name__ == ''__main__'':',
    \   '    main()',
    \ ]
    call writefile(head + lines + tail, a:out)
  catch
    echoerr substitute(v:throwpoint, '\.\.\zs\d\+', '\=s:numtoname(submatch(0))', 'g') . "\n" . v:exception
  endtry
endfunction

function! s:numtoname(num)
  let sig = printf("function('%s')", a:num)
  for k in keys(s:)
    if type(s:[k]) ==# type({})
      for name in keys(s:[k])
        if type(s:[k][name]) ==# type(function('tr')) && string(s:[k][name]) ==# sig
          return printf('%s.%s', k, name)
        endif
      endfor
    endif
  endfor
  return a:num
endfunction

function! s:parse_args() abort
  let v = [
  \  fnamemodify(s:script_dir . '/../autoload/vimlparser.vim', ':p'),
  \  fnamemodify(s:script_dir . '/vimlparser.py', ':p')
  \]
  let args = argv()[1:]
  %argdel
  if len(args) != 0
    if len(args) != 2
      throw 'invalid argument: ' . string(args)
    endif
	let v = args
  endif
  return v
endfunction:

function! s:main() abort
  try
    let args = s:parse_args()
    call s:convert(args[0], args[1])
  catch
    call writefile([v:exception], has('win32') ? 'conout$' : '/dev/stderr')
    cquit
  endtry
endfunction

call s:main()
