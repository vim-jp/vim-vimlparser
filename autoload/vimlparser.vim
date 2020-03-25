" vim:set ts=8 sts=2 sw=2 tw=0 et:
"
" VimL parser - Vim Script Parser
"
" License: This file is placed in the public domain.

function! vimlparser#import() abort
  return s:
endfunction

" @brief Read input as VimScript and return stringified AST.
" @param input Input filename or string of VimScript.
" @return Stringified AST.
function! vimlparser#test(input, ...) abort
  try
    if a:0 > 0
      let l:neovim = a:1
    else
      let l:neovim = 0
    endif
    let i = type(a:input) ==# 1 && filereadable(a:input) ? readfile(a:input) : split(a:input, "\n")
    let r = s:StringReader.new(i)
    let p = s:VimLParser.new(l:neovim)
    let c = s:Compiler.new()
    echo join(c.compile(p.parse(r)), "\n")
  catch
    echoerr substitute(v:throwpoint, '\.\.\zs\d\+', '\=s:numtoname(submatch(0))', 'g') . "\n" . v:exception
  endtry
endfunction

function! s:numtoname(num) abort
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

let s:NIL = []
let s:TRUE = 1
let s:FALSE = 0

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
let s:NODE_CURLYNAMEPART = 90
let s:NODE_CURLYNAMEEXPR = 91
let s:NODE_LAMBDA = 92
let s:NODE_BLOB = 93
let s:NODE_CONST = 94
let s:NODE_EVAL = 95
let s:NODE_HEREDOC = 96
let s:NODE_METHOD = 97

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
let s:TOKEN_SHARP = 64
let s:TOKEN_ARROW = 65
let s:TOKEN_BLOB = 66
let s:TOKEN_LITCOPEN = 67
let s:TOKEN_DOTDOT = 68
let s:TOKEN_HEREDOC = 69

let s:MAX_FUNC_ARGS = 20

function! s:isalpha(c) abort
  return a:c =~# '^[A-Za-z]$'
endfunction

function! s:isalnum(c) abort
  return a:c =~# '^[0-9A-Za-z]$'
endfunction

function! s:isdigit(c) abort
  return a:c =~# '^[0-9]$'
endfunction

function! s:isodigit(c) abort
  return a:c =~# '^[0-7]$'
endfunction

function! s:isxdigit(c) abort
  return a:c =~# '^[0-9A-Fa-f]$'
endfunction

function! s:iswordc(c) abort
  return a:c =~# '^[0-9A-Za-z_]$'
endfunction

function! s:iswordc1(c) abort
  return a:c =~# '^[A-Za-z_]$'
endfunction

function! s:iswhite(c) abort
  return a:c =~# '^[ \t]$'
endfunction

function! s:isnamec(c) abort
  return a:c =~# '^[0-9A-Za-z_:#]$'
endfunction

function! s:isnamec1(c) abort
  return a:c =~# '^[A-Za-z_]$'
endfunction

function! s:isargname(s) abort
  return a:s =~# '^[A-Za-z_][0-9A-Za-z_]*$'
endfunction

function! s:isvarname(s) abort
  return a:s =~# '^[vgslabwt]:$\|^\([vgslabwt]:\)\?[A-Za-z_][0-9A-Za-z_#]*$'
endfunction

" FIXME:
function! s:isidc(c) abort
  return a:c =~# '^[0-9A-Za-z_]$'
endfunction

function! s:isupper(c) abort
  return a:c =~# '^[A-Z]$'
endfunction

function! s:islower(c) abort
  return a:c =~# '^[a-z]$'
endfunction

function! s:ExArg() abort
  let ea = {}
  let ea.forceit = s:FALSE
  let ea.addr_count = 0
  let ea.line1 = 0
  let ea.line2 = 0
  let ea.flags = 0
  let ea.do_ecmd_cmd = ''
  let ea.do_ecmd_lnum = 0
  let ea.append = 0
  let ea.usefilter = s:FALSE
  let ea.amount = 0
  let ea.regname = 0
  let ea.force_bin = 0
  let ea.read_edit = 0
  let ea.force_ff = 0
  let ea.force_enc = 0
  let ea.bad_char = 0
  let ea.linepos = {}
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
"   node[]  default_args
"   node[]  body
"   string  op
"   string  str
"   int     depth
"   variant value
" }
" TOPLEVEL .body
" COMMENT .str
" EXCMD .ea .str
" FUNCTION .ea .body .left .rlist .default_args .attr .endfunction
" ENDFUNCTION .ea
" DELFUNCTION .ea .left
" RETURN .ea .left
" EXCALL .ea .left
" LET .ea .op .left .list .rest .right
" CONST .ea .op .left .list .rest .right
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
" EVAL .ea .left
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
" METHOD .left .right
" CALL .left .rlist
" DOT .left .right
" NUMBER .value
" STRING .value
" LIST .value
" DICT .value
" BLOB .value
" NESTING .left
" OPTION .value
" IDENTIFIER .value
" CURLYNAME .value
" ENV .value
" REG .value
" CURLYNAMEPART .value
" CURLYNAMEEXPR .value
" LAMBDA .rlist .left
" HEREDOC .rlist .op .body
function! s:Node(type) abort
  return {'type': a:type}
endfunction

function! s:Err(msg, pos) abort
  return printf('vimlparser: %s: line %d col %d', a:msg, a:pos.lnum, a:pos.col)
endfunction

let s:VimLParser = {}

function! s:VimLParser.new(...) abort
  let obj = copy(self)
  call call(obj.__init__, a:000, obj)
  return obj
endfunction

function! s:VimLParser.__init__(...) abort
  if len(a:000) > 0
    let self.neovim = a:000[0]
  else
    let self.neovim = 0
  endif

  let self.find_command_cache = {}
endfunction

function! s:VimLParser.push_context(node) abort
  call insert(self.context, a:node)
endfunction

function! s:VimLParser.pop_context() abort
  call remove(self.context, 0)
endfunction

function! s:VimLParser.find_context(type) abort
  let i = 0
  for node in self.context
    if node.type ==# a:type
      return i
    endif
    let i += 1
  endfor
  return -1
endfunction

function! s:VimLParser.add_node(node) abort
  call add(self.context[0].body, a:node)
endfunction

function! s:VimLParser.check_missing_endfunction(ends, pos) abort
  if self.context[0].type ==# s:NODE_FUNCTION
    throw s:Err(printf('E126: Missing :endfunction:    %s', a:ends), a:pos)
  endif
endfunction

function! s:VimLParser.check_missing_endif(ends, pos) abort
  if self.context[0].type ==# s:NODE_IF || self.context[0].type ==# s:NODE_ELSEIF || self.context[0].type ==# s:NODE_ELSE
    throw s:Err(printf('E171: Missing :endif:    %s', a:ends), a:pos)
  endif
endfunction

function! s:VimLParser.check_missing_endtry(ends, pos) abort
  if self.context[0].type ==# s:NODE_TRY || self.context[0].type ==# s:NODE_CATCH || self.context[0].type ==# s:NODE_FINALLY
    throw s:Err(printf('E600: Missing :endtry:    %s', a:ends), a:pos)
  endif
endfunction

function! s:VimLParser.check_missing_endwhile(ends, pos) abort
  if self.context[0].type ==# s:NODE_WHILE
    throw s:Err(printf('E170: Missing :endwhile:    %s', a:ends), a:pos)
  endif
endfunction

function! s:VimLParser.check_missing_endfor(ends, pos) abort
  if self.context[0].type ==# s:NODE_FOR
    throw s:Err(printf('E170: Missing :endfor:    %s', a:ends), a:pos)
  endif
endfunction

function! s:VimLParser.parse(reader) abort
  let self.reader = a:reader
  let self.context = []
  let toplevel = s:Node(s:NODE_TOPLEVEL)
  let toplevel.pos = self.reader.getpos()
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

function! s:VimLParser.parse_one_cmd() abort
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
function! s:VimLParser.parse_command_modifiers() abort
  let modifiers = []
  while s:TRUE
    let pos = self.reader.tell()
    let d = ''
    if s:isdigit(self.reader.peekn(1))
      let d = self.reader.read_digit()
      call self.reader.skip_white()
    endif
    let k = self.reader.read_alpha()
    let c = self.reader.peekn(1)
    call self.reader.skip_white()
    if stridx('aboveleft', k) ==# 0 && len(k) >= 3 " abo\%[veleft]
      call add(modifiers, {'name': 'aboveleft'})
    elseif stridx('belowright', k) ==# 0 && len(k) >= 3 " bel\%[owright]
      call add(modifiers, {'name': 'belowright'})
    elseif stridx('browse', k) ==# 0 && len(k) >= 3 " bro\%[wse]
      call add(modifiers, {'name': 'browse'})
    elseif stridx('botright', k) ==# 0 && len(k) >= 2 " bo\%[tright]
      call add(modifiers, {'name': 'botright'})
    elseif stridx('confirm', k) ==# 0 && len(k) >= 4 " conf\%[irm]
      call add(modifiers, {'name': 'confirm'})
    elseif stridx('keepmarks', k) ==# 0 && len(k) >= 3 " kee\%[pmarks]
      call add(modifiers, {'name': 'keepmarks'})
    elseif stridx('keepalt', k) ==# 0 && len(k) >= 5 " keepa\%[lt]
      call add(modifiers, {'name': 'keepalt'})
    elseif stridx('keepjumps', k) ==# 0 && len(k) >= 5 " keepj\%[umps]
      call add(modifiers, {'name': 'keepjumps'})
    elseif stridx('keeppatterns', k) ==# 0 && len(k) >= 5 " keepp\%[atterns]
      call add(modifiers, {'name': 'keeppatterns'})
    elseif stridx('hide', k) ==# 0 && len(k) >= 3 " hid\%[e]
      if self.ends_excmds(c)
        break
      endif
      call add(modifiers, {'name': 'hide'})
    elseif stridx('lockmarks', k) ==# 0 && len(k) >= 3 " loc\%[kmarks]
      call add(modifiers, {'name': 'lockmarks'})
    elseif stridx('leftabove', k) ==# 0 && len(k) >= 5 " lefta\%[bove]
      call add(modifiers, {'name': 'leftabove'})
    elseif stridx('noautocmd', k) ==# 0 && len(k) >= 3 " noa\%[utocmd]
      call add(modifiers, {'name': 'noautocmd'})
    elseif stridx('noswapfile', k) ==# 0 && len(k) >= 3 " :nos\%[wapfile]
      call add(modifiers, {'name': 'noswapfile'})
    elseif stridx('rightbelow', k) ==# 0 && len(k) >= 6 " rightb\%[elow]
      call add(modifiers, {'name': 'rightbelow'})
    elseif stridx('sandbox', k) ==# 0 && len(k) >= 3 " san\%[dbox]
      call add(modifiers, {'name': 'sandbox'})
    elseif stridx('silent', k) ==# 0 && len(k) >= 3 " sil\%[ent]
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
    elseif stridx('topleft', k) ==# 0 && len(k) >= 2 " to\%[pleft]
      call add(modifiers, {'name': 'topleft'})
    elseif stridx('unsilent', k) ==# 0 && len(k) >= 3 " uns\%[ilent]
      call add(modifiers, {'name': 'unsilent'})
    elseif stridx('vertical', k) ==# 0 && len(k) >= 4 " vert\%[ical]
      call add(modifiers, {'name': 'vertical'})
    elseif stridx('verbose', k) ==# 0 && len(k) >= 4 " verb\%[ose]
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
function! s:VimLParser.parse_range() abort
  let tokens = []

  while s:TRUE

    while s:TRUE
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
        let [pattern, _] = self.parse_pattern(c)
        call add(tokens, pattern)
      elseif c ==# '?'
        call self.reader.getn(1)
        let [pattern, _] = self.parse_pattern(c)
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

      while s:TRUE
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
function! s:VimLParser.parse_pattern(delimiter) abort
  let pattern = ''
  let endc = ''
  let inbracket = 0
  while s:TRUE
    let c = self.reader.getn(1)
    if c ==# ''
      break
    endif
    if c ==# a:delimiter && inbracket ==# 0
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

function! s:VimLParser.parse_command() abort
  call self.reader.skip_white_and_colon()

  let self.ea.cmdpos = self.reader.getpos()

  if self.reader.peekn(1) ==# '' || self.reader.peekn(1) ==# '"'
    if !empty(self.ea.modifiers) || !empty(self.ea.range)
      call self.parse_cmd_modifier_range()
    endif
    return
  endif

  let self.ea.cmd = self.find_command()

  if self.ea.cmd is# s:NIL
    call self.reader.setpos(self.ea.cmdpos)
    throw s:Err(printf('E492: Not an editor command: %s', self.reader.peekline()), self.ea.cmdpos)
  endif

  if self.reader.peekn(1) ==# '!' && self.ea.cmd.name !=# 'substitute' && self.ea.cmd.name !=# 'smagic' && self.ea.cmd.name !=# 'snomagic'
    call self.reader.getn(1)
    let self.ea.forceit = s:TRUE
  else
    let self.ea.forceit = s:FALSE
  endif

  if self.ea.cmd.flags !~# '\<BANG\>' && self.ea.forceit && self.ea.cmd.flags !~# '\<USERCMD\>'
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
      let self.ea.usefilter = s:TRUE
    endif
  endif

  if self.ea.cmd.name ==# 'read'
    if self.ea.forceit
      let self.ea.usefilter = s:TRUE
      let self.ea.forceit = s:FALSE
    elseif self.reader.peekn(1) ==# '!'
      call self.reader.getn(1)
      let self.ea.usefilter = s:TRUE
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

  call self._parse_command(self.ea.cmd.parser)
endfunction

" TODO: self[a:parser]
function! s:VimLParser._parse_command(parser) abort
  if a:parser ==# 'parse_cmd_append'
    call self.parse_cmd_append()
  elseif a:parser ==# 'parse_cmd_break'
    call self.parse_cmd_break()
  elseif a:parser ==# 'parse_cmd_call'
    call self.parse_cmd_call()
  elseif a:parser ==# 'parse_cmd_catch'
    call self.parse_cmd_catch()
  elseif a:parser ==# 'parse_cmd_common'
    call self.parse_cmd_common()
  elseif a:parser ==# 'parse_cmd_continue'
    call self.parse_cmd_continue()
  elseif a:parser ==# 'parse_cmd_delfunction'
    call self.parse_cmd_delfunction()
  elseif a:parser ==# 'parse_cmd_echo'
    call self.parse_cmd_echo()
  elseif a:parser ==# 'parse_cmd_echoerr'
    call self.parse_cmd_echoerr()
  elseif a:parser ==# 'parse_cmd_echohl'
    call self.parse_cmd_echohl()
  elseif a:parser ==# 'parse_cmd_echomsg'
    call self.parse_cmd_echomsg()
  elseif a:parser ==# 'parse_cmd_echon'
    call self.parse_cmd_echon()
  elseif a:parser ==# 'parse_cmd_else'
    call self.parse_cmd_else()
  elseif a:parser ==# 'parse_cmd_elseif'
    call self.parse_cmd_elseif()
  elseif a:parser ==# 'parse_cmd_endfor'
    call self.parse_cmd_endfor()
  elseif a:parser ==# 'parse_cmd_endfunction'
    call self.parse_cmd_endfunction()
  elseif a:parser ==# 'parse_cmd_endif'
    call self.parse_cmd_endif()
  elseif a:parser ==# 'parse_cmd_endtry'
    call self.parse_cmd_endtry()
  elseif a:parser ==# 'parse_cmd_endwhile'
    call self.parse_cmd_endwhile()
  elseif a:parser ==# 'parse_cmd_execute'
    call self.parse_cmd_execute()
  elseif a:parser ==# 'parse_cmd_finally'
    call self.parse_cmd_finally()
  elseif a:parser ==# 'parse_cmd_finish'
    call self.parse_cmd_finish()
  elseif a:parser ==# 'parse_cmd_for'
    call self.parse_cmd_for()
  elseif a:parser ==# 'parse_cmd_function'
    call self.parse_cmd_function()
  elseif a:parser ==# 'parse_cmd_if'
    call self.parse_cmd_if()
  elseif a:parser ==# 'parse_cmd_insert'
    call self.parse_cmd_insert()
  elseif a:parser ==# 'parse_cmd_let'
    call self.parse_cmd_let()
  elseif a:parser ==# 'parse_cmd_const'
    call self.parse_cmd_const()
  elseif a:parser ==# 'parse_cmd_loadkeymap'
    call self.parse_cmd_loadkeymap()
  elseif a:parser ==# 'parse_cmd_lockvar'
    call self.parse_cmd_lockvar()
  elseif a:parser ==# 'parse_cmd_lua'
    call self.parse_cmd_lua()
  elseif a:parser ==# 'parse_cmd_modifier_range'
    call self.parse_cmd_modifier_range()
  elseif a:parser ==# 'parse_cmd_mzscheme'
    call self.parse_cmd_mzscheme()
  elseif a:parser ==# 'parse_cmd_perl'
    call self.parse_cmd_perl()
  elseif a:parser ==# 'parse_cmd_python'
    call self.parse_cmd_python()
  elseif a:parser ==# 'parse_cmd_python3'
    call self.parse_cmd_python3()
  elseif a:parser ==# 'parse_cmd_return'
    call self.parse_cmd_return()
  elseif a:parser ==# 'parse_cmd_ruby'
    call self.parse_cmd_ruby()
  elseif a:parser ==# 'parse_cmd_tcl'
    call self.parse_cmd_tcl()
  elseif a:parser ==# 'parse_cmd_throw'
    call self.parse_cmd_throw()
  elseif a:parser ==# 'parse_cmd_eval'
    call self.parse_cmd_eval()
  elseif a:parser ==# 'parse_cmd_try'
    call self.parse_cmd_try()
  elseif a:parser ==# 'parse_cmd_unlet'
    call self.parse_cmd_unlet()
  elseif a:parser ==# 'parse_cmd_unlockvar'
    call self.parse_cmd_unlockvar()
  elseif a:parser ==# 'parse_cmd_usercmd'
    call self.parse_cmd_usercmd()
  elseif a:parser ==# 'parse_cmd_while'
    call self.parse_cmd_while()
  elseif a:parser ==# 'parse_wincmd'
    call self.parse_wincmd()
  elseif a:parser ==# 'parse_cmd_syntax'
    call self.parse_cmd_syntax()
  else
    throw printf('unknown parser: %s', string(a:parser))
  endif
endfunction

