" vim:set ts=8 sts=2 sw=2 tw=0 et:
"
" VimL parser - Vim Script Parser
"
" License: This file is placed in the public domain.

function! vimlparser#import()
  return s:
endfunction

" @brief Read input as VimScript and return stringified AST.
" @param input Input filename or string of VimScript.
" @return Stringified AST.
function! vimlparser#test(input)
  try
    let i = type(a:input) == 1 && filereadable(a:input) ? readfile(a:input) : a:input
    let r = s:StringReader.new(i)
    let p = s:VimLParser.new()
    let c = s:Compiler.new()
    echo join(c.compile(p.parse(r)), "\n")
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

let s:NIL = []

let s:NODE_TOPLEVEL = 1
let s:NODE_COMMENT = 2
let s:NODE_EXCMD = 3
let s:NODE_FUNCTION = 4
let s:NODE_ENDFUNCTION = 5
let s:NODE_DELFUNCTION = 6
let s:NODE_RETURN = 7
let s:NODE_EXCALL = 8
let s:NODE_LET = 9
let s:NODE_UNLET = 10
let s:NODE_LOCKVAR = 11
let s:NODE_UNLOCKVAR = 12
let s:NODE_IF = 13
let s:NODE_ELSEIF = 14
let s:NODE_ELSE = 15
let s:NODE_ENDIF = 16
let s:NODE_WHILE = 17
let s:NODE_ENDWHILE = 18
let s:NODE_FOR = 19
let s:NODE_ENDFOR = 20
let s:NODE_CONTINUE = 21
let s:NODE_BREAK = 22
let s:NODE_TRY = 23
let s:NODE_CATCH = 24
let s:NODE_FINALLY = 25
let s:NODE_ENDTRY = 26
let s:NODE_THROW = 27
let s:NODE_ECHO = 28
let s:NODE_ECHON = 29
let s:NODE_ECHOHL = 30
let s:NODE_ECHOMSG = 31
let s:NODE_ECHOERR = 32
let s:NODE_EXECUTE = 33
let s:NODE_TERNARY = 34
let s:NODE_OR = 35
let s:NODE_AND = 36
let s:NODE_EQUAL = 37
let s:NODE_EQUALCI = 38
let s:NODE_EQUALCS = 39
let s:NODE_NEQUAL = 40
let s:NODE_NEQUALCI = 41
let s:NODE_NEQUALCS = 42
let s:NODE_GREATER = 43
let s:NODE_GREATERCI = 44
let s:NODE_GREATERCS = 45
let s:NODE_GEQUAL = 46
let s:NODE_GEQUALCI = 47
let s:NODE_GEQUALCS = 48
let s:NODE_SMALLER = 49
let s:NODE_SMALLERCI = 50
let s:NODE_SMALLERCS = 51
let s:NODE_SEQUAL = 52
let s:NODE_SEQUALCI = 53
let s:NODE_SEQUALCS = 54
let s:NODE_MATCH = 55
let s:NODE_MATCHCI = 56
let s:NODE_MATCHCS = 57
let s:NODE_NOMATCH = 58
let s:NODE_NOMATCHCI = 59
let s:NODE_NOMATCHCS = 60
let s:NODE_IS = 61
let s:NODE_ISCI = 62
let s:NODE_ISCS = 63
let s:NODE_ISNOT = 64
let s:NODE_ISNOTCI = 65
let s:NODE_ISNOTCS = 66
let s:NODE_ADD = 67
let s:NODE_SUBTRACT = 68
let s:NODE_CONCAT = 69
let s:NODE_MULTIPLY = 70
let s:NODE_DIVIDE = 71
let s:NODE_REMAINDER = 72
let s:NODE_NOT = 73
let s:NODE_MINUS = 74
let s:NODE_PLUS = 75
let s:NODE_SUBSCRIPT = 76
let s:NODE_SLICE = 77
let s:NODE_CALL = 78
let s:NODE_DOT = 79
let s:NODE_NUMBER = 80
let s:NODE_STRING = 81
let s:NODE_LIST = 82
let s:NODE_DICT = 83
let s:NODE_OPTION = 85
let s:NODE_IDENTIFIER = 86
let s:NODE_CURLYNAME = 87
let s:NODE_ENV = 88
let s:NODE_REG = 89

let s:TOKEN_EOF = 1
let s:TOKEN_EOL = 2
let s:TOKEN_SPACE = 3
let s:TOKEN_OROR = 4
let s:TOKEN_ANDAND = 5
let s:TOKEN_EQEQ = 6
let s:TOKEN_EQEQCI = 7
let s:TOKEN_EQEQCS = 8
let s:TOKEN_NEQ = 9
let s:TOKEN_NEQCI = 10
let s:TOKEN_NEQCS = 11
let s:TOKEN_GT = 12
let s:TOKEN_GTCI = 13
let s:TOKEN_GTCS = 14
let s:TOKEN_GTEQ = 15
let s:TOKEN_GTEQCI = 16
let s:TOKEN_GTEQCS = 17
let s:TOKEN_LT = 18
let s:TOKEN_LTCI = 19
let s:TOKEN_LTCS = 20
let s:TOKEN_LTEQ = 21
let s:TOKEN_LTEQCI = 22
let s:TOKEN_LTEQCS = 23
let s:TOKEN_MATCH = 24
let s:TOKEN_MATCHCI = 25
let s:TOKEN_MATCHCS = 26
let s:TOKEN_NOMATCH = 27
let s:TOKEN_NOMATCHCI = 28
let s:TOKEN_NOMATCHCS = 29
let s:TOKEN_IS = 30
let s:TOKEN_ISCI = 31
let s:TOKEN_ISCS = 32
let s:TOKEN_ISNOT = 33
let s:TOKEN_ISNOTCI = 34
let s:TOKEN_ISNOTCS = 35
let s:TOKEN_PLUS = 36
let s:TOKEN_MINUS = 37
let s:TOKEN_DOT = 38
let s:TOKEN_STAR = 39
let s:TOKEN_SLASH = 40
let s:TOKEN_PERCENT = 41
let s:TOKEN_NOT = 42
let s:TOKEN_QUESTION = 43
let s:TOKEN_COLON = 44
let s:TOKEN_POPEN = 45
let s:TOKEN_PCLOSE = 46
let s:TOKEN_SQOPEN = 47
let s:TOKEN_SQCLOSE = 48
let s:TOKEN_COPEN = 49
let s:TOKEN_CCLOSE = 50
let s:TOKEN_COMMA = 51
let s:TOKEN_NUMBER = 52
let s:TOKEN_SQUOTE = 53
let s:TOKEN_DQUOTE = 54
let s:TOKEN_OPTION = 55
let s:TOKEN_IDENTIFIER = 56
let s:TOKEN_ENV = 57
let s:TOKEN_REG = 58
let s:TOKEN_EQ = 59
let s:TOKEN_OR = 60
let s:TOKEN_SEMICOLON = 61
let s:TOKEN_BACKTICK = 62
let s:TOKEN_DOTDOTDOT = 63

let s:MAX_FUNC_ARGS = 20

function! s:isalpha(c)
  return a:c =~# '^[A-Za-z]$'
endfunction

function! s:isalnum(c)
  return a:c =~# '^[0-9A-Za-z]$'
endfunction

function! s:isdigit(c)
  return a:c =~# '^[0-9]$'
endfunction

function! s:isxdigit(c)
  return a:c =~# '^[0-9A-Fa-f]$'
endfunction

function! s:iswordc(c)
  return a:c =~# '^[0-9A-Za-z_]$'
endfunction

function! s:iswordc1(c)
  return a:c =~# '^[A-Za-z_]$'
endfunction

function! s:iswhite(c)
  return a:c =~# '^[ \t]$'
endfunction

function! s:isnamec(c)
  return a:c =~# '^[0-9A-Za-z_:#]$'
endfunction

function! s:isnamec1(c)
  return a:c =~# '^[A-Za-z_]$'
endfunction

function! s:isargname(s)
  return a:s =~# '^[A-Za-z_][0-9A-Za-z_]*$'
endfunction

function! s:isvarname(s)
  return a:s =~# '^[vgslabwt]:$\|^\([vgslabwt]:\)\?[A-Za-z_][0-9A-Za-z_]*$'
endfunction

" FIXME:
function! s:isidc(c)
  return a:c =~# '^[0-9A-Za-z_]$'
endfunction

function! s:isupper(c)
  return a:c =~# '^[A-Z]$'
endfunction

function! s:islower(c)
  return a:c =~# '^[a-z]$'
endfunction

function! s:ExArg()
  let ea = {}
  let ea.forceit = 0
  let ea.addr_count = 0
  let ea.line1 = 0
  let ea.line2 = 0
  let ea.flags = 0
  let ea.do_ecmd_cmd = ''
  let ea.do_ecmd_lnum = 0
  let ea.append = 0
  let ea.usefilter = 0
  let ea.amount = 0
  let ea.regname = 0
  let ea.force_bin = 0
  let ea.read_edit = 0
  let ea.force_ff = 0
  let ea.force_enc = 0
  let ea.bad_char = 0
  let ea.linepos = []
  let ea.cmdpos = []
  let ea.argpos = []
  let ea.cmd = {}
  let ea.modifiers = []
  let ea.range = []
  let ea.argopt = {}
  let ea.argcmd = {}
  return ea
endfunction

" struct node {
"   int     type
"   pos     pos
"   node    left
"   node    right
"   node    cond
"   node    rest
"   node[]  list
"   node[]  rlist
"   node[]  body
"   string  op
"   string  str
"   int     depth
"   variant value
" }
" TOPLEVEL .body
" COMMENT .str
" EXCMD .ea .str
" FUNCTION .ea .body .left .rlist .attr .endfunction
" ENDFUNCTION .ea
" DELFUNCTION .ea .left
" RETURN .ea .left
" EXCALL .ea .left
" LET .ea .op .left .list .rest .right
" UNLET .ea .list
" LOCKVAR .ea .depth .list
" UNLOCKVAR .ea .depth .list
" IF .ea .body .cond .elseif .else .endif
" ELSEIF .ea .body .cond
" ELSE .ea .body
" ENDIF .ea
" WHILE .ea .body .cond .endwhile
" ENDWHILE .ea
" FOR .ea .body .left .list .rest .right .endfor
" ENDFOR .ea
" CONTINUE .ea
" BREAK .ea
" TRY .ea .body .catch .finally .endtry
" CATCH .ea .body .pattern
" FINALLY .ea .body
" ENDTRY .ea
" THROW .ea .left
" ECHO .ea .list
" ECHON .ea .list
" ECHOHL .ea .str
" ECHOMSG .ea .list
" ECHOERR .ea .list
" EXECUTE .ea .list
" TERNARY .cond .left .right
" OR .left .right
" AND .left .right
" EQUAL .left .right
" EQUALCI .left .right
" EQUALCS .left .right
" NEQUAL .left .right
" NEQUALCI .left .right
" NEQUALCS .left .right
" GREATER .left .right
" GREATERCI .left .right
" GREATERCS .left .right
" GEQUAL .left .right
" GEQUALCI .left .right
" GEQUALCS .left .right
" SMALLER .left .right
" SMALLERCI .left .right
" SMALLERCS .left .right
" SEQUAL .left .right
" SEQUALCI .left .right
" SEQUALCS .left .right
" MATCH .left .right
" MATCHCI .left .right
" MATCHCS .left .right
" NOMATCH .left .right
" NOMATCHCI .left .right
" NOMATCHCS .left .right
" IS .left .right
" ISCI .left .right
" ISCS .left .right
" ISNOT .left .right
" ISNOTCI .left .right
" ISNOTCS .left .right
" ADD .left .right
" SUBTRACT .left .right
" CONCAT .left .right
" MULTIPLY .left .right
" DIVIDE .left .right
" REMAINDER .left .right
" NOT .left
" MINUS .left
" PLUS .left
" SUBSCRIPT .left .right
" SLICE .left .rlist
" CALL .left .rlist
" DOT .left .right
" NUMBER .value
" STRING .value
" LIST .value
" DICT .value
" NESTING .left
" OPTION .value
" IDENTIFIER .value
" CURLYNAME .value
" ENV .value
" REG .value
function! s:Node(type)
  return {'type': a:type}
endfunction

function! s:Err(msg, pos)
  return printf('vimlparser: %s: line %d col %d', a:msg, a:pos.lnum, a:pos.col)
endfunction

let s:VimLParser = {}

function! s:VimLParser.new(...)
  let obj = copy(self)
  call call(obj.__init__, a:000, obj)
  return obj
endfunction

function! s:VimLParser.__init__()
  let self.find_command_cache = {}
endfunction

function! s:VimLParser.push_context(node)
  call insert(self.context, a:node)
endfunction

function! s:VimLParser.pop_context()
  call remove(self.context, 0)
endfunction

function! s:VimLParser.find_context(type)
  let i = 0
  for node in self.context
    if node.type == a:type
      return i
    endif
    let i += 1
  endfor
  return -1
endfunction

function! s:VimLParser.add_node(node)
  call add(self.context[0].body, a:node)
endfunction

function! s:VimLParser.check_missing_endfunction(ends, pos)
  if self.context[0].type == s:NODE_FUNCTION
    throw s:Err(printf('E126: Missing :endfunction:    %s', a:ends), a:pos)
  endif
endfunction

function! s:VimLParser.check_missing_endif(ends, pos)
  if self.context[0].type == s:NODE_IF || self.context[0].type == s:NODE_ELSEIF || self.context[0].type == s:NODE_ELSE
    throw s:Err(printf('E171: Missing :endif:    %s', a:ends), a:pos)
  endif
endfunction

function! s:VimLParser.check_missing_endtry(ends, pos)
  if self.context[0].type == s:NODE_TRY || self.context[0].type == s:NODE_CATCH || self.context[0].type == s:NODE_FINALLY
    throw s:Err(printf('E600: Missing :endtry:    %s', a:ends), a:pos)
  endif
endfunction

function! s:VimLParser.check_missing_endwhile(ends, pos)
  if self.context[0].type == s:NODE_WHILE
    throw s:Err(printf('E170: Missing :endwhile:    %s', a:ends), a:pos)
  endif
endfunction

function! s:VimLParser.check_missing_endfor(ends, pos)
  if self.context[0].type == s:NODE_FOR
    throw s:Err(printf('E170: Missing :endfor:    %s', a:ends), a:pos)
  endif
endfunction

function! s:VimLParser.parse(reader)
  let self.reader = a:reader
  let self.context = []
  let toplevel = s:Node(s:NODE_TOPLEVEL)
  let toplevel.body = []
  call self.push_context(toplevel)
  while self.reader.peek() !=# '<EOF>'
    call self.parse_one_cmd()
  endwhile
  call self.check_missing_endfunction('TOPLEVEL', self.reader.getpos())
  call self.check_missing_endif('TOPLEVEL', self.reader.getpos())
  call self.check_missing_endtry('TOPLEVEL', self.reader.getpos())
  call self.check_missing_endwhile('TOPLEVEL', self.reader.getpos())
  call self.check_missing_endfor('TOPLEVEL', self.reader.getpos())
  call self.pop_context()
  return toplevel
endfunction

function! s:VimLParser.parse_one_cmd()
  let self.ea = s:ExArg()

  if self.reader.peekn(2) ==# '#!'
    call self.parse_hashbang()
    call self.reader.get()
    return
  endif
  call self.reader.skip_white_and_colon()
  if self.reader.peekn(1) ==# ''
    call self.reader.get()
    return
  endif
  if self.reader.peekn(1) ==# '"'
    call self.parse_comment()
    call self.reader.get()
    return
  endif
  let self.ea.linepos = self.reader.getpos()
  call self.parse_command_modifiers()
  call self.parse_range()
  call self.parse_command()
  call self.parse_trail()
endfunction

" FIXME:
function! s:VimLParser.parse_command_modifiers()
  let modifiers = []
  while 1
    let pos = self.reader.tell()
    if s:isdigit(self.reader.peekn(1))
      let d = self.reader.read_digit()
      call self.reader.skip_white()
    else
      let d = ''
    endif
    let k = self.reader.read_alpha()
    let c = self.reader.peekn(1)
    call self.reader.skip_white()
    if stridx('aboveleft', k) == 0 && len(k) >= 3 " abo\%[veleft]
      call add(modifiers, {'name': 'aboveleft'})
    elseif stridx('belowright', k) == 0 && len(k) >= 3 " bel\%[owright]
      call add(modifiers, {'name': 'belowright'})
    elseif stridx('browse', k) == 0 && len(k) >= 3 " bro\%[wse]
      call add(modifiers, {'name': 'browse'})
    elseif stridx('botright', k) == 0 && len(k) >= 2 " bo\%[tright]
      call add(modifiers, {'name': 'botright'})
    elseif stridx('confirm', k) == 0 && len(k) >= 4 " conf\%[irm]
      call add(modifiers, {'name': 'confirm'})
    elseif stridx('keepmarks', k) == 0 && len(k) >= 3 " kee\%[pmarks]
      call add(modifiers, {'name': 'keepmarks'})
    elseif stridx('keepalt', k) == 0 && len(k) >= 5 " keepa\%[lt]
      call add(modifiers, {'name': 'keepalt'})
    elseif stridx('keepjumps', k) == 0 && len(k) >= 5 " keepj\%[umps]
      call add(modifiers, {'name': 'keepjumps'})
    elseif stridx('hide', k) == 0 && len(k) >= 3 "hid\%[e]
      if self.ends_excmds(c)
        break
      endif
      call add(modifiers, {'name': 'hide'})
    elseif stridx('lockmarks', k) == 0 && len(k) >= 3 " loc\%[kmarks]
      call add(modifiers, {'name': 'lockmarks'})
    elseif stridx('leftabove', k) == 0 && len(k) >= 5 " lefta\%[bove]
      call add(modifiers, {'name': 'leftabove'})
    elseif stridx('noautocmd', k) == 0 && len(k) >= 3 " noa\%[utocmd]
      call add(modifiers, {'name': 'noautocmd'})
    elseif stridx('rightbelow', k) == 0 && len(k) >= 6 "rightb\%[elow]
      call add(modifiers, {'name': 'rightbelow'})
    elseif stridx('sandbox', k) == 0 && len(k) >= 3 " san\%[dbox]
      call add(modifiers, {'name': 'sandbox'})
    elseif stridx('silent', k) == 0 && len(k) >= 3 " sil\%[ent]
      if c ==# '!'
        call self.reader.get()
        call add(modifiers, {'name': 'silent', 'bang': 1})
      else
        call add(modifiers, {'name': 'silent', 'bang': 0})
      endif
    elseif k ==# 'tab' " tab
      if d !=# ''
        call add(modifiers, {'name': 'tab', 'count': str2nr(d, 10)})
      else
        call add(modifiers, {'name': 'tab'})
      endif
    elseif stridx('topleft', k) == 0 && len(k) >= 2 " to\%[pleft]
      call add(modifiers, {'name': 'topleft'})
    elseif stridx('unsilent', k) == 0 && len(k) >= 3 " uns\%[ilent]
      call add(modifiers, {'name': 'unsilent'})
    elseif stridx('vertical', k) == 0 && len(k) >= 4 " vert\%[ical]
      call add(modifiers, {'name': 'vertical'})
    elseif stridx('verbose', k) == 0 && len(k) >= 4 " verb\%[ose]
      if d !=# ''
        call add(modifiers, {'name': 'verbose', 'count': str2nr(d, 10)})
      else
        call add(modifiers, {'name': 'verbose', 'count': 1})
      endif
    else
      call self.reader.seek_set(pos)
      break
    endif
  endwhile
  let self.ea.modifiers = modifiers
