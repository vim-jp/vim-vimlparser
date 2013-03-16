
call extend(s:, vimlparser#import())


let s:PythonCompiler = {}

function s:PythonCompiler.new(...)
  let obj = copy(self)
  call call(obj.__init__, a:000, obj)
  return obj
endfunction

function s:PythonCompiler.__init__()
  let self.indent = ['']
  let self.lines = []
endfunction

function s:PythonCompiler.out(...)
  if len(a:000) == 1
    if a:000[0] =~ '^)\+$'
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

function s:PythonCompiler.compile(node)
  if a:node.type == s:NODE_TOPLEVEL
    return self.compile_toplevel(a:node)
  elseif a:node.type == s:NODE_COMMENT
    return self.compile_comment(a:node)
  elseif a:node.type == s:NODE_EXCMD
    return self.compile_excmd(a:node)
  elseif a:node.type == s:NODE_FUNCTION
    return self.compile_function(a:node)
  elseif a:node.type == s:NODE_DELFUNCTION
    return self.compile_delfunction(a:node)
  elseif a:node.type == s:NODE_RETURN
    return self.compile_return(a:node)
  elseif a:node.type == s:NODE_EXCALL
    return self.compile_excall(a:node)
  elseif a:node.type == s:NODE_LET
    return self.compile_let(a:node)
  elseif a:node.type == s:NODE_UNLET
    return self.compile_unlet(a:node)
  elseif a:node.type == s:NODE_LOCKVAR
    return self.compile_lockvar(a:node)
  elseif a:node.type == s:NODE_UNLOCKVAR
    return self.compile_unlockvar(a:node)
  elseif a:node.type == s:NODE_IF
    return self.compile_if(a:node)
  elseif a:node.type == s:NODE_WHILE
    return self.compile_while(a:node)
  elseif a:node.type == s:NODE_FOR
    return self.compile_for(a:node)
  elseif a:node.type == s:NODE_CONTINUE
    return self.compile_continue(a:node)
  elseif a:node.type == s:NODE_BREAK
    return self.compile_break(a:node)
  elseif a:node.type == s:NODE_TRY
    return self.compile_try(a:node)
  elseif a:node.type == s:NODE_THROW
    return self.compile_throw(a:node)
  elseif a:node.type == s:NODE_ECHO
    return self.compile_echo(a:node)
  elseif a:node.type == s:NODE_ECHON
    return self.compile_echon(a:node)
  elseif a:node.type == s:NODE_ECHOHL
    return self.compile_echohl(a:node)
  elseif a:node.type == s:NODE_ECHOMSG
    return self.compile_echomsg(a:node)
  elseif a:node.type == s:NODE_ECHOERR
    return self.compile_echoerr(a:node)
  elseif a:node.type == s:NODE_EXECUTE
    return self.compile_execute(a:node)
  elseif a:node.type == s:NODE_TERNARY
    return self.compile_ternary(a:node)
  elseif a:node.type == s:NODE_OR
    return self.compile_or(a:node)
  elseif a:node.type == s:NODE_AND
    return self.compile_and(a:node)
  elseif a:node.type == s:NODE_EQUAL
    return self.compile_equal(a:node)
  elseif a:node.type == s:NODE_EQUALCI
    return self.compile_equalci(a:node)
  elseif a:node.type == s:NODE_EQUALCS
    return self.compile_equalcs(a:node)
  elseif a:node.type == s:NODE_NEQUAL
    return self.compile_nequal(a:node)
  elseif a:node.type == s:NODE_NEQUALCI
    return self.compile_nequalci(a:node)
  elseif a:node.type == s:NODE_NEQUALCS
    return self.compile_nequalcs(a:node)
  elseif a:node.type == s:NODE_GREATER
    return self.compile_greater(a:node)
  elseif a:node.type == s:NODE_GREATERCI
    return self.compile_greaterci(a:node)
  elseif a:node.type == s:NODE_GREATERCS
    return self.compile_greatercs(a:node)
  elseif a:node.type == s:NODE_GEQUAL
    return self.compile_gequal(a:node)
  elseif a:node.type == s:NODE_GEQUALCI
    return self.compile_gequalci(a:node)
  elseif a:node.type == s:NODE_GEQUALCS
    return self.compile_gequalcs(a:node)
  elseif a:node.type == s:NODE_SMALLER
    return self.compile_smaller(a:node)
  elseif a:node.type == s:NODE_SMALLERCI
    return self.compile_smallerci(a:node)
  elseif a:node.type == s:NODE_SMALLERCS
    return self.compile_smallercs(a:node)
  elseif a:node.type == s:NODE_SEQUAL
    return self.compile_sequal(a:node)
  elseif a:node.type == s:NODE_SEQUALCI
    return self.compile_sequalci(a:node)
  elseif a:node.type == s:NODE_SEQUALCS
    return self.compile_sequalcs(a:node)
  elseif a:node.type == s:NODE_MATCH
    return self.compile_match(a:node)
  elseif a:node.type == s:NODE_MATCHCI
    return self.compile_matchci(a:node)
  elseif a:node.type == s:NODE_MATCHCS
    return self.compile_matchcs(a:node)
  elseif a:node.type == s:NODE_NOMATCH
    return self.compile_nomatch(a:node)
  elseif a:node.type == s:NODE_NOMATCHCI
    return self.compile_nomatchci(a:node)
  elseif a:node.type == s:NODE_NOMATCHCS
    return self.compile_nomatchcs(a:node)
  elseif a:node.type == s:NODE_IS
    return self.compile_is(a:node)
  elseif a:node.type == s:NODE_ISCI
    return self.compile_isci(a:node)
  elseif a:node.type == s:NODE_ISCS
    return self.compile_iscs(a:node)
  elseif a:node.type == s:NODE_ISNOT
    return self.compile_isnot(a:node)
  elseif a:node.type == s:NODE_ISNOTCI
    return self.compile_isnotci(a:node)
  elseif a:node.type == s:NODE_ISNOTCS
    return self.compile_isnotcs(a:node)
  elseif a:node.type == s:NODE_ADD
    return self.compile_add(a:node)
  elseif a:node.type == s:NODE_SUBTRACT
    return self.compile_subtract(a:node)
  elseif a:node.type == s:NODE_CONCAT
    return self.compile_concat(a:node)
  elseif a:node.type == s:NODE_MULTIPLY
    return self.compile_multiply(a:node)
  elseif a:node.type == s:NODE_DIVIDE
    return self.compile_divide(a:node)
  elseif a:node.type == s:NODE_REMAINDER
    return self.compile_remainder(a:node)
  elseif a:node.type == s:NODE_NOT
    return self.compile_not(a:node)
  elseif a:node.type == s:NODE_PLUS
    return self.compile_plus(a:node)
  elseif a:node.type == s:NODE_MINUS
    return self.compile_minus(a:node)
  elseif a:node.type == s:NODE_SUBSCRIPT
    return self.compile_subscript(a:node)
  elseif a:node.type == s:NODE_SLICE
    return self.compile_slice(a:node)
  elseif a:node.type == s:NODE_DOT
    return self.compile_dot(a:node)
  elseif a:node.type == s:NODE_CALL
    return self.compile_call(a:node)
  elseif a:node.type == s:NODE_NUMBER
    return self.compile_number(a:node)
  elseif a:node.type == s:NODE_STRING
    return self.compile_string(a:node)
  elseif a:node.type == s:NODE_LIST
    return self.compile_list(a:node)
  elseif a:node.type == s:NODE_DICT
    return self.compile_dict(a:node)
  elseif a:node.type == s:NODE_NESTING
    return self.compile_nesting(a:node)
  elseif a:node.type == s:NODE_OPTION
    return self.compile_option(a:node)
  elseif a:node.type == s:NODE_IDENTIFIER
    return self.compile_identifier(a:node)
  elseif a:node.type == s:NODE_CURLYNAME
    return self.compile_curlyname(a:node)
  elseif a:node.type == s:NODE_ENV
    return self.compile_env(a:node)
  elseif a:node.type == s:NODE_REG
    return self.compile_reg(a:node)
  else
    throw self.err('Compiler: unknown node: %s', string(a:node))
  endif
endfunction

function s:PythonCompiler.compile_body(body)
  let empty = 1
  for node in a:body
    call self.compile(node)
    if node.type != s:NODE_COMMENT
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

function s:PythonCompiler.compile_function(node)
  let name = self.compile(a:node.name)
  if !empty(a:node.args) && a:node.args[-1] == '...'
    let a:node.args[-1] = '*a000'
  endif
  if name =~ '^\(VimLParser\|ExprTokenizer\|ExprParser\|LvalueParser\|StringReader\|Compiler\)\.'
    let name = matchstr(name, '\.\zs.*')
    if name == 'new'
      return
    endif
    call insert(a:node.args, 'self')
    call self.incindent('    ')
    call self.out('def %s(%s):', name, join(a:node.args, ', '))
    call self.incindent('    ')
    call self.compile_body(a:node.body)
    call self.decindent()
    call self.decindent()
  else
    call self.out('def %s(%s):', name, join(a:node.args, ', '))
    call self.incindent('    ')
    call self.compile_body(a:node.body)
    call self.decindent()
  endif
  call self.emptyline()
endfunction

function s:PythonCompiler.compile_delfunction(node)
  throw 'NotImplemented: delfunction'
endfunction

function s:PythonCompiler.compile_return(node)
  if a:node.arg is s:NIL
    call self.out('return')
  else
    call self.out('return %s', self.compile(a:node.arg))
  endif
endfunction

function s:PythonCompiler.compile_excall(node)
  call self.out('%s', self.compile(a:node.expr))
endfunction

function s:PythonCompiler.compile_let(node)
  let args = map(a:node.lhs.args, 'self.compile(v:val)')
  if a:node.lhs.rest isnot s:NIL
    call add(args, '*' . self.compile, a:node.lhs.rest)
  endif
  let op = a:node.op
  if op == '.='
    let op = '+='
  endif
  let lhs = join(args, ', ')
  let rhs = self.compile(a:node.rhs)
  if lhs == 'LvalueParser'
    call self.out('class LvalueParser(ExprParser):')
  elseif lhs =~ '^\(VimLParser\|ExprTokenizer\|ExprParser\|LvalueParser\|StringReader\|Compiler\)$'
    call self.out('class %s:', lhs)
  elseif lhs =~ '^\(VimLParser\|ExprTokenizer\|ExprParser\|LvalueParser\|StringReader\|Compiler\)\.'
    let lhs = matchstr(lhs, '\.\zs.*')
    call self.incindent('    ')
    call self.out('%s %s %s', lhs, op, rhs)
    call self.decindent()
  else
    call self.out('%s %s %s', lhs, op, rhs)
  endif
endfunction

function s:PythonCompiler.compile_unlet(node)
  let args = map(a:node.args, 'self.compile(v:val)')
  call self.out('del %s', join(args, ', '))
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
  let args = map(a:node.lhs.args, 'self.compile(v:val)')
  if a:node.lhs.rest isnot s:NIL
    call add(args, '*' . self.compile(a:node.lhs.rest))
  endif
  let lhs = join(args, ', ')
  let rhs = self.compile(a:node.rhs)
  call self.out('for %s in %s:', lhs, rhs)
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
  call self.out('raise Exception(%s)', self.compile(a:node.arg))
endfunction

function s:PythonCompiler.compile_echo(node)
  let args = map(a:node.args, 'self.compile(v:val)')
  call self.out('print(%s)', join(args, ', '))
endfunction

function s:PythonCompiler.compile_echon(node)
  let args = map(a:node.args, 'self.compile(v:val)')
  call self.out('print(%s)', join(args, ', '))
endfunction

function s:PythonCompiler.compile_echohl(node)
  throw 'NotImplemented: echohl'
endfunction

function s:PythonCompiler.compile_echomsg(node)
  let args = map(a:node.args, 'self.compile(v:val)')
  call self.out('print(%s)', join(args, ', '))
endfunction

function s:PythonCompiler.compile_echoerr(node)
  let args = map(a:node.args, 'self.compile(v:val)')
  call self.out('raise Exception([%s]))', join(args, ', '))
endfunction

function s:PythonCompiler.compile_execute(node)
  throw 'NotImplemented: execute'
endfunction

function s:PythonCompiler.compile_ternary(node)
  return printf('%s if %s else %s', self.compile(a:node.then), self.compile(a:node.cond), self.compile(a:node.else))
endfunction

function s:PythonCompiler.compile_or(node)
  return printf('%s or %s', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:PythonCompiler.compile_and(node)
  return printf('%s and %s', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:PythonCompiler.compile_equal(node)
  return printf('%s == %s', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:PythonCompiler.compile_equalci(node)
  return printf('%s.lower() == %s.lower()', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:PythonCompiler.compile_equalcs(node)
  return printf('%s == %s', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:PythonCompiler.compile_nequal(node)
  return printf('%s != %s', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:PythonCompiler.compile_nequalci(node)
  return printf('%s.lower() != %s.lower()', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:PythonCompiler.compile_nequalcs(node)
  return printf('%s != %s', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:PythonCompiler.compile_greater(node)
  return printf('%s > %s', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:PythonCompiler.compile_greaterci(node)
  throw 'NotImplemented: >?'
endfunction

function s:PythonCompiler.compile_greatercs(node)
  throw 'NotImplemented: >#'
endfunction

function s:PythonCompiler.compile_gequal(node)
  return printf('%s >= %s', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:PythonCompiler.compile_gequalci(node)
  throw 'NotImplemented: >=?'
endfunction

function s:PythonCompiler.compile_gequalcs(node)
  throw 'NotImplemented: >=#'
endfunction

function s:PythonCompiler.compile_smaller(node)
  return printf('%s < %s', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:PythonCompiler.compile_smallerci(node)
  throw 'NotImplemented: <?'
endfunction

function s:PythonCompiler.compile_smallercs(node)
  throw 'NotImplemented: <#'
endfunction

function s:PythonCompiler.compile_sequal(node)
  return printf('%s <= %s', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:PythonCompiler.compile_sequalci(node)
  throw 'NotImplemented: <=?'
endfunction

function s:PythonCompiler.compile_sequalcs(node)
  throw 'NotImplemented: <=#'
endfunction

function s:PythonCompiler.compile_match(node)
  return printf('viml_eqreg(%s, %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:PythonCompiler.compile_matchci(node)
  return printf('viml_eqregq(%s, %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:PythonCompiler.compile_matchcs(node)
  return printf('viml_eqregh(%s, %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:PythonCompiler.compile_nomatch(node)
  return printf('not viml_eqreg(%s, %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:PythonCompiler.compile_nomatchci(node)
  return printf('not viml_eqregq(%s, %s, flags=re.IGNORECASE)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:PythonCompiler.compile_nomatchcs(node)
  return printf('not viml_eqregh(%s, %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:PythonCompiler.compile_is(node)
  return printf('%s is %s', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:PythonCompiler.compile_isci(node)
  throw 'NotImplemented: is?'
endfunction

function s:PythonCompiler.compile_iscs(node)
  throw 'NotImplemented: is#'
endfunction

function s:PythonCompiler.compile_isnot(node)
  return printf('%s is not %s', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:PythonCompiler.compile_isnotci(node)
  throw 'NotImplemented: isnot?'
endfunction

function s:PythonCompiler.compile_isnotcs(node)
  throw 'NotImplemented: isnot#'
endfunction

function s:PythonCompiler.compile_add(node)
  return printf('%s + %s', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:PythonCompiler.compile_subtract(node)
  return printf('%s - %s', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:PythonCompiler.compile_concat(node)
  return printf('%s + %s', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:PythonCompiler.compile_multiply(node)
  return printf('%s * %s', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:PythonCompiler.compile_divide(node)
  return printf('%s // %s', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:PythonCompiler.compile_remainder(node)
  return printf('%s %% %s', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:PythonCompiler.compile_not(node)
  return printf('not %s', self.compile(a:node.expr))
endfunction

function s:PythonCompiler.compile_plus(node)
  return printf('+%s', self.compile(a:node.expr))
endfunction

function s:PythonCompiler.compile_minus(node)
  return printf('-%s', self.compile(a:node.expr))
endfunction

function s:PythonCompiler.compile_subscript(node)
  let expr = self.compile(a:node.expr)
  let expr1 = self.compile(a:node.expr1)
  if expr == 'self'
    return printf('getattr(%s, %s)', expr, expr1)
  else
    return printf('%s[%s]', expr, expr1)
  endif
endfunction

function s:PythonCompiler.compile_slice(node)
  let expr1 = a:node.expr1 is s:NIL ? 'nil' : self.compile(a:node.expr1)
  let expr2 = a:node.expr2 is s:NIL ? 'nil' : self.compile(a:node.expr2)
  return printf('%s[%s : %s]', self.compile(a:node.expr), expr1, expr2)
endfunction

function s:PythonCompiler.compile_dot(node)
  let lhs = self.compile(a:node.lhs)
  let rhs = self.compile(a:node.rhs)
  if rhs =~ '^\(else\|finally\)$'
    let rhs = '_' . rhs
  endif
  return printf('%s.%s', lhs, rhs)
endfunction

function s:PythonCompiler.compile_call(node)
  let args = map(a:node.args, 'self.compile(v:val)')
  let expr = self.compile(a:node.expr)
  if expr == 'map'
    let r = s:StringReader.new([eval(args[1])])
    let p = s:ExprParser.new(s:ExprTokenizer.new(r))
    let n = p.parse()
    return printf('[%s for vval in %s]', self.compile(n), args[0])
  elseif expr == 'call' && args[0][0] =~ '[''"]'
    return printf('viml_%s(*%s)', args[0][1:-2], args[1])
  endif
  if expr =~ '\.new$'
    let expr = matchstr(expr, '.*\ze\.new$')
  endif
  if index(s:viml_builtin_functions, expr) != -1
    let expr = printf('viml_%s', expr)
  endif
  return printf('%s(%s)', expr, join(args, ', '))
endfunction

function s:PythonCompiler.compile_number(node)
  return a:node.value
endfunction

function s:PythonCompiler.compile_string(node)
  if a:node.value[0] == "'"
    let s = substitute(a:node.value[1:-2], "''", "'", 'g')
    return '"' . escape(s, '\"') . '"'
  else
    return a:node.value
  endif
endfunction

function s:PythonCompiler.compile_list(node)
  let items = map(a:node.items, 'self.compile(v:val)')
  if empty(items)
    return '[]'
  else
    return printf('[%s]', join(items, ', '))
  endif
endfunction

function s:PythonCompiler.compile_dict(node)
  let items = map(a:node.items, 'self.compile(v:val[0]) . ":" . self.compile(v:val[1])')
  if empty(items)
    return 'AttributeDict({})'
  else
    return printf('AttributeDict({%s})', join(items, ', '))
  endif
endfunction

function s:PythonCompiler.compile_nesting(node)
  return '(' . self.compile(a:node.expr) . ')'
endfunction

function s:PythonCompiler.compile_option(node)
  throw 'NotImplemented: option'
endfunction

function s:PythonCompiler.compile_identifier(node)
  let name = a:node.value
  if name == 'a:000'
    let name = 'a000'
  elseif name == 'v:val'
    let name = 'vval'
  elseif name =~ '^[sa]:'
    let name = name[2:]
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

let s:viml_builtin_functions = ['abs', 'acos', 'add', 'and', 'append', 'append', 'argc', 'argidx', 'argv', 'argv', 'asin', 'atan', 'atan2', 'browse', 'browsedir', 'bufexists', 'buflisted', 'bufloaded', 'bufname', 'bufnr', 'bufwinnr', 'byte2line', 'byteidx', 'call', 'ceil', 'changenr', 'char2nr', 'cindent', 'clearmatches', 'col', 'complete', 'complete_add', 'complete_check', 'confirm', 'copy', 'cos', 'cosh', 'count', 'cscope_connection', 'cursor', 'cursor', 'deepcopy', 'delete', 'did_filetype', 'diff_filler', 'diff_hlID', 'empty', 'escape', 'eval', 'eventhandler', 'executable', 'exists', 'extend', 'exp', 'expand', 'feedkeys', 'filereadable', 'filewritable', 'filter', 'finddir', 'findfile', 'float2nr', 'floor', 'fmod', 'fnameescape', 'fnamemodify', 'foldclosed', 'foldclosedend', 'foldlevel', 'foldtext', 'foldtextresult', 'foreground', 'function', 'garbagecollect', 'get', 'get', 'getbufline', 'getbufvar', 'getchar', 'getcharmod', 'getcmdline', 'getcmdpos', 'getcmdtype', 'getcwd', 'getfperm', 'getfsize', 'getfontname', 'getftime', 'getftype', 'getline', 'getline', 'getloclist', 'getmatches', 'getpid', 'getpos', 'getqflist', 'getreg', 'getregtype', 'gettabvar', 'gettabwinvar', 'getwinposx', 'getwinposy', 'getwinvar', 'glob', 'globpath', 'has', 'has_key', 'haslocaldir', 'hasmapto', 'histadd', 'histdel', 'histget', 'histnr', 'hlexists', 'hlID', 'hostname', 'iconv', 'indent', 'index', 'input', 'inputdialog', 'inputlist', 'inputrestore', 'inputsave', 'inputsecret', 'insert', 'invert', 'isdirectory', 'islocked', 'items', 'join', 'keys', 'len', 'libcall', 'libcallnr', 'line', 'line2byte', 'lispindent', 'localtime', 'log', 'log10', 'luaeval', 'map', 'maparg', 'mapcheck', 'match', 'matchadd', 'matcharg', 'matchdelete', 'matchend', 'matchlist', 'matchstr', 'max', 'min', 'mkdir', 'mode', 'mzeval', 'nextnonblank', 'nr2char', 'or', 'pathshorten', 'pow', 'prevnonblank', 'printf', 'pumvisible', 'pyeval', 'py3eval', 'range', 'readfile', 'reltime', 'reltimestr', 'remote_expr', 'remote_foreground', 'remote_peek', 'remote_read', 'remote_send', 'remove', 'remove', 'rename', 'repeat', 'resolve', 'reverse', 'round', 'screencol', 'screenrow', 'search', 'searchdecl', 'searchpair', 'searchpairpos', 'searchpos', 'server2client', 'serverlist', 'setbufvar', 'setcmdpos', 'setline', 'setloclist', 'setmatches', 'setpos', 'setqflist', 'setreg', 'settabvar', 'settabwinvar', 'setwinvar', 'sha256', 'shellescape', 'shiftwidth', 'simplify', 'sin', 'sinh', 'sort', 'soundfold', 'spellbadword', 'spellsuggest', 'split', 'sqrt', 'str2float', 'str2nr', 'strchars', 'strdisplaywidth', 'strftime', 'stridx', 'string', 'strlen', 'strpart', 'strridx', 'strtrans', 'strwidth', 'submatch', 'substitute', 'synID', 'synIDattr', 'synIDtrans', 'synconcealed', 'synstack', 'system', 'tabpagebuflist', 'tabpagenr', 'tabpagewinnr', 'taglist', 'tagfiles', 'tempname', 'tan', 'tanh', 'tolower', 'toupper', 'tr', 'trunc', 'type', 'undofile', 'undotree', 'values', 'virtcol', 'visualmode', 'wildmenumode', 'winbufnr', 'wincol', 'winheight', 'winline', 'winnr', 'winrestcmd', 'winrestview', 'winsaveview', 'winwidth', 'writefile', 'xor']

function! s:test()
  let vimfile = 'autoload/vimlparser.vim'
  let pyfile = 'py/vimlparser.py'
  let vimlfunc = 'py/vimlfunc.py'
  let head = readfile(vimlfunc)
  try
    let r = s:StringReader.new(readfile(vimfile))
    let p = s:VimLParser.new()
    let c = s:PythonCompiler.new()
    let lines = c.compile(p.parse(r))
    unlet lines[0 : index(lines, 'NIL = []') - 1]
    call writefile(head + lines + ['', 'main()'], pyfile)
  catch
    echoerr substitute(v:throwpoint, '\.\.\zs\d\+', '\=s:numtoname(submatch(0))', 'g') . "\n" . v:exception
  endtry
endfunction

function! s:numtoname(num)
  let sig = printf("function('%s')", a:num)
  for k in keys(s:)
    if type(s:[k]) == type({})
      for name in keys(s:[k])
        if type(s:[k][name]) == type(function('tr')) && string(s:[k][name]) == sig
          return printf('%s.%s', k, name)
        endif
      endfor
    endif
  endfor
  return a:num
endfunction

call s:test()