function! s:VimLParser.find_command() abort
  let c = self.reader.peekn(1)
  let name = ''

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

  if name ==# ''
    return s:NIL
  endif

  if has_key(self.find_command_cache, name)
    return self.find_command_cache[name]
  endif

  let cmd = s:NIL

  for x in self.builtin_commands
    if stridx(x.name, name) ==# 0 && len(name) >= x.minlen
      unlet cmd
      let cmd = x
      break
    endif
  endfor

  if self.neovim
    for x in self.neovim_additional_commands
      if stridx(x.name, name) ==# 0 && len(name) >= x.minlen
        unlet cmd
        let cmd = x
        break
      endif
    endfor

    for x in self.neovim_removed_commands
      if stridx(x.name, name) ==# 0 && len(name) >= x.minlen
        unlet cmd
        let cmd = s:NIL
        break
      endif
    endfor
  endif

  " FIXME: user defined command
  if (cmd is# s:NIL || cmd.name ==# 'Print') && name =~# '^[A-Z]'
    let name .= self.reader.read_alnum()
    unlet cmd
    let cmd = {'name': name, 'flags': 'USERCMD', 'parser': 'parse_cmd_usercmd'}
  endif

  let self.find_command_cache[name] = cmd

  return cmd
endfunction

" TODO:
function! s:VimLParser.parse_hashbang() abort
  call self.reader.getn(-1)
endfunction

" TODO:
" ++opt=val
function! s:VimLParser.parse_argopt() abort
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
      throw s:Err('E474: Invalid Argument', self.reader.getpos())
    else
      break
    endif
    call self.reader.skip_white()
  endwhile
endfunction

" TODO:
" +command
function! s:VimLParser.parse_argcmd() abort
  if self.reader.peekn(1) ==# '+'
    call self.reader.getn(1)
    if self.reader.peekn(1) ==# ' '
      let self.ea.do_ecmd_cmd = '$'
    else
      let self.ea.do_ecmd_cmd = self.read_cmdarg()
    endif
  endif
endfunction

function! s:VimLParser.read_cmdarg() abort
  let r = ''
  while s:TRUE
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

function! s:VimLParser.parse_comment() abort
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

function! s:VimLParser.parse_trail() abort
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
function! s:VimLParser.parse_cmd_modifier_range() abort
  let node = s:Node(s:NODE_EXCMD)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let node.str = self.reader.getstr(self.ea.linepos, self.reader.getpos())
  call self.add_node(node)
endfunction

" TODO:
function! s:VimLParser.parse_cmd_common() abort
  let end = self.reader.getpos()
  if self.ea.cmd.flags =~# '\<TRLBAR\>' && !self.ea.usefilter
    let end = self.separate_nextcmd()
  elseif self.ea.cmd.name ==# '!' || self.ea.cmd.name ==# 'global' || self.ea.cmd.name ==# 'vglobal' || self.ea.usefilter
    while s:TRUE
      let end = self.reader.getpos()
      if self.reader.getn(1) ==# ''
        break
      endif
    endwhile
  else
    while s:TRUE
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

function! s:VimLParser.separate_nextcmd() abort
  if self.ea.cmd.name ==# 'vimgrep' || self.ea.cmd.name ==# 'vimgrepadd' || self.ea.cmd.name ==# 'lvimgrep' || self.ea.cmd.name ==# 'lvimgrepadd'
    call self.skip_vimgrep_pat()
  endif
  let pc = ''
  let end = self.reader.getpos()
  let nospend = end
  while s:TRUE
    let end = self.reader.getpos()
    if !s:iswhite(pc)
      let nospend = end
    endif
    let c = self.reader.peek()
    if c ==# '<EOF>' || c ==# '<EOL>'
      break
    elseif c ==# "\x16" " <C-V>
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
          \       || self.reader.getpos().i !=# self.ea.argpos.i + 1 || pc !=# '@'))
      let has_cpo_bar = s:FALSE " &cpoptions =~ 'b'
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
function! s:VimLParser.skip_vimgrep_pat() abort
  if self.reader.peekn(1) ==# ''
    " pass
  elseif s:isidc(self.reader.peekn(1))
    " :vimgrep pattern fname
    call self.reader.read_nonwhite()
  else
    " :vimgrep /pattern/[g][j] fname
    let c = self.reader.getn(1)
    let [_, endc] = self.parse_pattern(c)
    if c !=# endc
      return
    endif
    while self.reader.p(0) ==# 'g' || self.reader.p(0) ==# 'j'
      call self.reader.getn(1)
    endwhile
  endif
endfunction

function! s:VimLParser.parse_cmd_append() abort
  call self.reader.setpos(self.ea.linepos)
  let cmdline = self.reader.readline()
  let lines = [cmdline]
  let m = '.'
  while s:TRUE
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

function! s:VimLParser.parse_cmd_insert() abort
  call self.parse_cmd_append()
endfunction

function! s:VimLParser.parse_cmd_loadkeymap() abort
  call self.reader.setpos(self.ea.linepos)
  let cmdline = self.reader.readline()
  let lines = [cmdline]
  while s:TRUE
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

function! s:VimLParser.parse_cmd_lua() abort
  let lines = []
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
    while s:TRUE
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

function! s:VimLParser.parse_cmd_mzscheme() abort
  call self.parse_cmd_lua()
endfunction

function! s:VimLParser.parse_cmd_perl() abort
  call self.parse_cmd_lua()
endfunction

function! s:VimLParser.parse_cmd_python() abort
  call self.parse_cmd_lua()
endfunction

function! s:VimLParser.parse_cmd_python3() abort
  call self.parse_cmd_lua()
endfunction

function! s:VimLParser.parse_cmd_ruby() abort
  call self.parse_cmd_lua()
endfunction

function! s:VimLParser.parse_cmd_tcl() abort
  call self.parse_cmd_lua()
endfunction

function! s:VimLParser.parse_cmd_finish() abort
  call self.parse_cmd_common()
  if self.context[0].type ==# s:NODE_TOPLEVEL
    call self.reader.seek_end(0)
  endif
endfunction

" FIXME
function! s:VimLParser.parse_cmd_usercmd() abort
  call self.parse_cmd_common()
endfunction

function! s:VimLParser.parse_cmd_function() abort
  let pos = self.reader.tell()
  call self.reader.skip_white()

  " :function
  if self.ends_excmds(self.reader.peek())
    call self.reader.seek_set(pos)
    call self.parse_cmd_common()
    return
  endif

  " :function /pattern
  if self.reader.peekn(1) ==# '/'
    call self.reader.seek_set(pos)
    call self.parse_cmd_common()
    return
  endif

  let left = self.parse_lvalue_func()
  call self.reader.skip_white()

  if left.type ==# s:NODE_IDENTIFIER
    let s = left.value
    let ss = split(s, '\zs')
    if ss[0] !=# '<' && ss[0] !=# '_' && !s:isupper(ss[0]) && stridx(s, ':') ==# -1 && stridx(s, '#') ==# -1
      throw s:Err(printf('E128: Function name must start with a capital or contain a colon: %s', s), left.pos)
    endif
  endif

  " :function {name}
  if self.reader.peekn(1) !=# '('
    call self.reader.seek_set(pos)
    call self.parse_cmd_common()
    return
  endif

  " :function[!] {name}([arguments]) [range] [abort] [dict] [closure]
  let node = s:Node(s:NODE_FUNCTION)
  let node.pos = self.ea.cmdpos
  let node.body = []
  let node.ea = self.ea
  let node.left = left
  let node.rlist = []
  let node.default_args = []
  let node.attr = {'range': 0, 'abort': 0, 'dict': 0, 'closure': 0}
  let node.endfunction = s:NIL
  call self.reader.getn(1)
  let tokenizer = s:ExprTokenizer.new(self.reader)
  if tokenizer.peek().type ==# s:TOKEN_PCLOSE
    call tokenizer.get()
  else
    let named = {}
    while s:TRUE
      let varnode = s:Node(s:NODE_IDENTIFIER)
      let token = tokenizer.get()
      if token.type ==# s:TOKEN_IDENTIFIER
        if !s:isargname(token.value) || token.value ==# 'firstline' || token.value ==# 'lastline'
          throw s:Err(printf('E125: Illegal argument: %s', token.value), token.pos)
        elseif has_key(named, token.value)
          throw s:Err(printf('E853: Duplicate argument name: %s', token.value), token.pos)
        endif
        let named[token.value] = 1
        let varnode.pos = token.pos
        let varnode.value = token.value
        call add(node.rlist, varnode)
        if tokenizer.peek().type ==# s:TOKEN_EQ
          call tokenizer.get()
          call add(node.default_args, self.parse_expr())
        elseif len(node.default_args) > 0
          throw s:Err('E989: Non-default argument follows default argument', varnode.pos)
        endif
        " XXX: Vim doesn't skip white space before comma.  F(a ,b) => E475
        if s:iswhite(self.reader.p(0)) && tokenizer.peek().type ==# s:TOKEN_COMMA
          throw s:Err('E475: Invalid argument: White space is not allowed before comma', self.reader.getpos())
        endif
        let token = tokenizer.get()
        if token.type ==# s:TOKEN_COMMA
          " XXX: Vim allows last comma.  F(a, b, ) => OK
          if tokenizer.peek().type ==# s:TOKEN_PCLOSE
            call tokenizer.get()
            break
          endif
        elseif token.type ==# s:TOKEN_PCLOSE
          break
        else
          throw s:Err(printf('unexpected token: %s', token.value), token.pos)
        endif
      elseif token.type ==# s:TOKEN_DOTDOTDOT
        let varnode.pos = token.pos
        let varnode.value = token.value
        call add(node.rlist, varnode)
        let token = tokenizer.get()
        if token.type ==# s:TOKEN_PCLOSE
          break
        else
          throw s:Err(printf('unexpected token: %s', token.value), token.pos)
        endif
      else
        throw s:Err(printf('unexpected token: %s', token.value), token.pos)
      endif
    endwhile
  endif
  while s:TRUE
    call self.reader.skip_white()
    let epos = self.reader.getpos()
    let key = self.reader.read_alpha()
    if key ==# ''
      break
    elseif key ==# 'range'
      let node.attr.range = s:TRUE
    elseif key ==# 'abort'
      let node.attr.abort = s:TRUE
    elseif key ==# 'dict'
      let node.attr.dict = s:TRUE
    elseif key ==# 'closure'
      let node.attr.closure = s:TRUE
    else
      throw s:Err(printf('unexpected token: %s', key), epos)
    endif
  endwhile
  call self.add_node(node)
  call self.push_context(node)
endfunction

function! s:VimLParser.parse_cmd_endfunction() abort
  call self.check_missing_endif('ENDFUNCTION', self.ea.cmdpos)
  call self.check_missing_endtry('ENDFUNCTION', self.ea.cmdpos)
  call self.check_missing_endwhile('ENDFUNCTION', self.ea.cmdpos)
  call self.check_missing_endfor('ENDFUNCTION', self.ea.cmdpos)
  if self.context[0].type !=# s:NODE_FUNCTION
    throw s:Err('E193: :endfunction not inside a function', self.ea.cmdpos)
  endif
  call self.reader.getn(-1)
  let node = s:Node(s:NODE_ENDFUNCTION)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let self.context[0].endfunction = node
  call self.pop_context()
endfunction

function! s:VimLParser.parse_cmd_delfunction() abort
  let node = s:Node(s:NODE_DELFUNCTION)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let node.left = self.parse_lvalue_func()
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_cmd_return() abort
  if self.find_context(s:NODE_FUNCTION) ==# -1
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

function! s:VimLParser.parse_cmd_call() abort
  let node = s:Node(s:NODE_EXCALL)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  call self.reader.skip_white()
  let c = self.reader.peek()
  if self.ends_excmds(c)
    throw s:Err('E471: Argument required', self.reader.getpos())
  endif
  let node.left = self.parse_expr()
  if node.left.type !=# s:NODE_CALL
    throw s:Err('Not an function call', node.left.pos)
  endif
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_heredoc() abort
  let node = s:Node(s:NODE_HEREDOC)
  let node.pos = self.ea.cmdpos
  let node.op = ''
  let node.rlist = []
  let node.body = []

  while s:TRUE
    call self.reader.skip_white()
    let key = self.reader.read_word()
    if key == ''
      break
    endif
    if !s:islower(key[0])
      let node.op = key
      break
    else
      call add(node.rlist, key)
    endif
  endwhile
  if node.op ==# ''
    throw s:Err('E172: Missing marker', self.reader.getpos())
  endif
  call self.parse_trail()
  while s:TRUE
    if self.reader.peek() ==# '<EOF>'
      break
    endif
    let line = self.reader.getn(-1)
    if line ==# node.op
      return node
    endif
    call add(node.body, line)
    call self.reader.get()
  endwhile
  throw s:Err(printf("E990: Missing end marker '%s'", node.op), self.reader.getpos())
endfunction

function! s:VimLParser.parse_cmd_let() abort
  let pos = self.reader.tell()
  call self.reader.skip_white()

  " :let
  if self.ends_excmds(self.reader.peek())
    call self.reader.seek_set(pos)
    call self.parse_cmd_common()
    return
  endif

  let lhs = self.parse_letlhs()
  call self.reader.skip_white()
  let s1 = self.reader.peekn(1)
  let s2 = self.reader.peekn(2)
  " TODO check scriptversion?
  if s2 ==# '..'
    let s2 = self.reader.peekn(3)
  elseif s2 ==# '=<'
    let s2 = self.reader.peekn(3)
  endif

  " :let {var-name} ..
  if self.ends_excmds(s1) || (s2 !=# '+=' && s2 !=# '-=' && s2 !=# '.=' && s2 !=# '..=' && s2 !=# '*=' && s2 !=# '/=' && s2 !=# '%=' && s2 !=# '=<<' && s1 !=# '=')
    call self.reader.seek_set(pos)
    call self.parse_cmd_common()
    return
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
  if s2 ==# '+=' || s2 ==# '-=' || s2 ==# '.=' || s2 ==# '..=' || s2 ==# '*=' || s2 ==# '/=' || s2 ==# '%='
    call self.reader.getn(len(s2))
    let node.op = s2
  elseif s2 ==# '=<<'
    call self.reader.getn(len(s2))
    call self.reader.skip_white()
    let node.op = s2
    let node.right = self.parse_heredoc()
    call self.add_node(node)
    return
  elseif s1 ==# '='
    call self.reader.getn(1)
    let node.op = s1
  else
    throw 'NOT REACHED'
  endif
  let node.right = self.parse_expr()
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_cmd_const() abort
  let pos = self.reader.tell()
  call self.reader.skip_white()

  " :const
  if self.ends_excmds(self.reader.peek())
    call self.reader.seek_set(pos)
    call self.parse_cmd_common()
    return
  endif

  let lhs = self.parse_constlhs()
  call self.reader.skip_white()
  let s1 = self.reader.peekn(1)

  " :const {var-name}
  if self.ends_excmds(s1) || s1 !=# '='
    call self.reader.seek_set(pos)
    call self.parse_cmd_common()
    return
  endif

  " :const left op right
  let node = s:Node(s:NODE_CONST)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  call self.reader.getn(1)
  let node.op = s1
  let node.left = lhs.left
  let node.list = lhs.list
  let node.rest = lhs.rest
  let node.right = self.parse_expr()
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_cmd_unlet() abort
  let node = s:Node(s:NODE_UNLET)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let node.list = self.parse_lvaluelist()
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_cmd_lockvar() abort
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

function! s:VimLParser.parse_cmd_unlockvar() abort
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

function! s:VimLParser.parse_cmd_if() abort
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

function! s:VimLParser.parse_cmd_elseif() abort
  if self.context[0].type !=# s:NODE_IF && self.context[0].type !=# s:NODE_ELSEIF
    throw s:Err('E582: :elseif without :if', self.ea.cmdpos)
  endif
  if self.context[0].type !=# s:NODE_IF
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

function! s:VimLParser.parse_cmd_else() abort
  if self.context[0].type !=# s:NODE_IF && self.context[0].type !=# s:NODE_ELSEIF
    throw s:Err('E581: :else without :if', self.ea.cmdpos)
  endif
  if self.context[0].type !=# s:NODE_IF
    call self.pop_context()
  endif
  let node = s:Node(s:NODE_ELSE)
  let node.pos = self.ea.cmdpos
  let node.body = []
  let node.ea = self.ea
  let self.context[0].else = node
  call self.push_context(node)
endfunction

function! s:VimLParser.parse_cmd_endif() abort
  if self.context[0].type !=# s:NODE_IF && self.context[0].type !=# s:NODE_ELSEIF && self.context[0].type !=# s:NODE_ELSE
    throw s:Err('E580: :endif without :if', self.ea.cmdpos)
  endif
  if self.context[0].type !=# s:NODE_IF
    call self.pop_context()
  endif
  let node = s:Node(s:NODE_ENDIF)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let self.context[0].endif = node
  call self.pop_context()
endfunction

function! s:VimLParser.parse_cmd_while() abort
  let node = s:Node(s:NODE_WHILE)
  let node.pos = self.ea.cmdpos
  let node.body = []
  let node.ea = self.ea
  let node.cond = self.parse_expr()
  let node.endwhile = s:NIL
  call self.add_node(node)
  call self.push_context(node)
endfunction

function! s:VimLParser.parse_cmd_endwhile() abort
  if self.context[0].type !=# s:NODE_WHILE
    throw s:Err('E588: :endwhile without :while', self.ea.cmdpos)
  endif
  let node = s:Node(s:NODE_ENDWHILE)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let self.context[0].endwhile = node
  call self.pop_context()
endfunction

function! s:VimLParser.parse_cmd_for() abort
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

function! s:VimLParser.parse_cmd_endfor() abort
  if self.context[0].type !=# s:NODE_FOR
    throw s:Err('E588: :endfor without :for', self.ea.cmdpos)
  endif
  let node = s:Node(s:NODE_ENDFOR)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let self.context[0].endfor = node
  call self.pop_context()
endfunction

function! s:VimLParser.parse_cmd_continue() abort
  if self.find_context(s:NODE_WHILE) ==# -1 && self.find_context(s:NODE_FOR) ==# -1
    throw s:Err('E586: :continue without :while or :for', self.ea.cmdpos)
  endif
  let node = s:Node(s:NODE_CONTINUE)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_cmd_break() abort
  if self.find_context(s:NODE_WHILE) ==# -1 && self.find_context(s:NODE_FOR) ==# -1
    throw s:Err('E587: :break without :while or :for', self.ea.cmdpos)
  endif
  let node = s:Node(s:NODE_BREAK)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_cmd_try() abort
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

function! s:VimLParser.parse_cmd_catch() abort
  if self.context[0].type ==# s:NODE_FINALLY
    throw s:Err('E604: :catch after :finally', self.ea.cmdpos)
  elseif self.context[0].type !=# s:NODE_TRY && self.context[0].type !=# s:NODE_CATCH
    throw s:Err('E603: :catch without :try', self.ea.cmdpos)
  endif
  if self.context[0].type !=# s:NODE_TRY
    call self.pop_context()
  endif
  let node = s:Node(s:NODE_CATCH)
  let node.pos = self.ea.cmdpos
  let node.body = []
  let node.ea = self.ea
  let node.pattern = s:NIL
  call self.reader.skip_white()
  if !self.ends_excmds(self.reader.peek())
    let [node.pattern, _] = self.parse_pattern(self.reader.get())
  endif
  call add(self.context[0].catch, node)
  call self.push_context(node)
endfunction

function! s:VimLParser.parse_cmd_finally() abort
  if self.context[0].type !=# s:NODE_TRY && self.context[0].type !=# s:NODE_CATCH
    throw s:Err('E606: :finally without :try', self.ea.cmdpos)
  endif
  if self.context[0].type !=# s:NODE_TRY
    call self.pop_context()
  endif
  let node = s:Node(s:NODE_FINALLY)
  let node.pos = self.ea.cmdpos
  let node.body = []
  let node.ea = self.ea
  let self.context[0].finally = node
  call self.push_context(node)
endfunction

function! s:VimLParser.parse_cmd_endtry() abort
  if self.context[0].type !=# s:NODE_TRY && self.context[0].type !=# s:NODE_CATCH && self.context[0].type !=# s:NODE_FINALLY
    throw s:Err('E602: :endtry without :try', self.ea.cmdpos)
  endif
  if self.context[0].type !=# s:NODE_TRY
    call self.pop_context()
  endif
  let node = s:Node(s:NODE_ENDTRY)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let self.context[0].endtry = node
  call self.pop_context()
endfunction

function! s:VimLParser.parse_cmd_throw() abort
  let node = s:Node(s:NODE_THROW)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let node.left = self.parse_expr()
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_cmd_eval() abort
  let node = s:Node(s:NODE_EVAL)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let node.left = self.parse_expr()
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_cmd_echo() abort
  let node = s:Node(s:NODE_ECHO)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let node.list = self.parse_exprlist()
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_cmd_echon() abort
  let node = s:Node(s:NODE_ECHON)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let node.list = self.parse_exprlist()
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_cmd_echohl() abort
  let node = s:Node(s:NODE_ECHOHL)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let node.str = ''
  while !self.ends_excmds(self.reader.peek())
    let node.str .= self.reader.get()
  endwhile
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_cmd_echomsg() abort
  let node = s:Node(s:NODE_ECHOMSG)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let node.list = self.parse_exprlist()
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_cmd_echoerr() abort
  let node = s:Node(s:NODE_ECHOERR)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let node.list = self.parse_exprlist()
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_cmd_execute() abort
  let node = s:Node(s:NODE_EXECUTE)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let node.list = self.parse_exprlist()
  call self.add_node(node)
endfunction

function! s:VimLParser.parse_expr() abort
  return s:ExprParser.new(self.reader).parse()
endfunction

function! s:VimLParser.parse_exprlist() abort
  let list = []
  while s:TRUE
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

function! s:VimLParser.parse_lvalue_func() abort
  let p = s:LvalueParser.new(self.reader)
  let node = p.parse()
  if node.type ==# s:NODE_IDENTIFIER || node.type ==# s:NODE_CURLYNAME || node.type ==# s:NODE_SUBSCRIPT || node.type ==# s:NODE_DOT || node.type ==# s:NODE_OPTION || node.type ==# s:NODE_ENV || node.type ==# s:NODE_REG
    return node
  endif
  throw s:Err('Invalid Expression', node.pos)
endfunction

" FIXME:
function! s:VimLParser.parse_lvalue() abort
  let p = s:LvalueParser.new(self.reader)
  let node = p.parse()
  if node.type ==# s:NODE_IDENTIFIER
    if !s:isvarname(node.value)
      throw s:Err(printf('E461: Illegal variable name: %s', node.value), node.pos)
    endif
  endif
  if node.type ==# s:NODE_IDENTIFIER || node.type ==# s:NODE_CURLYNAME || node.type ==# s:NODE_SUBSCRIPT || node.type ==# s:NODE_SLICE || node.type ==# s:NODE_DOT || node.type ==# s:NODE_OPTION || node.type ==# s:NODE_ENV || node.type ==# s:NODE_REG
    return node
  endif
  throw s:Err('Invalid Expression', node.pos)
endfunction

" TODO: merge with s:VimLParser.parse_lvalue()
function! s:VimLParser.parse_constlvalue() abort
  let p = s:LvalueParser.new(self.reader)
  let node = p.parse()
  if node.type ==# s:NODE_IDENTIFIER
    if !s:isvarname(node.value)
      throw s:Err(printf('E461: Illegal variable name: %s', node.value), node.pos)
    endif
  endif
  if node.type ==# s:NODE_IDENTIFIER || node.type ==# s:NODE_CURLYNAME
    return node
  elseif node.type ==# s:NODE_SUBSCRIPT || node.type ==# s:NODE_SLICE || node.type ==# s:NODE_DOT
    throw s:Err('E996: Cannot lock a list or dict', node.pos)
  elseif node.type ==# s:NODE_OPTION
    throw s:Err('E996: Cannot lock an option', node.pos)
  elseif node.type ==# s:NODE_ENV
    throw s:Err('E996: Cannot lock an environment variable', node.pos)
  elseif node.type ==# s:NODE_REG
    throw s:Err('E996: Cannot lock a register', node.pos)
  endif
  throw s:Err('Invalid Expression', node.pos)
endfunction


function! s:VimLParser.parse_lvaluelist() abort
  let list = []
  let node = self.parse_expr()
  call add(list, node)
  while s:TRUE
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
function! s:VimLParser.parse_letlhs() abort
  let lhs = {'left': s:NIL, 'list': s:NIL, 'rest': s:NIL}
  let tokenizer = s:ExprTokenizer.new(self.reader)
  if tokenizer.peek().type ==# s:TOKEN_SQOPEN
    call tokenizer.get()
    let lhs.list = []
    while s:TRUE
      let node = self.parse_lvalue()
      call add(lhs.list, node)
      let token = tokenizer.get()
      if token.type ==# s:TOKEN_SQCLOSE
        break
      elseif token.type ==# s:TOKEN_COMMA
        continue
      elseif token.type ==# s:TOKEN_SEMICOLON
        let node = self.parse_lvalue()
        let lhs.rest = node
        let token = tokenizer.get()
        if token.type ==# s:TOKEN_SQCLOSE
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

" TODO: merge with s:VimLParser.parse_letlhs() ?
function! s:VimLParser.parse_constlhs() abort
  let lhs = {'left': s:NIL, 'list': s:NIL, 'rest': s:NIL}
  let tokenizer = s:ExprTokenizer.new(self.reader)
  if tokenizer.peek().type ==# s:TOKEN_SQOPEN
    call tokenizer.get()
    let lhs.list = []
    while s:TRUE
      let node = self.parse_lvalue()
      call add(lhs.list, node)
      let token = tokenizer.get()
      if token.type ==# s:TOKEN_SQCLOSE
        break
      elseif token.type ==# s:TOKEN_COMMA
        continue
      elseif token.type ==# s:TOKEN_SEMICOLON
        let node = self.parse_lvalue()
        let lhs.rest = node
        let token = tokenizer.get()
        if token.type ==# s:TOKEN_SQCLOSE
          break
        else
          throw s:Err(printf('E475 Invalid argument: %s', token.value), token.pos)
        endif
      else
        throw s:Err(printf('E475 Invalid argument: %s', token.value), token.pos)
      endif
    endwhile
  else
    let lhs.left = self.parse_constlvalue()
  endif
  return lhs
endfunction

function! s:VimLParser.ends_excmds(c) abort
  return a:c ==# '' || a:c ==# '|' || a:c ==# '"' || a:c ==# '<EOF>' || a:c ==# '<EOL>'
endfunction

" FIXME: validate argument
function! s:VimLParser.parse_wincmd() abort
  let c = self.reader.getn(1)
  if c ==# ''
    throw s:Err('E471: Argument required', self.reader.getpos())
  elseif c ==# 'g' || c ==# "\x07" " <C-G>
    let c2 = self.reader.getn(1)
    if c2 ==# '' || s:iswhite(c2)
      throw s:Err('E474: Invalid Argument', self.reader.getpos())
    endif
  endif
  let end = self.reader.getpos()
  call self.reader.skip_white()
  if !self.ends_excmds(self.reader.peek())
    throw s:Err('E474: Invalid Argument', self.reader.getpos())
  endif
  let node = s:Node(s:NODE_EXCMD)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let node.str = self.reader.getstr(self.ea.linepos, end)
  call self.add_node(node)
endfunction

" FIXME: validate argument
function! s:VimLParser.parse_cmd_syntax() abort
  let end = self.reader.getpos()
  while s:TRUE
    let end = self.reader.getpos()
    let c = self.reader.peek()
    if c ==# '/' || c ==# "'" || c ==# '"'
      call self.reader.getn(1)
      call self.parse_pattern(c)
    elseif c ==# '='
      call self.reader.getn(1)
      call self.parse_pattern(' ')
    elseif self.ends_excmds(c)
      break
    endif
    call self.reader.getn(1)
  endwhile
  let node = s:Node(s:NODE_EXCMD)
  let node.pos = self.ea.cmdpos
  let node.ea = self.ea
  let node.str = self.reader.getstr(self.ea.linepos, end)
  call self.add_node(node)
endfunction

let s:VimLParser.neovim_additional_commands = [
      \ {'name': 'rshada', 'minlen': 3, 'flags': 'BANG|FILE1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'wshada', 'minlen': 3, 'flags': 'BANG|FILE1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'}]

let s:VimLParser.neovim_removed_commands = [
      \ {'name': 'Print', 'minlen':1, 'flags': 'RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'fixdel', 'minlen':3, 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'helpfind', 'minlen':5, 'flags': 'EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'open', 'minlen':1, 'flags': 'RANGE|BANG|EXTRA', 'parser': 'parse_cmd_common'},
      \ {'name': 'shell', 'minlen':2, 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'tearoff', 'minlen':2, 'flags': 'NEEDARG|EXTRA|TRLBAR|NOTRLCOM|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'gvim', 'minlen':2, 'flags': 'BANG|FILES|EDITCMD|ARGOPT|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'}]

" To find new builtin_commands, run the below script.
" $ scripts/update_builtin_commands.sh /path/to/vim/src/ex_cmds.h
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
      \ {'name': 'caddbuffer', 'minlen': 3, 'flags': 'RANGE|NOTADR|WORD1|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'caddexpr', 'minlen': 5, 'flags': 'NEEDARG|WORD1|NOTRLCOM|TRLBAR', 'parser': 'parse_cmd_common'},
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
      \ {'name': 'delfunction', 'minlen': 4, 'flags': 'BANG|NEEDARG|WORD1|CMDWIN', 'parser': 'parse_cmd_delfunction'},
      \ {'name': 'diffupdate', 'minlen': 3, 'flags': 'BANG|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'diffget', 'minlen': 5, 'flags': 'RANGE|EXTRA|TRLBAR|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'diffoff', 'minlen': 5, 'flags': 'BANG|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'diffpatch', 'minlen': 5, 'flags': 'EXTRA|FILE1|TRLBAR|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'diffput', 'minlen': 6, 'flags': 'RANGE|EXTRA|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'diffsplit', 'minlen': 5, 'flags': 'EXTRA|FILE1|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'diffthis', 'minlen': 5, 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
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
      \ {'name': 'eval', 'minlen': 2, 'flags': 'EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_eval'},
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
      \ {'name': 'keeppatterns', 'minlen': 5, 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
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
      \ {'name': 'const', 'minlen': 4, 'flags': 'EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_const'},
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
      \ {'name': 'lopen', 'minlen': 3, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
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
      \ {'name': 'pydo', 'minlen': 3, 'flags': 'RANGE|DFLALL|EXTRA|NEEDARG|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'py3do', 'minlen': 4, 'flags': 'RANGE|DFLALL|EXTRA|NEEDARG|CMDWIN', 'parser': 'parse_cmd_common'},
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
      \ {'name': 'scriptnames', 'minlen': 3, 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
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
      \ {'name': 'syntax', 'minlen': 2, 'flags': 'EXTRA|NOTRLCOM|CMDWIN', 'parser': 'parse_cmd_syntax'},
      \ {'name': 'syntime', 'minlen': 5, 'flags': 'NEEDARG|WORD1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'syncbind', 'minlen': 4, 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 't', 'minlen': 1, 'flags': 'RANGE|WHOLEFOLD|EXTRA|TRLBAR|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'tNext', 'minlen': 2, 'flags': 'RANGE|NOTADR|BANG|TRLBAR|ZEROR', 'parser': 'parse_cmd_common'},
      \ {'name': 'tabNext', 'minlen': 4, 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'tabclose', 'minlen': 4, 'flags': 'RANGE|NOTADR|COUNT|BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'tabdo', 'minlen': 4, 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
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
      \ {'name': 'wincmd', 'minlen': 4, 'flags': 'NEEDARG|WORD1|RANGE|NOTADR', 'parser': 'parse_wincmd'},
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
      \
      \ {'flags': 'TRLBAR', 'minlen': 3, 'name': 'cbottom', 'parser': 'parse_cmd_common'},
      \ {'flags': 'BANG|NEEDARG|EXTRA|NOTRLCOM|RANGE|NOTADR|DFLALL', 'minlen': 3, 'name': 'cdo', 'parser': 'parse_cmd_common'},
      \ {'flags': 'BANG|NEEDARG|EXTRA|NOTRLCOM|RANGE|NOTADR|DFLALL', 'minlen': 3, 'name': 'cfdo', 'parser': 'parse_cmd_common'},
      \ {'flags': 'TRLBAR', 'minlen': 3, 'name': 'chistory', 'parser': 'parse_cmd_common'},
      \ {'flags': 'TRLBAR|CMDWIN', 'minlen': 3, 'name': 'clearjumps', 'parser': 'parse_cmd_common'},
      \ {'flags': 'BANG|NEEDARG|EXTRA|NOTRLCOM', 'minlen': 4, 'name': 'filter', 'parser': 'parse_cmd_common'},
      \ {'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'minlen': 5, 'name': 'helpclose', 'parser': 'parse_cmd_common'},
      \ {'flags': 'TRLBAR', 'minlen': 3, 'name': 'lbottom', 'parser': 'parse_cmd_common'},
      \ {'flags': 'BANG|NEEDARG|EXTRA|NOTRLCOM|RANGE|NOTADR|DFLALL', 'minlen': 2, 'name': 'ldo', 'parser': 'parse_cmd_common'},
      \ {'flags': 'BANG|NEEDARG|EXTRA|NOTRLCOM|RANGE|NOTADR|DFLALL', 'minlen': 3, 'name': 'lfdo', 'parser': 'parse_cmd_common'},
      \ {'flags': 'TRLBAR', 'minlen': 3, 'name': 'lhistory', 'parser': 'parse_cmd_common'},
      \ {'flags': 'BANG|EXTRA|TRLBAR|CMDWIN', 'minlen': 3, 'name': 'llist', 'parser': 'parse_cmd_common'},
      \ {'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'minlen': 3, 'name': 'noswapfile', 'parser': 'parse_cmd_common'},
      \ {'flags': 'BANG|FILE1|NEEDARG|TRLBAR|SBOXOK|CMDWIN', 'minlen': 2, 'name': 'packadd', 'parser': 'parse_cmd_common'},
      \ {'flags': 'BANG|TRLBAR|SBOXOK|CMDWIN', 'minlen': 5, 'name': 'packloadall', 'parser': 'parse_cmd_common'},
      \ {'flags': 'TRLBAR|CMDWIN|SBOXOK', 'minlen': 3, 'name': 'smile', 'parser': 'parse_cmd_common'},
      \ {'flags': 'RANGE|EXTRA|NEEDARG|CMDWIN', 'minlen': 3, 'name': 'pyx', 'parser': 'parse_cmd_common'},
      \ {'flags': 'RANGE|DFLALL|EXTRA|NEEDARG|CMDWIN', 'minlen': 4, 'name': 'pyxdo', 'parser': 'parse_cmd_common'},
      \ {'flags': 'RANGE|EXTRA|NEEDARG|CMDWIN', 'minlen': 7, 'name': 'pythonx', 'parser': 'parse_cmd_common'},
      \ {'flags': 'RANGE|FILE1|NEEDARG|CMDWIN', 'minlen': 4, 'name': 'pyxfile', 'parser': 'parse_cmd_common'},
      \ {'flags': 'RANGE|BANG|FILES|CMDWIN', 'minlen': 3, 'name': 'terminal', 'parser': 'parse_cmd_common'},
      \ {'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'minlen': 3, 'name': 'tmap', 'parser': 'parse_cmd_common'},
      \ {'flags': 'EXTRA|TRLBAR|CMDWIN', 'minlen': 5, 'name': 'tmapclear', 'parser': 'parse_cmd_common'},
      \ {'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'minlen': 3, 'name': 'tnoremap', 'parser': 'parse_cmd_common'},
      \ {'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'minlen': 5, 'name': 'tunmap', 'parser': 'parse_cmd_common'},
      \
      \ {'flags': 'RANGE|COUNT|TRLBAR', 'minlen': 4, 'name': 'cabove', 'parser': 'parse_cmd_common'},
      \ {'flags': 'RANGE|COUNT|TRLBAR', 'minlen': 3, 'name': 'cafter', 'parser': 'parse_cmd_common'},
      \ {'flags': 'RANGE|COUNT|TRLBAR', 'minlen': 3, 'name': 'cbefore', 'parser': 'parse_cmd_common'},
      \ {'flags': 'RANGE|COUNT|TRLBAR', 'minlen': 4, 'name': 'cbelow', 'parser': 'parse_cmd_common'},
      \ {'flags': 'EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'minlen': 4, 'name': 'const', 'parser': 'parse_cmd_common'},
      \ {'flags': 'RANGE|COUNT|TRLBAR', 'minlen': 3, 'name': 'labove', 'parser': 'parse_cmd_common'},
      \ {'flags': 'RANGE|COUNT|TRLBAR', 'minlen': 3, 'name': 'lafter', 'parser': 'parse_cmd_common'},
      \ {'flags': 'RANGE|COUNT|TRLBAR', 'minlen': 3, 'name': 'lbefore', 'parser': 'parse_cmd_common'},
      \ {'flags': 'RANGE|COUNT|TRLBAR', 'minlen': 4, 'name': 'lbelow', 'parser': 'parse_cmd_common'},
      \ {'flags': 'TRLBAR|CMDWIN', 'minlen': 7, 'name': 'redrawtabline', 'parser': 'parse_cmd_common'},
      \ {'flags': 'WORD1|TRLBAR|CMDWIN', 'minlen': 7, 'name': 'scriptversion', 'parser': 'parse_cmd_common'},
      \ {'flags': 'BANG|FILE1|TRLBAR|CMDWIN', 'minlen': 2, 'name': 'tcd', 'parser': 'parse_cmd_common'},
      \ {'flags': 'BANG|FILE1|TRLBAR|CMDWIN', 'minlen': 3, 'name': 'tchdir', 'parser': 'parse_cmd_common'},
      \ {'flags': 'RANGE|ZEROR|EXTRA|TRLBAR|NOTRLCOM|CTRLV|CMDWIN', 'minlen': 3, 'name': 'tlmenu', 'parser': 'parse_cmd_common'},
      \ {'flags': 'RANGE|ZEROR|EXTRA|TRLBAR|NOTRLCOM|CTRLV|CMDWIN', 'minlen': 3, 'name': 'tlnoremenu', 'parser': 'parse_cmd_common'},
      \ {'flags': 'RANGE|ZEROR|EXTRA|TRLBAR|NOTRLCOM|CTRLV|CMDWIN', 'minlen': 3, 'name': 'tlunmenu', 'parser': 'parse_cmd_common'},
      \ {'flags': 'EXTRA|TRLBAR|CMDWIN', 'minlen': 2, 'name': 'xrestore', 'parser': 'parse_cmd_common'},
      \
      \ {'flags': 'EXTRA|BANG|SBOXOK|CMDWIN', 'minlen': 3, 'name': 'def', 'parser': 'parse_cmd_common'},
      \ {'flags': 'EXTRA|NEEDARG|TRLBAR|CMDWIN', 'minlen': 4, 'name': 'disassemble', 'parser': 'parse_cmd_common'},
      \ {'flags': 'TRLBAR|CMDWIN', 'minlen': 4, 'name': 'enddef', 'parser': 'parse_cmd_common'},
      \ {'flags': 'EXTRA|NOTRLCOM', 'minlen': 3, 'name': 'export', 'parser': 'parse_cmd_common'},
      \ {'flags': 'EXTRA|NOTRLCOM', 'minlen': 3, 'name': 'import', 'parser': 'parse_cmd_common'},
      \ {'flags': 'BANG|RANGE|NEEDARG|EXTRA|TRLBAR', 'minlen': 7, 'name': 'spellrare', 'parser': 'parse_cmd_common'},
      \ {'flags': '', 'minlen': 4, 'name': 'vim9script', 'parser': 'parse_cmd_common'},
      \]

" To find new builtin_functions, run the below script.
" $ scripts/update_builtin_functions.sh /path/to/vim/src/evalfunc.c
let s:VimLParser.builtin_functions = [
      \ {'name': 'abs', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'acos', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'add', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'and', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'append', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_LAST'},
      \ {'name': 'appendbufline', 'min_argc': 3, 'max_argc': 3, 'argtype': 'FEARG_LAST'},
      \ {'name': 'argc', 'min_argc': 0, 'max_argc': 1, 'argtype': '0'},
      \ {'name': 'argidx', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'arglistid', 'min_argc': 0, 'max_argc': 2, 'argtype': '0'},
      \ {'name': 'argv', 'min_argc': 0, 'max_argc': 2, 'argtype': '0'},
      \ {'name': 'asin', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'assert_beeps', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'assert_equal', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_2'},
      \ {'name': 'assert_equalfile', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'assert_exception', 'min_argc': 1, 'max_argc': 2, 'argtype': '0'},
      \ {'name': 'assert_fails', 'min_argc': 1, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'assert_false', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'assert_inrange', 'min_argc': 3, 'max_argc': 4, 'argtype': 'FEARG_3'},
      \ {'name': 'assert_match', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_2'},
      \ {'name': 'assert_notequal', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_2'},
      \ {'name': 'assert_notmatch', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_2'},
      \ {'name': 'assert_report', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'assert_true', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'atan', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'atan2', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'balloon_gettext', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'balloon_show', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'balloon_split', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'browse', 'min_argc': 4, 'max_argc': 4, 'argtype': '0'},
      \ {'name': 'browsedir', 'min_argc': 2, 'max_argc': 2, 'argtype': '0'},
      \ {'name': 'bufadd', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'bufexists', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'buffer_exists', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'buffer_name', 'min_argc': 0, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'buffer_number', 'min_argc': 0, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'buflisted', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'bufload', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'bufloaded', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'bufname', 'min_argc': 0, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'bufnr', 'min_argc': 0, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'bufwinid', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'bufwinnr', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'byte2line', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'byteidx', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'byteidxcomp', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'call', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'ceil', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'ch_canread', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'ch_close', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'ch_close_in', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'ch_evalexpr', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'ch_evalraw', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'ch_getbufnr', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'ch_getjob', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'ch_info', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'ch_log', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'ch_logfile', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'ch_open', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'ch_read', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'ch_readblob', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'ch_readraw', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'ch_sendexpr', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'ch_sendraw', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'ch_setoptions', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'ch_status', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'changenr', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'char2nr', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'chdir', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'cindent', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'clearmatches', 'min_argc': 0, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'col', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'complete', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_2'},
      \ {'name': 'complete_add', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'complete_check', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'complete_info', 'min_argc': 0, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'confirm', 'min_argc': 1, 'max_argc': 4, 'argtype': 'FEARG_1'},
      \ {'name': 'copy', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'cos', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'cosh', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'count', 'min_argc': 2, 'max_argc': 4, 'argtype': 'FEARG_1'},
      \ {'name': 'cscope_connection', 'min_argc': 0, 'max_argc': 3, 'argtype': '0'},
      \ {'name': 'cursor', 'min_argc': 1, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'debugbreak', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'deepcopy', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'delete', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'deletebufline', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'did_filetype', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'diff_filler', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'diff_hlID', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'echoraw', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'empty', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'environ', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'escape', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'eval', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'eventhandler', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'executable', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'execute', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'exepath', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'exists', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'exp', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'expand', 'min_argc': 1, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'expandcmd', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'extend', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'feedkeys', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'file_readable', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'filereadable', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'filewritable', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'filter', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'finddir', 'min_argc': 1, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'findfile', 'min_argc': 1, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'float2nr', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'floor', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'fmod', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'fnameescape', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'fnamemodify', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'foldclosed', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'foldclosedend', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'foldlevel', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'foldtext', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'foldtextresult', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'foreground', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'funcref', 'min_argc': 1, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'function', 'min_argc': 1, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'garbagecollect', 'min_argc': 0, 'max_argc': 1, 'argtype': '0'},
      \ {'name': 'get', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'getbufinfo', 'min_argc': 0, 'max_argc': 1, 'argtype': '0'},
      \ {'name': 'getbufline', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'getbufvar', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'getchangelist', 'min_argc': 0, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'getchar', 'min_argc': 0, 'max_argc': 1, 'argtype': '0'},
      \ {'name': 'getcharmod', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'getcharsearch', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'getcmdline', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'getcmdpos', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'getcmdtype', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'getcmdwintype', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'getcompletion', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'getcurpos', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'getcwd', 'min_argc': 0, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'getenv', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'getfontname', 'min_argc': 0, 'max_argc': 1, 'argtype': '0'},
      \ {'name': 'getfperm', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'getfsize', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'getftime', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'getftype', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'getimstatus', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'getjumplist', 'min_argc': 0, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'getline', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'getloclist', 'min_argc': 1, 'max_argc': 2, 'argtype': '0'},
      \ {'name': 'getmatches', 'min_argc': 0, 'max_argc': 1, 'argtype': '0'},
      \ {'name': 'getmousepos', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'getpid', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'getpos', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'getqflist', 'min_argc': 0, 'max_argc': 1, 'argtype': '0'},
      \ {'name': 'getreg', 'min_argc': 0, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'getregtype', 'min_argc': 0, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'gettabinfo', 'min_argc': 0, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'gettabvar', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'gettabwinvar', 'min_argc': 3, 'max_argc': 4, 'argtype': 'FEARG_1'},
      \ {'name': 'gettagstack', 'min_argc': 0, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'getwininfo', 'min_argc': 0, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'getwinpos', 'min_argc': 0, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'getwinposx', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'getwinposy', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'getwinvar', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'glob', 'min_argc': 1, 'max_argc': 4, 'argtype': 'FEARG_1'},
      \ {'name': 'glob2regpat', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'globpath', 'min_argc': 2, 'max_argc': 5, 'argtype': 'FEARG_2'},
      \ {'name': 'has', 'min_argc': 1, 'max_argc': 1, 'argtype': '0'},
      \ {'name': 'has_key', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'haslocaldir', 'min_argc': 0, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'hasmapto', 'min_argc': 1, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'highlightID', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'highlight_exists', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'histadd', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_2'},
      \ {'name': 'histdel', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'histget', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'histnr', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'hlID', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'hlexists', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'hostname', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'iconv', 'min_argc': 3, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'indent', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'index', 'min_argc': 2, 'max_argc': 4, 'argtype': 'FEARG_1'},
      \ {'name': 'input', 'min_argc': 1, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'inputdialog', 'min_argc': 1, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'inputlist', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'inputrestore', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'inputsave', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'inputsecret', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'insert', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'interrupt', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'invert', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'isdirectory', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'isinf', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'islocked', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'isnan', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'items', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'job_getchannel', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'job_info', 'min_argc': 0, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'job_setoptions', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'job_start', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'job_status', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'job_stop', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'join', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'js_decode', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'js_encode', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'json_decode', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'json_encode', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'keys', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'last_buffer_nr', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'len', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'libcall', 'min_argc': 3, 'max_argc': 3, 'argtype': 'FEARG_3'},
      \ {'name': 'libcallnr', 'min_argc': 3, 'max_argc': 3, 'argtype': 'FEARG_3'},
      \ {'name': 'line', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'line2byte', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'lispindent', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'list2str', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'listener_add', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_2'},
      \ {'name': 'listener_flush', 'min_argc': 0, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'listener_remove', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'localtime', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'log', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'log10', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'luaeval', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'map', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'maparg', 'min_argc': 1, 'max_argc': 4, 'argtype': 'FEARG_1'},
      \ {'name': 'mapcheck', 'min_argc': 1, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'match', 'min_argc': 2, 'max_argc': 4, 'argtype': 'FEARG_1'},
      \ {'name': 'matchadd', 'min_argc': 2, 'max_argc': 5, 'argtype': 'FEARG_1'},
      \ {'name': 'matchaddpos', 'min_argc': 2, 'max_argc': 5, 'argtype': 'FEARG_1'},
      \ {'name': 'matcharg', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'matchdelete', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'matchend', 'min_argc': 2, 'max_argc': 4, 'argtype': 'FEARG_1'},
      \ {'name': 'matchlist', 'min_argc': 2, 'max_argc': 4, 'argtype': 'FEARG_1'},
      \ {'name': 'matchstr', 'min_argc': 2, 'max_argc': 4, 'argtype': 'FEARG_1'},
      \ {'name': 'matchstrpos', 'min_argc': 2, 'max_argc': 4, 'argtype': 'FEARG_1'},
      \ {'name': 'max', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'menu_info', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'min', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'mkdir', 'min_argc': 1, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'mode', 'min_argc': 0, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'mzeval', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'nextnonblank', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'nr2char', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'or', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'pathshorten', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'perleval', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'popup_atcursor', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'popup_beval', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'popup_clear', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'popup_close', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'popup_create', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'popup_dialog', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'popup_filter_menu', 'min_argc': 2, 'max_argc': 2, 'argtype': '0'},
      \ {'name': 'popup_filter_yesno', 'min_argc': 2, 'max_argc': 2, 'argtype': '0'},
      \ {'name': 'popup_findinfo', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'popup_findpreview', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'popup_getoptions', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'popup_getpos', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'popup_hide', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'popup_locate', 'min_argc': 2, 'max_argc': 2, 'argtype': '0'},
      \ {'name': 'popup_menu', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'popup_move', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'popup_notification', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'popup_setoptions', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'popup_settext', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'popup_show', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'pow', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'prevnonblank', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'printf', 'min_argc': 1, 'max_argc': 19, 'argtype': 'FEARG_2'},
      \ {'name': 'prompt_setcallback', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'prompt_setinterrupt', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'prompt_setprompt', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'prop_add', 'min_argc': 3, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'prop_clear', 'min_argc': 1, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'prop_find', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'prop_list', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'prop_remove', 'min_argc': 1, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'prop_type_add', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'prop_type_change', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'prop_type_delete', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'prop_type_get', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'prop_type_list', 'min_argc': 0, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'pum_getpos', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'pumvisible', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'py3eval', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'pyeval', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'pyxeval', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'rand', 'min_argc': 0, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'range', 'min_argc': 1, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'readdir', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'readfile', 'min_argc': 1, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'reg_executing', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'reg_recording', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'reltime', 'min_argc': 0, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'reltimefloat', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'reltimestr', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'remote_expr', 'min_argc': 2, 'max_argc': 4, 'argtype': 'FEARG_1'},
      \ {'name': 'remote_foreground', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'remote_peek', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'remote_read', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'remote_send', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'remote_startserver', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'remove', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'rename', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'repeat', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'resolve', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'reverse', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'round', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'rubyeval', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'screenattr', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'screenchar', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'screenchars', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'screencol', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'screenpos', 'min_argc': 3, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'screenrow', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'screenstring', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'search', 'min_argc': 1, 'max_argc': 4, 'argtype': 'FEARG_1'},
      \ {'name': 'searchdecl', 'min_argc': 1, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'searchpair', 'min_argc': 3, 'max_argc': 7, 'argtype': '0'},
      \ {'name': 'searchpairpos', 'min_argc': 3, 'max_argc': 7, 'argtype': '0'},
      \ {'name': 'searchpos', 'min_argc': 1, 'max_argc': 4, 'argtype': 'FEARG_1'},
      \ {'name': 'server2client', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'serverlist', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'setbufline', 'min_argc': 3, 'max_argc': 3, 'argtype': 'FEARG_3'},
      \ {'name': 'setbufvar', 'min_argc': 3, 'max_argc': 3, 'argtype': 'FEARG_3'},
      \ {'name': 'setcharsearch', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'setcmdpos', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'setenv', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_2'},
      \ {'name': 'setfperm', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'setline', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_2'},
      \ {'name': 'setloclist', 'min_argc': 2, 'max_argc': 4, 'argtype': 'FEARG_2'},
      \ {'name': 'setmatches', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'setpos', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_2'},
      \ {'name': 'setqflist', 'min_argc': 1, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'setreg', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_2'},
      \ {'name': 'settabvar', 'min_argc': 3, 'max_argc': 3, 'argtype': 'FEARG_3'},
      \ {'name': 'settabwinvar', 'min_argc': 4, 'max_argc': 4, 'argtype': 'FEARG_4'},
      \ {'name': 'settagstack', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_2'},
      \ {'name': 'setwinvar', 'min_argc': 3, 'max_argc': 3, 'argtype': 'FEARG_3'},
      \ {'name': 'sha256', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'shellescape', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'shiftwidth', 'min_argc': 0, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'sign_define', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'sign_getdefined', 'min_argc': 0, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'sign_getplaced', 'min_argc': 0, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'sign_jump', 'min_argc': 3, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'sign_place', 'min_argc': 4, 'max_argc': 5, 'argtype': 'FEARG_1'},
      \ {'name': 'sign_placelist', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'sign_undefine', 'min_argc': 0, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'sign_unplace', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'sign_unplacelist', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'simplify', 'min_argc': 1, 'max_argc': 1, 'argtype': '0'},
      \ {'name': 'sin', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'sinh', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'sort', 'min_argc': 1, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'sound_clear', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'sound_playevent', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'sound_playfile', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'sound_stop', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'soundfold', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'spellbadword', 'min_argc': 0, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'spellsuggest', 'min_argc': 1, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'split', 'min_argc': 1, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'sqrt', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'srand', 'min_argc': 0, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'state', 'min_argc': 0, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'str2float', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'str2list', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'str2nr', 'min_argc': 1, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'strcharpart', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'strchars', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'strdisplaywidth', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'strftime', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'strgetchar', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'stridx', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'string', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'strlen', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'strpart', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'strptime', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'strridx', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'strtrans', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'strwidth', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'submatch', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'substitute', 'min_argc': 4, 'max_argc': 4, 'argtype': 'FEARG_1'},
      \ {'name': 'swapinfo', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'swapname', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'synID', 'min_argc': 3, 'max_argc': 3, 'argtype': '0'},
      \ {'name': 'synIDattr', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'synIDtrans', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'synconcealed', 'min_argc': 2, 'max_argc': 2, 'argtype': '0'},
      \ {'name': 'synstack', 'min_argc': 2, 'max_argc': 2, 'argtype': '0'},
      \ {'name': 'system', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'systemlist', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'tabpagebuflist', 'min_argc': 0, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'tabpagenr', 'min_argc': 0, 'max_argc': 1, 'argtype': '0'},
      \ {'name': 'tabpagewinnr', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'tagfiles', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'taglist', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'tan', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'tanh', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'tempname', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'term_dumpdiff', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'term_dumpload', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'term_dumpwrite', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_2'},
      \ {'name': 'term_getaltscreen', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'term_getansicolors', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'term_getattr', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'term_getcursor', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'term_getjob', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'term_getline', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'term_getscrolled', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'term_getsize', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'term_getstatus', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'term_gettitle', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'term_gettty', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'term_list', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'term_scrape', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'term_sendkeys', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'term_setansicolors', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'term_setapi', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'term_setkill', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'term_setrestore', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'term_setsize', 'min_argc': 3, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'term_start', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'term_wait', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'test_alloc_fail', 'min_argc': 3, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'test_autochdir', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'test_feedinput', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'test_garbagecollect_now', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'test_garbagecollect_soon', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'test_getvalue', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'test_ignore_error', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'test_null_blob', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'test_null_channel', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'test_null_dict', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'test_null_job', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'test_null_list', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'test_null_partial', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'test_null_string', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'test_option_not_set', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'test_override', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_2'},
      \ {'name': 'test_refcount', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'test_scrollbar', 'min_argc': 3, 'max_argc': 3, 'argtype': 'FEARG_2'},
      \ {'name': 'test_setmouse', 'min_argc': 2, 'max_argc': 2, 'argtype': '0'},
      \ {'name': 'test_settime', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'test_srand_seed', 'min_argc': 0, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'test_unknown', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'test_void', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'timer_info', 'min_argc': 0, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'timer_pause', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'timer_start', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'timer_stop', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'timer_stopall', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'tolower', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'toupper', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'tr', 'min_argc': 3, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'trim', 'min_argc': 1, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'trunc', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'type', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'undofile', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'undotree', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'uniq', 'min_argc': 1, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'values', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'virtcol', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'visualmode', 'min_argc': 0, 'max_argc': 1, 'argtype': '0'},
      \ {'name': 'wildmenumode', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'win_execute', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_2'},
      \ {'name': 'win_findbuf', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'win_getid', 'min_argc': 0, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \ {'name': 'win_gettype', 'min_argc': 0, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'win_gotoid', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'win_id2tabwin', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'win_id2win', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'win_screenpos', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'win_splitmove', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'winbufnr', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'wincol', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'windowsversion', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'winheight', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'winlayout', 'min_argc': 0, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'winline', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'winnr', 'min_argc': 0, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'winrestcmd', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'winrestview', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'winsaveview', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'winwidth', 'min_argc': 1, 'max_argc': 1, 'argtype': 'FEARG_1'},
      \ {'name': 'wordcount', 'min_argc': 0, 'max_argc': 0, 'argtype': '0'},
      \ {'name': 'writefile', 'min_argc': 2, 'max_argc': 3, 'argtype': 'FEARG_1'},
      \ {'name': 'xor', 'min_argc': 2, 'max_argc': 2, 'argtype': 'FEARG_1'},
      \]

let s:ExprTokenizer = {}

function! s:ExprTokenizer.new(...) abort
  let obj = copy(self)
  call call(obj.__init__, a:000, obj)
  return obj
endfunction

function! s:ExprTokenizer.__init__(reader) abort
  let self.reader = a:reader
  let self.cache = {}
endfunction

function! s:ExprTokenizer.token(type, value, pos) abort
  return {'type': a:type, 'value': a:value, 'pos': a:pos}
endfunction

function! s:ExprTokenizer.peek() abort
  let pos = self.reader.tell()
  let r = self.get()
  call self.reader.seek_set(pos)
  return r
endfunction

function! s:ExprTokenizer.get() abort
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

function! s:ExprTokenizer.get2() abort
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
  elseif c ==# '0' && (r.p(1) ==# 'B' || r.p(1) ==# 'b') && (r.p(2) ==# '0' || r.p(2) ==# '1')
    let s = r.getn(3)
    let s .= r.read_bdigit()
    return self.token(s:TOKEN_NUMBER, s, pos)
  elseif c ==# '0' && (r.p(1) ==# 'Z' || r.p(1) ==# 'z') && r.p(2) !=# '.'
    let s = r.getn(2)
    let s .= r.read_blob()
    return self.token(s:TOKEN_BLOB, s, pos)
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
    if r.p(1) ==# '>'
      call r.seek_cur(2)
      return self.token(s:TOKEN_ARROW, '->', pos)
    else
      call r.seek_cur(1)
      return self.token(s:TOKEN_MINUS, '-', pos)
    endif
  elseif c ==# '.'
    if r.p(1) ==# '.' && r.p(2) ==# '.'
      call r.seek_cur(3)
      return self.token(s:TOKEN_DOTDOTDOT, '...', pos)
    elseif r.p(1) ==# '.'
      call r.seek_cur(2)
      return self.token(s:TOKEN_DOTDOT, '..', pos) " TODO check scriptversion?
    else
      call r.seek_cur(1)
      return self.token(s:TOKEN_DOT, '.', pos) " TODO check scriptversion?
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
  elseif c ==# '#'
    if r.p(1) ==# '{'
      call r.seek_cur(2)
      return self.token(s:TOKEN_LITCOPEN, '#{', pos)
    else
      call r.seek_cur(1)
      return self.token(s:TOKEN_SHARP, '#', pos)
    endif
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
    let s = ''
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

function! s:ExprTokenizer.get_sstring() abort
  call self.reader.skip_white()
  let c = self.reader.p(0)
  if c !=# "'"
    throw s:Err(printf('unexpected character: %s', c), self.reader.getpos())
  endif
  call self.reader.seek_cur(1)
  let s = ''
  while s:TRUE
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

function! s:ExprTokenizer.get_dstring() abort
  call self.reader.skip_white()
  let c = self.reader.p(0)
  if c !=# '"'
    throw s:Err(printf('unexpected character: %s', c), self.reader.getpos())
  endif
  call self.reader.seek_cur(1)
  let s = ''
  while s:TRUE
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

function! s:ExprTokenizer.parse_dict_literal_key() abort
  call self.reader.skip_white()
  let c = self.reader.peek()
  if !s:isalnum(c) && c !=# '_' && c !=# '-'
    throw s:Err(printf('unexpected character: %s', c), self.reader.getpos())
  endif
  let node = s:Node(s:NODE_STRING)
  let s = c
  call self.reader.seek_cur(1)
  let node.pos = self.reader.getpos()
  while s:TRUE
    let c = self.reader.p(0)
    if c ==# '<EOF>' || c ==# '<EOL>'
      throw s:Err('unexpectd EOL', self.reader.getpos())
    endif
    if !s:isalnum(c) && c !=# '_' && c !=# '-'
      break
    endif
    call self.reader.seek_cur(1)
    let s .= c
  endwhile
  let node.value = "'" . s . "'"
  return node
endfunction

let s:ExprParser = {}

function! s:ExprParser.new(...) abort
  let obj = copy(self)
  call call(obj.__init__, a:000, obj)
  return obj
endfunction

function! s:ExprParser.__init__(reader) abort
  let self.reader = a:reader
  let self.tokenizer = s:ExprTokenizer.new(a:reader)
endfunction

function! s:ExprParser.parse() abort
  return self.parse_expr1()
endfunction

" expr1: expr2 ? expr1 : expr1
function! s:ExprParser.parse_expr1() abort
  let left = self.parse_expr2()
  let pos = self.reader.tell()
  let token = self.tokenizer.get()
  if token.type ==# s:TOKEN_QUESTION
    let node = s:Node(s:NODE_TERNARY)
    let node.pos = token.pos
    let node.cond = left
    let node.left = self.parse_expr1()
    let token = self.tokenizer.get()
    if token.type !=# s:TOKEN_COLON
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
function! s:ExprParser.parse_expr2() abort
  let left = self.parse_expr3()
  while s:TRUE
    let pos = self.reader.tell()
    let token = self.tokenizer.get()
    if token.type ==# s:TOKEN_OROR
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
function! s:ExprParser.parse_expr3() abort
  let left = self.parse_expr4()
  while s:TRUE
    let pos = self.reader.tell()
    let token = self.tokenizer.get()
    if token.type ==# s:TOKEN_ANDAND
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
function! s:ExprParser.parse_expr4() abort
  let left = self.parse_expr5()
  let pos = self.reader.tell()
  let token = self.tokenizer.get()
  if token.type ==# s:TOKEN_EQEQ
    let node = s:Node(s:NODE_EQUAL)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type ==# s:TOKEN_EQEQCI
    let node = s:Node(s:NODE_EQUALCI)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type ==# s:TOKEN_EQEQCS
    let node = s:Node(s:NODE_EQUALCS)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type ==# s:TOKEN_NEQ
    let node = s:Node(s:NODE_NEQUAL)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type ==# s:TOKEN_NEQCI
    let node = s:Node(s:NODE_NEQUALCI)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type ==# s:TOKEN_NEQCS
    let node = s:Node(s:NODE_NEQUALCS)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type ==# s:TOKEN_GT
    let node = s:Node(s:NODE_GREATER)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type ==# s:TOKEN_GTCI
    let node = s:Node(s:NODE_GREATERCI)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type ==# s:TOKEN_GTCS
    let node = s:Node(s:NODE_GREATERCS)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type ==# s:TOKEN_GTEQ
    let node = s:Node(s:NODE_GEQUAL)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type ==# s:TOKEN_GTEQCI
    let node = s:Node(s:NODE_GEQUALCI)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type ==# s:TOKEN_GTEQCS
    let node = s:Node(s:NODE_GEQUALCS)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type ==# s:TOKEN_LT
    let node = s:Node(s:NODE_SMALLER)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type ==# s:TOKEN_LTCI
    let node = s:Node(s:NODE_SMALLERCI)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type ==# s:TOKEN_LTCS
    let node = s:Node(s:NODE_SMALLERCS)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type ==# s:TOKEN_LTEQ
    let node = s:Node(s:NODE_SEQUAL)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type ==# s:TOKEN_LTEQCI
    let node = s:Node(s:NODE_SEQUALCI)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type ==# s:TOKEN_LTEQCS
    let node = s:Node(s:NODE_SEQUALCS)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type ==# s:TOKEN_MATCH
    let node = s:Node(s:NODE_MATCH)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type ==# s:TOKEN_MATCHCI
    let node = s:Node(s:NODE_MATCHCI)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type ==# s:TOKEN_MATCHCS
    let node = s:Node(s:NODE_MATCHCS)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type ==# s:TOKEN_NOMATCH
    let node = s:Node(s:NODE_NOMATCH)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type ==# s:TOKEN_NOMATCHCI
    let node = s:Node(s:NODE_NOMATCHCI)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type ==# s:TOKEN_NOMATCHCS
    let node = s:Node(s:NODE_NOMATCHCS)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type ==# s:TOKEN_IS
    let node = s:Node(s:NODE_IS)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type ==# s:TOKEN_ISCI
    let node = s:Node(s:NODE_ISCI)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type ==# s:TOKEN_ISCS
    let node = s:Node(s:NODE_ISCS)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type ==# s:TOKEN_ISNOT
    let node = s:Node(s:NODE_ISNOT)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type ==# s:TOKEN_ISNOTCI
    let node = s:Node(s:NODE_ISNOTCI)
    let node.pos = token.pos
    let node.left = left
    let node.right = self.parse_expr5()
    let left = node
  elseif token.type ==# s:TOKEN_ISNOTCS
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
"        expr6 .. expr6 ..
function! s:ExprParser.parse_expr5() abort
  let left = self.parse_expr6()
  while s:TRUE
    let pos = self.reader.tell()
    let token = self.tokenizer.get()
    if token.type ==# s:TOKEN_PLUS
      let node = s:Node(s:NODE_ADD)
      let node.pos = token.pos
      let node.left = left
      let node.right = self.parse_expr6()
      let left = node
    elseif token.type ==# s:TOKEN_MINUS
      let node = s:Node(s:NODE_SUBTRACT)
      let node.pos = token.pos
      let node.left = left
      let node.right = self.parse_expr6()
      let left = node
    elseif token.type ==# s:TOKEN_DOTDOT " TODO check scriptversion?
      let node = s:Node(s:NODE_CONCAT)
      let node.pos = token.pos
      let node.left = left
      let node.right = self.parse_expr6()
      let left = node
    elseif token.type ==# s:TOKEN_DOT " TODO check scriptversion?
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
function! s:ExprParser.parse_expr6() abort
  let left = self.parse_expr7()
  while s:TRUE
    let pos = self.reader.tell()
    let token = self.tokenizer.get()
    if token.type ==# s:TOKEN_STAR
      let node = s:Node(s:NODE_MULTIPLY)
      let node.pos = token.pos
      let node.left = left
      let node.right = self.parse_expr7()
      let left = node
    elseif token.type ==# s:TOKEN_SLASH
      let node = s:Node(s:NODE_DIVIDE)
      let node.pos = token.pos
      let node.left = left
      let node.right = self.parse_expr7()
      let left = node
    elseif token.type ==# s:TOKEN_PERCENT
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
function! s:ExprParser.parse_expr7() abort
  let pos = self.reader.tell()
  let token = self.tokenizer.get()
  if token.type ==# s:TOKEN_NOT
    let node = s:Node(s:NODE_NOT)
    let node.pos = token.pos
    let node.left = self.parse_expr7()
    return node
  elseif token.type ==# s:TOKEN_MINUS
    let node = s:Node(s:NODE_MINUS)
    let node.pos = token.pos
    let node.left = self.parse_expr7()
    return node
  elseif token.type ==# s:TOKEN_PLUS
    let node = s:Node(s:NODE_PLUS)
    let node.pos = token.pos
    let node.left = self.parse_expr7()
    return node
  else
    call self.reader.seek_set(pos)
    let node = self.parse_expr8()
    return node
  endif
endfunction

" expr8: expr8[expr1]
"        expr8[expr1 : expr1]
"        expr8.name
"        expr8->name(expr1, ...)
"        expr8->s:user_func(expr1, ...)
"        expr8->{lambda}(expr1, ...)
"        expr8(expr1, ...)
function! s:ExprParser.parse_expr8() abort
  let left = self.parse_expr9()
  while s:TRUE
    let pos = self.reader.tell()
    let c = self.reader.peek()
    let token = self.tokenizer.get()
    if !s:iswhite(c) && token.type ==# s:TOKEN_SQOPEN
      let npos = token.pos
      if self.tokenizer.peek().type ==# s:TOKEN_COLON
        call self.tokenizer.get()
        let node = s:Node(s:NODE_SLICE)
        let node.pos = npos
        let node.left = left
        let node.rlist = [s:NIL, s:NIL]
        let token = self.tokenizer.peek()
        if token.type !=# s:TOKEN_SQCLOSE
          let node.rlist[1] = self.parse_expr1()
        endif
        let token = self.tokenizer.get()
        if token.type !=# s:TOKEN_SQCLOSE
          throw s:Err(printf('unexpected token: %s', token.value), token.pos)
        endif
        let left = node
      else
        let right = self.parse_expr1()
        if self.tokenizer.peek().type ==# s:TOKEN_COLON
          call self.tokenizer.get()
          let node = s:Node(s:NODE_SLICE)
          let node.pos = npos
          let node.left = left
          let node.rlist = [right, s:NIL]
          let token = self.tokenizer.peek()
          if token.type !=# s:TOKEN_SQCLOSE
            let node.rlist[1] = self.parse_expr1()
          endif
          let token = self.tokenizer.get()
          if token.type !=# s:TOKEN_SQCLOSE
            throw s:Err(printf('unexpected token: %s', token.value), token.pos)
          endif
          let left = node
        else
          let node = s:Node(s:NODE_SUBSCRIPT)
          let node.pos = npos
          let node.left = left
          let node.right = right
          let token = self.tokenizer.get()
          if token.type !=# s:TOKEN_SQCLOSE
            throw s:Err(printf('unexpected token: %s', token.value), token.pos)
          endif
          let left = node
        endif
      endif
      unlet node
    elseif token.type ==# s:TOKEN_ARROW
      let funcname_or_lambda = self.parse_expr9()
      let token = self.tokenizer.get()
      if token.type !=# s:TOKEN_POPEN
        throw s:Err('E107: Missing parentheses: lambda', token.pos)
      endif
      let right = s:Node(s:NODE_CALL)
      let right.pos = token.pos
      let right.left = funcname_or_lambda
      let right.rlist = self.parse_rlist()
      let node = s:Node(s:NODE_METHOD)
      let node.pos = token.pos
      let node.left = left
      let node.right = right
      let left = node
      unlet node
    elseif token.type ==# s:TOKEN_POPEN
      let node = s:Node(s:NODE_CALL)
      let node.pos = token.pos
      let node.left = left
      let node.rlist = self.parse_rlist()
      let left = node
      unlet node
    elseif !s:iswhite(c) && token.type ==# s:TOKEN_DOT " TODO check scriptversion?
      let node = self.parse_dot(token, left)
      if node is# s:NIL
        call self.reader.seek_set(pos)
        break
      endif
      let left = node
      unlet node
    else
      call self.reader.seek_set(pos)
      break
    endif
  endwhile
  return left
endfunction

function! s:ExprParser.parse_rlist() abort
  let rlist = []
  let token = self.tokenizer.peek()
  if self.tokenizer.peek().type ==# s:TOKEN_PCLOSE
    call self.tokenizer.get()
  else
    while s:TRUE
      call add(rlist, self.parse_expr1())
      let token = self.tokenizer.get()
      if token.type ==# s:TOKEN_COMMA
        " XXX: Vim allows foo(a, b, ).  Lint should warn it.
        if self.tokenizer.peek().type ==# s:TOKEN_PCLOSE
          call self.tokenizer.get()
          break
        endif
      elseif token.type ==# s:TOKEN_PCLOSE
        break
      else
        throw s:Err(printf('unexpected token: %s', token.value), token.pos)
      endif
    endwhile
  endif
  if len(rlist) > s:MAX_FUNC_ARGS
    " TODO: funcname E740: Too many arguments for function: %s
    throw s:Err('E740: Too many arguments for function', token.pos)
  endif
  return rlist
endfunction

" expr9: number
"        "string"
"        'string'
"        [expr1, ...]
"        {expr1: expr1, ...}
"        #{literal_key1: expr1, ...}
"        {args -> expr1}
"        &option
"        (expr1)
"        variable
"        var{ria}ble
"        $VAR
"        @r
"        function(expr1, ...)
"        func{ti}on(expr1, ...)
function! s:ExprParser.parse_expr9() abort
  let pos = self.reader.tell()
  let token = self.tokenizer.get()
  let node = s:Node(-1)
  if token.type ==# s:TOKEN_NUMBER
    let node = s:Node(s:NODE_NUMBER)
    let node.pos = token.pos
    let node.value = token.value
  elseif token.type ==# s:TOKEN_BLOB
    let node = s:Node(s:NODE_BLOB)
    let node.pos = token.pos
    let node.value = token.value
  elseif token.type ==# s:TOKEN_DQUOTE
    call self.reader.seek_set(pos)
    let node = s:Node(s:NODE_STRING)
    let node.pos = token.pos
    let node.value = '"' . self.tokenizer.get_dstring() . '"'
  elseif token.type ==# s:TOKEN_SQUOTE
    call self.reader.seek_set(pos)
    let node = s:Node(s:NODE_STRING)
    let node.pos = token.pos
    let node.value = "'" . self.tokenizer.get_sstring() . "'"
  elseif token.type ==# s:TOKEN_SQOPEN
    let node = s:Node(s:NODE_LIST)
    let node.pos = token.pos
    let node.value = []
    let token = self.tokenizer.peek()
    if token.type ==# s:TOKEN_SQCLOSE
      call self.tokenizer.get()
    else
      while s:TRUE
        call add(node.value, self.parse_expr1())
        let token = self.tokenizer.peek()
        if token.type ==# s:TOKEN_COMMA
          call self.tokenizer.get()
          if self.tokenizer.peek().type ==# s:TOKEN_SQCLOSE
            call self.tokenizer.get()
            break
          endif
        elseif token.type ==# s:TOKEN_SQCLOSE
          call self.tokenizer.get()
          break
        else
          throw s:Err(printf('unexpected token: %s', token.value), token.pos)
        endif
      endwhile
    endif
  elseif token.type ==# s:TOKEN_COPEN || token.type ==# s:TOKEN_LITCOPEN
    let is_litdict = token.type ==# s:TOKEN_LITCOPEN
    let savepos = self.reader.tell()
    let nodepos = token.pos
    let token = self.tokenizer.get()
    let lambda = token.type ==# s:TOKEN_ARROW
    if !lambda && !(token.type ==# s:TOKEN_SQUOTE || token.type ==# s:TOKEN_DQUOTE)
      " if the token type is stirng, we cannot peek next token and we can
      " assume it's not lambda.
      let token2 = self.tokenizer.peek()
      let lambda = token2.type ==# s:TOKEN_ARROW || token2.type ==# s:TOKEN_COMMA
    endif
    " fallback to dict or {expr} if true
    let fallback = s:FALSE
    if lambda
      " lambda {token,...} {->...} {token->...}
      let node = s:Node(s:NODE_LAMBDA)
      let node.pos = nodepos
      let node.rlist = []
      let named = {}
      while s:TRUE
        if token.type ==# s:TOKEN_ARROW
          break
        elseif token.type ==# s:TOKEN_IDENTIFIER
          if !s:isargname(token.value)
            throw s:Err(printf('E125: Illegal argument: %s', token.value), token.pos)
          elseif has_key(named, token.value)
            throw s:Err(printf('E853: Duplicate argument name: %s', token.value), token.pos)
          endif
          let named[token.value] = 1
          let varnode = s:Node(s:NODE_IDENTIFIER)
          let varnode.pos = token.pos
          let varnode.value = token.value
          " XXX: Vim doesn't skip white space before comma.  {a ,b -> ...} => E475
          if s:iswhite(self.reader.p(0)) && self.tokenizer.peek().type ==# s:TOKEN_COMMA
            throw s:Err('E475: Invalid argument: White space is not allowed before comma', self.reader.getpos())
          endif
          let token = self.tokenizer.get()
          call add(node.rlist, varnode)
          if token.type ==# s:TOKEN_COMMA
            " XXX: Vim allows last comma.  {a, b, -> ...} => OK
            let token = self.tokenizer.peek()
            if token.type ==# s:TOKEN_ARROW
              call self.tokenizer.get()
              break
            endif
          elseif token.type ==# s:TOKEN_ARROW
            break
          else
            throw s:Err(printf('unexpected token: %s, type: %d', token.value, token.type), token.pos)
          endif
        elseif token.type ==# s:TOKEN_DOTDOTDOT
          let varnode = s:Node(s:NODE_IDENTIFIER)
          let varnode.pos = token.pos
          let varnode.value = token.value
          call add(node.rlist, varnode)
          let token = self.tokenizer.peek()
          if token.type ==# s:TOKEN_ARROW
            call self.tokenizer.get()
            break
          else
            throw s:Err(printf('unexpected token: %s', token.value), token.pos)
          endif
        else
          let fallback = s:TRUE
          break
        endif
        let token = self.tokenizer.get()
      endwhile
      if !fallback
        let node.left = self.parse_expr1()
        let token = self.tokenizer.get()
        if token.type !=# s:TOKEN_CCLOSE
          throw s:Err(printf('unexpected token: %s', token.value), token.pos)
        endif
        return node
      endif
    endif
    " dict
    let node = s:Node(s:NODE_DICT)
    let node.pos = nodepos
    let node.value = []
    call self.reader.seek_set(savepos)
    let token = self.tokenizer.peek()
    if token.type ==# s:TOKEN_CCLOSE
      call self.tokenizer.get()
      return node
    endif
    while 1
      let key = is_litdict ? self.tokenizer.parse_dict_literal_key() : self.parse_expr1()
      let token = self.tokenizer.get()
      if token.type ==# s:TOKEN_CCLOSE
        if !empty(node.value)
          throw s:Err(printf('unexpected token: %s', token.value), token.pos)
        endif
        call self.reader.seek_set(pos)
        let node = self.parse_identifier()
        break
      endif
      if token.type !=# s:TOKEN_COLON
        throw s:Err(printf('unexpected token: %s', token.value), token.pos)
      endif
      let val = self.parse_expr1()
      call add(node.value, [key, val])
      let token = self.tokenizer.get()
      if token.type ==# s:TOKEN_COMMA
        if self.tokenizer.peek().type ==# s:TOKEN_CCLOSE
          call self.tokenizer.get()
          break
        endif
      elseif token.type ==# s:TOKEN_CCLOSE
        break
      else
        throw s:Err(printf('unexpected token: %s', token.value), token.pos)
      endif
    endwhile
    return node
  elseif token.type ==# s:TOKEN_POPEN
    let node = self.parse_expr1()
    let token = self.tokenizer.get()
    if token.type !=# s:TOKEN_PCLOSE
      throw s:Err(printf('unexpected token: %s', token.value), token.pos)
    endif
  elseif token.type ==# s:TOKEN_OPTION
    let node = s:Node(s:NODE_OPTION)
    let node.pos = token.pos
    let node.value = token.value
  elseif token.type ==# s:TOKEN_IDENTIFIER
    call self.reader.seek_set(pos)
    let node = self.parse_identifier()
  elseif s:FALSE && (token.type ==# s:TOKEN_COLON || token.type ==# s:TOKEN_SHARP)
    " XXX: no parse error but invalid expression
    call self.reader.seek_set(pos)
    let node = self.parse_identifier()
  elseif token.type ==# s:TOKEN_LT && self.reader.peekn(4) ==? 'SID>'
    call self.reader.seek_set(pos)
    let node = self.parse_identifier()
  elseif token.type ==# s:TOKEN_IS || token.type ==# s:TOKEN_ISCS || token.type ==# s:TOKEN_ISNOT || token.type ==# s:TOKEN_ISNOTCS
    call self.reader.seek_set(pos)
    let node = self.parse_identifier()
  elseif token.type ==# s:TOKEN_ENV
    let node = s:Node(s:NODE_ENV)
    let node.pos = token.pos
    let node.value = token.value
  elseif token.type ==# s:TOKEN_REG
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
function! s:ExprParser.parse_dot(token, left) abort
  if a:left.type !=# s:NODE_IDENTIFIER && a:left.type !=# s:NODE_CURLYNAME && a:left.type !=# s:NODE_DICT && a:left.type !=# s:NODE_SUBSCRIPT && a:left.type !=# s:NODE_CALL && a:left.type !=# s:NODE_DOT
    return s:NIL
  endif
  if !s:iswordc(self.reader.p(0))
    return s:NIL
  endif
  let pos = self.reader.getpos()
  let name = self.reader.read_word()
  if s:isnamec(self.reader.p(0))
    " XXX: foo is str => ok, foo is obj => invalid expression
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

" CONCAT
"   str  ".." expr6         => (concat str expr6)
function! s:ExprParser.parse_concat(token, left) abort
  if a:left.type !=# s:NODE_IDENTIFIER && a:left.type !=# s:NODE_CURLYNAME && a:left.type !=# s:NODE_DICT && a:left.type !=# s:NODE_SUBSCRIPT && a:left.type !=# s:NODE_CALL && a:left.type !=# s:NODE_DOT
    return s:NIL
  endif
  if !s:iswordc(self.reader.p(0))
    return s:NIL
  endif
  let pos = self.reader.getpos()
  let name = self.reader.read_word()
  if s:isnamec(self.reader.p(0))
    " XXX: foo is str => ok, foo is obj => invalid expression
    " foo.s:bar or foo.bar#baz
    return s:NIL
  endif
  let node = s:Node(s:NODE_CONCAT)
  let node.pos = a:token.pos
  let node.left = a:left
  let node.right = s:Node(s:NODE_IDENTIFIER)
  let node.right.pos = pos
  let node.right.value = name
  return node
endfunction

function! s:ExprParser.parse_identifier() abort
  call self.reader.skip_white()
  let npos = self.reader.getpos()
  let curly_parts = self.parse_curly_parts()
  if len(curly_parts) ==# 1 && curly_parts[0].type ==# s:NODE_CURLYNAMEPART
    let node = s:Node(s:NODE_IDENTIFIER)
    let node.pos = npos
    let node.value = curly_parts[0].value
    return node
  else
    let node = s:Node(s:NODE_CURLYNAME)
    let node.pos = npos
    let node.value = curly_parts
    return node
  endif
endfunction

function! s:ExprParser.parse_curly_parts() abort
  let curly_parts = []
  let c = self.reader.peek()
  let pos = self.reader.getpos()
  if c ==# '<' && self.reader.peekn(5) ==? '<SID>'
    let name = self.reader.getn(5)
    let node = s:Node(s:NODE_CURLYNAMEPART)
    let node.curly = s:FALSE " Keep backword compatibility for the curly attribute
    let node.pos = pos
    let node.value = name
    call add(curly_parts, node)
  endif
  while s:TRUE
    let c = self.reader.peek()
    if s:isnamec(c)
      let pos = self.reader.getpos()
      let name = self.reader.read_name()
      let node = s:Node(s:NODE_CURLYNAMEPART)
      let node.curly = s:FALSE " Keep backword compatibility for the curly attribute
      let node.pos = pos
      let node.value = name
      call add(curly_parts, node)
    elseif c ==# '{'
      call self.reader.get()
      let pos = self.reader.getpos()
      let node = s:Node(s:NODE_CURLYNAMEEXPR)
      let node.curly = s:TRUE " Keep backword compatibility for the curly attribute
      let node.pos = pos
      let node.value = self.parse_expr1()
      call add(curly_parts, node)
      call self.reader.skip_white()
      let c = self.reader.p(0)
      if c !=# '}'
        throw s:Err(printf('unexpected token: %s', c), self.reader.getpos())
      endif
      call self.reader.seek_cur(1)
    else
      break
    endif
  endwhile
  return curly_parts
endfunction

let s:LvalueParser = copy(s:ExprParser)

function! s:LvalueParser.parse() abort
  return self.parse_lv8()
endfunction

" expr8: expr8[expr1]
"        expr8[expr1 : expr1]
"        expr8.name
function! s:LvalueParser.parse_lv8() abort
  let left = self.parse_lv9()
  while s:TRUE
    let pos = self.reader.tell()
    let c = self.reader.peek()
    let token = self.tokenizer.get()
    if !s:iswhite(c) && token.type ==# s:TOKEN_SQOPEN
      let npos = token.pos
      let node = s:Node(-1)
      if self.tokenizer.peek().type ==# s:TOKEN_COLON
        call self.tokenizer.get()
        let node = s:Node(s:NODE_SLICE)
        let node.pos = npos
        let node.left = left
        let node.rlist = [s:NIL, s:NIL]
        let token = self.tokenizer.peek()
        if token.type !=# s:TOKEN_SQCLOSE
          let node.rlist[1] = self.parse_expr1()
        endif
        let token = self.tokenizer.get()
        if token.type !=# s:TOKEN_SQCLOSE
          throw s:Err(printf('unexpected token: %s', token.value), token.pos)
        endif
      else
        let right = self.parse_expr1()
        if self.tokenizer.peek().type ==# s:TOKEN_COLON
          call self.tokenizer.get()
          let node = s:Node(s:NODE_SLICE)
          let node.pos = npos
          let node.left = left
          let node.rlist = [right, s:NIL]
          let token = self.tokenizer.peek()
          if token.type !=# s:TOKEN_SQCLOSE
            let node.rlist[1] = self.parse_expr1()
          endif
          let token = self.tokenizer.get()
          if token.type !=# s:TOKEN_SQCLOSE
            throw s:Err(printf('unexpected token: %s', token.value), token.pos)
          endif
        else
          let node = s:Node(s:NODE_SUBSCRIPT)
          let node.pos = npos
          let node.left = left
          let node.right = right
          let token = self.tokenizer.get()
          if token.type !=# s:TOKEN_SQCLOSE
            throw s:Err(printf('unexpected token: %s', token.value), token.pos)
          endif
        endif
      endif
      let left = node
      unlet node
    elseif !s:iswhite(c) && token.type ==# s:TOKEN_DOT
      let node = self.parse_dot(token, left)
      if node is# s:NIL
        call self.reader.seek_set(pos)
        break
      endif
      let left = node
      unlet node
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
function! s:LvalueParser.parse_lv9() abort
  let pos = self.reader.tell()
  let token = self.tokenizer.get()
  let node = s:Node(-1)
  if token.type ==# s:TOKEN_COPEN
    call self.reader.seek_set(pos)
    let node = self.parse_identifier()
  elseif token.type ==# s:TOKEN_OPTION
    let node = s:Node(s:NODE_OPTION)
    let node.pos = token.pos
    let node.value = token.value
  elseif token.type ==# s:TOKEN_IDENTIFIER
    call self.reader.seek_set(pos)
    let node = self.parse_identifier()
  elseif token.type ==# s:TOKEN_LT && self.reader.peekn(4) ==? 'SID>'
    call self.reader.seek_set(pos)
    let node = self.parse_identifier()
  elseif token.type ==# s:TOKEN_ENV
    let node = s:Node(s:NODE_ENV)
    let node.pos = token.pos
    let node.value = token.value
  elseif token.type ==# s:TOKEN_REG
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

function! s:StringReader.new(...) abort
  let obj = copy(self)
  call call(obj.__init__, a:000, obj)
  return obj
endfunction

function! s:StringReader.__init__(lines) abort
  let self.buf = []
  let self.pos = []
  let lnum = 0
  let offset = 0
  while lnum < len(a:lines)
    let col = 0
    for c in split(a:lines[lnum], '\zs')
      call add(self.buf, c)
      call add(self.pos, [lnum + 1, col + 1, offset])
      let col += len(c)
      let offset += len(c)
    endfor
    while lnum + 1 < len(a:lines) && a:lines[lnum + 1] =~# '^\s*\\'
      let skip = s:TRUE
      let col = 0
      for c in split(a:lines[lnum + 1], '\zs')
        if skip
          if c ==# '\'
            let skip = s:FALSE
          endif
        else
          call add(self.buf, c)
          call add(self.pos, [lnum + 2, col + 1, offset])
        endif
        let col += len(c)
        let offset += len(c)
      endfor
      let lnum += 1
      let offset += 1
    endwhile
    call add(self.buf, '<EOL>')
    call add(self.pos, [lnum + 1, col + 1, offset])
    let lnum += 1
    let offset += 1
  endwhile
  " for <EOF>
  call add(self.pos, [lnum + 1, 0, offset])
  let self.i = 0
endfunction

function! s:StringReader.eof() abort
  return self.i >= len(self.buf)
endfunction

function! s:StringReader.tell() abort
  return self.i
endfunction

function! s:StringReader.seek_set(i) abort
  let self.i = a:i
endfunction

function! s:StringReader.seek_cur(i) abort
  let self.i = self.i + a:i
endfunction

function! s:StringReader.seek_end(i) abort
  let self.i = len(self.buf) + a:i
endfunction

function! s:StringReader.p(i) abort
  if self.i >= len(self.buf)
    return '<EOF>'
  endif
  return self.buf[self.i + a:i]
endfunction

function! s:StringReader.peek() abort
  if self.i >= len(self.buf)
    return '<EOF>'
  endif
  return self.buf[self.i]
endfunction

function! s:StringReader.get() abort
  if self.i >= len(self.buf)
    return '<EOF>'
  endif
  let self.i += 1
  return self.buf[self.i - 1]
endfunction

function! s:StringReader.peekn(n) abort
  let pos = self.tell()
  let r = self.getn(a:n)
  call self.seek_set(pos)
  return r
endfunction

function! s:StringReader.getn(n) abort
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

function! s:StringReader.peekline() abort
  return self.peekn(-1)
endfunction

function! s:StringReader.readline() abort
  let r = self.getn(-1)
  call self.get()
  return r
endfunction

function! s:StringReader.getstr(begin, end) abort
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

function! s:StringReader.getpos() abort
  let [lnum, col, offset] = self.pos[self.i]
  return {'i': self.i, 'lnum': lnum, 'col': col, 'offset': offset}
endfunction

function! s:StringReader.setpos(pos) abort
  let self.i  = a:pos.i
endfunction

function! s:StringReader.read_alpha() abort
  let r = ''
  while s:isalpha(self.peekn(1))
    let r .= self.getn(1)
  endwhile
  return r
endfunction

function! s:StringReader.read_alnum() abort
  let r = ''
  while s:isalnum(self.peekn(1))
    let r .= self.getn(1)
  endwhile
  return r
endfunction

function! s:StringReader.read_digit() abort
  let r = ''
  while s:isdigit(self.peekn(1))
    let r .= self.getn(1)
  endwhile
  return r
endfunction

function! s:StringReader.read_odigit() abort
  let r = ''
  while s:isodigit(self.peekn(1))
    let r .= self.getn(1)
  endwhile
  return r
endfunction

function! s:StringReader.read_blob() abort
  let r = ''
  while 1
    let s = self.peekn(2)
    if s =~# '^[0-9A-Fa-f][0-9A-Fa-f]$'
      let r .= self.getn(2)
    elseif s =~# '^\.[0-9A-Fa-f]$'
      let r .= self.getn(1)
    elseif s =~# '^[0-9A-Fa-f][^0-9A-Fa-f]$'
      throw s:Err('E973: Blob literal should have an even number of hex characters:' . s, self.getpos())
    else
      break
    endif
  endwhile
  return r
endfunction

function! s:StringReader.read_xdigit() abort
  let r = ''
  while s:isxdigit(self.peekn(1))
    let r .= self.getn(1)
  endwhile
  return r
endfunction

function! s:StringReader.read_bdigit() abort
  let r = ''
  while self.peekn(1) ==# '0' || self.peekn(1) ==# '1'
    let r .= self.getn(1)
  endwhile
  return r
endfunction

function! s:StringReader.read_integer() abort
  let r = ''
  let c = self.peekn(1)
  if c ==# '-' || c ==# '+'
    let r = self.getn(1)
  endif
  return r . self.read_digit()
endfunction

function! s:StringReader.read_word() abort
  let r = ''
  while s:iswordc(self.peekn(1))
    let r .= self.getn(1)
  endwhile
  return r
endfunction

function! s:StringReader.read_white() abort
  let r = ''
  while s:iswhite(self.peekn(1))
    let r .= self.getn(1)
  endwhile
  return r
endfunction

function! s:StringReader.read_nonwhite() abort
  let r = ''
  let ch = self.peekn(1)
  while !s:iswhite(ch) && ch !=# ''
    let r .= self.getn(1)
    let ch = self.peekn(1)
  endwhile
  return r
endfunction

function! s:StringReader.read_name() abort
  let r = ''
  while s:isnamec(self.peekn(1))
    let r .= self.getn(1)
  endwhile
  return r
endfunction

function! s:StringReader.skip_white() abort
  while s:iswhite(self.peekn(1))
    call self.seek_cur(1)
  endwhile
endfunction

function! s:StringReader.skip_white_and_colon() abort
  while s:TRUE
    let c = self.peekn(1)
    if !s:iswhite(c) && c !=# ':'
      break
    endif
    call self.seek_cur(1)
  endwhile
endfunction

let s:Compiler = {}

function! s:Compiler.new(...) abort
  let obj = copy(self)
  call call(obj.__init__, a:000, obj)
  return obj
endfunction

function! s:Compiler.__init__() abort
  let self.indent = ['']
  let self.lines = []
endfunction

function! s:Compiler.out(...) abort
  if len(a:000) ==# 1
    if a:000[0][0] ==# ')'
      let self.lines[-1] .= a:000[0]
    else
      call add(self.lines, self.indent[0] . a:000[0])
    endif
  else
    call add(self.lines, self.indent[0] . call('printf', a:000))
  endif
endfunction

function! s:Compiler.incindent(s) abort
  call insert(self.indent, self.indent[0] . a:s)
endfunction

function! s:Compiler.decindent() abort
  call remove(self.indent, 0)
endfunction

function! s:Compiler.compile(node) abort
  if a:node.type ==# s:NODE_TOPLEVEL
    return self.compile_toplevel(a:node)
  elseif a:node.type ==# s:NODE_COMMENT
    call self.compile_comment(a:node)
    return s:NIL
  elseif a:node.type ==# s:NODE_EXCMD
    call self.compile_excmd(a:node)
    return s:NIL
  elseif a:node.type ==# s:NODE_FUNCTION
    call self.compile_function(a:node)
    return s:NIL
  elseif a:node.type ==# s:NODE_DELFUNCTION
    call self.compile_delfunction(a:node)
    return s:NIL
  elseif a:node.type ==# s:NODE_RETURN
    call self.compile_return(a:node)
    return s:NIL
  elseif a:node.type ==# s:NODE_EXCALL
    call self.compile_excall(a:node)
    return s:NIL
  elseif a:node.type ==# s:NODE_EVAL
    call self.compile_eval(a:node)
    return s:NIL
  elseif a:node.type ==# s:NODE_LET
    call self.compile_let(a:node)
    return s:NIL
  elseif a:node.type ==# s:NODE_CONST
    call self.compile_const(a:node)
    return s:NIL
  elseif a:node.type ==# s:NODE_UNLET
    call self.compile_unlet(a:node)
    return s:NIL
  elseif a:node.type ==# s:NODE_LOCKVAR
    call self.compile_lockvar(a:node)
    return s:NIL
  elseif a:node.type ==# s:NODE_UNLOCKVAR
    call self.compile_unlockvar(a:node)
    return s:NIL
  elseif a:node.type ==# s:NODE_IF
    call self.compile_if(a:node)
    return s:NIL
  elseif a:node.type ==# s:NODE_WHILE
    call self.compile_while(a:node)
    return s:NIL
  elseif a:node.type ==# s:NODE_FOR
    call self.compile_for(a:node)
    return s:NIL
  elseif a:node.type ==# s:NODE_CONTINUE
    call self.compile_continue(a:node)
    return s:NIL
  elseif a:node.type ==# s:NODE_BREAK
    call self.compile_break(a:node)
    return s:NIL
  elseif a:node.type ==# s:NODE_TRY
    call self.compile_try(a:node)
    return s:NIL
  elseif a:node.type ==# s:NODE_THROW
    call self.compile_throw(a:node)
    return s:NIL
  elseif a:node.type ==# s:NODE_ECHO
    call self.compile_echo(a:node)
    return s:NIL
  elseif a:node.type ==# s:NODE_ECHON
    call self.compile_echon(a:node)
    return s:NIL
  elseif a:node.type ==# s:NODE_ECHOHL
    call self.compile_echohl(a:node)
    return s:NIL
  elseif a:node.type ==# s:NODE_ECHOMSG
    call self.compile_echomsg(a:node)
    return s:NIL
  elseif a:node.type ==# s:NODE_ECHOERR
    call self.compile_echoerr(a:node)
    return s:NIL
  elseif a:node.type ==# s:NODE_EXECUTE
    call self.compile_execute(a:node)
    return s:NIL
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
  elseif a:node.type ==# s:NODE_METHOD
    return self.compile_method(a:node)
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
  elseif a:node.type ==# s:NODE_CURLYNAMEPART
    return self.compile_curlynamepart(a:node)
  elseif a:node.type ==# s:NODE_CURLYNAMEEXPR
    return self.compile_curlynameexpr(a:node)
  elseif a:node.type ==# s:NODE_LAMBDA
    return self.compile_lambda(a:node)
  elseif a:node.type == s:NODE_HEREDOC
    return self.compile_heredoc(a:node)
  else
    throw printf('Compiler: unknown node: %s', string(a:node))
  endif
  return s:NIL
endfunction

function! s:Compiler.compile_body(body) abort
  for node in a:body
    call self.compile(node)
  endfor
endfunction

function! s:Compiler.compile_toplevel(node) abort
  call self.compile_body(a:node.body)
  return self.lines
endfunction

function! s:Compiler.compile_comment(node) abort
  call self.out(';%s', a:node.str)
endfunction

function! s:Compiler.compile_excmd(node) abort
  call self.out('(excmd "%s")', escape(a:node.str, '\"'))
endfunction

function! s:Compiler.compile_function(node) abort
  let left = self.compile(a:node.left)
  let rlist = map(a:node.rlist, 'self.compile(v:val)')
  let default_args = map(a:node.default_args, 'self.compile(v:val)')
  if !empty(rlist)
    let remaining = s:FALSE
    if rlist[-1] ==# '...'
      call remove(rlist, -1)
      let remaining = s:TRUE
    endif
    for i in range(len(rlist))
      if i < len(rlist) - len(default_args)
        let left .= printf(' %s', rlist[i])
      else
        let left .= printf(' (%s %s)', rlist[i], default_args[i + len(default_args) - len(rlist)])
      endif
    endfor
    if remaining
      let left .= ' . ...'
    endif
  endif
  call self.out('(function (%s)', left)
  call self.incindent('  ')
  call self.compile_body(a:node.body)
  call self.out(')')
  call self.decindent()
endfunction

function! s:Compiler.compile_delfunction(node) abort
  call self.out('(delfunction %s)', self.compile(a:node.left))
endfunction

function! s:Compiler.compile_return(node) abort
  if a:node.left is# s:NIL
    call self.out('(return)')
  else
    call self.out('(return %s)', self.compile(a:node.left))
  endif
endfunction

function! s:Compiler.compile_excall(node) abort
  call self.out('(call %s)', self.compile(a:node.left))
endfunction

function! s:Compiler.compile_eval(node) abort
  call self.out('(eval %s)', self.compile(a:node.left))
endfunction

function! s:Compiler.compile_let(node) abort
  let left = ''
  if a:node.left isnot# s:NIL
    let left = self.compile(a:node.left)
  else
    let left = join(map(a:node.list, 'self.compile(v:val)'), ' ')
    if a:node.rest isnot# s:NIL
      let left .= ' . ' . self.compile(a:node.rest)
    endif
    let left = '(' . left . ')'
  endif
  let right = self.compile(a:node.right)
  call self.out('(let %s %s %s)', a:node.op, left, right)
endfunction

" TODO: merge with s:Compiler.compile_let() ?
function! s:Compiler.compile_const(node) abort
  let left = ''
  if a:node.left isnot# s:NIL
    let left = self.compile(a:node.left)
  else
    let left = join(map(a:node.list, 'self.compile(v:val)'), ' ')
    if a:node.rest isnot# s:NIL
      let left .= ' . ' . self.compile(a:node.rest)
    endif
    let left = '(' . left . ')'
  endif
  let right = self.compile(a:node.right)
  call self.out('(const %s %s %s)', a:node.op, left, right)
endfunction

function! s:Compiler.compile_unlet(node) abort
  let list = map(a:node.list, 'self.compile(v:val)')
  call self.out('(unlet %s)', join(list, ' '))
endfunction

function! s:Compiler.compile_lockvar(node) abort
  let list = map(a:node.list, 'self.compile(v:val)')
  if a:node.depth is# s:NIL
    call self.out('(lockvar %s)', join(list, ' '))
  else
    call self.out('(lockvar %s %s)', a:node.depth, join(list, ' '))
  endif
endfunction

function! s:Compiler.compile_unlockvar(node) abort
  let list = map(a:node.list, 'self.compile(v:val)')
  if a:node.depth is# s:NIL
    call self.out('(unlockvar %s)', join(list, ' '))
  else
    call self.out('(unlockvar %s %s)', a:node.depth, join(list, ' '))
  endif
endfunction

function! s:Compiler.compile_if(node) abort
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
  if a:node.else isnot# s:NIL
    call self.out(' else')
    call self.incindent('  ')
    call self.compile_body(a:node.else.body)
    call self.decindent()
  endif
  call self.incindent('  ')
  call self.out(')')
  call self.decindent()
endfunction

function! s:Compiler.compile_while(node) abort
  call self.out('(while %s', self.compile(a:node.cond))
  call self.incindent('  ')
  call self.compile_body(a:node.body)
  call self.out(')')
  call self.decindent()
endfunction

function! s:Compiler.compile_for(node) abort
  let left = ''
  if a:node.left isnot# s:NIL
    let left = self.compile(a:node.left)
  else
    let left = join(map(a:node.list, 'self.compile(v:val)'), ' ')
    if a:node.rest isnot# s:NIL
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

function! s:Compiler.compile_continue(node) abort
  call self.out('(continue)')
endfunction

function! s:Compiler.compile_break(node) abort
  call self.out('(break)')
endfunction

function! s:Compiler.compile_try(node) abort
  call self.out('(try')
  call self.incindent('  ')
  call self.compile_body(a:node.body)
  for cnode in a:node.catch
    if cnode.pattern isnot# s:NIL
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
  if a:node.finally isnot# s:NIL
    call self.decindent()
    call self.out(' finally')
    call self.incindent('  ')
    call self.compile_body(a:node.finally.body)
  endif
  call self.out(')')
  call self.decindent()
endfunction

function! s:Compiler.compile_throw(node) abort
  call self.out('(throw %s)', self.compile(a:node.left))
endfunction

function! s:Compiler.compile_echo(node) abort
  let list = map(a:node.list, 'self.compile(v:val)')
  call self.out('(echo %s)', join(list, ' '))
endfunction

function! s:Compiler.compile_echon(node) abort
  let list = map(a:node.list, 'self.compile(v:val)')
  call self.out('(echon %s)', join(list, ' '))
endfunction

function! s:Compiler.compile_echohl(node) abort
  call self.out('(echohl "%s")', escape(a:node.str, '\"'))
endfunction

function! s:Compiler.compile_echomsg(node) abort
  let list = map(a:node.list, 'self.compile(v:val)')
  call self.out('(echomsg %s)', join(list, ' '))
endfunction

function! s:Compiler.compile_echoerr(node) abort
  let list = map(a:node.list, 'self.compile(v:val)')
  call self.out('(echoerr %s)', join(list, ' '))
endfunction

function! s:Compiler.compile_execute(node) abort
  let list = map(a:node.list, 'self.compile(v:val)')
  call self.out('(execute %s)', join(list, ' '))
endfunction

function! s:Compiler.compile_ternary(node) abort
  return printf('(?: %s %s %s)', self.compile(a:node.cond), self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_or(node) abort
  return printf('(|| %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_and(node) abort
  return printf('(&& %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_equal(node) abort
  return printf('(== %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_equalci(node) abort
  return printf('(==? %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_equalcs(node) abort
  return printf('(==# %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_nequal(node) abort
  return printf('(!= %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_nequalci(node) abort
  return printf('(!=? %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_nequalcs(node) abort
  return printf('(!=# %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_greater(node) abort
  return printf('(> %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_greaterci(node) abort
  return printf('(>? %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_greatercs(node) abort
  return printf('(># %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_gequal(node) abort
  return printf('(>= %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_gequalci(node) abort
  return printf('(>=? %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_gequalcs(node) abort
  return printf('(>=# %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_smaller(node) abort
  return printf('(< %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_smallerci(node) abort
  return printf('(<? %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_smallercs(node) abort
  return printf('(<# %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_sequal(node) abort
  return printf('(<= %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_sequalci(node) abort
  return printf('(<=? %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_sequalcs(node) abort
  return printf('(<=# %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_match(node) abort
  return printf('(=~ %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_matchci(node) abort
  return printf('(=~? %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_matchcs(node) abort
  return printf('(=~# %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_nomatch(node) abort
  return printf('(!~ %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_nomatchci(node) abort
  return printf('(!~? %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_nomatchcs(node) abort
  return printf('(!~# %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_is(node) abort
  return printf('(is %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_isci(node) abort
  return printf('(is? %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_iscs(node) abort
  return printf('(is# %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_isnot(node) abort
  return printf('(isnot %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_isnotci(node) abort
  return printf('(isnot? %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_isnotcs(node) abort
  return printf('(isnot# %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_add(node) abort
  return printf('(+ %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_subtract(node) abort
  return printf('(- %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_concat(node) abort
  return printf('(concat %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_multiply(node) abort
  return printf('(* %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_divide(node) abort
  return printf('(/ %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_remainder(node) abort
  return printf('(%% %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_not(node) abort
  return printf('(! %s)', self.compile(a:node.left))
endfunction

function! s:Compiler.compile_plus(node) abort
  return printf('(+ %s)', self.compile(a:node.left))
endfunction

function! s:Compiler.compile_minus(node) abort
  return printf('(- %s)', self.compile(a:node.left))
endfunction

function! s:Compiler.compile_subscript(node) abort
  return printf('(subscript %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_slice(node) abort
  let r0 = a:node.rlist[0] is# s:NIL ? 'nil' : self.compile(a:node.rlist[0])
  let r1 = a:node.rlist[1] is# s:NIL ? 'nil' : self.compile(a:node.rlist[1])
  return printf('(slice %s %s %s)', self.compile(a:node.left), r0, r1)
endfunction

function! s:Compiler.compile_dot(node) abort
  return printf('(dot %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_method(node) abort
  return printf('(method %s %s)', self.compile(a:node.left), self.compile(a:node.right))
endfunction

function! s:Compiler.compile_call(node) abort
  let rlist = map(a:node.rlist, 'self.compile(v:val)')
  if empty(rlist)
    return printf('(%s)', self.compile(a:node.left))
  else
    return printf('(%s %s)', self.compile(a:node.left), join(rlist, ' '))
  endif
endfunction

function! s:Compiler.compile_number(node) abort
  return a:node.value
endfunction

function! s:Compiler.compile_blob(node) abort
  return a:node.value
endfunction

function! s:Compiler.compile_string(node) abort
  return a:node.value
endfunction

function! s:Compiler.compile_list(node) abort
  let value = map(a:node.value, 'self.compile(v:val)')
  if empty(value)
    return '(list)'
  else
    return printf('(list %s)', join(value, ' '))
  endif
endfunction

function! s:Compiler.compile_dict(node) abort
  let value = map(a:node.value, '"(" . self.compile(v:val[0]) . " " . self.compile(v:val[1]) . ")"')
  if empty(value)
    return '(dict)'
  else
    return printf('(dict %s)', join(value, ' '))
  endif
endfunction

function! s:Compiler.compile_option(node) abort
  return a:node.value
endfunction

function! s:Compiler.compile_identifier(node) abort
  return a:node.value
endfunction

function! s:Compiler.compile_curlyname(node) abort
  return join(map(a:node.value, 'self.compile(v:val)'), '')
endfunction

function! s:Compiler.compile_env(node) abort
  return a:node.value
endfunction

function! s:Compiler.compile_reg(node) abort
  return a:node.value
endfunction

function! s:Compiler.compile_curlynamepart(node) abort
  return a:node.value
endfunction

function! s:Compiler.compile_curlynameexpr(node) abort
  return '{' . self.compile(a:node.value) . '}'
endfunction

function! s:Compiler.escape_string(str) abort
  let m = {"\n": '\n', "\t": '\t', "\r": '\r'}
  let out = '"'
  for i in range(len(a:str))
    let c = a:str[i]
    if has_key(m, c)
      let out .= m[c]
    else
      let out .= c
    endif
  endfor
  let out .= '"'
  return out
endfunction

function! s:Compiler.compile_lambda(node) abort
  let rlist = map(a:node.rlist, 'self.compile(v:val)')
  return printf('(lambda (%s) %s)', join(rlist, ' '), self.compile(a:node.left))
endfunction

function! s:Compiler.compile_heredoc(node) abort
  if empty(a:node.rlist)
    let rlist = '(list)'
  else
    let rlist = '(list ' . join(map(a:node.rlist, 'self.escape_string(v:val)'), ' ') . ')'
  endif
  if empty(a:node.body)
    let body = '(list)'
  else
    let body = '(list ' . join(map(a:node.body, 'self.escape_string(v:val)'), ' ') . ')'
  endif
  let op = self.escape_string(a:node.op)
  return printf('(heredoc %s %s %s)', rlist, op, body)
endfunction

" TODO: under construction
let s:RegexpParser = {}

let s:RegexpParser.RE_VERY_NOMAGIC = 1
let s:RegexpParser.RE_NOMAGIC = 2
let s:RegexpParser.RE_MAGIC = 3
let s:RegexpParser.RE_VERY_MAGIC = 4

function! s:RegexpParser.new(...) abort
  let obj = copy(self)
  call call(obj.__init__, a:000, obj)
  return obj
endfunction

function! s:RegexpParser.__init__(reader, cmd, delim) abort
  let self.reader = a:reader
  let self.cmd = a:cmd
  let self.delim = a:delim
  let self.reg_magic = self.RE_MAGIC
endfunction

function! s:RegexpParser.isend(c) abort
  return a:c ==# '<EOF>' || a:c ==# '<EOL>' || a:c ==# self.delim
endfunction

function! s:RegexpParser.parse_regexp() abort
  let prevtoken = ''
  let ntoken = ''
  let ret = []
  if self.reader.peekn(4) ==# '\%#='
    let epos = self.reader.getpos()
    let token = self.reader.getn(5)
    if token !=# '\%#=0' && token !=# '\%#=1' && token !=# '\%#=2'
      throw s:Err('E864: \%#= can only be followed by 0, 1, or 2', epos)
    endif
    call add(ret, token)
  endif
  while !self.isend(self.reader.peek())
    let prevtoken = ntoken
    let [token, ntoken] = self.get_token()
    if ntoken ==# '\m'
      let self.reg_magic = self.RE_MAGIC
    elseif ntoken ==# '\M'
      let self.reg_magic = self.RE_NOMAGIC
    elseif ntoken ==# '\v'
      let self.reg_magic = self.RE_VERY_MAGIC
    elseif ntoken ==# '\V'
      let self.reg_magic = self.RE_VERY_NOMAGIC
    elseif ntoken ==# '\*'
      " '*' is not magic as the very first character.
      if prevtoken ==# '' || prevtoken ==# '\^' || prevtoken ==# '\&' || prevtoken ==# '\|' || prevtoken ==# '\('
        let ntoken = '*'
      endif
    elseif ntoken ==# '\^'
      " '^' is only magic as the very first character.
      if self.reg_magic !=# self.RE_VERY_MAGIC && prevtoken !=# '' && prevtoken !=# '\&' && prevtoken !=# '\|' && prevtoken !=# '\n' && prevtoken !=# '\(' && prevtoken !=# '\%('
        let ntoken = '^'
      endif
    elseif ntoken ==# '\$'
      " '$' is only magic as the very last character
      let pos = self.reader.tell()
      if self.reg_magic !=# self.RE_VERY_MAGIC
        while !self.isend(self.reader.peek())
          let [t, n] = self.get_token()
          " XXX: Vim doesn't check \v and \V?
          if n ==# '\c' || n ==# '\C' || n ==# '\m' || n ==# '\M' || n ==# '\Z'
            continue
          endif
          if n !=# '\|' && n !=# '\&' && n !=# '\n' && n !=# '\)'
            let ntoken = '$'
          endif
          break
        endwhile
      endif
      call self.reader.seek_set(pos)
    elseif ntoken ==# '\?'
      " '?' is literal in '?' command.
      if self.cmd ==# '?'
        let ntoken = '?'
      endif
    endif
    call add(ret, ntoken)
  endwhile
  return ret
endfunction

" @return [actual_token, normalized_token]
function! s:RegexpParser.get_token() abort
  if self.reg_magic ==# self.RE_VERY_MAGIC
    return self.get_token_very_magic()
  elseif self.reg_magic ==# self.RE_MAGIC
    return self.get_token_magic()
  elseif self.reg_magic ==# self.RE_NOMAGIC
    return self.get_token_nomagic()
  elseif self.reg_magic ==# self.RE_VERY_NOMAGIC
    return self.get_token_very_nomagic()
  endif
endfunction

function! s:RegexpParser.get_token_very_magic() abort
  if self.isend(self.reader.peek())
    return ['<END>', '<END>']
  endif
  let c = self.reader.get()
  if c ==# '\'
    return self.get_token_backslash_common()
  elseif c ==# '*'
    return ['*', '\*']
  elseif c ==# '+'
    return ['+', '\+']
  elseif c ==# '='
    return ['=', '\=']
  elseif c ==# '?'
    return ['?', '\?']
  elseif c ==# '{'
    return self.get_token_brace('{')
  elseif c ==# '@'
    return self.get_token_at('@')
  elseif c ==# '^'
    return ['^', '\^']
  elseif c ==# '$'
    return ['$', '\$']
  elseif c ==# '.'
    return ['.', '\.']
  elseif c ==# '<'
    return ['<', '\<']
  elseif c ==# '>'
    return ['>', '\>']
  elseif c ==# '%'
    return self.get_token_percent('%')
  elseif c ==# '['
    return self.get_token_sq('[')
  elseif c ==# '~'
    return ['~', '\~']
  elseif c ==# '|'
    return ['|', '\|']
  elseif c ==# '&'
    return ['&', '\&']
  elseif c ==# '('
    return ['(', '\(']
  elseif c ==# ')'
    return [')', '\)']
  endif
  return [c, c]
endfunction

function! s:RegexpParser.get_token_magic() abort
  if self.isend(self.reader.peek())
    return ['<END>', '<END>']
  endif
  let c = self.reader.get()
  if c ==# '\'
    let pos = self.reader.tell()
    let c = self.reader.get()
    if c ==# '+'
      return ['\+', '\+']
    elseif c ==# '='
      return ['\=', '\=']
    elseif c ==# '?'
      return ['\?', '\?']
    elseif c ==# '{'
      return self.get_token_brace('\{')
    elseif c ==# '@'
      return self.get_token_at('\@')
    elseif c ==# '<'
      return ['\<', '\<']
    elseif c ==# '>'
      return ['\>', '\>']
    elseif c ==# '%'
      return self.get_token_percent('\%')
    elseif c ==# '|'
      return ['\|', '\|']
    elseif c ==# '&'
      return ['\&', '\&']
    elseif c ==# '('
      return ['\(', '\(']
    elseif c ==# ')'
      return ['\)', '\)']
    endif
    call self.reader.seek_set(pos)
    return self.get_token_backslash_common()
  elseif c ==# '*'
    return ['*', '\*']
  elseif c ==# '^'
    return ['^', '\^']
  elseif c ==# '$'
    return ['$', '\$']
  elseif c ==# '.'
    return ['.', '\.']
  elseif c ==# '['
    return self.get_token_sq('[')
  elseif c ==# '~'
    return ['~', '\~']
  endif
  return [c, c]
endfunction

function! s:RegexpParser.get_token_nomagic() abort
  if self.isend(self.reader.peek())
    return ['<END>', '<END>']
  endif
  let c = self.reader.get()
  if c ==# '\'
    let pos = self.reader.tell()
    let c = self.reader.get()
    if c ==# '*'
      return ['\*', '\*']
    elseif c ==# '+'
      return ['\+', '\+']
    elseif c ==# '='
      return ['\=', '\=']
    elseif c ==# '?'
      return ['\?', '\?']
    elseif c ==# '{'
      return self.get_token_brace('\{')
    elseif c ==# '@'
      return self.get_token_at('\@')
    elseif c ==# '.'
      return ['\.', '\.']
    elseif c ==# '<'
      return ['\<', '\<']
    elseif c ==# '>'
      return ['\>', '\>']
    elseif c ==# '%'
      return self.get_token_percent('\%')
    elseif c ==# '~'
      return ['\~', '\^']
    elseif c ==# '['
      return self.get_token_sq('\[')
    elseif c ==# '|'
      return ['\|', '\|']
    elseif c ==# '&'
      return ['\&', '\&']
    elseif c ==# '('
      return ['\(', '\(']
    elseif c ==# ')'
      return ['\)', '\)']
    endif
    call self.reader.seek_set(pos)
    return self.get_token_backslash_common()
  elseif c ==# '^'
    return ['^', '\^']
  elseif c ==# '$'
    return ['$', '\$']
  endif
  return [c, c]
endfunction

function! s:RegexpParser.get_token_very_nomagic() abort
  if self.isend(self.reader.peek())
    return ['<END>', '<END>']
  endif
  let c = self.reader.get()
  if c ==# '\'
    let pos = self.reader.tell()
    let c = self.reader.get()
    if c ==# '*'
      return ['\*', '\*']
    elseif c ==# '+'
      return ['\+', '\+']
    elseif c ==# '='
      return ['\=', '\=']
    elseif c ==# '?'
      return ['\?', '\?']
    elseif c ==# '{'
      return self.get_token_brace('\{')
    elseif c ==# '@'
      return self.get_token_at('\@')
    elseif c ==# '^'
      return ['\^', '\^']
    elseif c ==# '$'
      return ['\$', '\$']
    elseif c ==# '<'
      return ['\<', '\<']
    elseif c ==# '>'
      return ['\>', '\>']
    elseif c ==# '%'
      return self.get_token_percent('\%')
    elseif c ==# '~'
      return ['\~', '\~']
    elseif c ==# '['
      return self.get_token_sq('\[')
    elseif c ==# '|'
      return ['\|', '\|']
    elseif c ==# '&'
      return ['\&', '\&']
    elseif c ==# '('
      return ['\(', '\(']
    elseif c ==# ')'
      return ['\)', '\)']
    endif
    call self.reader.seek_set(pos)
    return self.get_token_backslash_common()
  endif
  return [c, c]
endfunction

function! s:RegexpParser.get_token_backslash_common() abort
  let cclass = 'iIkKfFpPsSdDxXoOwWhHaAlLuU'
  let c = self.reader.get()
  if c ==# '\'
    return ['\\', '\\']
  elseif stridx(cclass, c) !=# -1
    return ['\' . c, '\' . c]
  elseif c ==# '_'
    let epos = self.reader.getpos()
    let c = self.reader.get()
    if stridx(cclass, c) !=# -1
      return ['\_' . c, '\_ . c']
    elseif c ==# '^'
      return ['\_^', '\_^']
    elseif c ==# '$'
      return ['\_$', '\_$']
    elseif c ==# '.'
      return ['\_.', '\_.']
    elseif c ==# '['
      return self.get_token_sq('\_[')
    endif
    throw s:Err('E63: invalid use of \_', epos)
  elseif stridx('etrb', c) !=# -1
    return ['\' . c, '\' . c]
  elseif stridx('123456789', c) !=# -1
    return ['\' . c, '\' . c]
  elseif c ==# 'z'
    let epos = self.reader.getpos()
    let c = self.reader.get()
    if stridx('123456789', c) !=# -1
      return ['\z' . c, '\z' . c]
    elseif c ==# 's'
      return ['\zs', '\zs']
    elseif c ==# 'e'
      return ['\ze', '\ze']
    elseif c ==# '('
      return ['\z(', '\z(']
    endif
    throw s:Err('E68: Invalid character after \z', epos)
  elseif stridx('cCmMvVZ', c) !=# -1
    return ['\' . c, '\' . c]
  elseif c ==# '%'
    let epos = self.reader.getpos()
    let c = self.reader.get()
    if c ==# 'd'
      let r = self.getdecchrs()
      if r !=# ''
        return ['\%d' . r, '\%d' . r]
      endif
    elseif c ==# 'o'
      let r = self.getoctchrs()
      if r !=# ''
        return ['\%o' . r, '\%o' . r]
      endif
    elseif c ==# 'x'
      let r = self.gethexchrs(2)
      if r !=# ''
        return ['\%x' . r, '\%x' . r]
      endif
    elseif c ==# 'u'
      let r = self.gethexchrs(4)
      if r !=# ''
        return ['\%u' . r, '\%u' . r]
      endif
    elseif c ==# 'U'
      let r = self.gethexchrs(8)
      if r !=# ''
        return ['\%U' . r, '\%U' . r]
      endif
    endif
    throw s:Err('E678: Invalid character after \%[dxouU]', epos)
  endif
  return ['\' . c, c]
endfunction

" \{}
function! s:RegexpParser.get_token_brace(pre) abort
  let r = ''
  let minus = ''
  let comma = ''
  let n = ''
  let m = ''
  if self.reader.p(0) ==# '-'
    let minus = self.reader.get()
    let r .= minus
  endif
  if s:isdigit(self.reader.p(0))
    let n = self.reader.read_digit()
    let r .= n
  endif
  if self.reader.p(0) ==# ','
    let comma = self.rader.get()
    let r .= comma
  endif
  if s:isdigit(self.reader.p(0))
    let m = self.reader.read_digit()
    let r .= m
  endif
  if self.reader.p(0) ==# '\'
    let r .= self.reader.get()
  endif
  if self.reader.p(0) !=# '}'
    throw s:Err('E554: Syntax error in \{...}', self.reader.getpos())
  endif
  call self.reader.get()
  return [a:pre . r, '\{' . minus . n . comma . m . '}']
endfunction

" \[]
function! s:RegexpParser.get_token_sq(pre) abort
  let start = self.reader.tell()
  let r = ''
  " Complement of range
  if self.reader.p(0) ==# '^'
    let r .= self.reader.get()
  endif
  " At the start ']' and '-' mean the literal character.
  if self.reader.p(0) ==# ']' || self.reader.p(0) ==# '-'
    let r .= self.reader.get()
  endif
  while s:TRUE
    let startc = 0
    let c = self.reader.p(0)
    if self.isend(c)
      " If there is no matching ']', we assume the '[' is a normal character.
      call self.reader.seek_set(start)
      return [a:pre, '[']
    elseif c ==# ']'
      call self.reader.seek_cur(1)
      return [a:pre . r . ']', '\[' . r . ']']
    elseif c ==# '['
      let e = self.get_token_sq_char_class()
      if e ==# ''
        let e = self.get_token_sq_equi_class()
        if e ==# ''
          let e = self.get_token_sq_coll_element()
          if e ==# ''
            let [e, startc] = self.get_token_sq_c()
          endif
        endif
      endif
      let r .= e
    else
      let [e, startc] = self.get_token_sq_c()
      let r .= e
    endif
    if startc !=# 0 && self.reader.p(0) ==# '-' && !self.isend(self.reader.p(1)) && !(self.reader.p(1) ==# '\' && self.reader.p(2) ==# 'n')
      call self.reader.seek_cur(1)
      let r .= '-'
      let c = self.reader.p(0)
      if c ==# '['
        let e = self.get_token_sq_coll_element()
        if e !=# ''
          let endc = char2nr(e[2])
        else
          let [e, endc] = self.get_token_sq_c()
        endif
        let r .= e
      else
        let [e, endc] = self.get_token_sq_c()
        let r .= e
      endif
      if startc > endc || endc > startc + 256
        throw s:Err('E16: Invalid range', self.reader.getpos())
      endif
    endif
  endwhile
endfunction

" [c]
function! s:RegexpParser.get_token_sq_c() abort
  let c = self.reader.p(0)
  if c ==# '\'
    call self.reader.seek_cur(1)
    let c = self.reader.p(0)
    if c ==# 'n'
      call self.reader.seek_cur(1)
      return ['\n', 0]
    elseif c ==# 'r'
      call self.reader.seek_cur(1)
      return ['\r', 13]
    elseif c ==# 't'
      call self.reader.seek_cur(1)
      return ['\t', 9]
    elseif c ==# 'e'
      call self.reader.seek_cur(1)
      return ['\e', 27]
    elseif c ==# 'b'
      call self.reader.seek_cur(1)
      return ['\b', 8]
    elseif stridx(']^-\', c) !=# -1
      call self.reader.seek_cur(1)
      return ['\' . c, char2nr(c)]
    elseif stridx('doxuU', c) !=# -1
      let [c, n] = self.get_token_sq_coll_char()
      return [c, n]
    else
      return ['\', char2nr('\')]
    endif
  elseif c ==# '-'
    call self.reader.seek_cur(1)
    return ['-', char2nr('-')]
  else
    call self.reader.seek_cur(1)
    return [c, char2nr(c)]
  endif
endfunction

" [\d123]
function! s:RegexpParser.get_token_sq_coll_char() abort
  let pos = self.reader.tell()
  let c = self.reader.get()
  if c ==# 'd'
    let r = self.getdecchrs()
    let n = str2nr(r, 10)
  elseif c ==# 'o'
    let r = self.getoctchrs()
    let n = str2nr(r, 8)
  elseif c ==# 'x'
    let r = self.gethexchrs(2)
    let n = str2nr(r, 16)
  elseif c ==# 'u'
    let r = self.gethexchrs(4)
    let n = str2nr(r, 16)
  elseif c ==# 'U'
    let r = self.gethexchrs(8)
    let n = str2nr(r, 16)
  else
    let r = ''
  endif
  if r ==# ''
    call self.reader.seek_set(pos)
    return '\'
  endif
  return ['\' . c . r, n]
endfunction

" [[.a.]]
function! s:RegexpParser.get_token_sq_coll_element() abort
  if self.reader.p(0) ==# '[' && self.reader.p(1) ==# '.' && !self.isend(self.reader.p(2)) && self.reader.p(3) ==# '.' && self.reader.p(4) ==# ']'
    return self.reader.getn(5)
  endif
  return ''
endfunction

" [[=a=]]
function! s:RegexpParser.get_token_sq_equi_class() abort
  if self.reader.p(0) ==# '[' && self.reader.p(1) ==# '=' && !self.isend(self.reader.p(2)) && self.reader.p(3) ==# '=' && self.reader.p(4) ==# ']'
    return self.reader.getn(5)
  endif
  return ''
endfunction

" [[:alpha:]]
function! s:RegexpParser.get_token_sq_char_class() abort
  let class_names = ['alnum', 'alpha', 'blank', 'cntrl', 'digit', 'graph', 'lower', 'print', 'punct', 'space', 'upper', 'xdigit', 'tab', 'return', 'backspace', 'escape']
  let pos = self.reader.tell()
  if self.reader.p(0) ==# '[' && self.reader.p(1) ==# ':'
    call self.reader.seek_cur(2)
    let r = self.reader.read_alpha()
    if self.reader.p(0) ==# ':' && self.reader.p(1) ==# ']'
      call self.reader.seek_cur(2)
      for name in class_names
        if r ==# name
          return '[:' . name . ':]'
        endif
      endfor
    endif
  endif
  call self.reader.seek_set(pos)
  return ''
endfunction

" \@...
function! s:RegexpParser.get_token_at(pre) abort
  let epos = self.reader.getpos()
  let c = self.reader.get()
  if c ==# '>'
    return [a:pre . '>', '\@>']
  elseif c ==# '='
    return [a:pre . '=', '\@=']
  elseif c ==# '!'
    return [a:pre . '!', '\@!']
  elseif c ==# '<'
    let c = self.reader.get()
    if c ==# '='
      return [a:pre . '<=', '\@<=']
    elseif c ==# '!'
      return [a:pre . '<!', '\@<!']
    endif
  endif
  throw s:Err('E64: @ follows nothing', epos)
endfunction

" \%...
function! s:RegexpParser.get_token_percent(pre) abort
  let c = self.reader.get()
  if c ==# '^'
    return [a:pre . '^', '\%^']
  elseif c ==# '$'
    return [a:pre . '$', '\%$']
  elseif c ==# 'V'
    return [a:pre . 'V', '\%V']
  elseif c ==# '#'
    return [a:pre . '#', '\%#']
  elseif c ==# '['
    return self.get_token_percent_sq(a:pre . '[')
  elseif c ==# '('
    return [a:pre . '(', '\%(']
  else
    return self.get_token_mlcv(a:pre)
  endif
endfunction

" \%[]
function! s:RegexpParser.get_token_percent_sq(pre) abort
  let r = ''
  while s:TRUE
    let c = self.reader.peek()
    if self.isend(c)
      throw s:Err('E69: Missing ] after \%[', self.reader.getpos())
    elseif c ==# ']'
      if r ==# ''
        throw s:Err('E70: Empty \%[', self.reader.getpos())
      endif
      call self.reader.seek_cur(1)
      break
    endif
    call self.reader.seek_cur(1)
    let r .= c
  endwhile
  return [a:pre . r . ']', '\%[' . r . ']']
endfunction

" \%'m \%l \%c \%v
function! s:RegexpParser.get_token_mlvc(pre) abort
  let r = ''
  let cmp = ''
  if self.reader.p(0) ==# '<' || self.reader.p(0) ==# '>'
    let cmp = self.reader.get()
    let r .= cmp
  endif
  if self.reader.p(0) ==# "'"
    let r .= self.reader.get()
    let c = self.reader.p(0)
    if self.isend(c)
      " FIXME: Should be error?  Vim allow this.
      let c = ''
    else
      let c = self.reader.get()
    endif
    return [a:pre . r . c, '\%' . cmp . "'" . c]
  elseif s:isdigit(self.reader.p(0))
    let d = self.reader.read_digit()
    let r .= d
    let c = self.reader.p(0)
    if c ==# 'l'
      call self.reader.get()
      return [a:pre . r . 'l', '\%' . cmp . d . 'l']
    elseif c ==# 'c'
      call self.reader.get()
      return [a:pre . r . 'c', '\%' . cmp . d . 'c']
    elseif c ==# 'v'
      call self.reader.get()
      return [a:pre . r . 'v', '\%' . cmp . d . 'v']
    endif
  endif
  throw s:Err('E71: Invalid character after %', self.reader.getpos())
endfunction

function! s:RegexpParser.getdecchrs() abort
  return self.reader.read_digit()
endfunction

function! s:RegexpParser.getoctchrs() abort
  return self.reader.read_odigit()
endfunction

function! s:RegexpParser.gethexchrs(n) abort
  let r = ''
  for i in range(a:n)
    let c = self.reader.peek()
    if !s:isxdigit(c)
      break
    endif
    let r .= self.reader.get()
  endfor
  return r
endfunction