endfunction

" FIXME:
function! s:VimLParser.parse_range()
  let tokens = []

  while 1

    while 1
      call self.reader.skip_white()

      let c = self.reader.peekn(1)
      if c ==# ''
        break
      endif

      if c ==# '.'
        call add(tokens, self.reader.getn(1))
      elseif c ==# '$'
        call add(tokens, self.reader.getn(1))
      elseif c ==# "'"
        call self.reader.getn(1)
        let m = self.reader.getn(1)
        if m ==# ''
          break
        endif
        call add(tokens, "'" . m)
      elseif c ==# '/'
        call self.reader.getn(1)
        let [pattern, endc] = self.parse_pattern(c)
        call add(tokens, pattern)
      elseif c ==# '?'
        call self.reader.getn(1)
        let [pattern, endc] = self.parse_pattern(c)
        call add(tokens, pattern)
      elseif c ==# '\'
        let m = self.reader.p(1)
        if m ==# '&' || m ==# '?' || m ==# '/'
          call self.reader.seek_cur(2)
          call add(tokens, '\' . m)
        else
          throw s:Err('E10: \\ should be followed by /, ? or &', self.reader.getpos())
        endif
      elseif s:isdigit(c)
        call add(tokens, self.reader.read_digit())
      endif

      while 1
        call self.reader.skip_white()
        if self.reader.peekn(1) ==# ''
          break
        endif
        let n = self.reader.read_integer()
        if n ==# ''
          break
        endif
        call add(tokens, n)
      endwhile

      if self.reader.p(0) !=# '/' && self.reader.p(0) !=# '?'
        break
      endif
    endwhile

    if self.reader.peekn(1) ==# '%'
      call add(tokens, self.reader.getn(1))
    elseif self.reader.peekn(1) ==# '*' " && &cpoptions !~ '\*'
      call add(tokens, self.reader.getn(1))
    endif

    if self.reader.peekn(1) ==# ';'
      call add(tokens, self.reader.getn(1))
      continue
    elseif self.reader.peekn(1) ==# ','
      call add(tokens, self.reader.getn(1))
      continue
    endif

    break
  endwhile

  let self.ea.range = tokens
endfunction

" FIXME:
function! s:VimLParser.parse_pattern(delimiter)
  let pattern = ''
  let endc = ''
  let inbracket = 0
  while 1
    let c = self.reader.getn(1)
    if c ==# ''
      break
    endif
    if c ==# a:delimiter && inbracket == 0
      let endc = c
      break
    endif
    let pattern .= c
    if c ==# '\'
      let c = self.reader.peekn(1)
      if c ==# ''
        throw s:Err('E682: Invalid search pattern or delimiter', self.reader.getpos())
      endif
      call self.reader.getn(1)
      let pattern .= c
    elseif c ==# '['
      let inbracket += 1
    elseif c ==# ']'
      let inbracket -= 1
    endif
  endwhile
  return [pattern, endc]
endfunction

function! s:VimLParser.parse_command()
  call self.reader.skip_white_and_colon()

  let self.ea.cmdpos = self.reader.getpos()

  if self.reader.peekn(1) ==# '' || self.reader.peekn(1) ==# '"'
    if !empty(self.ea.modifiers) || !empty(self.ea.range)
      call self.parse_cmd_modifier_range()
    endif
    return
  endif

  let self.ea.cmd = self.find_command()

  if self.ea.cmd is s:NIL
    call self.reader.setpos(self.ea.cmdpos)
    throw s:Err(printf('E492: Not an editor command: %s', self.reader.peekline()), self.ea.cmdpos)
  endif

  if self.reader.peekn(1) ==# '!' && self.ea.cmd.name !=# 'substitute' && self.ea.cmd.name !=# 'smagic' && self.ea.cmd.name !=# 'snomagic'
    call self.reader.getn(1)
    let self.ea.forceit = 1
  else
    let self.ea.forceit = 0
  endif

  if self.ea.cmd.flags !~# '\<BANG\>' && self.ea.forceit
    throw s:Err('E477: No ! allowed', self.ea.cmdpos)
  endif

  if self.ea.cmd.name !=# '!'
    call self.reader.skip_white()
  endif

  let self.ea.argpos = self.reader.getpos()

  if self.ea.cmd.flags =~# '\<ARGOPT\>'
    call self.parse_argopt()
  endif

  if self.ea.cmd.name ==# 'write' || self.ea.cmd.name ==# 'update'
    if self.reader.p(0) ==# '>'
      if self.reader.p(1) !=# '>'
        throw s:Err('E494: Use w or w>>', self.ea.cmdpos)
      endif
      call self.reader.seek_cur(2)
      call self.reader.skip_white()
      let self.ea.append = 1
    elseif self.reader.peekn(1) ==# '!' && self.ea.cmd.name ==# 'write'
      call self.reader.getn(1)
      let self.ea.usefilter = 1
    endif
  endif

  if self.ea.cmd.name ==# 'read'
    if self.ea.forceit
      let self.ea.usefilter = 1
      let self.ea.forceit = 0
    elseif self.reader.peekn(1) ==# '!'
      call self.reader.getn(1)
      let self.ea.usefilter = 1
    endif
  endif

  if self.ea.cmd.name ==# '<' || self.ea.cmd.name ==# '>'
    let self.ea.amount = 1
    while self.reader.peekn(1) ==# self.ea.cmd.name
      call self.reader.getn(1)
      let self.ea.amount += 1
    endwhile
    call self.reader.skip_white()
  endif

  if self.ea.cmd.flags =~# '\<EDITCMD\>' && !self.ea.usefilter
    call self.parse_argcmd()
  endif

  call self[self.ea.cmd.parser]()
endfunction

function! s:VimLParser.find_command()
  let c = self.reader.peekn(1)

  if c ==# 'k'
    call self.reader.getn(1)
    let name = 'k'
  elseif c ==# 's' && self.reader.peekn(5) =~# '\v^s%(c[^sr][^i][^p]|g|i[^mlg]|I|r[^e])'
    call self.reader.getn(1)
    let name = 'substitute'
  elseif c =~# '[@*!=><&~#]'
    call self.reader.getn(1)
    let name = c
  elseif self.reader.peekn(2) ==# 'py'
    let name = self.reader.read_alnum()
  else
    let pos = self.reader.tell()
    let name = self.reader.read_alpha()
    if name !=# 'del' && name =~# '\v^d%[elete][lp]$'
      call self.reader.seek_set(pos)
      let name = self.reader.getn(len(name) - 1)
    endif
  endif

  if name == ''
    return s:NIL
  endif

  if has_key(self.find_command_cache, name)
    return self.find_command_cache[name]
  endif

  let cmd = s:NIL

  for x in self.builtin_commands
    if stridx(x.name, name) == 0 && len(name) >= x.minlen
      unlet cmd
      let cmd = x
      break
    endif
  endfor

  " FIXME: user defined command
  if (cmd is s:NIL || cmd.name ==# 'Print') && name =~# '^[A-Z]'
    let name .= self.reader.read_alnum()
    unlet cmd
    let cmd = {'name': name, 'flags': 'USERCMD', 'parser': 'parse_cmd_usercmd'}
  endif

  let self.find_command_cache[name] = cmd

  return cmd
endfunction

" TODO:
function! s:VimLParser.parse_hashbang()
  call self.reader.getn(-1)
endfunction

" TODO:
" ++opt=val
function! s:VimLParser.parse_argopt()
  while self.reader.p(0) ==# '+' && self.reader.p(1) ==# '+'
    let s = self.reader.peekn(20)
    if s =~# '^++bin\>'
      call self.reader.getn(5)
      let self.ea.force_bin = 1
    elseif s =~# '^++nobin\>'
      call self.reader.getn(7)
      let self.ea.force_bin = 2
    elseif s =~# '^++edit\>'
      call self.reader.getn(6)
      let self.ea.read_edit = 1
    elseif s =~# '^++ff=\(dos\|unix\|mac\)\>'
      call self.reader.getn(5)
      let self.ea.force_ff = self.reader.read_alpha()
    elseif s =~# '^++fileformat=\(dos\|unix\|mac\)\>'
      call self.reader.getn(13)
      let self.ea.force_ff = self.reader.read_alpha()
    elseif s =~# '^++enc=\S'
      call self.reader.getn(6)
      let self.ea.force_enc = self.reader.read_nonwhite()
    elseif s =~# '^++encoding=\S'
      call self.reader.getn(11)
      let self.ea.force_enc = self.reader.read_nonwhite()
    elseif s =~# '^++bad=\(keep\|drop\|.\)\>'
      call self.reader.getn(6)
      if s =~# '^++bad=keep'
        let self.ea.bad_char = self.reader.getn(4)
      elseif s =~# '^++bad=drop'
        let self.ea.bad_char = self.reader.getn(4)
      else
        let self.ea.bad_char = self.reader.getn(1)
      endif
    elseif s =~# '^++'
      throw 'VimLParser: E474: Invalid Argument'
    else
      break
    endif
    call self.reader.skip_white()
  endwhile
endfunction

" TODO:
" +command
function! s:VimLParser.parse_argcmd()
  if self.reader.peekn(1) ==# '+'
    call self.reader.getn(1)
    if self.reader.peekn(1) ==# ' '
      let self.ea.do_ecmd_cmd = '$'
    else
      let self.ea.do_ecmd_cmd = self.read_cmdarg()
    endif
  endif
endfunction

function! s:VimLParser.read_cmdarg()
  let r = ''
  while 1
    let c = self.reader.peekn(1)
    if c ==# '' || s:iswhite(c)
      break
    endif
    call self.reader.getn(1)
    if c ==# '\'
      let c = self.reader.getn(1)
    endif
    let r .= c
  endwhile
  return r
endfunction

function! s:VimLParser.parse_comment()
  let npos = self.reader.getpos()
  let c = self.reader.get()
  if c !=# '"'
    throw s:Err(printf('unexpected character: %s', c), npos)
  endif
  let node = s:Node(s:NODE_COMMENT)
  let node.pos = npos
  let node.str = self.reader.getn(-1)
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_trail()
  call self.reader.skip_white()
  let c = self.reader.peek()
  if c ==# '<EOF>'
    " pass
  elseif c ==# '<EOL>'
    call self.reader.get()
  elseif c ==# '|'
    call self.reader.get()
  elseif c ==# '"'
    call self.parse_comment()
    call self.reader.get()
  else
    throw s:Err(printf('E488: Trailing characters: %s', c), self.reader.getpos())
  endif
endfunction

" modifier or range only command line
function! s:VimLParser.parse_cmd_modifier_range()
  let node = s:Node(s:NODE_EXCMD)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let node.str = self.reader.getstr(self.ea.linepos, self.reader.getpos())
  call self.add_node(node)
endfunction

" TODO:
function! s:VimLParser.parse_cmd_common()
  if self.ea.cmd.flags =~# '\<TRLBAR\>' && !self.ea.usefilter
    let end = self.separate_nextcmd()
  elseif self.ea.cmd.name ==# '!' || self.ea.cmd.name ==# 'global' || self.ea.cmd.name ==# 'vglobal' || self.ea.usefilter
    while 1
      let end = self.reader.getpos()
      if self.reader.getn(1) ==# ''
        break
      endif
    endwhile
  else
    while 1
      let end = self.reader.getpos()
      if self.reader.getn(1) ==# ''
        break
      endif
    endwhile
  endif
  let node = s:Node(s:NODE_EXCMD)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let node.str = self.reader.getstr(self.ea.linepos, end)
  call self.add_node(node)
endfunction

function! s:VimLParser.separate_nextcmd()
  if self.ea.cmd.name ==# 'vimgrep' || self.ea.cmd.name ==# 'vimgrepadd' || self.ea.cmd.name ==# 'lvimgrep' || self.ea.cmd.name ==# 'lvimgrepadd'
    call self.skip_vimgrep_pat()
  endif
  let pc = ''
  let end = self.reader.getpos()
  let nospend = end
  while 1
    let end = self.reader.getpos()
    if !s:iswhite(pc)
      let nospend = end
    endif
    let c = self.reader.peek()
    if c ==# '<EOF>' || c ==# '<EOL>'
      break
    elseif c ==# "\<C-V>"
      call self.reader.get()
      let end = self.reader.getpos()
      let nospend = self.reader.getpos()
      let c = self.reader.peek()
      if c ==# '<EOF>' || c ==# '<EOL>'
        break
      endif
      call self.reader.get()
    elseif self.reader.peekn(2) ==# '`=' && self.ea.cmd.flags =~# '\<\(XFILE\|FILES\|FILE1\)\>'
      call self.reader.getn(2)
      call self.parse_expr()
      let c = self.reader.peekn(1)
      if c !=# '`'
        throw s:Err(printf('unexpected character: %s', c), self.reader.getpos())
      endif
      call self.reader.getn(1)
    elseif c ==# '|' || c ==# "\n" ||
          \ (c ==# '"' && self.ea.cmd.flags !~# '\<NOTRLCOM\>'
          \   && ((self.ea.cmd.name !=# '@' && self.ea.cmd.name !=# '*')
          \       || self.reader.getpos() !=# self.ea.argpos)
          \   && (self.ea.cmd.name !=# 'redir'
          \       || self.reader.getpos().i != self.ea.argpos.i + 1 || pc !=# '@'))
      let has_cpo_bar = 0 " &cpoptions =~ 'b'
      if (!has_cpo_bar || self.ea.cmd.flags !~# '\<USECTRLV\>') && pc ==# '\'
        call self.reader.get()
      else
        break
      endif
    else
      call self.reader.get()
    endif
    let pc = c
  endwhile
  if self.ea.cmd.flags !~# '\<NOTRLCOM\>'
    let end = nospend
  endif
  return end
endfunction

" FIXME
function! s:VimLParser.skip_vimgrep_pat()
  if self.reader.peekn(1) ==# ''
    " pass
  elseif s:isidc(self.reader.peekn(1))
    " :vimgrep pattern fname
    call self.reader.read_nonwhite()
  else
    " :vimgrep /pattern/[g][j] fname
    let c = self.reader.getn(1)
    let [pattern, endc] = self.parse_pattern(c)
    if c !=# endc
      return
    endif
    while self.reader.p(0) ==# 'g' || self.reader.p(0) ==# 'j'
      call self.reader.getn(1)
    endwhile
  endif
endfunction

function! s:VimLParser.parse_cmd_append()
  call self.reader.setpos(self.ea.linepos)
  let cmdline = self.reader.readline()
  let lines = [cmdline]
  let m = '.'
  while 1
    if self.reader.peek() ==# '<EOF>'
      break
    endif
    let line = self.reader.getn(-1)
    call add(lines, line)
    if line ==# m
      break
    endif
    call self.reader.get()
  endwhile
  let node = s:Node(s:NODE_EXCMD)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let node.str = join(lines, "\n")
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_cmd_insert()
  return self.parse_cmd_append()
endfunction

function! s:VimLParser.parse_cmd_loadkeymap()
  call self.reader.setpos(self.ea.linepos)
  let cmdline = self.reader.readline()
  let lines = [cmdline]
  while 1
    if self.reader.peek() ==# '<EOF>'
      break
    endif
    let line = self.reader.readline()
    call add(lines, line)
  endwhile
  let node = s:Node(s:NODE_EXCMD)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let node.str = join(lines, "\n")
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_cmd_lua()
  call self.reader.skip_white()
  if self.reader.peekn(2) ==# '<<'
    call self.reader.getn(2)
    call self.reader.skip_white()
    let m = self.reader.readline()
    if m ==# ''
      let m = '.'
    endif
    call self.reader.setpos(self.ea.linepos)
    let cmdline = self.reader.getn(-1)
    let lines = [cmdline]
    call self.reader.get()
    while 1
      if self.reader.peek() ==# '<EOF>'
        break
      endif
      let line = self.reader.getn(-1)
      call add(lines, line)
      if line ==# m
        break
      endif
      call self.reader.get()
    endwhile
  else
    call self.reader.setpos(self.ea.linepos)
    let cmdline = self.reader.getn(-1)
    let lines = [cmdline]
  endif
  let node = s:Node(s:NODE_EXCMD)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let node.str = join(lines, "\n")
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_cmd_mzscheme()
  return self.parse_cmd_lua()
endfunction

function! s:VimLParser.parse_cmd_perl()
  return self.parse_cmd_lua()
endfunction

function! s:VimLParser.parse_cmd_python()
  return self.parse_cmd_lua()
endfunction

function! s:VimLParser.parse_cmd_python3()
  return self.parse_cmd_lua()
endfunction

function! s:VimLParser.parse_cmd_ruby()
  return self.parse_cmd_lua()
endfunction

function! s:VimLParser.parse_cmd_tcl()
  return self.parse_cmd_lua()
endfunction

function! s:VimLParser.parse_cmd_finish()
  call self.parse_cmd_common()
  if self.context[0].type == s:NODE_TOPLEVEL
    call self.reader.seek_end(0)
  endif
endfunction

" FIXME
function! s:VimLParser.parse_cmd_usercmd()
  return self.parse_cmd_common()
endfunction

function! s:VimLParser.parse_cmd_function()
  let pos = self.reader.tell()
  call self.reader.skip_white()

  " :function
  if self.ends_excmds(self.reader.peek())
    call self.reader.seek_set(pos)
    return self.parse_cmd_common()
  endif

  " :function /pattern
  if self.reader.peekn(1) ==# '/'
    call self.reader.seek_set(pos)
    return self.parse_cmd_common()
  endif

  let left = self.parse_lvalue_func()
  call self.reader.skip_white()

  if left.type == s:NODE_IDENTIFIER
    let s = left.value
    if s[0] !=# '<' && !s:isupper(s[0]) && stridx(s, ':') == -1 && stridx(s, '#') == -1
      throw s:Err(printf('E128: Function name must start with a capital or contain a colon: %s', s), left.pos)
    endif
  endif

  " :function {name}
  if self.reader.peekn(1) !=# '('
    call self.reader.seek_set(pos)
    return self.parse_cmd_common()
  endif

  " :function[!] {name}([arguments]) [range] [abort] [dict]
  let node = s:Node(s:NODE_FUNCTION)
  let node.pos = self.ea.cmdpos
  let node.body = []
  let node.ea = self.ea
  let node.left = left
  let node.rlist = []
  let node.attr = {'range': 0, 'abort': 0, 'dict': 0}
  let node.endfunction = s:NIL
  call self.reader.getn(1)
  let tokenizer = s:ExprTokenizer.new(self.reader)
  if tokenizer.peek().type == s:TOKEN_PCLOSE
    call tokenizer.get()
  else
    let named = {}
    while 1
      let token = tokenizer.get()
      if token.type == s:TOKEN_IDENTIFIER
        if !s:isargname(token.value) || token.value ==# 'firstline' || token.value ==# 'lastline'
          throw s:Err(printf('E125: Illegal argument: %s', token.value), token.pos)
        elseif has_key(named, token.value)
          throw s:Err(printf('E853: Duplicate argument name: %s', token.value), token.pos)
        endif
        let named[token.value] = 1
        let varnode = s:Node(s:NODE_IDENTIFIER)
        let varnode.pos = token.pos
        let varnode.value = token.value
        call add(node.rlist, varnode)
        let token = tokenizer.get()
        if token.type == s:TOKEN_COMMA
        elseif token.type == s:TOKEN_PCLOSE
          break
        else
          throw s:Err(printf('unexpected token: %s', token.value), token.pos)
        endif
      elseif token.type == s:TOKEN_DOTDOTDOT
        let varnode = s:Node(s:NODE_IDENTIFIER)
        let varnode.pos = token.pos
        let varnode.value = token.value
        call add(node.rlist, varnode)
        let token = tokenizer.get()
        if token.type == s:TOKEN_PCLOSE
          break
        else
          throw s:Err(printf('unexpected token: %s', token.value), token.pos)
        endif
      else
        throw s:Err(printf('unexpected token: %s', token.value), token.pos)
      endif
    endwhile
  endif
  while 1
    call self.reader.skip_white()
    let epos = self.reader.getpos()
    let key = self.reader.read_alpha()
    if key ==# ''
      break
    elseif key ==# 'range'
      let node.attr.range = 1
    elseif key ==# 'abort'
      let node.attr.abort = 1
    elseif key ==# 'dict'
      let node.attr.dict = 1
    else
      throw s:Err(printf('unexpected token: %s', key), epos)
    endif
  endwhile
  call self.add_node(node)
  call self.push_context(node)
endfunction

function! s:VimLParser.parse_cmd_endfunction()
  call self.check_missing_endif('ENDFUNCTION', self.ea.cmdpos)
  call self.check_missing_endtry('ENDFUNCTION', self.ea.cmdpos)
  call self.check_missing_endwhile('ENDFUNCTION', self.ea.cmdpos)
  call self.check_missing_endfor('ENDFUNCTION', self.ea.cmdpos)
  if self.context[0].type != s:NODE_FUNCTION
    throw s:Err('E193: :endfunction not inside a function', self.ea.cmdpos)
  endif
  call self.reader.getn(-1)
  let node = s:Node(s:NODE_ENDFUNCTION)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let self.context[0].endfunction = node
  call self.pop_context()
endfunction

function! s:VimLParser.parse_cmd_delfunction()
  let node = s:Node(s:NODE_DELFUNCTION)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let node.left = self.parse_lvalue_func()
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_cmd_return()
  if self.find_context(s:NODE_FUNCTION) == -1
    throw s:Err('E133: :return not inside a function', self.ea.cmdpos)
  endif
  let node = s:Node(s:NODE_RETURN)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let node.left = s:NIL
  call self.reader.skip_white()
  let c = self.reader.peek()
  if c ==# '"' || !self.ends_excmds(c)
    let node.left = self.parse_expr()
  endif
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_cmd_call()
  let node = s:Node(s:NODE_EXCALL)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  call self.reader.skip_white()
  let c = self.reader.peek()
  if self.ends_excmds(c)
    throw s:Err('E471: Argument required', self.reader.getpos())
  endif
  let node.left = self.parse_expr()
  if node.left.type != s:NODE_CALL
    throw s:Err('Not an function call', node.left.pos)
  endif
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_cmd_let()
  let pos = self.reader.tell()
  call self.reader.skip_white()

  " :let
  if self.ends_excmds(self.reader.peek())
    call self.reader.seek_set(pos)
    return self.parse_cmd_common()
  endif

  let lhs = self.parse_letlhs()
  call self.reader.skip_white()
  let s1 = self.reader.peekn(1)
  let s2 = self.reader.peekn(2)

  " :let {var-name} ..
  if self.ends_excmds(s1) || (s2 !=# '+=' && s2 !=# '-=' && s2 !=# '.=' && s1 !=# '=')
    call self.reader.seek_set(pos)
    return self.parse_cmd_common()
  endif

  " :let left op right
  let node = s:Node(s:NODE_LET)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let node.op = ''
  let node.left = lhs.left
  let node.list = lhs.list
  let node.rest = lhs.rest
  let node.right = s:NIL
  if s2 ==# '+=' || s2 ==# '-=' || s2 ==# '.='
    call self.reader.getn(2)
    let node.op = s2
  elseif s1 ==# '='
    call self.reader.getn(1)
    let node.op = s1
  else
    throw 'NOT REACHED'
  endif
  let node.right = self.parse_expr()
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_cmd_unlet()
  let node = s:Node(s:NODE_UNLET)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let node.list = self.parse_lvaluelist()
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_cmd_lockvar()
  let node = s:Node(s:NODE_LOCKVAR)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let node.depth = s:NIL
  let node.list = []
  call self.reader.skip_white()
  if s:isdigit(self.reader.peekn(1))
    let node.depth = str2nr(self.reader.read_digit(), 10)
  endif
  let node.list = self.parse_lvaluelist()
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_cmd_unlockvar()
  let node = s:Node(s:NODE_UNLOCKVAR)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let node.depth = s:NIL
  let node.list = []
  call self.reader.skip_white()
  if s:isdigit(self.reader.peekn(1))
    let node.depth = str2nr(self.reader.read_digit(), 10)
  endif
  let node.list = self.parse_lvaluelist()
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_cmd_if()
  let node = s:Node(s:NODE_IF)
  let node.pos = self.ea.cmdpos
  let node.body = []
  let node.ea = self.ea
  let node.cond = self.parse_expr()
  let node.elseif = []
  let node.else = s:NIL
  let node.endif = s:NIL
  call self.add_node(node)
  call self.push_context(node)
endfunction

function! s:VimLParser.parse_cmd_elseif()
  if self.context[0].type != s:NODE_IF && self.context[0].type != s:NODE_ELSEIF
    throw s:Err('E582: :elseif without :if', self.ea.cmdpos)
  endif
  if self.context[0].type != s:NODE_IF
    call self.pop_context()
  endif
  let node = s:Node(s:NODE_ELSEIF)
  let node.pos = self.ea.cmdpos
  let node.body = []
  let node.ea = self.ea
  let node.cond = self.parse_expr()
  call add(self.context[0].elseif, node)
  call self.push_context(node)
endfunction

function! s:VimLParser.parse_cmd_else()
  if self.context[0].type != s:NODE_IF && self.context[0].type != s:NODE_ELSEIF
    throw s:Err('E581: :else without :if', self.ea.cmdpos)
  endif
  if self.context[0].type != s:NODE_IF
    call self.pop_context()
  endif
  let node = s:Node(s:NODE_ELSE)
  let node.pos = self.ea.cmdpos
  let node.body = []
  let node.ea = self.ea
  let self.context[0].else = node
  call self.push_context(node)
endfunction

function! s:VimLParser.parse_cmd_endif()
  if self.context[0].type != s:NODE_IF && self.context[0].type != s:NODE_ELSEIF && self.context[0].type != s:NODE_ELSE
    throw s:Err('E580: :endif without :if', self.ea.cmdpos)
  endif
  if self.context[0].type != s:NODE_IF
    call self.pop_context()
  endif
  let node = s:Node(s:NODE_ENDIF)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let self.context[0].endif = node
  call self.pop_context()
endfunction

function! s:VimLParser.parse_cmd_while()
  let node = s:Node(s:NODE_WHILE)
  let node.pos = self.ea.cmdpos
  let node.body = []
  let node.ea = self.ea
  let node.cond = self.parse_expr()
  let node.endwhile = s:NIL
  call self.add_node(node)
  call self.push_context(node)
endfunction

function! s:VimLParser.parse_cmd_endwhile()
  if self.context[0].type != s:NODE_WHILE
    throw s:Err('E588: :endwhile without :while', self.ea.cmdpos)
  endif
  let node = s:Node(s:NODE_ENDWHILE)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let self.context[0].endwhile = node
  call self.pop_context()
endfunction

function! s:VimLParser.parse_cmd_for()
  let node = s:Node(s:NODE_FOR)
  let node.pos = self.ea.cmdpos
  let node.body = []
  let node.ea = self.ea
  let node.left = s:NIL
  let node.right = s:NIL
  let node.endfor = s:NIL
  let lhs = self.parse_letlhs()
  let node.left = lhs.left
  let node.list = lhs.list
  let node.rest = lhs.rest
  call self.reader.skip_white()
  let epos = self.reader.getpos()
  if self.reader.read_alpha() !=# 'in'
    throw s:Err('Missing "in" after :for', epos)
  endif
  let node.right = self.parse_expr()
  call self.add_node(node)
  call self.push_context(node)
endfunction

function! s:VimLParser.parse_cmd_endfor()
  if self.context[0].type != s:NODE_FOR
    throw s:Err('E588: :endfor without :for', self.ea.cmdpos)
  endif
  let node = s:Node(s:NODE_ENDFOR)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let self.context[0].endfor = node
  call self.pop_context()
endfunction

function! s:VimLParser.parse_cmd_continue()
  if self.find_context(s:NODE_WHILE) == -1 && self.find_context(s:NODE_FOR) == -1
    throw s:Err('E586: :continue without :while or :for', self.ea.cmdpos)
  endif
  let node = s:Node(s:NODE_CONTINUE)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_cmd_break()
  if self.find_context(s:NODE_WHILE) == -1 && self.find_context(s:NODE_FOR) == -1
    throw s:Err('E587: :break without :while or :for', self.ea.cmdpos)
  endif
  let node = s:Node(s:NODE_BREAK)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_cmd_try()
  let node = s:Node(s:NODE_TRY)
  let node.pos = self.ea.cmdpos
  let node.body = []
  let node.ea = self.ea
  let node.catch = []
  let node.finally = s:NIL
  let node.endtry = s:NIL
  call self.add_node(node)
  call self.push_context(node)
endfunction

function! s:VimLParser.parse_cmd_catch()
  if self.context[0].type == s:NODE_FINALLY
    throw s:Err('E604: :catch after :finally', self.ea.cmdpos)
  elseif self.context[0].type != s:NODE_TRY && self.context[0].type != s:NODE_CATCH
    throw s:Err('E603: :catch without :try', self.ea.cmdpos)
  endif
  if self.context[0].type != s:NODE_TRY
    call self.pop_context()
  endif
  let node = s:Node(s:NODE_CATCH)
  let node.pos = self.ea.cmdpos
  let node.body = []
  let node.ea = self.ea
  let node.pattern = s:NIL
  call self.reader.skip_white()
  if !self.ends_excmds(self.reader.peek())
    let [node.pattern, endc] = self.parse_pattern(self.reader.get())
  endif
  call add(self.context[0].catch, node)
  call self.push_context(node)
endfunction

function! s:VimLParser.parse_cmd_finally()
  if self.context[0].type != s:NODE_TRY && self.context[0].type != s:NODE_CATCH
    throw s:Err('E606: :finally without :try', self.ea.cmdos)
  endif
  if self.context[0].type != s:NODE_TRY
    call self.pop_context()
  endif
  let node = s:Node(s:NODE_FINALLY)
  let node.pos = self.ea.cmdpos
  let node.body = []
  let node.ea = self.ea
  let self.context[0].finally = node
  call self.push_context(node)
endfunction

function! s:VimLParser.parse_cmd_endtry()
  if self.context[0].type != s:NODE_TRY && self.context[0].type != s:NODE_CATCH && self.context[0].type != s:NODE_FINALLY
    throw s:Err('E602: :endtry without :try', self.ea.cmdpos)
  endif
  if self.context[0].type != s:NODE_TRY
    call self.pop_context()
  endif
  let node = s:Node(s:NODE_ENDTRY)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let self.context[0].endtry = node
  call self.pop_context()
endfunction

function! s:VimLParser.parse_cmd_throw()
  let node = s:Node(s:NODE_THROW)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let node.left = self.parse_expr()
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_cmd_echo()
  let node = s:Node(s:NODE_ECHO)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let node.list = self.parse_exprlist()
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_cmd_echon()
  let node = s:Node(s:NODE_ECHON)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let node.list = self.parse_exprlist()
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_cmd_echohl()
  let node = s:Node(s:NODE_ECHOHL)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let node.str = ''
  while !self.ends_excmds(self.reader.peek())
    let node.str .= self.reader.get()
  endwhile
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_cmd_echomsg()
  let node = s:Node(s:NODE_ECHOMSG)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let node.list = self.parse_exprlist()
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_cmd_echoerr()
  let node = s:Node(s:NODE_ECHOERR)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let node.list = self.parse_exprlist()
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_cmd_execute()
  let node = s:Node(s:NODE_EXECUTE)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let node.list = self.parse_exprlist()
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_expr()
  return s:ExprParser.new(self.reader).parse()
endfunction

function! s:VimLParser.parse_exprlist()
  let list = []
  while 1
    call self.reader.skip_white()
    let c = self.reader.peek()
    if c !=# '"' && self.ends_excmds(c)
      break
    endif
    let node = self.parse_expr()
    call add(list, node)
  endwhile
  return list
endfunction

function! s:VimLParser.parse_lvalue_func()
  let p = s:LvalueParser.new(self.reader)
  let node = p.parse()
  if node.type == s:NODE_IDENTIFIER || node.type == s:NODE_CURLYNAME || node.type == s:NODE_SUBSCRIPT || node.type == s:NODE_DOT || node.type == s:NODE_OPTION || node.type == s:NODE_ENV || node.type == s:NODE_REG
    return node
  endif
  throw s:Err('Invalid Expression', node.pos)
endfunction

" FIXME:
function! s:VimLParser.parse_lvalue()
  let p = s:LvalueParser.new(self.reader)
  let node = p.parse()
  if node.type == s:NODE_IDENTIFIER
    if !s:isvarname(node.value)
      throw s:Err(printf('E461: Illegal variable name: %s', node.value), node.pos)
    endif
  endif
  if node.type == s:NODE_IDENTIFIER || node.type == s:NODE_CURLYNAME || node.type == s:NODE_SUBSCRIPT || node.type == s:NODE_DOT || node.type == s:NODE_OPTION || node.type == s:NODE_ENV || node.type == s:NODE_REG
    return node
  endif
  throw s:Err('Invalid Expression', node.pos)
endfunction

function! s:VimLParser.parse_lvaluelist()
  let list = []
  let node = self.parse_expr()
  call add(list, node)
  while 1
    call self.reader.skip_white()
    if self.ends_excmds(self.reader.peek())
      break
    endif
    let node = self.parse_lvalue()
    call add(list, node)
  endwhile
  return list
endfunction

" FIXME:
function! s:VimLParser.parse_letlhs()
  let lhs = {'left': s:NIL, 'list': s:NIL, 'rest': s:NIL}
  let tokenizer = s:ExprTokenizer.new(self.reader)
  if tokenizer.peek().type == s:TOKEN_SQOPEN
    call tokenizer.get()
    let lhs.list = []
    while 1
      let node = self.parse_lvalue()
      call add(lhs.list, node)
      let token = tokenizer.get()
      if token.type == s:TOKEN_SQCLOSE
        break
      elseif token.type == s:TOKEN_COMMA
        continue
      elseif token.type == s:TOKEN_SEMICOLON
        let node = self.parse_lvalue()
        let lhs.rest = node
        let token = tokenizer.get()
        if token.type == s:TOKEN_SQCLOSE
          break
        else
          throw s:Err(printf('E475 Invalid argument: %s', token.value), token.pos)
        endif
      else
        throw s:Err(printf('E475 Invalid argument: %s', token.value), token.pos)
      endif
    endwhile
  else
    let lhs.left = self.parse_lvalue()
  endif
  return lhs
endfunction

function! s:VimLParser.ends_excmds(c)
  return a:c ==# '' || a:c ==# '|' || a:c ==# '"' || a:c ==# '<EOF>' || a:c ==# '<EOL>'
endfunction

let s:VimLParser.builtin_commands = [
      \ {'name': 'append', 'minlen': 1, 'flags': 'BANG|RANGE|ZEROR|TRLBAR|CMDWIN|MODIFY', 'parser': 'parse_cmd_append'},
      \ {'name': 'abbreviate', 'minlen': 2, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'abclear', 'minlen': 3, 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'aboveleft', 'minlen': 3, 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'all', 'minlen': 2, 'flags': 'BANG|RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'amenu', 'minlen': 2, 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'anoremenu', 'minlen': 2, 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'args', 'minlen': 2, 'flags': 'BANG|FILES|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'argadd', 'minlen': 4, 'flags': 'BANG|NEEDARG|RANGE|NOTADR|ZEROR|FILES|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'argdelete', 'minlen': 4, 'flags': 'BANG|RANGE|NOTADR|FILES|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'argedit', 'minlen': 4, 'flags': 'BANG|NEEDARG|RANGE|NOTADR|FILE1|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'argdo', 'minlen': 5, 'flags': 'BANG|NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'argglobal', 'minlen': 4, 'flags': 'BANG|FILES|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'arglocal', 'minlen': 4, 'flags': 'BANG|FILES|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'argument', 'minlen': 4, 'flags': 'BANG|RANGE|NOTADR|COUNT|EXTRA|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'ascii', 'minlen': 2, 'flags': 'TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'autocmd', 'minlen': 2, 'flags': 'BANG|EXTRA|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'augroup', 'minlen': 3, 'flags': 'BANG|WORD1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'aunmenu', 'minlen': 3, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'buffer', 'minlen': 1, 'flags': 'BANG|RANGE|NOTADR|BUFNAME|BUFUNL|COUNT|EXTRA|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'bNext', 'minlen': 2, 'flags': 'BANG|RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'ball', 'minlen': 2, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'badd', 'minlen': 3, 'flags': 'NEEDARG|FILE1|EDITCMD|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'bdelete', 'minlen': 2, 'flags': 'BANG|RANGE|NOTADR|BUFNAME|COUNT|EXTRA|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'behave', 'minlen': 2, 'flags': 'NEEDARG|WORD1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'belowright', 'minlen': 3, 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'bfirst', 'minlen': 2, 'flags': 'BANG|RANGE|NOTADR|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'blast', 'minlen': 2, 'flags': 'BANG|RANGE|NOTADR|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'bmodified', 'minlen': 2, 'flags': 'BANG|RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'bnext', 'minlen': 2, 'flags': 'BANG|RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'botright', 'minlen': 2, 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'bprevious', 'minlen': 2, 'flags': 'BANG|RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'brewind', 'minlen': 2, 'flags': 'BANG|RANGE|NOTADR|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'break', 'minlen': 4, 'flags': 'TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_break'},
      \ {'name': 'breakadd', 'minlen': 6, 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'breakdel', 'minlen': 6, 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'breaklist', 'minlen': 6, 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'browse', 'minlen': 3, 'flags': 'NEEDARG|EXTRA|NOTRLCOM|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'bufdo', 'minlen': 5, 'flags': 'BANG|NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'buffers', 'minlen': 7, 'flags': 'BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'bunload', 'minlen': 3, 'flags': 'BANG|RANGE|NOTADR|BUFNAME|COUNT|EXTRA|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'bwipeout', 'minlen': 2, 'flags': 'BANG|RANGE|NOTADR|BUFNAME|BUFUNL|COUNT|EXTRA|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'change', 'minlen': 1, 'flags': 'BANG|WHOLEFOLD|RANGE|COUNT|TRLBAR|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'cNext', 'minlen': 2, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'cNfile', 'minlen': 3, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'cabbrev', 'minlen': 2, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'cabclear', 'minlen': 4, 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'caddbuffer', 'minlen': 5, 'flags': 'RANGE|NOTADR|WORD1|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'caddexpr', 'minlen': 3, 'flags': 'NEEDARG|WORD1|NOTRLCOM|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'caddfile', 'minlen': 5, 'flags': 'TRLBAR|FILE1', 'parser': 'parse_cmd_common'},
      \ {'name': 'call', 'minlen': 3, 'flags': 'RANGE|NEEDARG|EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_call'},
      \ {'name': 'catch', 'minlen': 3, 'flags': 'EXTRA|SBOXOK|CMDWIN', 'parser': 'parse_cmd_catch'},
      \ {'name': 'cbuffer', 'minlen': 2, 'flags': 'BANG|RANGE|NOTADR|WORD1|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'cc', 'minlen': 2, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'cclose', 'minlen': 3, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'cd', 'minlen': 2, 'flags': 'BANG|FILE1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'center', 'minlen': 2, 'flags': 'TRLBAR|RANGE|WHOLEFOLD|EXTRA|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'cexpr', 'minlen': 3, 'flags': 'NEEDARG|WORD1|NOTRLCOM|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'cfile', 'minlen': 2, 'flags': 'TRLBAR|FILE1|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'cfirst', 'minlen': 4, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'cgetbuffer', 'minlen': 5, 'flags': 'RANGE|NOTADR|WORD1|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'cgetexpr', 'minlen': 5, 'flags': 'NEEDARG|WORD1|NOTRLCOM|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'cgetfile', 'minlen': 2, 'flags': 'TRLBAR|FILE1', 'parser': 'parse_cmd_common'},
      \ {'name': 'changes', 'minlen': 7, 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'chdir', 'minlen': 3, 'flags': 'BANG|FILE1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'checkpath', 'minlen': 3, 'flags': 'TRLBAR|BANG|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'checktime', 'minlen': 6, 'flags': 'RANGE|NOTADR|BUFNAME|COUNT|EXTRA|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'clist', 'minlen': 2, 'flags': 'BANG|EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'clast', 'minlen': 3, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'close', 'minlen': 3, 'flags': 'BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'cmap', 'minlen': 2, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'cmapclear', 'minlen': 5, 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'cmenu', 'minlen': 3, 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'cnext', 'minlen': 2, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'cnewer', 'minlen': 4, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'cnfile', 'minlen': 3, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'cnoremap', 'minlen': 3, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'cnoreabbrev', 'minlen': 6, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'cnoremenu', 'minlen': 7, 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'copy', 'minlen': 2, 'flags': 'RANGE|WHOLEFOLD|EXTRA|TRLBAR|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'colder', 'minlen': 3, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'colorscheme', 'minlen': 4, 'flags': 'WORD1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'command', 'minlen': 3, 'flags': 'EXTRA|BANG|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'comclear', 'minlen': 4, 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'compiler', 'minlen': 4, 'flags': 'BANG|TRLBAR|WORD1|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'continue', 'minlen': 3, 'flags': 'TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_continue'},
      \ {'name': 'confirm', 'minlen': 4, 'flags': 'NEEDARG|EXTRA|NOTRLCOM|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'copen', 'minlen': 4, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'cprevious', 'minlen': 2, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'cpfile', 'minlen': 3, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'cquit', 'minlen': 2, 'flags': 'TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'crewind', 'minlen': 2, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'cscope', 'minlen': 2, 'flags': 'EXTRA|NOTRLCOM|XFILE', 'parser': 'parse_cmd_common'},
      \ {'name': 'cstag', 'minlen': 3, 'flags': 'BANG|TRLBAR|WORD1', 'parser': 'parse_cmd_common'},
      \ {'name': 'cunmap', 'minlen': 2, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'cunabbrev', 'minlen': 4, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'cunmenu', 'minlen': 5, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'cwindow', 'minlen': 2, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'delete', 'minlen': 1, 'flags': 'RANGE|WHOLEFOLD|REGSTR|COUNT|TRLBAR|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'delmarks', 'minlen': 4, 'flags': 'BANG|EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'debug', 'minlen': 3, 'flags': 'NEEDARG|EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'debuggreedy', 'minlen': 6, 'flags': 'RANGE|NOTADR|ZEROR|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'delcommand', 'minlen': 4, 'flags': 'NEEDARG|WORD1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'delfunction', 'minlen': 4, 'flags': 'NEEDARG|WORD1|CMDWIN', 'parser': 'parse_cmd_delfunction'},
      \ {'name': 'diffupdate', 'minlen': 3, 'flags': 'BANG|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'diffget', 'minlen': 5, 'flags': 'RANGE|EXTRA|TRLBAR|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'diffoff', 'minlen': 5, 'flags': 'BANG|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'diffpatch', 'minlen': 5, 'flags': 'EXTRA|FILE1|TRLBAR|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'diffput', 'minlen': 6, 'flags': 'RANGE|EXTRA|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'diffsplit', 'minlen': 5, 'flags': 'EXTRA|FILE1|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'diffthis', 'minlen': 8, 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'digraphs', 'minlen': 3, 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'display', 'minlen': 2, 'flags': 'EXTRA|NOTRLCOM|TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'djump', 'minlen': 2, 'flags': 'BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA', 'parser': 'parse_cmd_common'},
      \ {'name': 'dlist', 'minlen': 2, 'flags': 'BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'doautocmd', 'minlen': 2, 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'doautoall', 'minlen': 7, 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'drop', 'minlen': 2, 'flags': 'FILES|EDITCMD|NEEDARG|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'dsearch', 'minlen': 2, 'flags': 'BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'dsplit', 'minlen': 3, 'flags': 'BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA', 'parser': 'parse_cmd_common'},
      \ {'name': 'edit', 'minlen': 1, 'flags': 'BANG|FILE1|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'earlier', 'minlen': 2, 'flags': 'TRLBAR|EXTRA|NOSPC|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'echo', 'minlen': 2, 'flags': 'EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_echo'},
      \ {'name': 'echoerr', 'minlen': 5, 'flags': 'EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_echoerr'},
      \ {'name': 'echohl', 'minlen': 5, 'flags': 'EXTRA|TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_echohl'},
      \ {'name': 'echomsg', 'minlen': 5, 'flags': 'EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_echomsg'},
      \ {'name': 'echon', 'minlen': 5, 'flags': 'EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_echon'},
      \ {'name': 'else', 'minlen': 2, 'flags': 'TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_else'},
      \ {'name': 'elseif', 'minlen': 5, 'flags': 'EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_elseif'},
      \ {'name': 'emenu', 'minlen': 2, 'flags': 'NEEDARG|EXTRA|TRLBAR|NOTRLCOM|RANGE|NOTADR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'endif', 'minlen': 2, 'flags': 'TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_endif'},
      \ {'name': 'endfor', 'minlen': 5, 'flags': 'TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_endfor'},
      \ {'name': 'endfunction', 'minlen': 4, 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_endfunction'},
      \ {'name': 'endtry', 'minlen': 4, 'flags': 'TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_endtry'},
      \ {'name': 'endwhile', 'minlen': 4, 'flags': 'TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_endwhile'},
      \ {'name': 'enew', 'minlen': 3, 'flags': 'BANG|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'ex', 'minlen': 2, 'flags': 'BANG|FILE1|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'execute', 'minlen': 3, 'flags': 'EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_execute'},
      \ {'name': 'exit', 'minlen': 3, 'flags': 'RANGE|WHOLEFOLD|BANG|FILE1|ARGOPT|DFLALL|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'exusage', 'minlen': 3, 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'file', 'minlen': 1, 'flags': 'RANGE|NOTADR|ZEROR|BANG|FILE1|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'files', 'minlen': 5, 'flags': 'BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'filetype', 'minlen': 5, 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'find', 'minlen': 3, 'flags': 'RANGE|NOTADR|BANG|FILE1|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'finally', 'minlen': 4, 'flags': 'TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_finally'},
      \ {'name': 'finish', 'minlen': 4, 'flags': 'TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_finish'},
      \ {'name': 'first', 'minlen': 3, 'flags': 'EXTRA|BANG|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'fixdel', 'minlen': 3, 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'fold', 'minlen': 2, 'flags': 'RANGE|WHOLEFOLD|TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'foldclose', 'minlen': 5, 'flags': 'RANGE|BANG|WHOLEFOLD|TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'folddoopen', 'minlen': 5, 'flags': 'RANGE|DFLALL|NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'folddoclosed', 'minlen': 7, 'flags': 'RANGE|DFLALL|NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'foldopen', 'minlen': 5, 'flags': 'RANGE|BANG|WHOLEFOLD|TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'for', 'minlen': 3, 'flags': 'EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_for'},
      \ {'name': 'function', 'minlen': 2, 'flags': 'EXTRA|BANG|CMDWIN', 'parser': 'parse_cmd_function'},
      \ {'name': 'global', 'minlen': 1, 'flags': 'RANGE|WHOLEFOLD|BANG|EXTRA|DFLALL|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'goto', 'minlen': 2, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'grep', 'minlen': 2, 'flags': 'RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE', 'parser': 'parse_cmd_common'},
      \ {'name': 'grepadd', 'minlen': 5, 'flags': 'RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE', 'parser': 'parse_cmd_common'},
      \ {'name': 'gui', 'minlen': 2, 'flags': 'BANG|FILES|EDITCMD|ARGOPT|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'gvim', 'minlen': 2, 'flags': 'BANG|FILES|EDITCMD|ARGOPT|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'hardcopy', 'minlen': 2, 'flags': 'RANGE|COUNT|EXTRA|TRLBAR|DFLALL|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'help', 'minlen': 1, 'flags': 'BANG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'helpfind', 'minlen': 5, 'flags': 'EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'helpgrep', 'minlen': 5, 'flags': 'EXTRA|NOTRLCOM|NEEDARG', 'parser': 'parse_cmd_common'},
      \ {'name': 'helptags', 'minlen': 5, 'flags': 'NEEDARG|FILES|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'highlight', 'minlen': 2, 'flags': 'BANG|EXTRA|TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'hide', 'minlen': 3, 'flags': 'BANG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'history', 'minlen': 3, 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'insert', 'minlen': 1, 'flags': 'BANG|RANGE|TRLBAR|CMDWIN|MODIFY', 'parser': 'parse_cmd_insert'},
      \ {'name': 'iabbrev', 'minlen': 2, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'iabclear', 'minlen': 4, 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'if', 'minlen': 2, 'flags': 'EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_if'},
      \ {'name': 'ijump', 'minlen': 2, 'flags': 'BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA', 'parser': 'parse_cmd_common'},
      \ {'name': 'ilist', 'minlen': 2, 'flags': 'BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'imap', 'minlen': 2, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'imapclear', 'minlen': 5, 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'imenu', 'minlen': 3, 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'inoremap', 'minlen': 3, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'inoreabbrev', 'minlen': 6, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'inoremenu', 'minlen': 7, 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'intro', 'minlen': 3, 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'isearch', 'minlen': 2, 'flags': 'BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'isplit', 'minlen': 3, 'flags': 'BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA', 'parser': 'parse_cmd_common'},
      \ {'name': 'iunmap', 'minlen': 2, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'iunabbrev', 'minlen': 4, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'iunmenu', 'minlen': 5, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'join', 'minlen': 1, 'flags': 'BANG|RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'jumps', 'minlen': 2, 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'k', 'minlen': 1, 'flags': 'RANGE|WORD1|TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'keepalt', 'minlen': 5, 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'keepmarks', 'minlen': 3, 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'keepjumps', 'minlen': 5, 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'lNext', 'minlen': 2, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'lNfile', 'minlen': 3, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'list', 'minlen': 1, 'flags': 'RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'laddexpr', 'minlen': 3, 'flags': 'NEEDARG|WORD1|NOTRLCOM|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'laddbuffer', 'minlen': 5, 'flags': 'RANGE|NOTADR|WORD1|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'laddfile', 'minlen': 5, 'flags': 'TRLBAR|FILE1', 'parser': 'parse_cmd_common'},
      \ {'name': 'last', 'minlen': 2, 'flags': 'EXTRA|BANG|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'language', 'minlen': 3, 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'later', 'minlen': 3, 'flags': 'TRLBAR|EXTRA|NOSPC|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'lbuffer', 'minlen': 2, 'flags': 'BANG|RANGE|NOTADR|WORD1|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'lcd', 'minlen': 2, 'flags': 'BANG|FILE1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'lchdir', 'minlen': 3, 'flags': 'BANG|FILE1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'lclose', 'minlen': 3, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'lcscope', 'minlen': 3, 'flags': 'EXTRA|NOTRLCOM|XFILE', 'parser': 'parse_cmd_common'},
      \ {'name': 'left', 'minlen': 2, 'flags': 'TRLBAR|RANGE|WHOLEFOLD|EXTRA|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'leftabove', 'minlen': 5, 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'let', 'minlen': 3, 'flags': 'EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_let'},
      \ {'name': 'lexpr', 'minlen': 3, 'flags': 'NEEDARG|WORD1|NOTRLCOM|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'lfile', 'minlen': 2, 'flags': 'TRLBAR|FILE1|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'lfirst', 'minlen': 4, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'lgetbuffer', 'minlen': 5, 'flags': 'RANGE|NOTADR|WORD1|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'lgetexpr', 'minlen': 5, 'flags': 'NEEDARG|WORD1|NOTRLCOM|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'lgetfile', 'minlen': 2, 'flags': 'TRLBAR|FILE1', 'parser': 'parse_cmd_common'},
      \ {'name': 'lgrep', 'minlen': 3, 'flags': 'RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE', 'parser': 'parse_cmd_common'},
      \ {'name': 'lgrepadd', 'minlen': 6, 'flags': 'RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE', 'parser': 'parse_cmd_common'},
      \ {'name': 'lhelpgrep', 'minlen': 2, 'flags': 'EXTRA|NOTRLCOM|NEEDARG', 'parser': 'parse_cmd_common'},
      \ {'name': 'll', 'minlen': 2, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'llast', 'minlen': 3, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'list', 'minlen': 3, 'flags': 'BANG|EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'lmake', 'minlen': 4, 'flags': 'BANG|EXTRA|NOTRLCOM|TRLBAR|XFILE', 'parser': 'parse_cmd_common'},
      \ {'name': 'lmap', 'minlen': 2, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'lmapclear', 'minlen': 5, 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'lnext', 'minlen': 3, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'lnewer', 'minlen': 4, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'lnfile', 'minlen': 3, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'lnoremap', 'minlen': 2, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'loadkeymap', 'minlen': 5, 'flags': 'CMDWIN', 'parser': 'parse_cmd_loadkeymap'},
      \ {'name': 'loadview', 'minlen': 2, 'flags': 'FILE1|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'lockmarks', 'minlen': 3, 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'lockvar', 'minlen': 5, 'flags': 'BANG|EXTRA|NEEDARG|SBOXOK|CMDWIN', 'parser': 'parse_cmd_lockvar'},
      \ {'name': 'lolder', 'minlen': 3, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'lopen', 'minlen': 4, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'lprevious', 'minlen': 2, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'lpfile', 'minlen': 3, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'lrewind', 'minlen': 2, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'ls', 'minlen': 2, 'flags': 'BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'ltag', 'minlen': 2, 'flags': 'NOTADR|TRLBAR|BANG|WORD1', 'parser': 'parse_cmd_common'},
      \ {'name': 'lunmap', 'minlen': 2, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'lua', 'minlen': 3, 'flags': 'RANGE|EXTRA|NEEDARG|CMDWIN', 'parser': 'parse_cmd_lua'},
      \ {'name': 'luado', 'minlen': 4, 'flags': 'RANGE|DFLALL|EXTRA|NEEDARG|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'luafile', 'minlen': 4, 'flags': 'RANGE|FILE1|NEEDARG|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'lvimgrep', 'minlen': 2, 'flags': 'RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE', 'parser': 'parse_cmd_common'},
      \ {'name': 'lvimgrepadd', 'minlen': 9, 'flags': 'RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE', 'parser': 'parse_cmd_common'},
      \ {'name': 'lwindow', 'minlen': 2, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'move', 'minlen': 1, 'flags': 'RANGE|WHOLEFOLD|EXTRA|TRLBAR|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'mark', 'minlen': 2, 'flags': 'RANGE|WORD1|TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'make', 'minlen': 3, 'flags': 'BANG|EXTRA|NOTRLCOM|TRLBAR|XFILE', 'parser': 'parse_cmd_common'},
      \ {'name': 'map', 'minlen': 3, 'flags': 'BANG|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'mapclear', 'minlen': 4, 'flags': 'EXTRA|BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'marks', 'minlen': 5, 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'match', 'minlen': 3, 'flags': 'RANGE|NOTADR|EXTRA|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'menu', 'minlen': 2, 'flags': 'RANGE|NOTADR|ZEROR|BANG|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'menutranslate', 'minlen': 5, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'messages', 'minlen': 3, 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'mkexrc', 'minlen': 2, 'flags': 'BANG|FILE1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'mksession', 'minlen': 3, 'flags': 'BANG|FILE1|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'mkspell', 'minlen': 4, 'flags': 'BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE', 'parser': 'parse_cmd_common'},
      \ {'name': 'mkvimrc', 'minlen': 3, 'flags': 'BANG|FILE1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'mkview', 'minlen': 5, 'flags': 'BANG|FILE1|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'mode', 'minlen': 3, 'flags': 'WORD1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'mzscheme', 'minlen': 2, 'flags': 'RANGE|EXTRA|DFLALL|NEEDARG|CMDWIN|SBOXOK', 'parser': 'parse_cmd_mzscheme'},
      \ {'name': 'mzfile', 'minlen': 3, 'flags': 'RANGE|FILE1|NEEDARG|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'nbclose', 'minlen': 3, 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'nbkey', 'minlen': 2, 'flags': 'EXTRA|NOTADR|NEEDARG', 'parser': 'parse_cmd_common'},
      \ {'name': 'nbstart', 'minlen': 3, 'flags': 'WORD1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'next', 'minlen': 1, 'flags': 'RANGE|NOTADR|BANG|FILES|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'new', 'minlen': 3, 'flags': 'BANG|FILE1|RANGE|NOTADR|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'nmap', 'minlen': 2, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'nmapclear', 'minlen': 5, 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'nmenu', 'minlen': 3, 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'nnoremap', 'minlen': 2, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'nnoremenu', 'minlen': 7, 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'noautocmd', 'minlen': 3, 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'noremap', 'minlen': 2, 'flags': 'BANG|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'nohlsearch', 'minlen': 3, 'flags': 'TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'noreabbrev', 'minlen': 5, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'noremenu', 'minlen': 6, 'flags': 'RANGE|NOTADR|ZEROR|BANG|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'normal', 'minlen': 4, 'flags': 'RANGE|BANG|EXTRA|NEEDARG|NOTRLCOM|USECTRLV|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'number', 'minlen': 2, 'flags': 'RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'nunmap', 'minlen': 3, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'nunmenu', 'minlen': 5, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'oldfiles', 'minlen': 2, 'flags': 'BANG|TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'open', 'minlen': 1, 'flags': 'RANGE|BANG|EXTRA', 'parser': 'parse_cmd_common'},
      \ {'name': 'omap', 'minlen': 2, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'omapclear', 'minlen': 5, 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'omenu', 'minlen': 3, 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'only', 'minlen': 2, 'flags': 'BANG|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'onoremap', 'minlen': 3, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'onoremenu', 'minlen': 7, 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'options', 'minlen': 3, 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'ounmap', 'minlen': 2, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'ounmenu', 'minlen': 5, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'ownsyntax', 'minlen': 2, 'flags': 'EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'pclose', 'minlen': 2, 'flags': 'BANG|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'pedit', 'minlen': 3, 'flags': 'BANG|FILE1|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'perl', 'minlen': 2, 'flags': 'RANGE|EXTRA|DFLALL|NEEDARG|SBOXOK|CMDWIN', 'parser': 'parse_cmd_perl'},
      \ {'name': 'print', 'minlen': 1, 'flags': 'RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN|SBOXOK', 'parser': 'parse_cmd_common'},
      \ {'name': 'profdel', 'minlen': 5, 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'profile', 'minlen': 4, 'flags': 'BANG|EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'promptfind', 'minlen': 3, 'flags': 'EXTRA|NOTRLCOM|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'promptrepl', 'minlen': 7, 'flags': 'EXTRA|NOTRLCOM|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'perldo', 'minlen': 5, 'flags': 'RANGE|EXTRA|DFLALL|NEEDARG|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'pop', 'minlen': 2, 'flags': 'RANGE|NOTADR|BANG|COUNT|TRLBAR|ZEROR', 'parser': 'parse_cmd_common'},
      \ {'name': 'popup', 'minlen': 4, 'flags': 'NEEDARG|EXTRA|BANG|TRLBAR|NOTRLCOM|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'ppop', 'minlen': 2, 'flags': 'RANGE|NOTADR|BANG|COUNT|TRLBAR|ZEROR', 'parser': 'parse_cmd_common'},
      \ {'name': 'preserve', 'minlen': 3, 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'previous', 'minlen': 4, 'flags': 'EXTRA|RANGE|NOTADR|COUNT|BANG|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'psearch', 'minlen': 2, 'flags': 'BANG|RANGE|WHOLEFOLD|DFLALL|EXTRA', 'parser': 'parse_cmd_common'},
      \ {'name': 'ptag', 'minlen': 2, 'flags': 'RANGE|NOTADR|BANG|WORD1|TRLBAR|ZEROR', 'parser': 'parse_cmd_common'},
      \ {'name': 'ptNext', 'minlen': 3, 'flags': 'RANGE|NOTADR|BANG|TRLBAR|ZEROR', 'parser': 'parse_cmd_common'},
      \ {'name': 'ptfirst', 'minlen': 3, 'flags': 'RANGE|NOTADR|BANG|TRLBAR|ZEROR', 'parser': 'parse_cmd_common'},
      \ {'name': 'ptjump', 'minlen': 3, 'flags': 'BANG|TRLBAR|WORD1', 'parser': 'parse_cmd_common'},
      \ {'name': 'ptlast', 'minlen': 3, 'flags': 'BANG|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'ptnext', 'minlen': 3, 'flags': 'RANGE|NOTADR|BANG|TRLBAR|ZEROR', 'parser': 'parse_cmd_common'},
      \ {'name': 'ptprevious', 'minlen': 3, 'flags': 'RANGE|NOTADR|BANG|TRLBAR|ZEROR', 'parser': 'parse_cmd_common'},
      \ {'name': 'ptrewind', 'minlen': 3, 'flags': 'RANGE|NOTADR|BANG|TRLBAR|ZEROR', 'parser': 'parse_cmd_common'},
      \ {'name': 'ptselect', 'minlen': 3, 'flags': 'BANG|TRLBAR|WORD1', 'parser': 'parse_cmd_common'},
      \ {'name': 'put', 'minlen': 2, 'flags': 'RANGE|WHOLEFOLD|BANG|REGSTR|TRLBAR|ZEROR|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'pwd', 'minlen': 2, 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'py3', 'minlen': 3, 'flags': 'RANGE|EXTRA|NEEDARG|CMDWIN', 'parser': 'parse_cmd_python3'},
      \ {'name': 'python3', 'minlen': 7, 'flags': 'RANGE|EXTRA|NEEDARG|CMDWIN', 'parser': 'parse_cmd_python3'},
      \ {'name': 'py3file', 'minlen': 4, 'flags': 'RANGE|FILE1|NEEDARG|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'python', 'minlen': 2, 'flags': 'RANGE|EXTRA|NEEDARG|CMDWIN', 'parser': 'parse_cmd_python'},
      \ {'name': 'pyfile', 'minlen': 3, 'flags': 'RANGE|FILE1|NEEDARG|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'quit', 'minlen': 1, 'flags': 'BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'quitall', 'minlen': 5, 'flags': 'BANG|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'qall', 'minlen': 2, 'flags': 'BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'read', 'minlen': 1, 'flags': 'BANG|RANGE|WHOLEFOLD|FILE1|ARGOPT|TRLBAR|ZEROR|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'recover', 'minlen': 3, 'flags': 'BANG|FILE1|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'redo', 'minlen': 3, 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'redir', 'minlen': 4, 'flags': 'BANG|FILES|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'redraw', 'minlen': 4, 'flags': 'BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'redrawstatus', 'minlen': 7, 'flags': 'BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'registers', 'minlen': 3, 'flags': 'EXTRA|NOTRLCOM|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'resize', 'minlen': 3, 'flags': 'RANGE|NOTADR|TRLBAR|WORD1', 'parser': 'parse_cmd_common'},
      \ {'name': 'retab', 'minlen': 3, 'flags': 'TRLBAR|RANGE|WHOLEFOLD|DFLALL|BANG|WORD1|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'return', 'minlen': 4, 'flags': 'EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_return'},
      \ {'name': 'rewind', 'minlen': 3, 'flags': 'EXTRA|BANG|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'right', 'minlen': 2, 'flags': 'TRLBAR|RANGE|WHOLEFOLD|EXTRA|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'rightbelow', 'minlen': 6, 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'ruby', 'minlen': 3, 'flags': 'RANGE|EXTRA|NEEDARG|CMDWIN', 'parser': 'parse_cmd_ruby'},
      \ {'name': 'rubydo', 'minlen': 5, 'flags': 'RANGE|DFLALL|EXTRA|NEEDARG|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'rubyfile', 'minlen': 5, 'flags': 'RANGE|FILE1|NEEDARG|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'rundo', 'minlen': 4, 'flags': 'NEEDARG|FILE1', 'parser': 'parse_cmd_common'},
      \ {'name': 'runtime', 'minlen': 2, 'flags': 'BANG|NEEDARG|FILES|TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'rviminfo', 'minlen': 2, 'flags': 'BANG|FILE1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'substitute', 'minlen': 1, 'flags': 'RANGE|WHOLEFOLD|EXTRA|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'sNext', 'minlen': 2, 'flags': 'EXTRA|RANGE|NOTADR|COUNT|BANG|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'sandbox', 'minlen': 3, 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'sargument', 'minlen': 2, 'flags': 'BANG|RANGE|NOTADR|COUNT|EXTRA|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'sall', 'minlen': 3, 'flags': 'BANG|RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'saveas', 'minlen': 3, 'flags': 'BANG|DFLALL|FILE1|ARGOPT|CMDWIN|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'sbuffer', 'minlen': 2, 'flags': 'BANG|RANGE|NOTADR|BUFNAME|BUFUNL|COUNT|EXTRA|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'sbNext', 'minlen': 3, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'sball', 'minlen': 3, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'sbfirst', 'minlen': 3, 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'sblast', 'minlen': 3, 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'sbmodified', 'minlen': 3, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'sbnext', 'minlen': 3, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'sbprevious', 'minlen': 3, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'sbrewind', 'minlen': 3, 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'scriptnames', 'minlen': 5, 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'scriptencoding', 'minlen': 7, 'flags': 'WORD1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'scscope', 'minlen': 3, 'flags': 'EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'set', 'minlen': 2, 'flags': 'TRLBAR|EXTRA|CMDWIN|SBOXOK', 'parser': 'parse_cmd_common'},
      \ {'name': 'setfiletype', 'minlen': 4, 'flags': 'TRLBAR|EXTRA|NEEDARG|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'setglobal', 'minlen': 4, 'flags': 'TRLBAR|EXTRA|CMDWIN|SBOXOK', 'parser': 'parse_cmd_common'},
      \ {'name': 'setlocal', 'minlen': 4, 'flags': 'TRLBAR|EXTRA|CMDWIN|SBOXOK', 'parser': 'parse_cmd_common'},
      \ {'name': 'sfind', 'minlen': 2, 'flags': 'BANG|FILE1|RANGE|NOTADR|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'sfirst', 'minlen': 4, 'flags': 'EXTRA|BANG|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'shell', 'minlen': 2, 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'simalt', 'minlen': 3, 'flags': 'NEEDARG|WORD1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'sign', 'minlen': 3, 'flags': 'NEEDARG|RANGE|NOTADR|EXTRA|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'silent', 'minlen': 3, 'flags': 'NEEDARG|EXTRA|BANG|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'sleep', 'minlen': 2, 'flags': 'RANGE|NOTADR|COUNT|EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'slast', 'minlen': 3, 'flags': 'EXTRA|BANG|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'smagic', 'minlen': 2, 'flags': 'RANGE|WHOLEFOLD|EXTRA|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'smap', 'minlen': 4, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'smapclear', 'minlen': 5, 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'smenu', 'minlen': 3, 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'snext', 'minlen': 2, 'flags': 'RANGE|NOTADR|BANG|FILES|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'sniff', 'minlen': 3, 'flags': 'EXTRA|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'snomagic', 'minlen': 3, 'flags': 'RANGE|WHOLEFOLD|EXTRA|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'snoremap', 'minlen': 4, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'snoremenu', 'minlen': 7, 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'sort', 'minlen': 3, 'flags': 'RANGE|DFLALL|WHOLEFOLD|BANG|EXTRA|NOTRLCOM|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'source', 'minlen': 2, 'flags': 'BANG|FILE1|TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'spelldump', 'minlen': 6, 'flags': 'BANG|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'spellgood', 'minlen': 3, 'flags': 'BANG|RANGE|NOTADR|NEEDARG|EXTRA|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'spellinfo', 'minlen': 6, 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'spellrepall', 'minlen': 6, 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'spellundo', 'minlen': 6, 'flags': 'BANG|RANGE|NOTADR|NEEDARG|EXTRA|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'spellwrong', 'minlen': 6, 'flags': 'BANG|RANGE|NOTADR|NEEDARG|EXTRA|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'split', 'minlen': 2, 'flags': 'BANG|FILE1|RANGE|NOTADR|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'sprevious', 'minlen': 3, 'flags': 'EXTRA|RANGE|NOTADR|COUNT|BANG|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'srewind', 'minlen': 3, 'flags': 'EXTRA|BANG|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'stop', 'minlen': 2, 'flags': 'TRLBAR|BANG|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'stag', 'minlen': 3, 'flags': 'RANGE|NOTADR|BANG|WORD1|TRLBAR|ZEROR', 'parser': 'parse_cmd_common'},
      \ {'name': 'startinsert', 'minlen': 4, 'flags': 'BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'startgreplace', 'minlen': 6, 'flags': 'BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'startreplace', 'minlen': 6, 'flags': 'BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'stopinsert', 'minlen': 5, 'flags': 'BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'stjump', 'minlen': 3, 'flags': 'BANG|TRLBAR|WORD1', 'parser': 'parse_cmd_common'},
      \ {'name': 'stselect', 'minlen': 3, 'flags': 'BANG|TRLBAR|WORD1', 'parser': 'parse_cmd_common'},
      \ {'name': 'sunhide', 'minlen': 3, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'sunmap', 'minlen': 4, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'sunmenu', 'minlen': 5, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'suspend', 'minlen': 3, 'flags': 'TRLBAR|BANG|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'sview', 'minlen': 2, 'flags': 'BANG|FILE1|RANGE|NOTADR|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'swapname', 'minlen': 2, 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'syntax', 'minlen': 2, 'flags': 'EXTRA|NOTRLCOM|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'syncbind', 'minlen': 4, 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 't', 'minlen': 1, 'flags': 'RANGE|WHOLEFOLD|EXTRA|TRLBAR|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'tNext', 'minlen': 2, 'flags': 'RANGE|NOTADR|BANG|TRLBAR|ZEROR', 'parser': 'parse_cmd_common'},
      \ {'name': 'tabNext', 'minlen': 4, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'tabclose', 'minlen': 4, 'flags': 'RANGE|NOTADR|COUNT|BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'tabdo', 'minlen': 5, 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'tabedit', 'minlen': 4, 'flags': 'BANG|FILE1|RANGE|NOTADR|ZEROR|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'tabfind', 'minlen': 4, 'flags': 'BANG|FILE1|RANGE|NOTADR|ZEROR|EDITCMD|ARGOPT|NEEDARG|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'tabfirst', 'minlen': 6, 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'tablast', 'minlen': 4, 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'tabmove', 'minlen': 4, 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|NOSPC|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'tabnew', 'minlen': 6, 'flags': 'BANG|FILE1|RANGE|NOTADR|ZEROR|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'tabnext', 'minlen': 4, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'tabonly', 'minlen': 4, 'flags': 'BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'tabprevious', 'minlen': 4, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'tabrewind', 'minlen': 4, 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'tabs', 'minlen': 4, 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'tab', 'minlen': 3, 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'tag', 'minlen': 2, 'flags': 'RANGE|NOTADR|BANG|WORD1|TRLBAR|ZEROR', 'parser': 'parse_cmd_common'},
      \ {'name': 'tags', 'minlen': 4, 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'tcl', 'minlen': 2, 'flags': 'RANGE|EXTRA|NEEDARG|CMDWIN', 'parser': 'parse_cmd_tcl'},
      \ {'name': 'tcldo', 'minlen': 4, 'flags': 'RANGE|DFLALL|EXTRA|NEEDARG|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'tclfile', 'minlen': 4, 'flags': 'RANGE|FILE1|NEEDARG|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'tearoff', 'minlen': 2, 'flags': 'NEEDARG|EXTRA|TRLBAR|NOTRLCOM|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'tfirst', 'minlen': 2, 'flags': 'RANGE|NOTADR|BANG|TRLBAR|ZEROR', 'parser': 'parse_cmd_common'},
      \ {'name': 'throw', 'minlen': 2, 'flags': 'EXTRA|NEEDARG|SBOXOK|CMDWIN', 'parser': 'parse_cmd_throw'},
      \ {'name': 'tjump', 'minlen': 2, 'flags': 'BANG|TRLBAR|WORD1', 'parser': 'parse_cmd_common'},
      \ {'name': 'tlast', 'minlen': 2, 'flags': 'BANG|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'tmenu', 'minlen': 2, 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'tnext', 'minlen': 2, 'flags': 'RANGE|NOTADR|BANG|TRLBAR|ZEROR', 'parser': 'parse_cmd_common'},
      \ {'name': 'topleft', 'minlen': 2, 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'tprevious', 'minlen': 2, 'flags': 'RANGE|NOTADR|BANG|TRLBAR|ZEROR', 'parser': 'parse_cmd_common'},
      \ {'name': 'trewind', 'minlen': 2, 'flags': 'RANGE|NOTADR|BANG|TRLBAR|ZEROR', 'parser': 'parse_cmd_common'},
      \ {'name': 'try', 'minlen': 3, 'flags': 'TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_try'},
      \ {'name': 'tselect', 'minlen': 2, 'flags': 'BANG|TRLBAR|WORD1', 'parser': 'parse_cmd_common'},
      \ {'name': 'tunmenu', 'minlen': 2, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'undo', 'minlen': 1, 'flags': 'RANGE|NOTADR|COUNT|ZEROR|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'undojoin', 'minlen': 5, 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'undolist', 'minlen': 5, 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'unabbreviate', 'minlen': 3, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'unhide', 'minlen': 3, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'unlet', 'minlen': 3, 'flags': 'BANG|EXTRA|NEEDARG|SBOXOK|CMDWIN', 'parser': 'parse_cmd_unlet'},
      \ {'name': 'unlockvar', 'minlen': 4, 'flags': 'BANG|EXTRA|NEEDARG|SBOXOK|CMDWIN', 'parser': 'parse_cmd_unlockvar'},
      \ {'name': 'unmap', 'minlen': 3, 'flags': 'BANG|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'unmenu', 'minlen': 4, 'flags': 'BANG|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'unsilent', 'minlen': 3, 'flags': 'NEEDARG|EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'update', 'minlen': 2, 'flags': 'RANGE|WHOLEFOLD|BANG|FILE1|ARGOPT|DFLALL|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'vglobal', 'minlen': 1, 'flags': 'RANGE|WHOLEFOLD|EXTRA|DFLALL|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'version', 'minlen': 2, 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'verbose', 'minlen': 4, 'flags': 'NEEDARG|RANGE|NOTADR|EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'vertical', 'minlen': 4, 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'vimgrep', 'minlen': 3, 'flags': 'RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE', 'parser': 'parse_cmd_common'},
      \ {'name': 'vimgrepadd', 'minlen': 8, 'flags': 'RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE', 'parser': 'parse_cmd_common'},
      \ {'name': 'visual', 'minlen': 2, 'flags': 'BANG|FILE1|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'viusage', 'minlen': 3, 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'view', 'minlen': 3, 'flags': 'BANG|FILE1|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'vmap', 'minlen': 2, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'vmapclear', 'minlen': 5, 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'vmenu', 'minlen': 3, 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'vnew', 'minlen': 3, 'flags': 'BANG|FILE1|RANGE|NOTADR|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'vnoremap', 'minlen': 2, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'vnoremenu', 'minlen': 7, 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'vsplit', 'minlen': 2, 'flags': 'BANG|FILE1|RANGE|NOTADR|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'vunmap', 'minlen': 2, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'vunmenu', 'minlen': 5, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'windo', 'minlen': 5, 'flags': 'BANG|NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'write', 'minlen': 1, 'flags': 'RANGE|WHOLEFOLD|BANG|FILE1|ARGOPT|DFLALL|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'wNext', 'minlen': 2, 'flags': 'RANGE|WHOLEFOLD|NOTADR|BANG|FILE1|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'wall', 'minlen': 2, 'flags': 'BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'while', 'minlen': 2, 'flags': 'EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_while'},
      \ {'name': 'winsize', 'minlen': 2, 'flags': 'EXTRA|NEEDARG|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'wincmd', 'minlen': 4, 'flags': 'NEEDARG|WORD1|RANGE|NOTADR', 'parser': 'parse_cmd_common'},
      \ {'name': 'winpos', 'minlen': 4, 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'wnext', 'minlen': 2, 'flags': 'RANGE|NOTADR|BANG|FILE1|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'wprevious', 'minlen': 2, 'flags': 'RANGE|NOTADR|BANG|FILE1|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'wq', 'minlen': 2, 'flags': 'RANGE|WHOLEFOLD|BANG|FILE1|ARGOPT|DFLALL|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'wqall', 'minlen': 3, 'flags': 'BANG|FILE1|ARGOPT|DFLALL|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'wsverb', 'minlen': 2, 'flags': 'EXTRA|NOTADR|NEEDARG', 'parser': 'parse_cmd_common'},
      \ {'name': 'wundo', 'minlen': 2, 'flags': 'BANG|NEEDARG|FILE1', 'parser': 'parse_cmd_common'},
      \ {'name': 'wviminfo', 'minlen': 2, 'flags': 'BANG|FILE1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'xit', 'minlen': 1, 'flags': 'RANGE|WHOLEFOLD|BANG|FILE1|ARGOPT|DFLALL|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'xall', 'minlen': 2, 'flags': 'BANG|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'xmapclear', 'minlen': 5, 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'xmap', 'minlen': 2, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'xmenu', 'minlen': 3, 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'xnoremap', 'minlen': 2, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'xnoremenu', 'minlen': 7, 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'xunmap', 'minlen': 2, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'xunmenu', 'minlen': 5, 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'yank', 'minlen': 1, 'flags': 'RANGE|WHOLEFOLD|REGSTR|COUNT|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'z', 'minlen': 1, 'flags': 'RANGE|WHOLEFOLD|EXTRA|EXFLAGS|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': '!', 'minlen': 1, 'flags': 'RANGE|WHOLEFOLD|BANG|FILES|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': '#', 'minlen': 1, 'flags': 'RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': '&', 'minlen': 1, 'flags': 'RANGE|WHOLEFOLD|EXTRA|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': '*', 'minlen': 1, 'flags': 'RANGE|WHOLEFOLD|EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': '<', 'minlen': 1, 'flags': 'RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': '=', 'minlen': 1, 'flags': 'RANGE|TRLBAR|DFLALL|EXFLAGS|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': '>', 'minlen': 1, 'flags': 'RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': '@', 'minlen': 1, 'flags': 'RANGE|WHOLEFOLD|EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'Next', 'minlen': 1, 'flags': 'EXTRA|RANGE|NOTADR|COUNT|BANG|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'Print', 'minlen': 1, 'flags': 'RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'X', 'minlen': 1, 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': '~', 'minlen': 1, 'flags': 'RANGE|WHOLEFOLD|EXTRA|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \]

let s:ExprTokenizer = {}

function! s:ExprTokenizer.new(...)
  let obj = copy(self)
  call call(obj.__init__, a:000, obj)
  return obj
endfunction

function! s:ExprTokenizer.__init__(reader)
  let self.reader = a:reader
  let self.cache = {}
endfunction

function! s:ExprTokenizer.token(type, value, pos)
  return {'type': a:type, 'value': a:value, 'pos': a:pos}
endfunction

function! s:ExprTokenizer.peek()
  let pos = self.reader.tell()
  let r = self.get()
  call self.reader.seek_set(pos)
  return r
endfunction

function! s:ExprTokenizer.get()
  " FIXME: remove dirty hack
  if has_key(self.cache, self.reader.tell())
    let x = self.cache[self.reader.tell()]
    call self.reader.seek_set(x[0])
    return x[1]
  endif
  let pos = self.reader.tell()
  call self.reader.skip_white()
  let r = self.get2()
  let self.cache[pos] = [self.reader.tell(), r]
  return r
endfunction

function! s:ExprTokenizer.get2()
  let r = self.reader
  let pos = r.getpos()
  let c = r.peek()
  if c ==# '<EOF>'
    return self.token(s:TOKEN_EOF, c, pos)
  elseif c ==# '<EOL>'
    call r.seek_cur(1)
    return self.token(s:TOKEN_EOL, c, pos)
  elseif s:iswhite(c)
    let s = r.read_white()
    return self.token(s:TOKEN_SPACE, s, pos)
  elseif c ==# '0' && (r.p(1) ==# 'X' || r.p(1) ==# 'x') && s:isxdigit(r.p(2))
    let s = r.getn(3)
    let s .= r.read_xdigit()
    return self.token(s:TOKEN_NUMBER, s, pos)
  elseif s:isdigit(c)
    let s = r.read_digit()
    if r.p(0) ==# '.' && s:isdigit(r.p(1))
      let s .= r.getn(1)
      let s .= r.read_digit()
      if (r.p(0) ==# 'E' || r.p(0) ==# 'e') && (s:isdigit(r.p(1)) || ((r.p(1) ==# '-' || r.p(1) ==# '+') && s:isdigit(r.p(2))))
        let s .= r.getn(2)
        let s .= r.read_digit()
      endif
    endif
    return self.token(s:TOKEN_NUMBER, s, pos)
  elseif c ==# 'i' && r.p(1) ==# 's' && !s:isidc(r.p(2))
    if r.p(2) ==# '?'
      call r.seek_cur(3)
      return self.token(s:TOKEN_ISCI, 'is?', pos)
    elseif r.p(2) ==# '#'
      call r.seek_cur(3)
      return self.token(s:TOKEN_ISCS, 'is#', pos)
    else
      call r.seek_cur(2)
      return self.token(s:TOKEN_IS, 'is', pos)
    endif
  elseif c ==# 'i' && r.p(1) ==# 's' && r.p(2) ==# 'n' && r.p(3) ==# 'o' && r.p(4) ==# 't' && !s:isidc(r.p(5))
    if r.p(5) ==# '?'
      call r.seek_cur(6)
      return self.token(s:TOKEN_ISNOTCI, 'isnot?', pos)
    elseif r.p(5) ==# '#'
      call r.seek_cur(6)
      return self.token(s:TOKEN_ISNOTCS, 'isnot#', pos)
    else
      call r.seek_cur(5)
      return self.token(s:TOKEN_ISNOT, 'isnot', pos)
    endif
  elseif s:isnamec1(c)
    let s = r.read_name()
    return self.token(s:TOKEN_IDENTIFIER, s, pos)
  elseif c ==# '|' && r.p(1) ==# '|'
    call r.seek_cur(2)
    return self.token(s:TOKEN_OROR, '||', pos)
  elseif c ==# '&' && r.p(1) ==# '&'
    call r.seek_cur(2)
    return self.token(s:TOKEN_ANDAND, '&&', pos)
  elseif c ==# '=' && r.p(1) ==# '='
    if r.p(2) ==# '?'
      call r.seek_cur(3)
      return self.token(s:TOKEN_EQEQCI, '==?', pos)
    elseif r.p(2) ==# '#'
      call r.seek_cur(3)
      return self.token(s:TOKEN_EQEQCS, '==#', pos)
    else
      call r.seek_cur(2)
      return self.token(s:TOKEN_EQEQ, '==', pos)
    endif
  elseif c ==# '!' && r.p(1) ==# '='
    if r.p(2) ==# '?'
      call r.seek_cur(3)
      return self.token(s:TOKEN_NEQCI, '!=?', pos)
    elseif r.p(2) ==# '#'
      call r.seek_cur(3)
      return self.token(s:TOKEN_NEQCS, '!=#', pos)
    else
      call r.seek_cur(2)
      return self.token(s:TOKEN_NEQ, '!=', pos)
    endif
  elseif c ==# '>' && r.p(1) ==# '='
    if r.p(2) ==# '?'
      call r.seek_cur(3)
      return self.token(s:TOKEN_GTEQCI, '>=?', pos)
    elseif r.p(2) ==# '#'
      call r.seek_cur(3)
      return self.token(s:TOKEN_GTEQCS, '>=#', pos)
    else
      call r.seek_cur(2)
      return self.token(s:TOKEN_GTEQ, '>=', pos)
    endif
  elseif c ==# '<' && r.p(1) ==# '='
    if r.p(2) ==# '?'
      call r.seek_cur(3)
      return self.token(s:TOKEN_LTEQCI, '<=?', pos)
    elseif r.p(2) ==# '#'
      call r.seek_cur(3)
      return self.token(s:TOKEN_LTEQCS, '<=#', pos)
    else
      call r.seek_cur(2)
      return self.token(s:TOKEN_LTEQ, '<=', pos)
    endif
  elseif c ==# '=' && r.p(1) ==# '~'
    if r.p(2) ==# '?'
      call r.seek_cur(3)
      return self.token(s:TOKEN_MATCHCI, '=~?', pos)
    elseif r.p(2) ==# '#'
      call r.seek_cur(3)
      return self.token(s:TOKEN_MATCHCS, '=~#', pos)
    else
      call r.seek_cur(2)
      return self.token(s:TOKEN_MATCH, '=~', pos)
    endif
  elseif c ==# '!' && r.p(1) ==# '~'
    if r.p(2) ==# '?'
      call r.seek_cur(3)
      return self.token(s:TOKEN_NOMATCHCI, '!~?', pos)
    elseif r.p(2) ==# '#'
      call r.seek_cur(3)
      return self.token(s:TOKEN_NOMATCHCS, '!~#', pos)
    else
      call r.seek_cur(2)
      return self.token(s:TOKEN_NOMATCH, '!~', pos)
    endif
  elseif c ==# '>'
    if r.p(1) ==# '?'
      call r.seek_cur(2)
      return self.token(s:TOKEN_GTCI, '>?', pos)
    elseif r.p(1) ==# '#'
      call r.seek_cur(2)
      return self.token(s:TOKEN_GTCS, '>#', pos)
    else
      call r.seek_cur(1)
      return self.token(s:TOKEN_GT, '>', pos)
    endif
  elseif c ==# '<'
    if r.p(1) ==# '?'
      call r.seek_cur(2)
      return self.token(s:TOKEN_LTCI, '<?', pos)
    elseif r.p(1) ==# '#'
      call r.seek_cur(2)
      return self.token(s:TOKEN_LTCS, '<#', pos)
    else
      call r.seek_cur(1)
      return self.token(s:TOKEN_LT, '<', pos)
    endif
  elseif c ==# '+'
    call r.seek_cur(1)
    return self.token(s:TOKEN_PLUS, '+', pos)
  elseif c ==# '-'
    call r.seek_cur(1)
    return self.token(s:TOKEN_MINUS, '-', pos)
  elseif c ==# '.'
    if r.p(1) ==# '.' && r.p(2) ==# '.'
      call r.seek_cur(3)
      return self.token(s:TOKEN_DOTDOTDOT, '...', pos)
    else
      call r.seek_cur(1)
      return self.token(s:TOKEN_DOT, '.', pos)
    endif
  elseif c ==# '*'
    call r.seek_cur(1)
    return self.token(s:TOKEN_STAR, '*', pos)
  elseif c ==# '/'
    call r.seek_cur(1)
    return self.token(s:TOKEN_SLASH, '/', pos)
  elseif c ==# '%'
    call r.seek_cur(1)
    return self.token(s:TOKEN_PERCENT, '%', pos)
  elseif c ==# '!'
    call r.seek_cur(1)
    return self.token(s:TOKEN_NOT, '!', pos)
  elseif c ==# '?'
    call r.seek_cur(1)
    return self.token(s:TOKEN_QUESTION, '?', pos)
  elseif c ==# ':'
    call r.seek_cur(1)
    return self.token(s:TOKEN_COLON, ':', pos)
  elseif c ==# '('
    call r.seek_cur(1)
    return self.token(s:TOKEN_POPEN, '(', pos)
  elseif c ==# ')'
    call r.seek_cur(1)
    return self.token(s:TOKEN_PCLOSE, ')', pos)
  elseif c ==# '['
    call r.seek_cur(1)
    return self.token(s:TOKEN_SQOPEN, '[', pos)
  elseif c ==# ']'
    call r.seek_cur(1)
    return self.token(s:TOKEN_SQCLOSE, ']', pos)
  elseif c ==# '{'
    call r.seek_cur(1)
    return self.token(s:TOKEN_COPEN, '{', pos)
  elseif c ==# '}'
    call r.seek_cur(1)
    return self.token(s:TOKEN_CCLOSE, '}', pos)
  elseif c ==# ','
    call r.seek_cur(1)
    return self.token(s:TOKEN_COMMA, ',', pos)
  elseif c ==# "'"
    call r.seek_cur(1)
    return self.token(s:TOKEN_SQUOTE, "'", pos)
  elseif c ==# '"'
    call r.seek_cur(1)
    return self.token(s:TOKEN_DQUOTE, '"', pos)
  elseif c ==# '$'
    let s = r.getn(1)
    let s .= r.read_word()
    return self.token(s:TOKEN_ENV, s, pos)
  elseif c ==# '@'
    " @<EOL> is treated as @"
    return self.token(s:TOKEN_REG, r.getn(2), pos)
  elseif c ==# '&'
    if (r.p(1) ==# 'g' || r.p(1) ==# 'l') && r.p(2) ==# ':'
      let s = r.getn(3) . r.read_word()
    else
      let s = r.getn(1) . r.read_word()
    endif
    return self.token(s:TOKEN_OPTION, s, pos)
  elseif c ==# '='
    call r.seek_cur(1)
    return self.token(s:TOKEN_EQ, '=', pos)
  elseif c ==# '|'
    call r.seek_cur(1)
    return self.token(s:TOKEN_OR, '|', pos)
  elseif c ==# ';'
    call r.seek_cur(1)
    return self.token(s:TOKEN_SEMICOLON, ';', pos)
  elseif c ==# '`'
    call r.seek_cur(1)
    return self.token(s:TOKEN_BACKTICK, '`', pos)
  else
    throw s:Err(printf('unexpected character: %s', c), self.reader.getpos())
  endif
endfunction

function! s:ExprTokenizer.get_sstring()
  call self.reader.skip_white()
  let c = self.reader.p(0)
  if c !=# "'"
    throw s:Err(printf('unexpected character: %s', c), self.reader.getpos())
  endif
  call self.reader.seek_cur(1)
  let s = ''
  while 1
    let c = self.reader.p(0)
    if c ==# '<EOF>' || c ==# '<EOL>'
      throw s:Err('unexpected EOL', self.reader.getpos())
    elseif c ==# "'"
      call self.reader.seek_cur(1)
      if self.reader.p(0) ==# "'"
        call self.reader.seek_cur(1)
        let s .= "''"
      else
        break
      endif
    else
      call self.reader.seek_cur(1)
      let s .= c
    endif
  endwhile
  return s
endfunction

function! s:ExprTokenizer.get_dstring()
  call self.reader.skip_white()
  let c = self.reader.p(0)
  if c !=# '"'
    throw s:Err(printf('unexpected character: %s', c), self.reader.getpos())
  endif
  call self.reader.seek_cur(1)
  let s = ''
  while 1
    let c = self.reader.p(0)
    if c ==# '<EOF>' || c ==# '<EOL>'
      throw s:Err('unexpectd EOL', self.reader.getpos())
    elseif c ==# '"'
      call self.reader.seek_cur(1)
      break
    elseif c ==# '\'
      call self.reader.seek_cur(1)
      let s .= c
      let c = self.reader.p(0)
      if c ==# '<EOF>' || c ==# '<EOL>'
        throw s:Err('ExprTokenizer: unexpected EOL', self.reader.getpos())
      endif
      call self.reader.seek_cur(1)
      let s .= c
    else
      call self.reader.seek_cur(1)
      let s .= c
    endif
  endwhile
  return s
endfunction

let s:ExprParser = {}

function! s:ExprParser.new(...)
  let obj = copy(self)
  call call(obj.__init__, a:000, obj)
  return obj
endfunction

function! s:ExprParser.__init__(reader)
  let self.reader = a:reader
  let self.tokenizer = s:ExprTokenizer.new(a:reader)
endfunction

function! s:ExprParser.parse()
  return self.parse_expr1()
endfunction

" expr1: expr2 ? expr1 : expr1
function! s:ExprParser.parse_expr1()
  let left = self.parse_expr2()
  let pos = self.reader.tell()
  let token = self.tokenizer.get()
  if token.type == s:TOKEN_QUESTION
    let node = s:Node(s:NODE_TERNARY)
    let node.pos = token.pos
    let node.cond = left
    let node.left = self.parse_expr1()
    let token = self.tokenizer.get()
    if token.type != s:TOKEN_COLON
      throw s:Err(printf('unexpected token: %s', token.value), token.pos)
    endif
    let node.right = self.parse_expr1()
    let left = node
  else
    call self.reader.seek_set(pos)
  endif
  return left
endfunction

" expr2: expr3 || expr3 ..
function! s:ExprParser.parse_expr2()
  let left = self.parse_expr3()
  while 1
    let pos = self.reader.tell()
    let token = self.tokenizer.get()
    if token.type == s:TOKEN_OROR
      let node = s:Node(s:NODE_OR)
      let node.pos = token.pos
      let node.left = left
      let node.right = self.parse_expr3()
      let left = node
    else
      call self.reader.seek_set(pos)
      break
    endif
  endwhile
  return left
endfunction

" expr3: expr4 && expr4
function! s:ExprParser.parse_expr3()
  let left = self.parse_expr4()
  while 1
    let pos = self.reader.tell()
    let token = self.tokenizer.get()
    if token.type == s:TOKEN_ANDAND
      let node = s:Node(s:NODE_AND)
      let node.pos = token.pos
      let node.left = left
      let node.right = self.parse_expr4()
      let left = node
    else
      call self.reader.seek_set(pos)
      break
    endif
  endwhile
  return left
endfunction

" expr4: expr5 == expr5
"        expr5 != expr5
"        expr5 >  expr5
"        expr5 >= expr5
"        expr5 <  expr5
"        expr5 <= expr5
"        expr5 =~ expr5
"        expr5 !~ expr5
"
"        expr5 ==? expr5
"        expr5 ==# expr5
"        etc.
"
"        expr5 is expr5
"        expr5 isnot expr5
function! s:ExprParser.parse_expr4()
  let left = self.parse_expr5()
  let pos = self.reader.tell()
  let token = self.tokenizer.get()
  if token.type == s:TOKEN_EQEQ
    let node = s:Node(s:NODE_EQUAL)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type == s:TOKEN_EQEQCI
    let node = s:Node(s:NODE_EQUALCI)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type == s:TOKEN_EQEQCS
    let node = s:Node(s:NODE_EQUALCS)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type == s:TOKEN_NEQ
    let node = s:Node(s:NODE_NEQUAL)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type == s:TOKEN_NEQCI
    let node = s:Node(s:NODE_NEQUALCI)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type == s:TOKEN_NEQCS
    let node = s:Node(s:NODE_NEQUALCS)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type == s:TOKEN_GT
    let node = s:Node(s:NODE_GREATER)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type == s:TOKEN_GTCI
    let node = s:Node(s:NODE_GREATERCI)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type == s:TOKEN_GTCS
    let node = s:Node(s:NODE_GREATERCS)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type == s:TOKEN_GTEQ
    let node = s:Node(s:NODE_GEQUAL)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type == s:TOKEN_GTEQCI
    let node = s:Node(s:NODE_GEQUALCI)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type == s:TOKEN_GTEQCS
    let node = s:Node(s:NODE_GEQUALCS)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type == s:TOKEN_LT
    let node = s:Node(s:NODE_SMALLER)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type == s:TOKEN_LTCI
    let node = s:Node(s:NODE_SMALLERCI)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type == s:TOKEN_LTCS
    let node = s:Node(s:NODE_SMALLERCS)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type == s:TOKEN_LTEQ
    let node = s:Node(s:NODE_SEQUAL)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type == s:TOKEN_LTEQCI
    let node = s:Node(s:NODE_SEQUALCI)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type == s:TOKEN_LTEQCS
    let node = s:Node(s:NODE_SEQUALCS)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type == s:TOKEN_MATCH
    let node = s:Node(s:NODE_MATCH)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type == s:TOKEN_MATCHCI
    let node = s:Node(s:NODE_MATCHCI)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type == s:TOKEN_MATCHCS
    let node = s:Node(s:NODE_MATCHCS)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type == s:TOKEN_NOMATCH
    let node = s:Node(s:NODE_NOMATCH)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type == s:TOKEN_NOMATCHCI
    let node = s:Node(s:NODE_NOMATCHCI)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type == s:TOKEN_NOMATCHCS
    let node = s:Node(s:NODE_NOMATCHCS)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type == s:TOKEN_IS
    let node = s:Node(s:NODE_IS)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type == s:TOKEN_ISCI
    let node = s:Node(s:NODE_ISCI)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type == s:TOKEN_ISCS
    let node = s:Node(s:NODE_ISCS)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type == s:TOKEN_ISNOT
    let node = s:Node(s:NODE_ISNOT)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type == s:TOKEN_ISNOTCI
    let node = s:Node(s:NODE_ISNOTCI)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type == s:TOKEN_ISNOTCS
    let node = s:Node(s:NODE_ISNOTCS)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  else
    call self.reader.seek_set(pos)
  endif
  return left
endfunction

" expr5: expr6 + expr6 ..
"        expr6 - expr6 ..
"        expr6 . expr6 ..
function! s:ExprParser.parse_expr5()
  let left = self.parse_expr6()
  while 1
    let pos = self.reader.tell()
    let token = self.tokenizer.get()
    if token.type == s:TOKEN_PLUS
      let node = s:Node(s:NODE_ADD)
      let node.pos = token.pos
      let node.left = left
      let node.right = self.parse_expr6()
      let left = node
    elseif token.type == s:TOKEN_MINUS
      let node = s:Node(s:NODE_SUBTRACT)
      let node.pos = token.pos
      let node.left = left
      let node.right = self.parse_expr6()
      let left = node
    elseif token.type == s:TOKEN_DOT
      let node = s:Node(s:NODE_CONCAT)
      let node.pos = token.pos
      let node.left = left
      let node.right = self.parse_expr6()
      let left = node
    else
      call self.reader.seek_set(pos)
      break
    endif
  endwhile
  return left
endfunction

" expr6: expr7 * expr7 ..
"        expr7 / expr7 ..
"        expr7 % expr7 ..
function! s:ExprParser.parse_expr6()
  let left = self.parse_expr7()
  while 1
    let pos = self.reader.tell()
    let token = self.tokenizer.get()
    if token.type == s:TOKEN_STAR
      let node = s:Node(s:NODE_MULTIPLY)
      let node.pos = token.pos
      let node.left = left
      let node.right = self.parse_expr7()
      let left = node
    elseif token.type == s:TOKEN_SLASH
      let node = s:Node(s:NODE_DIVIDE)
      let node.pos = token.pos
      let node.left = left
      let node.right = self.parse_expr7()
      let left = node
    elseif token.type == s:TOKEN_PERCENT
      let node = s:Node(s:NODE_REMAINDER)
      let node.pos = token.pos
      let node.left = left
      let node.right = self.parse_expr7()
      let left = node
    else
      call self.reader.seek_set(pos)
      break
    endif
  endwhile
  return left
endfunction

" expr7: ! expr7
"        - expr7
"        + expr7
function! s:ExprParser.parse_expr7()
  let pos = self.reader.tell()
  let token = self.tokenizer.get()
  if token.type == s:TOKEN_NOT
    let node = s:Node(s:NODE_NOT)
    let node.pos = token.pos
    let node.left = self.parse_expr7()
  elseif token.type == s:TOKEN_MINUS
    let node = s:Node(s:NODE_MINUS)
    let node.pos = token.pos
    let node.left = self.parse_expr7()
  elseif token.type == s:TOKEN_PLUS
    let node = s:Node(s:NODE_PLUS)
    let node.pos = token.pos
    let node.left = self.parse_expr7()
  else
    call self.reader.seek_set(pos)
    let node = self.parse_expr8()
  endif
  return node
endfunction

" expr8: expr8[expr1]
"        expr8[expr1 : expr1]
"        expr8.name
"        expr8(expr1, ...)
function! s:ExprParser.parse_expr8()
  let left = self.parse_expr9()
  while 1
    let pos = self.reader.tell()
    let c = self.reader.peek()
    let token = self.tokenizer.get()
    if !s:iswhite(c) && token.type == s:TOKEN_SQOPEN
      let npos = token.pos
      if self.tokenizer.peek().type == s:TOKEN_COLON
        call self.tokenizer.get()
        let node = s:Node(s:NODE_SLICE)
        let node.pos = npos
        let node.left = left
        let node.rlist = [s:NIL, s:NIL]
        let token = self.tokenizer.peek()
        if token.type != s:TOKEN_SQCLOSE
          let node.rlist[1] = self.parse_expr1()
        endif
        let token = self.tokenizer.get()
        if token.type != s:TOKEN_SQCLOSE
          throw s:Err(printf('unexpected token: %s', token.value), token.pos)
        endif
      else
        let right = self.parse_expr1()
        if self.tokenizer.peek().type == s:TOKEN_COLON
          call self.tokenizer.get()
          let node = s:Node(s:NODE_SLICE)
          let node.pos = npos
          let node.left = left
          let node.rlist = [right, s:NIL]
          let token = self.tokenizer.peek()
          if token.type != s:TOKEN_SQCLOSE
            let node.rlist[1] = self.parse_expr1()
          endif
          let token = self.tokenizer.get()
          if token.type != s:TOKEN_SQCLOSE
            throw s:Err(printf('unexpected token: %s', token.value), token.pos)
          endif
        else
          let node = s:Node(s:NODE_SUBSCRIPT)
          let node.pos = npos
          let node.left = left
          let node.right = right
          let token = self.tokenizer.get()
          if token.type != s:TOKEN_SQCLOSE
            throw s:Err(printf('unexpected token: %s', token.value), token.pos)
          endif
        endif
      endif
      let left = node
    elseif token.type == s:TOKEN_POPEN
      let node = s:Node(s:NODE_CALL)
      let node.pos = token.pos
      let node.left = left
      let node.rlist = []
      if self.tokenizer.peek().type == s:TOKEN_PCLOSE
        call self.tokenizer.get()
      else
        while 1
          call add(node.rlist, self.parse_expr1())
          let token = self.tokenizer.get()
          if token.type == s:TOKEN_COMMA
          elseif token.type == s:TOKEN_PCLOSE
            break
          else
            throw s:Err(printf('unexpected token: %s', token.value), token.pos)
          endif
        endwhile
      endif
      if len(node.rlist) > s:MAX_FUNC_ARGS
        " TODO: funcname E740: Too many arguments for function: %s
        throw s:Err('E740: Too many arguments for function', node.pos)
      endif
      let left = node
    elseif !s:iswhite(c) && token.type == s:TOKEN_DOT
      let node = self.parse_dot(token, left)
      if node is s:NIL
        call self.reader.seek_set(pos)
        break
      endif
      let left = node
    else
      call self.reader.seek_set(pos)
      break
    endif
  endwhile
  return left
endfunction

" expr9: number
"        "string"
"        'string'
"        [expr1, ...]
"        {expr1: expr1, ...}
"        &option
"        (expr1)
"        variable
"        var{ria}ble
"        $VAR
"        @r
"        function(expr1, ...)
"        func{ti}on(expr1, ...)
function! s:ExprParser.parse_expr9()
  let pos = self.reader.tell()
  let token = self.tokenizer.get()
  if token.type == s:TOKEN_NUMBER
    let node = s:Node(s:NODE_NUMBER)
    let node.pos = token.pos
    let node.value = token.value
  elseif token.type == s:TOKEN_DQUOTE
    call self.reader.seek_set(pos)
    let node = s:Node(s:NODE_STRING)
    let node.pos = token.pos
    let node.value = '"' . self.tokenizer.get_dstring() . '"'
  elseif token.type == s:TOKEN_SQUOTE
    call self.reader.seek_set(pos)
    let node = s:Node(s:NODE_STRING)
    let node.pos = token.pos
    let node.value = "'" . self.tokenizer.get_sstring() . "'"
  elseif token.type == s:TOKEN_SQOPEN
    let node = s:Node(s:NODE_LIST)
    let node.pos = token.pos
    let node.value = []
    let token = self.tokenizer.peek()
    if token.type == s:TOKEN_SQCLOSE
      call self.tokenizer.get()
    else
      while 1
        call add(node.value, self.parse_expr1())
        let token = self.tokenizer.peek()
        if token.type == s:TOKEN_COMMA
          call self.tokenizer.get()
          if self.tokenizer.peek().type == s:TOKEN_SQCLOSE
            call self.tokenizer.get()
            break
          endif
        elseif token.type == s:TOKEN_SQCLOSE
          call self.tokenizer.get()
          break
        else
          throw s:Err(printf('unexpected token: %s', token.value), token.pos)
        endif
      endwhile
    endif
  elseif token.type == s:TOKEN_COPEN
    let node = s:Node(s:NODE_DICT)
    let node.pos = token.pos
    let node.value = []
    let token = self.tokenizer.peek()
    if token.type == s:TOKEN_CCLOSE
      call self.tokenizer.get()
    else
      while 1
        let key = self.parse_expr1()
        let token = self.tokenizer.get()
        if token.type == s:TOKEN_CCLOSE
          if !empty(node.value)
            throw s:Err(printf('unexpected token: %s', token.value), token.pos)
          endif
          call self.reader.seek_set(pos)
          let node = self.parse_identifier()
          break
        endif
        if token.type != s:TOKEN_COLON
          throw s:Err(printf('unexpected token: %s', token.value), token.pos)
        endif
        let val = self.parse_expr1()
        call add(node.value, [key, val])
        let token = self.tokenizer.get()
        if token.type == s:TOKEN_COMMA
          if self.tokenizer.peek().type == s:TOKEN_CCLOSE
            call self.tokenizer.get()
            break
          endif
        elseif token.type == s:TOKEN_CCLOSE
          break
        else
          throw s:Err(printf('unexpected token: %s', token.value), token.pos)
        endif
      endwhile
    endif
  elseif token.type == s:TOKEN_POPEN
    let node = self.parse_expr1()
    let token = self.tokenizer.get()
    if token.type != s:TOKEN_PCLOSE
      throw s:Err(printf('unexpected token: %s', token.value), token.pos)
    endif
  elseif token.type == s:TOKEN_OPTION
    let node = s:Node(s:NODE_OPTION)
    let node.pos = token.pos
    let node.value = token.value
  elseif token.type == s:TOKEN_IDENTIFIER
    call self.reader.seek_set(pos)
    let node = self.parse_identifier()
  elseif token.type == s:TOKEN_LT && self.reader.peekn(4) ==? 'SID>'
    call self.reader.seek_set(pos)
    let node = self.parse_identifier()
  elseif token.type == s:TOKEN_IS || token.type == s:TOKEN_ISCS || token.type == s:TOKEN_ISNOT || token.type == s:TOKEN_ISNOTCS
    call self.reader.seek_set(pos)
    let node = self.parse_identifier()
  elseif token.type == s:TOKEN_ENV
    let node = s:Node(s:NODE_ENV)
    let node.pos = token.pos
    let node.value = token.value
  elseif token.type == s:TOKEN_REG
    let node = s:Node(s:NODE_REG)
    let node.pos = token.pos
    let node.value = token.value
  else
    throw s:Err(printf('unexpected token: %s', token.value), token.pos)
  endif
  return node
endfunction

" SUBSCRIPT or CONCAT
"   dict "." [0-9A-Za-z_]+ => (subscript dict key)
"   str  "." expr6         => (concat str expr6)
function! s:ExprParser.parse_dot(token, left)
  if a:left.type != s:NODE_IDENTIFIER && a:left.type != s:NODE_CURLYNAME && a:left.type != s:NODE_DICT && a:left.type != s:NODE_SUBSCRIPT && a:left.type != s:NODE_CALL && a:left.type != s:NODE_DOT
    return s:NIL
  endif
  if !s:iswordc(self.reader.p(0))
    return s:NIL
  endif
  let pos = self.reader.getpos()
  let name = self.reader.read_word()
  if s:isnamec(self.reader.p(0))
    " foo.s:bar or foo.bar#baz
    return s:NIL
  endif
  let node = s:Node(s:NODE_DOT)
  let node.pos = a:token.pos
  let node.left = a:left
  let node.right = s:Node(s:NODE_IDENTIFIER)
  let node.right.pos = pos
  let node.right.value = name
  return node
endfunction

function! s:ExprParser.parse_identifier()
  let id = []
  call self.reader.skip_white()
  let npos = self.reader.getpos()
  let c = self.reader.peek()
  if c ==# '<' && self.reader.peekn(5) ==? '<SID>'
    let name = self.reader.getn(5)
    call add(id, {'curly': 0, 'value': name})
  endif
  while 1
    let c = self.reader.peek()
    if s:isnamec(c)
      let name = self.reader.read_name()
      call add(id, {'curly': 0, 'value': name})
    elseif c ==# '{'
      call self.reader.get()
      let node = self.parse_expr1()
      call self.reader.skip_white()
      let c = self.reader.p(0)
      if c !=# '}'
        throw s:Err(printf('unexpected token: %s', c), self.reader.getpos())
      endif
      call self.reader.seek_cur(1)
      call add(id, {'curly': 1, 'value': node})
    else
      break
    endif
  endwhile
  if len(id) == 1 && id[0].curly == 0
    let node = s:Node(s:NODE_IDENTIFIER)
    let node.pos = npos
    let node.value = id[0].value
  else
    let node = s:Node(s:NODE_CURLYNAME)
    let node.pos = npos
    let node.value = id
  endif
  return node
endfunction

let s:LvalueParser = copy(s:ExprParser)

function! s:LvalueParser.parse()
  return self.parse_lv8()
endfunction

" expr8: expr8[expr1]
"        expr8[expr1 : expr1]
"        expr8.name
function! s:LvalueParser.parse_lv8()
  let left = self.parse_lv9()
  while 1
    let pos = self.reader.tell()
    let c = self.reader.peek()
    let token = self.tokenizer.get()
    if !s:iswhite(c) && token.type == s:TOKEN_SQOPEN
      let npos = token.pos
      if self.tokenizer.peek().type == s:TOKEN_COLON
        call self.tokenizer.get()
        let node = s:Node(s:NODE_SLICE)
        let node.pos = npos
        let node.left = left
        let node.rlist = [s:NIL, s:NIL]
        let token = self.tokenizer.peek()
        if token.type != s:TOKEN_SQCLOSE
          let node.rlist[1] = self.parse_expr1()
        endif
        let token = self.tokenizer.get()
        if token.type != s:TOKEN_SQCLOSE
          throw s:Err(printf('unexpected token: %s', token.value), token.pos)
        endif
      else
        let right = self.parse_expr1()
        if self.tokenizer.peek().type == s:TOKEN_COLON
          call self.tokenizer.get()
          let node = s:Node(s:NODE_SLICE)
          let node.pos = npos
          let node.left = left
          let node.rlist = [right, s:NIL]
          let token = self.tokenizer.peek()
          if token.type != s:TOKEN_SQCLOSE
            let node.rlist[1] = self.parse_expr1()
          endif
          let token = self.tokenizer.get()
          if token.type != s:TOKEN_SQCLOSE
            throw s:Err(printf('unexpected token: %s', token.value), token.pos)
          endif
        else
          let node = s:Node(s:NODE_SUBSCRIPT)
          let node.pos = npos
          let node.left = left
          let node.right = right
          let token = self.tokenizer.get()
          if token.type != s:TOKEN_SQCLOSE
            throw s:Err(printf('unexpected token: %s', token.value), token.pos)
          endif
        endif
      endif
      let left = node
    elseif !s:iswhite(c) && token.type == s:TOKEN_DOT
      let node = self.parse_dot(token, left)
      if node is s:NIL
        call self.reader.seek_set(pos)
        break
      endif
      let left = node
    else
      call self.reader.seek_set(pos)
      break
    endif
  endwhile
  return left
endfunction

" expr9: &option
"        variable
"        var{ria}ble
"        $VAR
"        @r
function! s:LvalueParser.parse_lv9()
  let pos = self.reader.tell()
  let token = self.tokenizer.get()
  if token.type == s:TOKEN_COPEN
    call self.reader.seek_set(pos)
    let node = self.parse_identifier()
  elseif token.type == s:TOKEN_OPTION
    let node = s:Node(s:NODE_OPTION)
    let node.pos = token.pos
    let node.value = token.value
  elseif token.type == s:TOKEN_IDENTIFIER
    call self.reader.seek_set(pos)
    let node = self.parse_identifier()
  elseif token.type == s:TOKEN_LT && self.reader.peekn(4) ==? 'SID>'
    call self.reader.seek_set(pos)
    let node = self.parse_identifier()
  elseif token.type == s:TOKEN_ENV
    let node = s:Node(s:NODE_ENV)
    let node.pos = token.pos
    let node.value = token.value
  elseif token.type == s:TOKEN_REG
    let node = s:Node(s:NODE_REG)
    let node.pos = token.pos
    let node.pos = token.pos
    let node.value = token.value
  else
    throw s:Err(printf('unexpected token: %s', token.value), token.pos)
  endif
  return node
endfunction

let s:StringReader = {}

function! s:StringReader.new(...)
  let obj = copy(self)
  call call(obj.__init__, a:000, obj)
  return obj
endfunction

function! s:StringReader.__init__(lines)
  let lines = type(a:lines) == 3 ? a:lines : [a:lines]
  let self.buf = []
  let self.pos = []
  let lnum = 0
  while lnum < len(lines)
    let col = 0
    for c in split(lines[lnum], '\zs')
      call add(self.buf, c)
      call add(self.pos, [lnum + 1, col + 1])
      let col += len(c)
    endfor
    while lnum + 1 < len(lines) && lines[lnum + 1] =~# '^\s*\\'
      let skip = 1
      let col = 0
      for c in split(lines[lnum + 1], '\zs')
        if skip
          if c == '\'
            let skip = 0
          endif
        else
          call add(self.buf, c)
          call add(self.pos, [lnum + 1, col + 1])
        endif
        let col += len(c)
      endfor
      let lnum += 1
    endwhile
    call add(self.buf, '<EOL>')
    call add(self.pos, [lnum + 1, col + 1])
    let lnum += 1
  endwhile
  " for <EOF>
  call add(self.pos, [lnum + 1, 0])
  let self.i = 0
endfunction

function! s:StringReader.eof()
  return self.i >= len(self.buf)
endfunction

function! s:StringReader.tell()
  return self.i
endfunction

function! s:StringReader.seek_set(i)
  let self.i = a:i
endfunction

function! s:StringReader.seek_cur(i)
  let self.i = self.i + a:i
endfunction

function! s:StringReader.seek_end(i)
  let self.i = len(self.buf) + a:i
endfunction

function! s:StringReader.p(i)
  if self.i >= len(self.buf)
    return '<EOF>'
  endif
  return self.buf[self.i + a:i]
endfunction

function! s:StringReader.peek()
  if self.i >= len(self.buf)
    return '<EOF>'
  endif
  return self.buf[self.i]
endfunction

function! s:StringReader.get()
  if self.i >= len(self.buf)
    return '<EOF>'
  endif
  let self.i += 1
  return self.buf[self.i - 1]
endfunction

function! s:StringReader.peekn(n)
  let pos = self.tell()
  let r = self.getn(a:n)
  call self.seek_set(pos)
  return r
endfunction

function! s:StringReader.getn(n)
  let r = ''
  let j = 0
  while self.i < len(self.buf) && (a:n < 0 || j < a:n)
    let c = self.buf[self.i]
    if c ==# '<EOL>'
      break
    endif
    let r .= c
    let self.i += 1
    let j += 1
  endwhile
  return r
endfunction

function! s:StringReader.peekline()
  return self.peekn(-1)
endfunction

function! s:StringReader.readline()
  let r = self.getn(-1)
  call self.get()
  return r
endfunction

function! s:StringReader.getstr(begin, end)
  let r = ''
  for i in range(a:begin.i, a:end.i - 1)
    if i >= len(self.buf)
      break
    endif
    let c = self.buf[i]
    if c ==# '<EOL>'
      let c = "\n"
    endif
    let r .= c
  endfor
  return r
endfunction

function! s:StringReader.getpos()
  let [lnum, col] = self.pos[self.i]
  return {'i': self.i, 'lnum': lnum, 'col': col}
endfunction

function! s:StringReader.setpos(pos)
  let self.i  = a:pos.i
endfunction

function! s:StringReader.read_alpha()
  let r = ''
  while s:isalpha(self.peekn(1))
    let r .= self.getn(1)
  endwhile
  return r
endfunction

function! s:StringReader.read_alnum()
  let r = ''
  while s:isalnum(self.peekn(1))
    let r .= self.getn(1)
  endwhile
  return r
endfunction

function! s:StringReader.read_digit()
  let r = ''
  while s:isdigit(self.peekn(1))
    let r .= self.getn(1)
  endwhile
  return r
endfunction

function! s:StringReader.read_xdigit()
  let r = ''
  while s:isxdigit(self.peekn(1))
    let r .= self.getn(1)
  endwhile
  return r
endfunction

function! s:StringReader.read_integer()
  let r = ''
  let c = self.peekn(1)
  if c == '-' || c == '+'
    let r = self.getn(1)
  endif
  return r . self.read_digit()
endfunction

function! s:StringReader.read_word()
  let r = ''
  while s:iswordc(self.peekn(1))
    let r .= self.getn(1)
  endwhile
  return r
endfunction

function! s:StringReader.read_white()
  let r = ''
  while s:iswhite(self.peekn(1))
    let r .= self.getn(1)
  endwhile
  return r
endfunction

function! s:StringReader.read_nonwhite()
  let r = ''
  while !s:iswhite(self.peekn(1))
    let r .= self.getn(1)
  endwhile
  return r
endfunction

function! s:StringReader.read_name()
  let r = ''
  while s:isnamec(self.peekn(1))
    let r .= self.getn(1)
  endwhile
  return r
endfunction

function! s:StringReader.skip_white()
  while s:iswhite(self.peekn(1))
    call self.seek_cur(1)
  endwhile
endfunction

function! s:StringReader.skip_white_and_colon()
  while 1
    let c = self.peekn(1)
    if !s:iswhite(c) && c !=# ':'
      break
    endif
    call self.seek_cur(1)
  endwhile
endfunction

let s:Compiler = {}

function! s:Compiler.new(...)
  let obj = copy(self)
  call call(obj.__init__, a:000, obj)
  return obj
endfunction

function! s:Compiler.__init__()
  let self.indent = ['']
  let self.lines = []
endfunction

function! s:Compiler.out(...)
  if len(a:000) == 1
    if a:000[0][0] ==# ')'
      let self.lines[-1] .= a:000[0]
    else
      call add(self.lines, self.indent[0] . a:000[0])
    endif
  else
    call add(self.lines, self.indent[0] . call('printf', a:000))
  endif
endfunction

function! s:Compiler.incindent(s)
  call insert(self.indent, self.indent[0] . a:s)
endfunction

function! s:Compiler.decindent()
  call remove(self.indent, 0)
endfunction

function! s:Compiler.compile(node)
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
    throw printf('Compiler: unknown node: %s', string(a:node))
  endif
endfunction

function! s:Compiler.compile_body(body)
  for node in a:body
    call self.compile(node)
  endfor
endfunction

function! s:Compiler.compile_toplevel(node)
  call self.compile_body(a:node.body)
  return self.lines
endfunction

function! s:Compiler.compile_comment(node)
  call self.out(';%s', a:node.str)
endfunction

function! s:Compiler.compile_excmd(node)
  call self.out('(excmd "%s")', escape(a:node.str, '\"'))
endfunction

function! s:Compiler.compile_function(node)
  let left = self.compile(a:node.left)
  let rlist = map(a:node.rlist, 'self.compile(v:val)')
  if !empty(rlist) && rlist[-1] ==# '...'
    let rlist[-1] = '. ...'
  endif
  if empty(rlist)
    call self.out('(function (%s)', left)
  else
    call self.out('(function (%s %s)', left, join(rlist, ' '))
  endif
  call self.incindent('  ')
  call self.compile_body(a:node.body)
  call self.out(')')
  call self.decindent()
endfunction

function! s:Compiler.compile_delfunction(node)
  call self.out('(delfunction %s)', self.compile(a:node.left))
endfunction

function! s:Compiler.compile_return(node)
  if a:node.left is s:NIL
    call self.out('(return)')
  else
    call self.out('(return %s)', self.compile(a:node.left))
  endif
endfunction

function! s:Compiler.compile_excall(node)
  call self.out('(call %s)', self.compile(a:node.left))
endfunction

function! s:Compiler.compile_let(node)
  if a:node.left isnot s:NIL
    let left = self.compile(a:node.left)
  else
    let left = join(map(a:node.list, 'self.compile(v:val)'), ' ')
    if a:node.rest isnot s:NIL
      let left .= ' . ' . self.compile(a:node.rest)
    endif
    let left = '(' . left . ')'
  endif
  let right = self.compile(a:node.right)
  call self.out('(let %s %s %s)', a:node.op, left, right)
endfunction

function! s:Compiler.compile_unlet(node)
  let list = map(a:node.list, 'self.compile(v:val)')
  call self.out('(unlet %s)', join(list, ' '))
endfunction

function! s:Compiler.compile_lockvar(node)
  let list = map(a:node.list, 'self.compile(v:val)')
  if a:node.depth is s:NIL
    call self.out('(lockvar %s)', join(list, ' '))
  else
    call self.out('(lockvar %s %s)', a:node.depth, join(list, ' '))
  endif
endfunction

function! s:Compiler.compile_unlockvar(node)
  let list = map(a:node.list, 'self.compile(v:val)')
  if a:node.depth is s:NIL
    call self.out('(unlockvar %s)', join(list, ' '))
  else
    call self.out('(unlockvar %s %s)', a:node.depth, join(list, ' '))
  endif
endfunction

function! s:Compiler.compile_if(node)
  call self.out('(if %s', self.compile(a:node.cond))
  call self.incindent('  ')
  call self.compile_body(a:node.body)
  call self.decindent()
  for enode in a:node.elseif
    call self.out(' elseif %s', self.compile(enode.cond))
    call self.incindent('  ')
    call self.compile_body(enode.body)
    call self.decindent()
  endfor
  if a:node.else isnot s:NIL
    call self.out(' else')
    call self.incindent('  ')
    call self.compile_body(a:node.else.body)
    call self.decindent()
  endif
  call self.incindent('  ')
  call self.out(')')
  call self.decindent()
endfunction

function! s:Compiler.compile_while(node)
  call self.out('(while %s', self.compile(a:node.cond))
  call self.incindent('  ')
  call self.compile_body(a:node.body)
  call self.out(')')
  call self.decindent()
endfunction

function! s:Compiler.compile_for(node)
  if a:node.left isnot s:NIL
    let left = self.compile(a:node.left)
  else
    let left = join(map(a:node.list, 'self.compile(v:val)'), ' ')
    if a:node.rest isnot s:NIL
      let left .= ' . ' . self.compile(a:node.rest)
    endif
    let left = '(' . left . ')'
  endif
  let right = self.compile(a:node.right)
  call self.out('(for %s %s', left, right)
  call self.incindent('  ')
  call self.compile_body(a:node.body)
  call self.out(')')
  call self.decindent()
endfunction

function! s:Compiler.compile_continue(node)
  call self.out('(continue)')
endfunction

function! s:Compiler.compile_break(node)
  call self.out('(break)')
endfunction

function! s:Compiler.compile_try(node)
  call self.out('(try')
  call self.incindent('  ')
  call self.compile_body(a:node.body)
  for cnode in a:node.catch
    if cnode.pattern isnot s:NIL
      call self.decindent()
      call self.out(' catch /%s/', cnode.pattern)
      call self.incindent('  ')
      call self.compile_body(cnode.body)
    else
      call self.decindent()
      call self.out(' catch')
      call self.incindent('  ')
      call self.compile_body(cnode.body)
    endif
  endfor
  if a:node.finally isnot s:NIL
    call self.decindent()
    call self.out(' finally')
    call self.incindent('  ')
    call self.compile_body(a:node.finally.body)
  endif
  call self.out(')')
  call self.decindent()
endfunction

function! s:Compiler.compile_throw(node)
  call self.out('(throw %s)', self.compile(a:node.left))
endfunction

function! s:Compiler.compile_echo(node)
  let list = map(a:node.list, 'self.compile(v:val)')
  call self.out('(echo %s)', join(list, ' '))
endfunction

function! s:Compiler.compile_echon(node)
  let list = map(a:node.list, 'self.compile(v:val)')
  call self.out('(echon %s)', join(list, ' '))
endfunction

function! s:Compiler.compile_echohl(node)
  call self.out('(echohl "%s")', escape(a:node.str, '\"'))
endfunction

function! s:Compiler.compile_echomsg(node)
  let list = map(a:node.list, 'self.compile(v:val)')
  call self.out('(echomsg %s)', join(list, ' '))
endfunction

function! s:Compiler.compile_echoerr(node)
  let list = map(a:node.list, 'self.compile(v:val)')
  call self.out('(echoerr %s)', join(list, ' '))
endfunction

function! s:Compiler.compile_execute(node)
  let list = map(a:node.list, 'self.compile(v:val)')
  call self.out('(execute %s)', join(list, ' '))
endfunction

function! s:Compiler.compile_ternary(node)
  return printf('(?: %s %s %s)', self.compile(a:node.cond), self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_or(node)
  return printf('(|| %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_and(node)
  return printf('(&& %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_equal(node)
  return printf('(== %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_equalci(node)
  return printf('(==? %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_equalcs(node)
  return printf('(==# %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_nequal(node)
  return printf('(!= %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_nequalci(node)
  return printf('(!=? %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_nequalcs(node)
  return printf('(!=# %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_greater(node)
  return printf('(> %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_greaterci(node)
  return printf('(>? %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_greatercs(node)
  return printf('(># %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_gequal(node)
  return printf('(>= %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_gequalci(node)
  return printf('(>=? %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_gequalcs(node)
  return printf('(>=# %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_smaller(node)
  return printf('(< %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_smallerci(node)
  return printf('(<? %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_smallercs(node)
  return printf('(<# %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_sequal(node)
  return printf('(<= %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_sequalci(node)
  return printf('(<=? %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_sequalcs(node)
  return printf('(<=# %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_match(node)
  return printf('(=~ %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_matchci(node)
  return printf('(=~? %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_matchcs(node)
  return printf('(=~# %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_nomatch(node)
  return printf('(!~ %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_nomatchci(node)
  return printf('(!~? %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_nomatchcs(node)
  return printf('(!~# %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_is(node)
  return printf('(is %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_isci(node)
  return printf('(is? %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_iscs(node)
  return printf('(is# %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_isnot(node)
  return printf('(isnot %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_isnotci(node)
  return printf('(isnot? %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_isnotcs(node)
  return printf('(isnot# %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_add(node)
  return printf('(+ %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_subtract(node)
  return printf('(- %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_concat(node)
  return printf('(concat %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_multiply(node)
  return printf('(* %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_divide(node)
  return printf('(/ %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_remainder(node)
  return printf('(%% %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_not(node)
  return printf('(! %s)', self.compile(a:node.left))
endfunction

function! s:Compiler.compile_plus(node)
  return printf('(+ %s)', self.compile(a:node.left))
endfunction

function! s:Compiler.compile_minus(node)
  return printf('(- %s)', self.compile(a:node.left))
endfunction

function! s:Compiler.compile_subscript(node)
  return printf('(subscript %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_slice(node)
  let r0 = a:node.rlist[0] is s:NIL ? 'nil' : self.compile(a:node.rlist[0])
  let r1 = a:node.rlist[1] is s:NIL ? 'nil' : self.compile(a:node.rlist[1])
  return printf('(slice %s %s %s)', self.compile(a:node.left), r0, r1)
endfunction

function! s:Compiler.compile_dot(node)
  return printf('(dot %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_call(node)
  let rlist = map(a:node.rlist, 'self.compile(v:val)')
  if empty(rlist)
    return printf('(%s)', self.compile(a:node.left))
  else
    return printf('(%s %s)', self.compile(a:node.left), join(rlist, ' '))
  endif
endfunction

function! s:Compiler.compile_number(node)
  return a:node.value
endfunction

function! s:Compiler.compile_string(node)
  return a:node.value
endfunction

function! s:Compiler.compile_list(node)
  let value = map(a:node.value, 'self.compile(v:val)')
  if empty(value)
    return '(list)'
  else
    return printf('(list %s)', join(value, ' '))
  endif
endfunction

function! s:Compiler.compile_dict(node)
  let value = map(a:node.value, '"(" . self.compile(v:val[0]) . " " . self.compile(v:val[1]) . ")"')
  if empty(value)
    return '(dict)'
  else
    return printf('(dict %s)', join(value, ' '))
  endif
endfunction

function! s:Compiler.compile_option(node)
  return a:node.value
endfunction

function! s:Compiler.compile_identifier(node)
  return a:node.value
endfunction

function! s:Compiler.compile_curlyname(node)
  let name = ''
  for x in a:node.value
    if x.curly
      let name .= '{' . self.compile(x.value) . '}'
    else
      let name .= x.value
    endif
  endfor
  return name
endfunction

function! s:Compiler.compile_env(node)
  return a:node.value
endfunction

function! s:Compiler.compile_reg(node)
  return a:node.value
endfunction

