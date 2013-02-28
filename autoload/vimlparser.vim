" VimL parser
" License: This file is placed in the public domain.

function vimlparser#import()
  return s:
endfunction

function vimlparser#test(filename)
  try
    let r = s:StringReader.new(readfile(a:filename))
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
let s:NODE_CONDEXP = 34
let s:NODE_LOGOR = 35
let s:NODE_LOGAND = 36
let s:NODE_EQEQQ = 37
let s:NODE_EQEQH = 38
let s:NODE_NOTEQQ = 39
let s:NODE_NOTEQH = 40
let s:NODE_GTEQQ = 41
let s:NODE_GTEQH = 42
let s:NODE_LTEQQ = 43
let s:NODE_LTEQH = 44
let s:NODE_EQTILDQ = 45
let s:NODE_EQTILDH = 46
let s:NODE_NOTTILDQ = 47
let s:NODE_NOTTILDH = 48
let s:NODE_GTQ = 49
let s:NODE_GTH = 50
let s:NODE_LTQ = 51
let s:NODE_LTH = 52
let s:NODE_EQEQ = 53
let s:NODE_NOTEQ = 54
let s:NODE_GTEQ = 55
let s:NODE_LTEQ = 56
let s:NODE_EQTILD = 57
let s:NODE_NOTTILD = 58
let s:NODE_GT = 59
let s:NODE_LT = 60
let s:NODE_ISH = 61
let s:NODE_ISQ = 62
let s:NODE_ISNOTH = 63
let s:NODE_ISNOTQ = 64
let s:NODE_IS = 65
let s:NODE_ISNOT = 66
let s:NODE_ADD = 67
let s:NODE_SUB = 68
let s:NODE_CONCAT = 69
let s:NODE_MUL = 70
let s:NODE_DIV = 71
let s:NODE_MOD = 72
let s:NODE_NOT = 73
let s:NODE_MINUS = 74
let s:NODE_PLUS = 75
let s:NODE_INDEX = 76
let s:NODE_SLICE = 77
let s:NODE_CALL = 78
let s:NODE_DOT = 79
let s:NODE_NUMBER = 80
let s:NODE_STRING = 81
let s:NODE_LIST = 82
let s:NODE_DICT = 83
let s:NODE_NESTING = 84
let s:NODE_OPTION = 85
let s:NODE_IDENTIFIER = 86
let s:NODE_ENV = 87
let s:NODE_REG = 88

let s:TOKEN_EOF = 1
let s:TOKEN_EOL = 2
let s:TOKEN_SPACE = 3
let s:TOKEN_NUMBER = 4
let s:TOKEN_ISH = 5
let s:TOKEN_ISQ = 6
let s:TOKEN_ISNOTH = 7
let s:TOKEN_ISNOTQ = 8
let s:TOKEN_IS = 9
let s:TOKEN_ISNOT = 10
let s:TOKEN_IDENTIFIER = 11
let s:TOKEN_EQEQQ = 12
let s:TOKEN_EQEQH = 13
let s:TOKEN_NOTEQQ = 14
let s:TOKEN_NOTEQH = 15
let s:TOKEN_GTEQQ = 16
let s:TOKEN_GTEQH = 17
let s:TOKEN_LTEQQ = 18
let s:TOKEN_LTEQH = 19
let s:TOKEN_EQTILDQ = 20
let s:TOKEN_EQTILDH = 21
let s:TOKEN_NOTTILDQ = 22
let s:TOKEN_NOTTILDH = 23
let s:TOKEN_GTQ = 24
let s:TOKEN_GTH = 25
let s:TOKEN_LTQ = 26
let s:TOKEN_LTH = 27
let s:TOKEN_OROR = 28
let s:TOKEN_ANDAND = 29
let s:TOKEN_EQEQ = 30
let s:TOKEN_NOTEQ = 31
let s:TOKEN_GTEQ = 32
let s:TOKEN_LTEQ = 33
let s:TOKEN_EQTILD = 34
let s:TOKEN_NOTTILD = 35
let s:TOKEN_GT = 36
let s:TOKEN_LT = 37
let s:TOKEN_PLUS = 38
let s:TOKEN_MINUS = 39
let s:TOKEN_DOT = 40
let s:TOKEN_STAR = 41
let s:TOKEN_SLASH = 42
let s:TOKEN_PER = 43
let s:TOKEN_NOT = 44
let s:TOKEN_QUESTION = 45
let s:TOKEN_COLON = 46
let s:TOKEN_LPAR = 47
let s:TOKEN_RPAR = 48
let s:TOKEN_LBRA = 49
let s:TOKEN_RBRA = 50
let s:TOKEN_LBPAR = 51
let s:TOKEN_RBPAR = 52
let s:TOKEN_COMMA = 53
let s:TOKEN_SQUOTE = 54
let s:TOKEN_DQUOTE = 55
let s:TOKEN_ENV = 56
let s:TOKEN_REG = 57
let s:TOKEN_OPTION = 58
let s:TOKEN_EQ = 59
let s:TOKEN_OR = 60
let s:TOKEN_SEMICOLON = 61
let s:TOKEN_BACKTICK = 62

let s:VimLParser = {}

function s:VimLParser.new(...)
  let obj = copy(self)
  call call(obj.__init__, a:000, obj)
  return obj
endfunction

function s:VimLParser.__init__()
  let self.find_command_cache = {}
endfunction

function s:VimLParser.err(...)
  let pos = self.reader.getpos()
  if len(a:000) == 1
    let msg = a:000[0]
  else
    let msg = call('printf', a:000)
  endif
  return printf('%s: line %d col %d', msg, pos.lnum, pos.col)
endfunction

function s:VimLParser.exnode(type)
  let node = {'type': a:type}
  return node
endfunction

function s:VimLParser.blocknode(type)
  let node = self.exnode(a:type)
  let node.body = []
  return node
endfunction

function s:VimLParser.push_context(node)
  call insert(self.context, a:node)
endfunction

function s:VimLParser.pop_context()
  call remove(self.context, 0)
endfunction

function s:VimLParser.find_context(type)
  let i = 0
  for node in self.context
    if node.type == a:type
      return i
    endif
    let i += 1
  endfor
  return -1
endfunction

function s:VimLParser.add_node(node)
  call add(self.context[0].body, a:node)
endfunction

function s:VimLParser.check_missing_endfunction(ends)
  if self.context[0].type == s:NODE_FUNCTION
    throw self.err('VimLParser: E126: Missing :endfunction:    %s', a:ends)
  endif
endfunction

function s:VimLParser.check_missing_endif(ends)
  if self.context[0].type == s:NODE_IF || self.context[0].type == s:NODE_ELSEIF || self.context[0].type == s:NODE_ELSE
    throw self.err('VimLParser: E171: Missing :endif:    %s', a:ends)
  endif
endfunction

function s:VimLParser.check_missing_endtry(ends)
  if self.context[0].type == s:NODE_TRY || self.context[0].type == s:NODE_CATCH || self.context[0].type == s:NODE_FINALLY
    throw self.err('VimLParser: E600: Missing :endtry:    %s', a:ends)
  endif
endfunction

function s:VimLParser.check_missing_endwhile(ends)
  if self.context[0].type == s:NODE_WHILE
    throw self.err('VimLParser: E170: Missing :endwhile:    %s', a:ends)
  endif
endfunction

function s:VimLParser.check_missing_endfor(ends)
  if self.context[0].type == s:NODE_FOR
    throw self.err('VimLParser: E170: Missing :endfor:    %s', a:ends)
  endif
endfunction

function s:VimLParser.parse(reader)
  let self.reader = a:reader
  let self.context = []
  let toplevel = self.blocknode(s:NODE_TOPLEVEL)
  call self.push_context(toplevel)
  while self.reader.peek() !=# '<EOF>'
    call self.parse_one_cmd()
  endwhile
  call self.check_missing_endfunction('TOPLEVEL')
  call self.check_missing_endif('TOPLEVEL')
  call self.check_missing_endtry('TOPLEVEL')
  call self.check_missing_endwhile('TOPLEVEL')
  call self.check_missing_endfor('TOPLEVEL')
  call self.pop_context()
  return toplevel
endfunction

function s:VimLParser.parse_one_cmd()
  let self.ea = {}
  let self.ea.forceit = 0
  let self.ea.addr_count = 0
  let self.ea.line1 = 0
  let self.ea.line2 = 0
  let self.ea.flags = 0
  let self.ea.do_ecmd_cmd = ''
  let self.ea.do_ecmd_lnum = 0
  let self.ea.append = 0
  let self.ea.usefilter = 0
  let self.ea.amount = 0
  let self.ea.regname = 0
  let self.ea.regname = 0
  let self.ea.force_bin = 0
  let self.ea.read_edit = 0
  let self.ea.force_ff = 0
  let self.ea.force_enc = 0
  let self.ea.bad_char = 0
  let self.ea.linepos = []
  let self.ea.cmdpos = []
  let self.ea.argpos = []
  let self.ea.cmd = {}
  let self.ea.modifiers = []
  let self.ea.range = []
  let self.ea.argopt = {}
  let self.ea.argcmd = {}

  if self.reader.peekn(2) ==# '#!'
    call self.parse_hashbang()
    call self.reader.get()
    return
  endif
  call self.skip_white_and_colon()
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
function s:VimLParser.parse_command_modifiers()
  let modifiers = []
  while 1
    let pos = self.reader.getpos()
    if self.reader.peekn(1) =~# '\d'
      let d = self.read_digits()
      call self.skip_white()
    else
      let d = ''
    endif
    let k = self.read_alpha()
    let c = self.reader.peekn(1)
    call self.skip_white()
    if k =~# '^abo\%[veleft]$'
      call add(modifiers, {'name': 'aboveleft'})
    elseif k =~# '^bel\%[owright]$'
      call add(modifiers, {'name': 'belowright'})
    elseif k =~# '^bro\%[wse]$'
      call add(modifiers, {'name': 'browse'})
    elseif k =~# '^bo\%[tright]$'
      call add(modifiers, {'name': 'botright'})
    elseif k =~# '^conf\%[irm]$'
      call add(modifiers, {'name': 'confirm'})
    elseif k =~# '^kee\%[pmarks]$'
      call add(modifiers, {'name': 'keepmarks'})
    elseif k =~# '^keepa\%[lt]$'
      call add(modifiers, {'name': 'keepalt'})
    elseif k =~# '^keepj\%[umps]$'
      call add(modifiers, {'name': 'keepjumps'})
    elseif k =~# '^hid\%[e]$'
      if self.ends_excmds(c)
        break
      endif
      call add(modifiers, {'name': 'hide'})
    elseif k =~# '^loc\%[kmarks]$'
      call add(modifiers, {'name': 'lockmarks'})
    elseif k =~# '^lefta\%[bove]$'
      call add(modifiers, {'name': 'leftabove'})
    elseif k =~# '^noa\%[utocmd]$'
      call add(modifiers, {'name': 'noautocmd'})
    elseif k =~# '^rightb\%[elow]$'
      call add(modifiers, {'name': 'rightbelow'})
    elseif k =~# '^san\%[dbox]$'
      call add(modifiers, {'name': 'sandbox'})
    elseif k =~# '^sil\%[ent]$'
      if c ==# '!'
        call self.reader.get()
        call add(modifiers, {'name': 'silent', 'bang': 1})
      else
        call add(modifiers, {'name': 'silent', 'bang': 0})
      endif
    elseif k =~# '^tab$'
      if d !=# ''
        call add(modifiers, {'name': 'tab', 'count': str2nr(d, 10)})
      else
        call add(modifiers, {'name': 'tab'})
      endif
    elseif k =~# '^to\%[pleft]$'
      call add(modifiers, {'name': 'topleft'})
    elseif k =~# '^uns\%[ilent]$'
      call add(modifiers, {'name': 'unsilent'})
    elseif k =~# '^vert\%[ical]$'
      call add(modifiers, {'name': 'vertical'})
    elseif k =~# '^verb\%[ose]$'
      if d !=# ''
        call add(modifiers, {'name': 'verbose', 'count': str2nr(d, 10)})
      else
        call add(modifiers, {'name': 'verbose', 'count': 1})
      endif
    else
      call self.reader.setpos(pos)
      break
    endif
  endwhile
  let self.ea.modifiers = modifiers
endfunction

" FIXME:
function s:VimLParser.parse_range()
  let tokens = []

  while 1

    while 1
      call self.skip_white()

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
        call self.reader.getn(1)
        let m = self.reader.getn(1)
        if m ==# '&' || m ==# '?' || m ==# '/'
          call add(tokens, '\' . m)
        else
          throw self.err('VimLParser: E10: \\ should be followed by /, ? or &')
        endif
      elseif c =~# '\d'
        call add(tokens, self.read_digits())
      endif

      while 1
        call self.skip_white()
        if self.reader.peekn(1) ==# ''
          break
        endif
        let n = self.read_integer()
        if n ==# ''
          break
        endif
        call add(tokens, n)
      endwhile

      if self.reader.peekn(1) !~# '[/?]'
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
function s:VimLParser.parse_pattern(delimiter)
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
      let c = self.reader.getn(1)
      if c ==# ''
        throw self.err('VimLParser: E682: Invalid search pattern or delimiter')
      endif
      let pattern .= c
    elseif c ==# '['
      let inbracket += 1
    elseif c ==# ']'
      let inbracket -= 1
    endif
  endwhile
  return [pattern, endc]
endfunction

function s:VimLParser.parse_command()
  call self.skip_white_and_colon()

  if self.reader.peekn(1) ==# '' || self.reader.peekn(1) ==# '"'
    if !empty(self.ea.modifiers) || !empty(self.ea.range)
      call self.parse_cmd_modifier_range()
    endif
    return
  endif

  let self.ea.cmdpos = self.reader.getpos()

  let self.ea.cmd = self.find_command()

  if self.ea.cmd is s:NIL
    call self.reader.setpos(self.ea.cmdpos)
    throw self.err('VimLParser: E492: Not an editor command: %s', self.reader.peekline())
  endif

  if self.reader.peekn(1) ==# '!' && self.ea.cmd.name !~# '\v^%(substitute|smagic|snomagic)$'
    call self.reader.getn(1)
    let self.ea.forceit = 1
  else
    let self.ea.forceit = 0
  endif

  if self.ea.cmd.flags !~# '\<BANG\>' && self.ea.forceit
    throw self.err('VimLParser: E477: No ! allowed')
  endif

  if self.ea.cmd.name !=# '!'
    call self.skip_white()
  endif

  let self.ea.argpos = self.reader.getpos()

  if self.ea.cmd.flags =~# '\<ARGOPT\>'
    call self.parse_argopt()
  endif

  if self.ea.cmd.name =~# '\v^%(write|update)$'
    if self.reader.peekn(1) ==# '>'
      call self.reader.getn(1)
      if self.reader.peekn(1) ==# '>'
        throw self.err('VimLParser: E494: Use w or w>>')
      endif
      call self.skip_white()
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

  if self.ea.cmd.name =~# '^[<>]$'
    let self.ea.amount = 1
    while self.reader.peekn(1) ==# self.ea.cmd.name
      call self.reader.getn(1)
      let self.ea.amount += 1
    endwhile
    call self.skip_white()
  endif

  if self.ea.cmd.flags =~# '\<EDITCMD\>' && !self.ea.usefilter
    call self.parse_argcmd()
  endif

  call self[self.ea.cmd.parser]()
endfunction

function s:VimLParser.find_command()
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
    let name = self.read_alnum()
  else
    let pos = self.reader.getpos()
    let name = self.read_alpha()
    if name !=# 'del' && name =~# '\v^d%[elete][lp]$'
      call self.reader.setpos(pos)
      let name = self.reader.getn(len(name) - 1)
    endif
  endif

  if has_key(self.find_command_cache, name)
    return self.find_command_cache[name]
  endif

  let cmd = s:NIL

  for x in self.builtin_commands
    if name =~# x.pat
      unlet cmd
      let cmd = x
      break
    endif
  endfor

  " FIXME: user defined command
  if (cmd is s:NIL || cmd.name ==# 'Print') && name =~# '^[A-Z]'
    let name .= self.read_alnum()
    unlet cmd
    let cmd = {'name': name, 'flags': 'USERCMD', 'parser': 'parse_cmd_usercmd'}
  endif

  let self.find_command_cache[name] = cmd

  return cmd
endfunction

" TODO:
function s:VimLParser.parse_hashbang()
  call self.reader.getn(-1)
endfunction

" TODO:
" ++opt=val
function s:VimLParser.parse_argopt()
  while 1
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
      let self.ea.force_ff = self.read_alpha()
    elseif s =~# '^++fileformat=\(dos\|unix\|mac\)\>'
      call self.reader.getn(13)
      let self.ea.force_ff = self.read_alpha()
    elseif s =~# '^++enc=\S'
      call self.reader.getn(6)
      let self.ea.force_enc = self.readx('\S')
    elseif s =~# '^++encoding=\S'
      call self.reader.getn(11)
      let self.ea.force_enc = self.readx('\S')
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
    call self.skip_white()
  endwhile
endfunction

" TODO:
" +command
function s:VimLParser.parse_argcmd()
  if self.reader.peekn(1) ==# '+'
    call self.reader.getn(1)
    if self.reader.peekn(1) ==# ' '
      let self.ea.do_ecmd_cmd = '$'
    else
      let self.ea.do_ecmd_cmd = self.read_cmdarg()
    endif
  endif
endfunction

function s:VimLParser.read_cmdarg()
  let r = ''
  while 1
    let c = self.reader.peekn(1)
    if c ==# '' || c =~# '\s'
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

function s:VimLParser.parse_comment()
  let c = self.reader.get()
  if c !=# '"'
    throw self.err('VimLParser: unexpected character: %s', c)
  endif
  let node = self.exnode(s:NODE_COMMENT)
  let node.str = self.reader.getn(-1)
  call self.add_node(node)
endfunction

function s:VimLParser.parse_trail()
  call self.skip_white()
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
    throw self.err('VimLParser: E488: Trailing characters: %s', c)
  endif
endfunction

" modifier or range only command line
function s:VimLParser.parse_cmd_modifier_range()
  let node = self.exnode(s:NODE_EXCMD)
  let node.ea = self.ea
  let node.str = self.reader.getstr(self.ea.linepos, self.reader.getpos())
  call self.add_node(node)
endfunction

" TODO:
function s:VimLParser.parse_cmd_common()
  if self.ea.cmd.flags =~# '\<TRLBAR\>' && !self.ea.usefilter
    let end = self.separate_nextcmd()
  elseif self.ea.cmd.name =~# '^\(!\|global\|vglobal\)$' || self.ea.usefilter
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
  let node = self.exnode(s:NODE_EXCMD)
  let node.ea = self.ea
  let node.str = self.reader.getstr(self.ea.linepos, end)
  call self.add_node(node)
endfunction

function s:VimLParser.separate_nextcmd()
  if self.ea.cmd.name =~# '^\(vimgrep\|vimgrepadd\|lvimgrep\|lvimgrepadd\)$'
    call self.skip_vimgrep_pat()
  endif
  let pc = ''
  let end = self.reader.getpos()
  let nospend = end
  while 1
    let end = self.reader.getpos()
    if pc !~# '\s'
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
      let c = self.reader.getn(1)
      if c !=# '`'
        throw self.err('VimLParser: unexpected character: %s', c)
      endif
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
function s:VimLParser.skip_vimgrep_pat()
  if self.reader.peekn(1) ==# ''
    " pass
  elseif self.isidc(self.reader.peekn(1))
    " :vimgrep pattern fname
    call self.readx('\S')
  else
    " :vimgrep /pattern/[g][j] fname
    let c = self.reader.getn(1)
    let [pattern, endc] = self.parse_pattern(c)
    if c !=# endc
      return
    endif
    while self.reader.peekn(1) =~# '[gj]'
      call self.reader.getn(1)
    endwhile
  endif
endfunction

function s:VimLParser.parse_cmd_append()
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
  let node = self.exnode(s:NODE_EXCMD)
  let node.ea = self.ea
  let node.str = join(lines, "\n")
  call self.add_node(node)
endfunction

function s:VimLParser.parse_cmd_insert()
  return self.parse_cmd_append()
endfunction

function s:VimLParser.parse_cmd_loadkeymap()
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
  let node = self.exnode(s:NODE_EXCMD)
  let node.ea = self.ea
  let node.str = join(lines, "\n")
  call self.add_node(node)
endfunction

function s:VimLParser.parse_cmd_lua()
  call self.skip_white()
  if self.reader.peekn(2) ==# '<<'
    call self.reader.getn(2)
    call self.skip_white()
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
  let node = self.exnode(s:NODE_EXCMD)
  let node.ea = self.ea
  let node.str = join(lines, "\n")
  call self.add_node(node)
endfunction

function s:VimLParser.parse_cmd_mzscheme()
  return self.parse_cmd_lua()
endfunction

function s:VimLParser.parse_cmd_perl()
  return self.parse_cmd_lua()
endfunction

function s:VimLParser.parse_cmd_python()
  return self.parse_cmd_lua()
endfunction

function s:VimLParser.parse_cmd_python3()
  return self.parse_cmd_lua()
endfunction

function s:VimLParser.parse_cmd_ruby()
  return self.parse_cmd_lua()
endfunction

function s:VimLParser.parse_cmd_tcl()
  return self.parse_cmd_lua()
endfunction

function s:VimLParser.parse_cmd_finish()
  call self.parse_cmd_common()
  if self.context[0].type == s:NODE_TOPLEVEL
    while self.reader.peek() !=# '<EOF>'
      call self.reader.get()
    endwhile
  endif
endfunction

" FIXME
function s:VimLParser.parse_cmd_usercmd()
  return self.parse_cmd_common()
endfunction

function s:VimLParser.parse_cmd_function()
  let pos = self.reader.getpos()
  call self.skip_white()

  " :function
  if self.ends_excmds(self.reader.peek())
    call self.reader.setpos(pos)
    return self.parse_cmd_common()
  endif

  " :function /pattern
  if self.reader.peekn(1) ==# '/'
    call self.reader.setpos(pos)
    return self.parse_cmd_common()
  endif

  let name = self.parse_lvalue()
  call self.skip_white()

  " :function {name}
  if self.reader.peekn(1) !=# '('
    call self.reader.setpos(pos)
    return self.parse_cmd_common()
  endif

  " :function[!] {name}([arguments]) [range] [abort] [dict]
  let node = self.blocknode(s:NODE_FUNCTION)
  let node.ea = self.ea
  let node.name = name
  let node.args = []
  let node.attr = {'range': 0, 'abort': 0, 'dict': 0}
  let node.endfunction = s:NIL
  call self.reader.getn(1)
  let c = self.reader.peekn(1)
  if c ==# ')'
    call self.reader.getn(1)
  else
    while 1
      call self.skip_white()
      if self.reader.peekn(1) =~# '\h'
        let arg = self.readx('\w')
        call add(node.args, arg)
        call self.skip_white()
        let c = self.reader.peekn(1)
        if c ==# ','
          call self.reader.getn(1)
          continue
        elseif c ==# ')'
          call self.reader.getn(1)
          break
        else
          throw self.err('VimLParser: unexpected characters: %s', c)
        endif
      elseif self.reader.peekn(3) ==# '...'
        call self.reader.getn(3)
        call add(node.args, '...')
        call self.skip_white()
        let c = self.reader.peekn(1)
        if c ==# ')'
          call self.reader.getn(1)
          break
        else
          throw self.err('VimLParser: unexpected characters: %s', c)
        endif
      else
        throw self.err('VimLParser: unexpected characters: %s', c)
      endif
    endwhile
  endif
  while 1
    call self.skip_white()
    let key = self.read_alpha()
    if key ==# ''
      break
    elseif key ==# 'range'
      let node.attr.range = 1
    elseif key ==# 'abort'
      let node.attr.abort = 1
    elseif key ==# 'dict'
      let node.attr.dict = 1
    else
      throw self.err('VimLParser: unexpected token: %s', key)
    endif
  endwhile
  call self.add_node(node)
  call self.push_context(node)
endfunction

function s:VimLParser.parse_cmd_endfunction()
  call self.check_missing_endif('ENDFUNCTION')
  call self.check_missing_endtry('ENDFUNCTION')
  call self.check_missing_endwhile('ENDFUNCTION')
  call self.check_missing_endfor('ENDFUNCTION')
  if self.context[0].type != s:NODE_FUNCTION
    throw self.err('VimLParser: E193: :endfunction not inside a function')
  endif
  call self.reader.getn(-1)
  let node = self.exnode(s:NODE_ENDFUNCTION)
  let node.ea = self.ea
  let self.context[0].endfunction = node
  call self.pop_context()
endfunction

function s:VimLParser.parse_cmd_delfunction()
  let node = self.exnode(s:NODE_DELFUNCTION)
  let node.ea = self.ea
  let node.name = self.parse_lvalue()
  call self.add_node(node)
endfunction

function s:VimLParser.parse_cmd_return()
  if self.find_context(s:NODE_FUNCTION) == -1
    throw self.err('VimLParser: E133: :return not inside a function')
  endif
  let node = self.exnode(s:NODE_RETURN)
  let node.ea = self.ea
  let node.arg = s:NIL
  call self.skip_white()
  let c = self.reader.peek()
  if !self.ends_excmds(c)
    let node.arg = self.parse_expr()
  endif
  call self.add_node(node)
endfunction

function s:VimLParser.parse_cmd_call()
  let node = self.exnode(s:NODE_EXCALL)
  let node.ea = self.ea
  let node.expr = s:NIL
  call self.skip_white()
  let c = self.reader.peek()
  if self.ends_excmds(c)
    throw self.err('VimLParser: call error: %s', c)
  endif
  let node.expr = self.parse_expr()
  if node.expr.type != s:NODE_CALL
    throw self.err('VimLParser: call error: %s', node.expr.type)
  endif
  call self.add_node(node)
endfunction

function s:VimLParser.parse_cmd_let()
  let pos = self.reader.getpos()
  call self.skip_white()

  " :let
  if self.ends_excmds(self.reader.peek())
    call self.reader.setpos(pos)
    return self.parse_cmd_common()
  endif

  let lhs = self.parse_letlhs()
  call self.skip_white()
  let s1 = self.reader.peekn(1)
  let s2 = self.reader.peekn(2)

  " :let {var-name} ..
  if self.ends_excmds(s1) || (s2 !=# '+=' && s2 !=# '-=' && s2 !=# '.=' && s1 !=# '=')
    call self.reader.setpos(pos)
    return self.parse_cmd_common()
  endif

  " :let lhs op rhs
  let node = self.exnode(s:NODE_LET)
  let node.ea = self.ea
  let node.op = ''
  let node.lhs = lhs
  let node.rhs = s:NIL
  if s2 ==# '+=' || s2 ==# '-=' || s2 ==# '.='
    call self.reader.getn(2)
    let node.op = s2
  elseif s1 ==# '='
    call self.reader.getn(1)
    let node.op = s1
  else
    throw 'NOT REACHED'
  endif
  let node.rhs = self.parse_expr()
  call self.add_node(node)
endfunction

function s:VimLParser.parse_cmd_unlet()
  let node = self.exnode(s:NODE_UNLET)
  let node.ea = self.ea
  let node.args = self.parse_lvaluelist()
  call self.add_node(node)
endfunction

function s:VimLParser.parse_cmd_lockvar()
  let node = self.exnode(s:NODE_LOCKVAR)
  let node.ea = self.ea
  let node.depth = 2
  let node.args = []
  call self.skip_white()
  if self.reader.peekn(1) =~# '\d'
    let node.depth = str2nr(self.read_digits(), 10)
  endif
  let node.args = self.parse_lvaluelist()
  call self.add_node(node)
endfunction

function s:VimLParser.parse_cmd_unlockvar()
  let node = self.exnode(s:NODE_UNLOCKVAR)
  let node.ea = self.ea
  let node.depth = 2
  let node.args = []
  call self.skip_white()
  if self.reader.peekn(1) =~# '\d'
    let node.depth = str2nr(self.read_digits(), 10)
  endif
  let node.args = self.parse_lvaluelist()
  call self.add_node(node)
endfunction

function s:VimLParser.parse_cmd_if()
  let node = self.blocknode(s:NODE_IF)
  let node.ea = self.ea
  let node.cond = self.parse_expr()
  let node.elseif = []
  let node.else = s:NIL
  let node.endif = s:NIL
  call self.add_node(node)
  call self.push_context(node)
endfunction

function s:VimLParser.parse_cmd_elseif()
  if self.context[0].type != s:NODE_IF && self.context[0].type != s:NODE_ELSEIF
    throw self.err('VimLParser: E582: :elseif without :if')
  endif
  if self.context[0].type != s:NODE_IF
    call self.pop_context()
  endif
  let node = self.blocknode(s:NODE_ELSEIF)
  let node.ea = self.ea
  let node.cond = self.parse_expr()
  call add(self.context[0].elseif, node)
  call self.push_context(node)
endfunction

function s:VimLParser.parse_cmd_else()
  if self.context[0].type != s:NODE_IF && self.context[0].type != s:NODE_ELSEIF
    throw self.err('VimLParser: E581: :else without :if')
  endif
  if self.context[0].type != s:NODE_IF
    call self.pop_context()
  endif
  let node = self.blocknode(s:NODE_ELSE)
  let node.ea = self.ea
  let self.context[0].else = node
  call self.push_context(node)
endfunction

function s:VimLParser.parse_cmd_endif()
  if self.context[0].type != s:NODE_IF && self.context[0].type != s:NODE_ELSEIF && self.context[0].type != s:NODE_ELSE
    throw self.err('VimLParser: E580: :endif without :if')
  endif
  if self.context[0].type != s:NODE_IF
    call self.pop_context()
  endif
  let node = self.exnode(s:NODE_ENDIF)
  let node.ea = self.ea
  let self.context[0].endif = node
  call self.pop_context()
endfunction

function s:VimLParser.parse_cmd_while()
  let node = self.blocknode(s:NODE_WHILE)
  let node.ea = self.ea
  let node.cond = self.parse_expr()
  let node.endwhile = s:NIL
  call self.add_node(node)
  call self.push_context(node)
endfunction

function s:VimLParser.parse_cmd_endwhile()
  if self.context[0].type != s:NODE_WHILE
    throw self.err('VimLParser: E588: :endwhile without :while')
  endif
  let node = self.exnode(s:NODE_ENDWHILE)
  let node.ea = self.ea
  let self.context[0].endwhile = node
  call self.pop_context()
endfunction

function s:VimLParser.parse_cmd_for()
  let node = self.blocknode(s:NODE_FOR)
  let node.ea = self.ea
  let node.lhs = s:NIL
  let node.rhs = s:NIL
  let node.endfor = s:NIL
  let node.lhs = self.parse_letlhs()
  call self.skip_white()
  if self.read_alpha() !=# 'in'
    throw self.err('VimLParser: Missing "in" after :for')
  endif
  let node.rhs = self.parse_expr()
  call self.add_node(node)
  call self.push_context(node)
endfunction

function s:VimLParser.parse_cmd_endfor()
  if self.context[0].type != s:NODE_FOR
    throw self.err('VimLParser: E588: :endfor without :for')
  endif
  let node = self.exnode(s:NODE_ENDFOR)
  let node.ea = self.ea
  let self.context[0].endfor = node
  call self.pop_context()
endfunction

function s:VimLParser.parse_cmd_continue()
  if self.find_context(s:NODE_WHILE) == -1 && self.find_context(s:NODE_FOR) == -1
    throw self.err('VimLParser: E586: :continue without :while or :for')
  endif
  let node = self.exnode(s:NODE_CONTINUE)
  let node.ea = self.ea
  call self.add_node(node)
endfunction

function s:VimLParser.parse_cmd_break()
  if self.find_context(s:NODE_WHILE) == -1 && self.find_context(s:NODE_FOR) == -1
    throw self.err('VimLParser: E587: :break without :while or :for')
  endif
  let node = self.exnode(s:NODE_BREAK)
  let node.ea = self.ea
  call self.add_node(node)
endfunction

function s:VimLParser.parse_cmd_try()
  let node = self.blocknode(s:NODE_TRY)
  let node.ea = self.ea
  let node.catch = []
  let node.finally = s:NIL
  let node.endtry = s:NIL
  call self.add_node(node)
  call self.push_context(node)
endfunction

function s:VimLParser.parse_cmd_catch()
  if self.context[0].type == s:NODE_FINALLY
    throw self.err('VimLParser: E604: :catch after :finally')
  elseif self.context[0].type != s:NODE_TRY && self.context[0].type != s:NODE_CATCH
    throw self.err('VimLParser: E603: :catch without :try')
  endif
  if self.context[0].type != s:NODE_TRY
    call self.pop_context()
  endif
  let node = self.blocknode(s:NODE_CATCH)
  let node.ea = self.ea
  let node.pattern = s:NIL
  call self.skip_white()
  if !self.ends_excmds(self.reader.peek())
    let [node.pattern, endc] = self.parse_pattern(self.reader.get())
  endif
  call add(self.context[0].catch, node)
  call self.push_context(node)
endfunction

function s:VimLParser.parse_cmd_finally()
  if self.context[0].type != s:NODE_TRY && self.context[0].type != s:NODE_CATCH
    throw self.err('VimLParser: E606: :finally without :try')
  endif
  if self.context[0].type != s:NODE_TRY
    call self.pop_context()
  endif
  let node = self.blocknode(s:NODE_FINALLY)
  let node.ea = self.ea
  let self.context[0].finally = node
  call self.push_context(node)
endfunction

function s:VimLParser.parse_cmd_endtry()
  if self.context[0].type != s:NODE_TRY && self.context[0].type != s:NODE_CATCH && self.context[0].type != s:NODE_FINALLY
    throw self.err('VimLParser: E602: :endtry without :try')
  endif
  if self.context[0].type != s:NODE_TRY
    call self.pop_context()
  endif
  let node = self.exnode(s:NODE_ENDTRY)
  let node.ea = self.ea
  let self.context[0].endtry = node
  call self.pop_context()
endfunction

function s:VimLParser.parse_cmd_throw()
  let node = self.exnode(s:NODE_THROW)
  let node.ea = self.ea
  let node.arg = self.parse_expr()
  call self.add_node(node)
endfunction

function s:VimLParser.parse_cmd_echo()
  let node = self.exnode(s:NODE_ECHO)
  let node.ea = self.ea
  let node.args = self.parse_exprlist()
  call self.add_node(node)
endfunction

function s:VimLParser.parse_cmd_echon()
  let node = self.exnode(s:NODE_ECHON)
  let node.ea = self.ea
  let node.args = self.parse_exprlist()
  call self.add_node(node)
endfunction

function s:VimLParser.parse_cmd_echohl()
  let node = self.exnode(s:NODE_ECHOHL)
  let node.ea = self.ea
  let node.name = ''
  while !self.ends_excmds(self.reader.peek())
    let node.name .= self.reader.get()
  endwhile
  call self.add_node(node)
endfunction

function s:VimLParser.parse_cmd_echomsg()
  let node = self.exnode(s:NODE_ECHOMSG)
  let node.ea = self.ea
  let node.args = self.parse_exprlist()
  call self.add_node(node)
endfunction

function s:VimLParser.parse_cmd_echoerr()
  let node = self.exnode(s:NODE_ECHOERR)
  let node.ea = self.ea
  let node.args = self.parse_exprlist()
  call self.add_node(node)
endfunction

function s:VimLParser.parse_cmd_execute()
  let node = self.exnode(s:NODE_EXECUTE)
  let node.ea = self.ea
  let node.args = self.parse_exprlist()
  call self.add_node(node)
endfunction

function s:VimLParser.parse_expr()
  return s:ExprParser.new(s:ExprTokenizer.new(self.reader)).parse()
endfunction

function s:VimLParser.parse_exprlist()
  let args = []
  while 1
    call self.skip_white()
    let c = self.reader.peek()
    if c !=# '"' && self.ends_excmds(c)
      break
    endif
    let node = self.parse_expr()
    call add(args, node)
  endwhile
  return args
endfunction

" FIXME:
function s:VimLParser.parse_lvalue()
  let p = s:LvalueParser.new(s:ExprTokenizer.new(self.reader))
  let node = p.parse()
  if node.type == s:NODE_IDENTIFIER || node.type == s:NODE_INDEX || node.type == s:NODE_DOT || node.type == s:NODE_OPTION || node.type == s:NODE_ENV || node.type == s:NODE_REG
    return node
  endif
  throw self.err('VimLParser: lvalue error: %s', node.value)
endfunction

function s:VimLParser.parse_lvaluelist()
  let args = []
  let node = self.parse_expr()
  call add(args, node)
  while 1
    call self.skip_white()
    if self.ends_excmds(self.reader.peek())
      break
    endif
    let node = self.parse_lvalue()
    call add(args, node)
  endwhile
  return args
endfunction

" FIXME:
function s:VimLParser.parse_letlhs()
  let values = {'args': [], 'rest': s:NIL}
  let tokenizer = s:ExprTokenizer.new(self.reader)
  if tokenizer.peek().type == s:TOKEN_LBRA
    call tokenizer.get()
    while 1
      let node = self.parse_lvalue()
      call add(values.args, node)
      if tokenizer.peek().type == s:TOKEN_RBRA
        call tokenizer.get()
        break
      elseif tokenizer.peek().type == s:TOKEN_COMMA
        call tokenizer.get()
        continue
      elseif tokenizer.peek().type == s:TOKEN_SEMICOLON
        call tokenizer.get()
        let node = self.parse_lvalue()
        let values.rest = node
        let token = tokenizer.peek()
        if token.type == s:TOKEN_RBRA
          call tokenizer.get()
          break
        else
          throw self.err('VimLParser: E475 Invalid argument: %s', token.value)
        endif
      else
        throw self.err('VimLParser: E475 Invalid argument: %s', token.value)
      endif
    endwhile
  else
    let node = self.parse_lvalue()
    call add(values.args, node)
  endif
  return values
endfunction

function s:VimLParser.readx(pat)
  let r = ''
  while self.reader.peekn(1) =~# a:pat
    let r .= self.reader.getn(1)
  endwhile
  return r
endfunction

function s:VimLParser.read_alpha()
  return self.readx('\a')
endfunction

function s:VimLParser.read_digits()
  return self.readx('\d')
endfunction

function s:VimLParser.read_integer()
  if self.reader.peekn(1) =~# '[-+]'
    let c = self.reader.getn(1)
  else
    let c = ''
  endif
  return c . self.read_digits()
endfunction

function s:VimLParser.read_alnum()
  return self.readx('[0-9a-zA-Z]')
endfunction

function s:VimLParser.skip_white()
  call self.readx('\s')
endfunction

function s:VimLParser.skip_white_and_colon()
  call self.readx(':\|\s')
endfunction

function s:VimLParser.ends_excmds(c)
  return a:c ==# '' || a:c ==# '|' || a:c ==# '"' || a:c ==# '<EOF>' || a:c ==# '<EOL>'
endfunction

" FIXME:
function s:VimLParser.isidc(c)
  return a:c =~# '[0-9A-Za-z_]'
endfunction

let s:VimLParser.builtin_commands = [
      \ {'name': 'append', 'pat': '^a\%[ppend]$', 'flags': 'BANG|RANGE|ZEROR|TRLBAR|CMDWIN|MODIFY', 'parser': 'parse_cmd_append'},
      \ {'name': 'abbreviate', 'pat': '^ab\%[breviate]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'abclear', 'pat': '^abc\%[lear]$', 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'aboveleft', 'pat': '^abo\%[veleft]$', 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'all', 'pat': '^al\%[l]$', 'flags': 'BANG|RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'amenu', 'pat': '^am\%[enu]$', 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'anoremenu', 'pat': '^an\%[oremenu]$', 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'args', 'pat': '^ar\%[gs]$', 'flags': 'BANG|FILES|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'argadd', 'pat': '^arga\%[dd]$', 'flags': 'BANG|NEEDARG|RANGE|NOTADR|ZEROR|FILES|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'argdelete', 'pat': '^argd\%[elete]$', 'flags': 'BANG|RANGE|NOTADR|FILES|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'argedit', 'pat': '^arge\%[dit]$', 'flags': 'BANG|NEEDARG|RANGE|NOTADR|FILE1|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'argdo', 'pat': '^argdo$', 'flags': 'BANG|NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'argglobal', 'pat': '^argg\%[lobal]$', 'flags': 'BANG|FILES|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'arglocal', 'pat': '^argl\%[ocal]$', 'flags': 'BANG|FILES|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'argument', 'pat': '^argu\%[ment]$', 'flags': 'BANG|RANGE|NOTADR|COUNT|EXTRA|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'ascii', 'pat': '^as\%[cii]$', 'flags': 'TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'autocmd', 'pat': '^au\%[tocmd]$', 'flags': 'BANG|EXTRA|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'augroup', 'pat': '^aug\%[roup]$', 'flags': 'BANG|WORD1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'aunmenu', 'pat': '^aun\%[menu]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'buffer', 'pat': '^b\%[uffer]$', 'flags': 'BANG|RANGE|NOTADR|BUFNAME|BUFUNL|COUNT|EXTRA|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'bNext', 'pat': '^bN\%[ext]$', 'flags': 'BANG|RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'ball', 'pat': '^ba\%[ll]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'badd', 'pat': '^bad\%[d]$', 'flags': 'NEEDARG|FILE1|EDITCMD|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'bdelete', 'pat': '^bd\%[elete]$', 'flags': 'BANG|RANGE|NOTADR|BUFNAME|COUNT|EXTRA|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'behave', 'pat': '^be\%[have]$', 'flags': 'NEEDARG|WORD1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'belowright', 'pat': '^bel\%[owright]$', 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'bfirst', 'pat': '^bf\%[irst]$', 'flags': 'BANG|RANGE|NOTADR|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'blast', 'pat': '^bl\%[ast]$', 'flags': 'BANG|RANGE|NOTADR|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'bmodified', 'pat': '^bm\%[odified]$', 'flags': 'BANG|RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'bnext', 'pat': '^bn\%[ext]$', 'flags': 'BANG|RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'botright', 'pat': '^bo\%[tright]$', 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'bprevious', 'pat': '^bp\%[revious]$', 'flags': 'BANG|RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'brewind', 'pat': '^br\%[ewind]$', 'flags': 'BANG|RANGE|NOTADR|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'break', 'pat': '^brea\%[k]$', 'flags': 'TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_break'},
      \ {'name': 'breakadd', 'pat': '^breaka\%[dd]$', 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'breakdel', 'pat': '^breakd\%[el]$', 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'breaklist', 'pat': '^breakl\%[ist]$', 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'browse', 'pat': '^bro\%[wse]$', 'flags': 'NEEDARG|EXTRA|NOTRLCOM|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'bufdo', 'pat': '^bufdo$', 'flags': 'BANG|NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'buffers', 'pat': '^buffers$', 'flags': 'BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'bunload', 'pat': '^bun\%[load]$', 'flags': 'BANG|RANGE|NOTADR|BUFNAME|COUNT|EXTRA|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'bwipeout', 'pat': '^bw\%[ipeout]$', 'flags': 'BANG|RANGE|NOTADR|BUFNAME|BUFUNL|COUNT|EXTRA|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'change', 'pat': '^c\%[hange]$', 'flags': 'BANG|WHOLEFOLD|RANGE|COUNT|TRLBAR|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'cNext', 'pat': '^cN\%[ext]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'cNfile', 'pat': '^cNf\%[ile]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'cabbrev', 'pat': '^ca\%[bbrev]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'cabclear', 'pat': '^cabc\%[lear]$', 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'caddbuffer', 'pat': '^caddb\%[uffer]$', 'flags': 'RANGE|NOTADR|WORD1|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'caddexpr', 'pat': '^cad\%[dexpr]$', 'flags': 'NEEDARG|WORD1|NOTRLCOM|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'caddfile', 'pat': '^caddf\%[ile]$', 'flags': 'TRLBAR|FILE1', 'parser': 'parse_cmd_common'},
      \ {'name': 'call', 'pat': '^cal\%[l]$', 'flags': 'RANGE|NEEDARG|EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_call'},
      \ {'name': 'catch', 'pat': '^cat\%[ch]$', 'flags': 'EXTRA|SBOXOK|CMDWIN', 'parser': 'parse_cmd_catch'},
      \ {'name': 'cbuffer', 'pat': '^cb\%[uffer]$', 'flags': 'BANG|RANGE|NOTADR|WORD1|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'cc', 'pat': '^cc$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'cclose', 'pat': '^ccl\%[ose]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'cd', 'pat': '^cd$', 'flags': 'BANG|FILE1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'center', 'pat': '^ce\%[nter]$', 'flags': 'TRLBAR|RANGE|WHOLEFOLD|EXTRA|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'cexpr', 'pat': '^cex\%[pr]$', 'flags': 'NEEDARG|WORD1|NOTRLCOM|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'cfile', 'pat': '^cf\%[ile]$', 'flags': 'TRLBAR|FILE1|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'cfirst', 'pat': '^cfir\%[st]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'cgetbuffer', 'pat': '^cgetb\%[uffer]$', 'flags': 'RANGE|NOTADR|WORD1|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'cgetexpr', 'pat': '^cgete\%[xpr]$', 'flags': 'NEEDARG|WORD1|NOTRLCOM|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'cgetfile', 'pat': '^cg\%[etfile]$', 'flags': 'TRLBAR|FILE1', 'parser': 'parse_cmd_common'},
      \ {'name': 'changes', 'pat': '^changes$', 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'chdir', 'pat': '^chd\%[ir]$', 'flags': 'BANG|FILE1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'checkpath', 'pat': '^che\%[ckpath]$', 'flags': 'TRLBAR|BANG|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'checktime', 'pat': '^checkt\%[ime]$', 'flags': 'RANGE|NOTADR|BUFNAME|COUNT|EXTRA|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'clist', 'pat': '^cl\%[ist]$', 'flags': 'BANG|EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'clast', 'pat': '^cla\%[st]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'close', 'pat': '^clo\%[se]$', 'flags': 'BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'cmap', 'pat': '^cm\%[ap]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'cmapclear', 'pat': '^cmapc\%[lear]$', 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'cmenu', 'pat': '^cme\%[nu]$', 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'cnext', 'pat': '^cn\%[ext]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'cnewer', 'pat': '^cnew\%[er]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'cnfile', 'pat': '^cnf\%[ile]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'cnoremap', 'pat': '^cno\%[remap]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'cnoreabbrev', 'pat': '^cnorea\%[bbrev]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'cnoremenu', 'pat': '^cnoreme\%[nu]$', 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'copy', 'pat': '^co\%[py]$', 'flags': 'RANGE|WHOLEFOLD|EXTRA|TRLBAR|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'colder', 'pat': '^col\%[der]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'colorscheme', 'pat': '^colo\%[rscheme]$', 'flags': 'WORD1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'command', 'pat': '^com\%[mand]$', 'flags': 'EXTRA|BANG|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'comclear', 'pat': '^comc\%[lear]$', 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'compiler', 'pat': '^comp\%[iler]$', 'flags': 'BANG|TRLBAR|WORD1|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'continue', 'pat': '^con\%[tinue]$', 'flags': 'TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_continue'},
      \ {'name': 'confirm', 'pat': '^conf\%[irm]$', 'flags': 'NEEDARG|EXTRA|NOTRLCOM|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'copen', 'pat': '^cope\%[n]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'cprevious', 'pat': '^cp\%[revious]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'cpfile', 'pat': '^cpf\%[ile]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'cquit', 'pat': '^cq\%[uit]$', 'flags': 'TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'crewind', 'pat': '^cr\%[ewind]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'cscope', 'pat': '^cs\%[cope]$', 'flags': 'EXTRA|NOTRLCOM|XFILE', 'parser': 'parse_cmd_common'},
      \ {'name': 'cstag', 'pat': '^cst\%[ag]$', 'flags': 'BANG|TRLBAR|WORD1', 'parser': 'parse_cmd_common'},
      \ {'name': 'cunmap', 'pat': '^cu\%[nmap]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'cunabbrev', 'pat': '^cuna\%[bbrev]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'cunmenu', 'pat': '^cunme\%[nu]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'cwindow', 'pat': '^cw\%[indow]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'delete', 'pat': '^d\%[elete]$', 'flags': 'RANGE|WHOLEFOLD|REGSTR|COUNT|TRLBAR|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'delmarks', 'pat': '^delm\%[arks]$', 'flags': 'BANG|EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'debug', 'pat': '^deb\%[ug]$', 'flags': 'NEEDARG|EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'debuggreedy', 'pat': '^debugg\%[reedy]$', 'flags': 'RANGE|NOTADR|ZEROR|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'delcommand', 'pat': '^delc\%[ommand]$', 'flags': 'NEEDARG|WORD1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'delfunction', 'pat': '^delf\%[unction]$', 'flags': 'NEEDARG|WORD1|CMDWIN', 'parser': 'parse_cmd_delfunction'},
      \ {'name': 'diffupdate', 'pat': '^dif\%[fupdate]$', 'flags': 'BANG|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'diffget', 'pat': '^diffg\%[et]$', 'flags': 'RANGE|EXTRA|TRLBAR|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'diffoff', 'pat': '^diffo\%[ff]$', 'flags': 'BANG|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'diffpatch', 'pat': '^diffp\%[atch]$', 'flags': 'EXTRA|FILE1|TRLBAR|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'diffput', 'pat': '^diffpu\%[t]$', 'flags': 'RANGE|EXTRA|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'diffsplit', 'pat': '^diffs\%[plit]$', 'flags': 'EXTRA|FILE1|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'diffthis', 'pat': '^diffthis$', 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'digraphs', 'pat': '^dig\%[raphs]$', 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'display', 'pat': '^di\%[splay]$', 'flags': 'EXTRA|NOTRLCOM|TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'djump', 'pat': '^dj\%[ump]$', 'flags': 'BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA', 'parser': 'parse_cmd_common'},
      \ {'name': 'dlist', 'pat': '^dl\%[ist]$', 'flags': 'BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'doautocmd', 'pat': '^do\%[autocmd]$', 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'doautoall', 'pat': '^doautoa\%[ll]$', 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'drop', 'pat': '^dr\%[op]$', 'flags': 'FILES|EDITCMD|NEEDARG|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'dsearch', 'pat': '^ds\%[earch]$', 'flags': 'BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'dsplit', 'pat': '^dsp\%[lit]$', 'flags': 'BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA', 'parser': 'parse_cmd_common'},
      \ {'name': 'edit', 'pat': '^e\%[dit]$', 'flags': 'BANG|FILE1|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'earlier', 'pat': '^ea\%[rlier]$', 'flags': 'TRLBAR|EXTRA|NOSPC|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'echo', 'pat': '^ec\%[ho]$', 'flags': 'EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_echo'},
      \ {'name': 'echoerr', 'pat': '^echoe\%[rr]$', 'flags': 'EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_echoerr'},
      \ {'name': 'echohl', 'pat': '^echoh\%[l]$', 'flags': 'EXTRA|TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_echohl'},
      \ {'name': 'echomsg', 'pat': '^echom\%[sg]$', 'flags': 'EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_echomsg'},
      \ {'name': 'echon', 'pat': '^echon$', 'flags': 'EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_echon'},
      \ {'name': 'else', 'pat': '^el\%[se]$', 'flags': 'TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_else'},
      \ {'name': 'elseif', 'pat': '^elsei\%[f]$', 'flags': 'EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_elseif'},
      \ {'name': 'emenu', 'pat': '^em\%[enu]$', 'flags': 'NEEDARG|EXTRA|TRLBAR|NOTRLCOM|RANGE|NOTADR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'endif', 'pat': '^en\%[dif]$', 'flags': 'TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_endif'},
      \ {'name': 'endfor', 'pat': '^endfo\%[r]$', 'flags': 'TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_endfor'},
      \ {'name': 'endfunction', 'pat': '^endf\%[unction]$', 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_endfunction'},
      \ {'name': 'endtry', 'pat': '^endt\%[ry]$', 'flags': 'TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_endtry'},
      \ {'name': 'endwhile', 'pat': '^endw\%[hile]$', 'flags': 'TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_endwhile'},
      \ {'name': 'enew', 'pat': '^ene\%[w]$', 'flags': 'BANG|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'ex', 'pat': '^ex$', 'flags': 'BANG|FILE1|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'execute', 'pat': '^exe\%[cute]$', 'flags': 'EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_execute'},
      \ {'name': 'exit', 'pat': '^exi\%[t]$', 'flags': 'RANGE|WHOLEFOLD|BANG|FILE1|ARGOPT|DFLALL|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'exusage', 'pat': '^exu\%[sage]$', 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'file', 'pat': '^f\%[ile]$', 'flags': 'RANGE|NOTADR|ZEROR|BANG|FILE1|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'files', 'pat': '^files$', 'flags': 'BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'filetype', 'pat': '^filet\%[ype]$', 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'find', 'pat': '^fin\%[d]$', 'flags': 'RANGE|NOTADR|BANG|FILE1|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'finally', 'pat': '^fina\%[lly]$', 'flags': 'TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_finally'},
      \ {'name': 'finish', 'pat': '^fini\%[sh]$', 'flags': 'TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_finish'},
      \ {'name': 'first', 'pat': '^fir\%[st]$', 'flags': 'EXTRA|BANG|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'fixdel', 'pat': '^fix\%[del]$', 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'fold', 'pat': '^fo\%[ld]$', 'flags': 'RANGE|WHOLEFOLD|TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'foldclose', 'pat': '^foldc\%[lose]$', 'flags': 'RANGE|BANG|WHOLEFOLD|TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'folddoopen', 'pat': '^foldd\%[oopen]$', 'flags': 'RANGE|DFLALL|NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'folddoclosed', 'pat': '^folddoc\%[losed]$', 'flags': 'RANGE|DFLALL|NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'foldopen', 'pat': '^foldo\%[pen]$', 'flags': 'RANGE|BANG|WHOLEFOLD|TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'for', 'pat': '^for$', 'flags': 'EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_for'},
      \ {'name': 'function', 'pat': '^fu\%[nction]$', 'flags': 'EXTRA|BANG|CMDWIN', 'parser': 'parse_cmd_function'},
      \ {'name': 'global', 'pat': '^g\%[lobal]$', 'flags': 'RANGE|WHOLEFOLD|BANG|EXTRA|DFLALL|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'goto', 'pat': '^go\%[to]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'grep', 'pat': '^gr\%[ep]$', 'flags': 'RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE', 'parser': 'parse_cmd_common'},
      \ {'name': 'grepadd', 'pat': '^grepa\%[dd]$', 'flags': 'RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE', 'parser': 'parse_cmd_common'},
      \ {'name': 'gui', 'pat': '^gu\%[i]$', 'flags': 'BANG|FILES|EDITCMD|ARGOPT|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'gvim', 'pat': '^gv\%[im]$', 'flags': 'BANG|FILES|EDITCMD|ARGOPT|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'hardcopy', 'pat': '^ha\%[rdcopy]$', 'flags': 'RANGE|COUNT|EXTRA|TRLBAR|DFLALL|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'help', 'pat': '^h\%[elp]$', 'flags': 'BANG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'helpfind', 'pat': '^helpf\%[ind]$', 'flags': 'EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'helpgrep', 'pat': '^helpg\%[rep]$', 'flags': 'EXTRA|NOTRLCOM|NEEDARG', 'parser': 'parse_cmd_common'},
      \ {'name': 'helptags', 'pat': '^helpt\%[ags]$', 'flags': 'NEEDARG|FILES|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'highlight', 'pat': '^hi\%[ghlight]$', 'flags': 'BANG|EXTRA|TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'hide', 'pat': '^hid\%[e]$', 'flags': 'BANG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'history', 'pat': '^his\%[tory]$', 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'insert', 'pat': '^i\%[nsert]$', 'flags': 'BANG|RANGE|TRLBAR|CMDWIN|MODIFY', 'parser': 'parse_cmd_insert'},
      \ {'name': 'iabbrev', 'pat': '^ia\%[bbrev]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'iabclear', 'pat': '^iabc\%[lear]$', 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'if', 'pat': '^if$', 'flags': 'EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_if'},
      \ {'name': 'ijump', 'pat': '^ij\%[ump]$', 'flags': 'BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA', 'parser': 'parse_cmd_common'},
      \ {'name': 'ilist', 'pat': '^il\%[ist]$', 'flags': 'BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'imap', 'pat': '^im\%[ap]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'imapclear', 'pat': '^imapc\%[lear]$', 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'imenu', 'pat': '^ime\%[nu]$', 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'inoremap', 'pat': '^ino\%[remap]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'inoreabbrev', 'pat': '^inorea\%[bbrev]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'inoremenu', 'pat': '^inoreme\%[nu]$', 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'intro', 'pat': '^int\%[ro]$', 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'isearch', 'pat': '^is\%[earch]$', 'flags': 'BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'isplit', 'pat': '^isp\%[lit]$', 'flags': 'BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA', 'parser': 'parse_cmd_common'},
      \ {'name': 'iunmap', 'pat': '^iu\%[nmap]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'iunabbrev', 'pat': '^iuna\%[bbrev]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'iunmenu', 'pat': '^iunme\%[nu]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'join', 'pat': '^j\%[oin]$', 'flags': 'BANG|RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'jumps', 'pat': '^ju\%[mps]$', 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'k', 'pat': '^k$', 'flags': 'RANGE|WORD1|TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'keepalt', 'pat': '^keepa\%[lt]$', 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'keepmarks', 'pat': '^kee\%[pmarks]$', 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'keepjumps', 'pat': '^keepj\%[umps]$', 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'lNext', 'pat': '^lN\%[ext]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'lNfile', 'pat': '^lNf\%[ile]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'list', 'pat': '^l\%[ist]$', 'flags': 'RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'laddexpr', 'pat': '^lad\%[dexpr]$', 'flags': 'NEEDARG|WORD1|NOTRLCOM|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'laddbuffer', 'pat': '^laddb\%[uffer]$', 'flags': 'RANGE|NOTADR|WORD1|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'laddfile', 'pat': '^laddf\%[ile]$', 'flags': 'TRLBAR|FILE1', 'parser': 'parse_cmd_common'},
      \ {'name': 'last', 'pat': '^la\%[st]$', 'flags': 'EXTRA|BANG|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'language', 'pat': '^lan\%[guage]$', 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'later', 'pat': '^lat\%[er]$', 'flags': 'TRLBAR|EXTRA|NOSPC|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'lbuffer', 'pat': '^lb\%[uffer]$', 'flags': 'BANG|RANGE|NOTADR|WORD1|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'lcd', 'pat': '^lc\%[d]$', 'flags': 'BANG|FILE1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'lchdir', 'pat': '^lch\%[dir]$', 'flags': 'BANG|FILE1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'lclose', 'pat': '^lcl\%[ose]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'lcscope', 'pat': '^lcs\%[cope]$', 'flags': 'EXTRA|NOTRLCOM|XFILE', 'parser': 'parse_cmd_common'},
      \ {'name': 'left', 'pat': '^le\%[ft]$', 'flags': 'TRLBAR|RANGE|WHOLEFOLD|EXTRA|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'leftabove', 'pat': '^lefta\%[bove]$', 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'let', 'pat': '^let$', 'flags': 'EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_let'},
      \ {'name': 'lexpr', 'pat': '^lex\%[pr]$', 'flags': 'NEEDARG|WORD1|NOTRLCOM|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'lfile', 'pat': '^lf\%[ile]$', 'flags': 'TRLBAR|FILE1|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'lfirst', 'pat': '^lfir\%[st]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'lgetbuffer', 'pat': '^lgetb\%[uffer]$', 'flags': 'RANGE|NOTADR|WORD1|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'lgetexpr', 'pat': '^lgete\%[xpr]$', 'flags': 'NEEDARG|WORD1|NOTRLCOM|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'lgetfile', 'pat': '^lg\%[etfile]$', 'flags': 'TRLBAR|FILE1', 'parser': 'parse_cmd_common'},
      \ {'name': 'lgrep', 'pat': '^lgr\%[ep]$', 'flags': 'RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE', 'parser': 'parse_cmd_common'},
      \ {'name': 'lgrepadd', 'pat': '^lgrepa\%[dd]$', 'flags': 'RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE', 'parser': 'parse_cmd_common'},
      \ {'name': 'lhelpgrep', 'pat': '^lh\%[elpgrep]$', 'flags': 'EXTRA|NOTRLCOM|NEEDARG', 'parser': 'parse_cmd_common'},
      \ {'name': 'll', 'pat': '^ll$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'llast', 'pat': '^lla\%[st]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'llist', 'pat': '^lli\%[st]$', 'flags': 'BANG|EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'lmake', 'pat': '^lmak\%[e]$', 'flags': 'BANG|EXTRA|NOTRLCOM|TRLBAR|XFILE', 'parser': 'parse_cmd_common'},
      \ {'name': 'lmap', 'pat': '^lm\%[ap]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'lmapclear', 'pat': '^lmapc\%[lear]$', 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'lnext', 'pat': '^lne\%[xt]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'lnewer', 'pat': '^lnew\%[er]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'lnfile', 'pat': '^lnf\%[ile]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'lnoremap', 'pat': '^ln\%[oremap]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'loadkeymap', 'pat': '^loadk\%[eymap]$', 'flags': 'CMDWIN', 'parser': 'parse_cmd_loadkeymap'},
      \ {'name': 'loadview', 'pat': '^lo\%[adview]$', 'flags': 'FILE1|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'lockmarks', 'pat': '^loc\%[kmarks]$', 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'lockvar', 'pat': '^lockv\%[ar]$', 'flags': 'BANG|EXTRA|NEEDARG|SBOXOK|CMDWIN', 'parser': 'parse_cmd_lockvar'},
      \ {'name': 'lolder', 'pat': '^lol\%[der]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'lopen', 'pat': '^lope\%[n]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'lprevious', 'pat': '^lp\%[revious]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'lpfile', 'pat': '^lpf\%[ile]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'lrewind', 'pat': '^lr\%[ewind]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR|BANG', 'parser': 'parse_cmd_common'},
      \ {'name': 'ls', 'pat': '^ls$', 'flags': 'BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'ltag', 'pat': '^lt\%[ag]$', 'flags': 'NOTADR|TRLBAR|BANG|WORD1', 'parser': 'parse_cmd_common'},
      \ {'name': 'lunmap', 'pat': '^lu\%[nmap]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'lua', 'pat': '^lua$', 'flags': 'RANGE|EXTRA|NEEDARG|CMDWIN', 'parser': 'parse_cmd_lua'},
      \ {'name': 'luado', 'pat': '^luad\%[o]$', 'flags': 'RANGE|DFLALL|EXTRA|NEEDARG|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'luafile', 'pat': '^luaf\%[ile]$', 'flags': 'RANGE|FILE1|NEEDARG|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'lvimgrep', 'pat': '^lv\%[imgrep]$', 'flags': 'RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE', 'parser': 'parse_cmd_common'},
      \ {'name': 'lvimgrepadd', 'pat': '^lvimgrepa\%[dd]$', 'flags': 'RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE', 'parser': 'parse_cmd_common'},
      \ {'name': 'lwindow', 'pat': '^lw\%[indow]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'move', 'pat': '^m\%[ove]$', 'flags': 'RANGE|WHOLEFOLD|EXTRA|TRLBAR|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'mark', 'pat': '^ma\%[rk]$', 'flags': 'RANGE|WORD1|TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'make', 'pat': '^mak\%[e]$', 'flags': 'BANG|EXTRA|NOTRLCOM|TRLBAR|XFILE', 'parser': 'parse_cmd_common'},
      \ {'name': 'map', 'pat': '^map$', 'flags': 'BANG|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'mapclear', 'pat': '^mapc\%[lear]$', 'flags': 'EXTRA|BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'marks', 'pat': '^marks$', 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'match', 'pat': '^mat\%[ch]$', 'flags': 'RANGE|NOTADR|EXTRA|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'menu', 'pat': '^me\%[nu]$', 'flags': 'RANGE|NOTADR|ZEROR|BANG|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'menutranslate', 'pat': '^menut\%[ranslate]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'messages', 'pat': '^mes\%[sages]$', 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'mkexrc', 'pat': '^mk\%[exrc]$', 'flags': 'BANG|FILE1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'mksession', 'pat': '^mks\%[ession]$', 'flags': 'BANG|FILE1|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'mkspell', 'pat': '^mksp\%[ell]$', 'flags': 'BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE', 'parser': 'parse_cmd_common'},
      \ {'name': 'mkvimrc', 'pat': '^mkv\%[imrc]$', 'flags': 'BANG|FILE1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'mkview', 'pat': '^mkvie\%[w]$', 'flags': 'BANG|FILE1|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'mode', 'pat': '^mod\%[e]$', 'flags': 'WORD1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'mzscheme', 'pat': '^mz\%[scheme]$', 'flags': 'RANGE|EXTRA|DFLALL|NEEDARG|CMDWIN|SBOXOK', 'parser': 'parse_cmd_mzscheme'},
      \ {'name': 'mzfile', 'pat': '^mzf\%[ile]$', 'flags': 'RANGE|FILE1|NEEDARG|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'nbclose', 'pat': '^nbc\%[lose]$', 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'nbkey', 'pat': '^nb\%[key]$', 'flags': 'EXTRA|NOTADR|NEEDARG', 'parser': 'parse_cmd_common'},
      \ {'name': 'nbstart', 'pat': '^nbs\%[art]$', 'flags': 'WORD1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'next', 'pat': '^n\%[ext]$', 'flags': 'RANGE|NOTADR|BANG|FILES|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'new', 'pat': '^new$', 'flags': 'BANG|FILE1|RANGE|NOTADR|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'nmap', 'pat': '^nm\%[ap]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'nmapclear', 'pat': '^nmapc\%[lear]$', 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'nmenu', 'pat': '^nme\%[nu]$', 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'nnoremap', 'pat': '^nn\%[oremap]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'nnoremenu', 'pat': '^nnoreme\%[nu]$', 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'noautocmd', 'pat': '^noa\%[utocmd]$', 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'noremap', 'pat': '^no\%[remap]$', 'flags': 'BANG|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'nohlsearch', 'pat': '^noh\%[lsearch]$', 'flags': 'TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'noreabbrev', 'pat': '^norea\%[bbrev]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'noremenu', 'pat': '^noreme\%[nu]$', 'flags': 'RANGE|NOTADR|ZEROR|BANG|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'normal', 'pat': '^norm\%[al]$', 'flags': 'RANGE|BANG|EXTRA|NEEDARG|NOTRLCOM|USECTRLV|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'number', 'pat': '^nu\%[mber]$', 'flags': 'RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'nunmap', 'pat': '^nun\%[map]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'nunmenu', 'pat': '^nunme\%[nu]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'oldfiles', 'pat': '^ol\%[dfiles]$', 'flags': 'BANG|TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'open', 'pat': '^o\%[pen]$', 'flags': 'RANGE|BANG|EXTRA', 'parser': 'parse_cmd_common'},
      \ {'name': 'omap', 'pat': '^om\%[ap]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'omapclear', 'pat': '^omapc\%[lear]$', 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'omenu', 'pat': '^ome\%[nu]$', 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'only', 'pat': '^on\%[ly]$', 'flags': 'BANG|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'onoremap', 'pat': '^ono\%[remap]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'onoremenu', 'pat': '^onoreme\%[nu]$', 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'options', 'pat': '^opt\%[ions]$', 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'ounmap', 'pat': '^ou\%[nmap]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'ounmenu', 'pat': '^ounme\%[nu]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'ownsyntax', 'pat': '^ow\%[nsyntax]$', 'flags': 'EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'pclose', 'pat': '^pc\%[lose]$', 'flags': 'BANG|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'pedit', 'pat': '^ped\%[it]$', 'flags': 'BANG|FILE1|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'perl', 'pat': '^pe\%[rl]$', 'flags': 'RANGE|EXTRA|DFLALL|NEEDARG|SBOXOK|CMDWIN', 'parser': 'parse_cmd_perl'},
      \ {'name': 'print', 'pat': '^p\%[rint]$', 'flags': 'RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN|SBOXOK', 'parser': 'parse_cmd_common'},
      \ {'name': 'profdel', 'pat': '^profd\%[el]$', 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'profile', 'pat': '^prof\%[ile]$', 'flags': 'BANG|EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'promptfind', 'pat': '^pro\%[mptfind]$', 'flags': 'EXTRA|NOTRLCOM|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'promptrepl', 'pat': '^promptr\%[epl]$', 'flags': 'EXTRA|NOTRLCOM|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'perldo', 'pat': '^perld\%[o]$', 'flags': 'RANGE|EXTRA|DFLALL|NEEDARG|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'pop', 'pat': '^po\%[p]$', 'flags': 'RANGE|NOTADR|BANG|COUNT|TRLBAR|ZEROR', 'parser': 'parse_cmd_common'},
      \ {'name': 'popup', 'pat': '^popu\%[p]$', 'flags': 'NEEDARG|EXTRA|BANG|TRLBAR|NOTRLCOM|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'ppop', 'pat': '^pp\%[op]$', 'flags': 'RANGE|NOTADR|BANG|COUNT|TRLBAR|ZEROR', 'parser': 'parse_cmd_common'},
      \ {'name': 'preserve', 'pat': '^pre\%[serve]$', 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'previous', 'pat': '^prev\%[ious]$', 'flags': 'EXTRA|RANGE|NOTADR|COUNT|BANG|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'psearch', 'pat': '^ps\%[earch]$', 'flags': 'BANG|RANGE|WHOLEFOLD|DFLALL|EXTRA', 'parser': 'parse_cmd_common'},
      \ {'name': 'ptag', 'pat': '^pt\%[ag]$', 'flags': 'RANGE|NOTADR|BANG|WORD1|TRLBAR|ZEROR', 'parser': 'parse_cmd_common'},
      \ {'name': 'ptNext', 'pat': '^ptN\%[ext]$', 'flags': 'RANGE|NOTADR|BANG|TRLBAR|ZEROR', 'parser': 'parse_cmd_common'},
      \ {'name': 'ptfirst', 'pat': '^ptf\%[irst]$', 'flags': 'RANGE|NOTADR|BANG|TRLBAR|ZEROR', 'parser': 'parse_cmd_common'},
      \ {'name': 'ptjump', 'pat': '^ptj\%[ump]$', 'flags': 'BANG|TRLBAR|WORD1', 'parser': 'parse_cmd_common'},
      \ {'name': 'ptlast', 'pat': '^ptl\%[ast]$', 'flags': 'BANG|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'ptnext', 'pat': '^ptn\%[ext]$', 'flags': 'RANGE|NOTADR|BANG|TRLBAR|ZEROR', 'parser': 'parse_cmd_common'},
      \ {'name': 'ptprevious', 'pat': '^ptp\%[revious]$', 'flags': 'RANGE|NOTADR|BANG|TRLBAR|ZEROR', 'parser': 'parse_cmd_common'},
      \ {'name': 'ptrewind', 'pat': '^ptr\%[ewind]$', 'flags': 'RANGE|NOTADR|BANG|TRLBAR|ZEROR', 'parser': 'parse_cmd_common'},
      \ {'name': 'ptselect', 'pat': '^pts\%[elect]$', 'flags': 'BANG|TRLBAR|WORD1', 'parser': 'parse_cmd_common'},
      \ {'name': 'put', 'pat': '^pu\%[t]$', 'flags': 'RANGE|WHOLEFOLD|BANG|REGSTR|TRLBAR|ZEROR|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'pwd', 'pat': '^pw\%[d]$', 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'py3', 'pat': '^py3$', 'flags': 'RANGE|EXTRA|NEEDARG|CMDWIN', 'parser': 'parse_cmd_python3'},
      \ {'name': 'python3', 'pat': '^python3$', 'flags': 'RANGE|EXTRA|NEEDARG|CMDWIN', 'parser': 'parse_cmd_python3'},
      \ {'name': 'py3file', 'pat': '^py3f\%[ile]$', 'flags': 'RANGE|FILE1|NEEDARG|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'python', 'pat': '^py\%[thon]$', 'flags': 'RANGE|EXTRA|NEEDARG|CMDWIN', 'parser': 'parse_cmd_python'},
      \ {'name': 'pyfile', 'pat': '^pyf\%[ile]$', 'flags': 'RANGE|FILE1|NEEDARG|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'quit', 'pat': '^q\%[uit]$', 'flags': 'BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'quitall', 'pat': '^quita\%[ll]$', 'flags': 'BANG|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'qall', 'pat': '^qa\%[ll]$', 'flags': 'BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'read', 'pat': '^r\%[ead]$', 'flags': 'BANG|RANGE|WHOLEFOLD|FILE1|ARGOPT|TRLBAR|ZEROR|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'recover', 'pat': '^rec\%[over]$', 'flags': 'BANG|FILE1|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'redo', 'pat': '^red\%[o]$', 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'redir', 'pat': '^redi\%[r]$', 'flags': 'BANG|FILES|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'redraw', 'pat': '^redr\%[aw]$', 'flags': 'BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'redrawstatus', 'pat': '^redraws\%[tatus]$', 'flags': 'BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'registers', 'pat': '^reg\%[isters]$', 'flags': 'EXTRA|NOTRLCOM|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'resize', 'pat': '^res\%[ize]$', 'flags': 'RANGE|NOTADR|TRLBAR|WORD1', 'parser': 'parse_cmd_common'},
      \ {'name': 'retab', 'pat': '^ret\%[ab]$', 'flags': 'TRLBAR|RANGE|WHOLEFOLD|DFLALL|BANG|WORD1|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'return', 'pat': '^retu\%[rn]$', 'flags': 'EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_return'},
      \ {'name': 'rewind', 'pat': '^rew\%[ind]$', 'flags': 'EXTRA|BANG|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'right', 'pat': '^ri\%[ght]$', 'flags': 'TRLBAR|RANGE|WHOLEFOLD|EXTRA|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'rightbelow', 'pat': '^rightb\%[elow]$', 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'ruby', 'pat': '^rub\%[y]$', 'flags': 'RANGE|EXTRA|NEEDARG|CMDWIN', 'parser': 'parse_cmd_ruby'},
      \ {'name': 'rubydo', 'pat': '^rubyd\%[o]$', 'flags': 'RANGE|DFLALL|EXTRA|NEEDARG|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'rubyfile', 'pat': '^rubyf\%[ile]$', 'flags': 'RANGE|FILE1|NEEDARG|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'rundo', 'pat': '^rund\%[o]$', 'flags': 'NEEDARG|FILE1', 'parser': 'parse_cmd_common'},
      \ {'name': 'runtime', 'pat': '^ru\%[ntime]$', 'flags': 'BANG|NEEDARG|FILES|TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'rviminfo', 'pat': '^rv\%[iminfo]$', 'flags': 'BANG|FILE1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'substitute', 'pat': '^s\%[ubstitute]$', 'flags': 'RANGE|WHOLEFOLD|EXTRA|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'sNext', 'pat': '^sN\%[ext]$', 'flags': 'EXTRA|RANGE|NOTADR|COUNT|BANG|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'sandbox', 'pat': '^san\%[dbox]$', 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'sargument', 'pat': '^sa\%[rgument]$', 'flags': 'BANG|RANGE|NOTADR|COUNT|EXTRA|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'sall', 'pat': '^sal\%[l]$', 'flags': 'BANG|RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'saveas', 'pat': '^sav\%[eas]$', 'flags': 'BANG|DFLALL|FILE1|ARGOPT|CMDWIN|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'sbuffer', 'pat': '^sb\%[uffer]$', 'flags': 'BANG|RANGE|NOTADR|BUFNAME|BUFUNL|COUNT|EXTRA|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'sbNext', 'pat': '^sbN\%[ext]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'sball', 'pat': '^sba\%[ll]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'sbfirst', 'pat': '^sbf\%[irst]$', 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'sblast', 'pat': '^sbl\%[ast]$', 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'sbmodified', 'pat': '^sbm\%[odified]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'sbnext', 'pat': '^sbn\%[ext]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'sbprevious', 'pat': '^sbp\%[revious]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'sbrewind', 'pat': '^sbr\%[ewind]$', 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'scriptnames', 'pat': '^scrip\%[tnames]$', 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'scriptencoding', 'pat': '^scripte\%[ncoding]$', 'flags': 'WORD1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'scscope', 'pat': '^scs\%[cope]$', 'flags': 'EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'set', 'pat': '^se\%[t]$', 'flags': 'TRLBAR|EXTRA|CMDWIN|SBOXOK', 'parser': 'parse_cmd_common'},
      \ {'name': 'setfiletype', 'pat': '^setf\%[iletype]$', 'flags': 'TRLBAR|EXTRA|NEEDARG|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'setglobal', 'pat': '^setg\%[lobal]$', 'flags': 'TRLBAR|EXTRA|CMDWIN|SBOXOK', 'parser': 'parse_cmd_common'},
      \ {'name': 'setlocal', 'pat': '^setl\%[ocal]$', 'flags': 'TRLBAR|EXTRA|CMDWIN|SBOXOK', 'parser': 'parse_cmd_common'},
      \ {'name': 'sfind', 'pat': '^sf\%[ind]$', 'flags': 'BANG|FILE1|RANGE|NOTADR|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'sfirst', 'pat': '^sfir\%[st]$', 'flags': 'EXTRA|BANG|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'shell', 'pat': '^sh\%[ell]$', 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'simalt', 'pat': '^sim\%[alt]$', 'flags': 'NEEDARG|WORD1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'sign', 'pat': '^sig\%[n]$', 'flags': 'NEEDARG|RANGE|NOTADR|EXTRA|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'silent', 'pat': '^sil\%[ent]$', 'flags': 'NEEDARG|EXTRA|BANG|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'sleep', 'pat': '^sl\%[eep]$', 'flags': 'RANGE|NOTADR|COUNT|EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'slast', 'pat': '^sla\%[st]$', 'flags': 'EXTRA|BANG|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'smagic', 'pat': '^sm\%[agic]$', 'flags': 'RANGE|WHOLEFOLD|EXTRA|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'smap', 'pat': '^smap$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'smapclear', 'pat': '^smapc\%[lear]$', 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'smenu', 'pat': '^sme\%[nu]$', 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'snext', 'pat': '^sn\%[ext]$', 'flags': 'RANGE|NOTADR|BANG|FILES|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'sniff', 'pat': '^sni\%[ff]$', 'flags': 'EXTRA|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'snomagic', 'pat': '^sno\%[magic]$', 'flags': 'RANGE|WHOLEFOLD|EXTRA|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'snoremap', 'pat': '^snor\%[emap]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'snoremenu', 'pat': '^snoreme\%[nu]$', 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'sort', 'pat': '^sor\%[t]$', 'flags': 'RANGE|DFLALL|WHOLEFOLD|BANG|EXTRA|NOTRLCOM|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'source', 'pat': '^so\%[urce]$', 'flags': 'BANG|FILE1|TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'spelldump', 'pat': '^spelld\%[ump]$', 'flags': 'BANG|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'spellgood', 'pat': '^spe\%[llgood]$', 'flags': 'BANG|RANGE|NOTADR|NEEDARG|EXTRA|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'spellinfo', 'pat': '^spelli\%[nfo]$', 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'spellrepall', 'pat': '^spellr\%[epall]$', 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'spellundo', 'pat': '^spellu\%[ndo]$', 'flags': 'BANG|RANGE|NOTADR|NEEDARG|EXTRA|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'spellwrong', 'pat': '^spellw\%[rong]$', 'flags': 'BANG|RANGE|NOTADR|NEEDARG|EXTRA|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'split', 'pat': '^sp\%[lit]$', 'flags': 'BANG|FILE1|RANGE|NOTADR|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'sprevious', 'pat': '^spr\%[evious]$', 'flags': 'EXTRA|RANGE|NOTADR|COUNT|BANG|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'srewind', 'pat': '^sre\%[wind]$', 'flags': 'EXTRA|BANG|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'stop', 'pat': '^st\%[op]$', 'flags': 'TRLBAR|BANG|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'stag', 'pat': '^sta\%[g]$', 'flags': 'RANGE|NOTADR|BANG|WORD1|TRLBAR|ZEROR', 'parser': 'parse_cmd_common'},
      \ {'name': 'startinsert', 'pat': '^star\%[tinsert]$', 'flags': 'BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'startgreplace', 'pat': '^startg\%[replace]$', 'flags': 'BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'startreplace', 'pat': '^startr\%[eplace]$', 'flags': 'BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'stopinsert', 'pat': '^stopi\%[nsert]$', 'flags': 'BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'stjump', 'pat': '^stj\%[ump]$', 'flags': 'BANG|TRLBAR|WORD1', 'parser': 'parse_cmd_common'},
      \ {'name': 'stselect', 'pat': '^sts\%[elect]$', 'flags': 'BANG|TRLBAR|WORD1', 'parser': 'parse_cmd_common'},
      \ {'name': 'sunhide', 'pat': '^sun\%[hide]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'sunmap', 'pat': '^sunm\%[ap]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'sunmenu', 'pat': '^sunme\%[nu]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'suspend', 'pat': '^sus\%[pend]$', 'flags': 'TRLBAR|BANG|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'sview', 'pat': '^sv\%[iew]$', 'flags': 'BANG|FILE1|RANGE|NOTADR|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'swapname', 'pat': '^sw\%[apname]$', 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'syntax', 'pat': '^sy\%[ntax]$', 'flags': 'EXTRA|NOTRLCOM|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'syncbind', 'pat': '^sync\%[bind]$', 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 't', 'pat': '^t$', 'flags': 'RANGE|WHOLEFOLD|EXTRA|TRLBAR|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': 'tNext', 'pat': '^tN\%[ext]$', 'flags': 'RANGE|NOTADR|BANG|TRLBAR|ZEROR', 'parser': 'parse_cmd_common'},
      \ {'name': 'tabNext', 'pat': '^tabN\%[ext]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'tabclose', 'pat': '^tabc\%[lose]$', 'flags': 'RANGE|NOTADR|COUNT|BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'tabdo', 'pat': '^tabdo$', 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'tabedit', 'pat': '^tabe\%[dit]$', 'flags': 'BANG|FILE1|RANGE|NOTADR|ZEROR|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'tabfind', 'pat': '^tabf\%[ind]$', 'flags': 'BANG|FILE1|RANGE|NOTADR|ZEROR|EDITCMD|ARGOPT|NEEDARG|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'tabfirst', 'pat': '^tabfir\%[st]$', 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'tablast', 'pat': '^tabl\%[ast]$', 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'tabmove', 'pat': '^tabm\%[ove]$', 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|NOSPC|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'tabnew', 'pat': '^tabnew$', 'flags': 'BANG|FILE1|RANGE|NOTADR|ZEROR|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'tabnext', 'pat': '^tabn\%[ext]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'tabonly', 'pat': '^tabo\%[nly]$', 'flags': 'BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'tabprevious', 'pat': '^tabp\%[revious]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'tabrewind', 'pat': '^tabr\%[ewind]$', 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'tabs', 'pat': '^tabs$', 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'tab', 'pat': '^tab$', 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'tag', 'pat': '^ta\%[g]$', 'flags': 'RANGE|NOTADR|BANG|WORD1|TRLBAR|ZEROR', 'parser': 'parse_cmd_common'},
      \ {'name': 'tags', 'pat': '^tags$', 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'tcl', 'pat': '^tc\%[l]$', 'flags': 'RANGE|EXTRA|NEEDARG|CMDWIN', 'parser': 'parse_cmd_tcl'},
      \ {'name': 'tcldo', 'pat': '^tcld\%[o]$', 'flags': 'RANGE|DFLALL|EXTRA|NEEDARG|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'tclfile', 'pat': '^tclf\%[ile]$', 'flags': 'RANGE|FILE1|NEEDARG|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'tearoff', 'pat': '^te\%[aroff]$', 'flags': 'NEEDARG|EXTRA|TRLBAR|NOTRLCOM|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'tfirst', 'pat': '^tf\%[irst]$', 'flags': 'RANGE|NOTADR|BANG|TRLBAR|ZEROR', 'parser': 'parse_cmd_common'},
      \ {'name': 'throw', 'pat': '^th\%[row]$', 'flags': 'EXTRA|NEEDARG|SBOXOK|CMDWIN', 'parser': 'parse_cmd_throw'},
      \ {'name': 'tjump', 'pat': '^tj\%[ump]$', 'flags': 'BANG|TRLBAR|WORD1', 'parser': 'parse_cmd_common'},
      \ {'name': 'tlast', 'pat': '^tl\%[ast]$', 'flags': 'BANG|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'tmenu', 'pat': '^tm\%[enu]$', 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'tnext', 'pat': '^tn\%[ext]$', 'flags': 'RANGE|NOTADR|BANG|TRLBAR|ZEROR', 'parser': 'parse_cmd_common'},
      \ {'name': 'topleft', 'pat': '^to\%[pleft]$', 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'tprevious', 'pat': '^tp\%[revious]$', 'flags': 'RANGE|NOTADR|BANG|TRLBAR|ZEROR', 'parser': 'parse_cmd_common'},
      \ {'name': 'trewind', 'pat': '^tr\%[ewind]$', 'flags': 'RANGE|NOTADR|BANG|TRLBAR|ZEROR', 'parser': 'parse_cmd_common'},
      \ {'name': 'try', 'pat': '^try$', 'flags': 'TRLBAR|SBOXOK|CMDWIN', 'parser': 'parse_cmd_try'},
      \ {'name': 'tselect', 'pat': '^ts\%[elect]$', 'flags': 'BANG|TRLBAR|WORD1', 'parser': 'parse_cmd_common'},
      \ {'name': 'tunmenu', 'pat': '^tu\%[nmenu]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'undo', 'pat': '^u\%[ndo]$', 'flags': 'RANGE|NOTADR|COUNT|ZEROR|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'undojoin', 'pat': '^undoj\%[oin]$', 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'undolist', 'pat': '^undol\%[ist]$', 'flags': 'TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'unabbreviate', 'pat': '^una\%[bbreviate]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'unhide', 'pat': '^unh\%[ide]$', 'flags': 'RANGE|NOTADR|COUNT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'unlet', 'pat': '^unl\%[et]$', 'flags': 'BANG|EXTRA|NEEDARG|SBOXOK|CMDWIN', 'parser': 'parse_cmd_unlet'},
      \ {'name': 'unlockvar', 'pat': '^unlo\%[ckvar]$', 'flags': 'BANG|EXTRA|NEEDARG|SBOXOK|CMDWIN', 'parser': 'parse_cmd_unlockvar'},
      \ {'name': 'unmap', 'pat': '^unm\%[ap]$', 'flags': 'BANG|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'unmenu', 'pat': '^unme\%[nu]$', 'flags': 'BANG|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'unsilent', 'pat': '^uns\%[ilent]$', 'flags': 'NEEDARG|EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'update', 'pat': '^up\%[date]$', 'flags': 'RANGE|WHOLEFOLD|BANG|FILE1|ARGOPT|DFLALL|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'vglobal', 'pat': '^v\%[global]$', 'flags': 'RANGE|WHOLEFOLD|EXTRA|DFLALL|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'version', 'pat': '^ve\%[rsion]$', 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'verbose', 'pat': '^verb\%[ose]$', 'flags': 'NEEDARG|RANGE|NOTADR|EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'vertical', 'pat': '^vert\%[ical]$', 'flags': 'NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'vimgrep', 'pat': '^vim\%[grep]$', 'flags': 'RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE', 'parser': 'parse_cmd_common'},
      \ {'name': 'vimgrepadd', 'pat': '^vimgrepa\%[dd]$', 'flags': 'RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE', 'parser': 'parse_cmd_common'},
      \ {'name': 'visual', 'pat': '^vi\%[sual]$', 'flags': 'BANG|FILE1|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'viusage', 'pat': '^viu\%[sage]$', 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'view', 'pat': '^vie\%[w]$', 'flags': 'BANG|FILE1|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'vmap', 'pat': '^vm\%[ap]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'vmapclear', 'pat': '^vmapc\%[lear]$', 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'vmenu', 'pat': '^vme\%[nu]$', 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'vnew', 'pat': '^vne\%[w]$', 'flags': 'BANG|FILE1|RANGE|NOTADR|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'vnoremap', 'pat': '^vn\%[oremap]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'vnoremenu', 'pat': '^vnoreme\%[nu]$', 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'vsplit', 'pat': '^vs\%[plit]$', 'flags': 'BANG|FILE1|RANGE|NOTADR|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'vunmap', 'pat': '^vu\%[nmap]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'vunmenu', 'pat': '^vunme\%[nu]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'windo', 'pat': '^windo$', 'flags': 'BANG|NEEDARG|EXTRA|NOTRLCOM', 'parser': 'parse_cmd_common'},
      \ {'name': 'write', 'pat': '^w\%[rite]$', 'flags': 'RANGE|WHOLEFOLD|BANG|FILE1|ARGOPT|DFLALL|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'wNext', 'pat': '^wN\%[ext]$', 'flags': 'RANGE|WHOLEFOLD|NOTADR|BANG|FILE1|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'wall', 'pat': '^wa\%[ll]$', 'flags': 'BANG|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'while', 'pat': '^wh\%[ile]$', 'flags': 'EXTRA|NOTRLCOM|SBOXOK|CMDWIN', 'parser': 'parse_cmd_while'},
      \ {'name': 'winsize', 'pat': '^wi\%[nsize]$', 'flags': 'EXTRA|NEEDARG|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'wincmd', 'pat': '^winc\%[md]$', 'flags': 'NEEDARG|WORD1|RANGE|NOTADR', 'parser': 'parse_cmd_common'},
      \ {'name': 'winpos', 'pat': '^winp\%[os]$', 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'wnext', 'pat': '^wn\%[ext]$', 'flags': 'RANGE|NOTADR|BANG|FILE1|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'wprevious', 'pat': '^wp\%[revious]$', 'flags': 'RANGE|NOTADR|BANG|FILE1|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'wq', 'pat': '^wq$', 'flags': 'RANGE|WHOLEFOLD|BANG|FILE1|ARGOPT|DFLALL|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'wqall', 'pat': '^wqa\%[ll]$', 'flags': 'BANG|FILE1|ARGOPT|DFLALL|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'wsverb', 'pat': '^ws\%[verb]$', 'flags': 'EXTRA|NOTADR|NEEDARG', 'parser': 'parse_cmd_common'},
      \ {'name': 'wundo', 'pat': '^wu\%[ndo]$', 'flags': 'BANG|NEEDARG|FILE1', 'parser': 'parse_cmd_common'},
      \ {'name': 'wviminfo', 'pat': '^wv\%[iminfo]$', 'flags': 'BANG|FILE1|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'xit', 'pat': '^x\%[it]$', 'flags': 'RANGE|WHOLEFOLD|BANG|FILE1|ARGOPT|DFLALL|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'xall', 'pat': '^xa\%[ll]$', 'flags': 'BANG|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'xmapclear', 'pat': '^xmapc\%[lear]$', 'flags': 'EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'xmap', 'pat': '^xm\%[ap]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'xmenu', 'pat': '^xme\%[nu]$', 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'xnoremap', 'pat': '^xn\%[oremap]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'xnoremenu', 'pat': '^xnoreme\%[nu]$', 'flags': 'RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'xunmap', 'pat': '^xu\%[nmap]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'xunmenu', 'pat': '^xunme\%[nu]$', 'flags': 'EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'yank', 'pat': '^y\%[ank]$', 'flags': 'RANGE|WHOLEFOLD|REGSTR|COUNT|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'z', 'pat': '^z$', 'flags': 'RANGE|WHOLEFOLD|EXTRA|EXFLAGS|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': '!', 'pat': '^!$', 'flags': 'RANGE|WHOLEFOLD|BANG|FILES|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': '#', 'pat': '^#$', 'flags': 'RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': '&', 'pat': '^&$', 'flags': 'RANGE|WHOLEFOLD|EXTRA|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': '*', 'pat': '^\*$', 'flags': 'RANGE|WHOLEFOLD|EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': '<', 'pat': '^<$', 'flags': 'RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': '=', 'pat': '^=$', 'flags': 'RANGE|TRLBAR|DFLALL|EXFLAGS|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': '>', 'pat': '^>$', 'flags': 'RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \ {'name': '@', 'pat': '^@$', 'flags': 'RANGE|WHOLEFOLD|EXTRA|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'Next', 'pat': '^N\%[ext]$', 'flags': 'EXTRA|RANGE|NOTADR|COUNT|BANG|EDITCMD|ARGOPT|TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': 'Print', 'pat': '^P\%[rint]$', 'flags': 'RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN', 'parser': 'parse_cmd_common'},
      \ {'name': 'X', 'pat': '^X$', 'flags': 'TRLBAR', 'parser': 'parse_cmd_common'},
      \ {'name': '~', 'pat': '^\~$', 'flags': 'RANGE|WHOLEFOLD|EXTRA|CMDWIN|MODIFY', 'parser': 'parse_cmd_common'},
      \]

let s:ExprTokenizer = {}

function s:ExprTokenizer.new(...)
  let obj = copy(self)
  call call(obj.__init__, a:000, obj)
  return obj
endfunction

function s:ExprTokenizer.__init__(reader)
  let self.reader = a:reader
  let self.cache = {}
endfunction

function s:ExprTokenizer.err(...)
  let pos = self.reader.getpos()
  if len(a:000) == 1
    let msg = a:000[0]
  else
    let msg = call('printf', a:000)
  endif
  return printf('%s: line %d col %d', msg, pos.lnum, pos.col)
endfunction

function s:ExprTokenizer.token(type, value)
  return {'type': a:type, 'value': a:value}
endfunction

function s:ExprTokenizer.peek()
  let pos = self.reader.getpos()
  let r = self.get()
  call self.reader.setpos(pos)
  return r
endfunction

function s:ExprTokenizer.get()
  while 1
    let r = self.get_keepspace()
    if r.type != s:TOKEN_SPACE
      return r
    endif
  endwhile
endfunction

function s:ExprTokenizer.peek_keepspace()
  let pos = self.reader.getpos()
  let r = self.get_keepspace()
  call self.reader.setpos(pos)
  return r
endfunction

function s:ExprTokenizer.get_keepspace()
  " FIXME: remove dirty hack
  if has_key(self.cache, self.reader.i)
    let x = self.cache[self.reader.i]
    let self.reader.i = x[0]
    return x[1]
  endif
  let i = self.reader.i
  let r = self.get_keepspace2()
  let self.cache[i] = [self.reader.i, r]
  return r
endfunction

function s:ExprTokenizer.get_keepspace2()
  let c = self.reader.peek()
  let s = self.reader.peekn(10)
  if c ==# '<EOF>'
    return self.token(s:TOKEN_EOF, c)
  elseif c ==# '<EOL>'
    call self.reader.get()
    return self.token(s:TOKEN_EOL, c)
  elseif s =~# '^\s'
    let s = ''
    while self.reader.peekn(1) =~# '\s'
      let s .= self.reader.getn(1)
    endwhile
    return self.token(s:TOKEN_SPACE, s)
  elseif s =~# '^0x\x'
    let s = self.reader.getn(3)
    while self.reader.peekn(1) =~# '\x'
      let s .= self.reader.getn(1)
    endwhile
    return self.token(s:TOKEN_NUMBER, s)
  elseif s =~# '^\d'
    let s = ''
    while self.reader.peekn(1) =~# '\d'
      let s .= self.reader.getn(1)
    endwhile
    if self.reader.peekn(2) =~# '\.\d'
      let s .= self.reader.getn(1)
      while self.reader.peekn(1) =~# '\d'
        let s .= self.reader.getn(1)
      endwhile
      if self.reader.peekn(3) =~# '[Ee][-+]\d'
        let s .= self.reader.getn(3)
        while self.reader.peekn(1) =~# '\d'
          let s .= self.reader.getn(1)
        endwhile
      endif
    endif
    return self.token(s:TOKEN_NUMBER, s)
  elseif s =~# '^is#'
    call self.reader.getn(3)
    return self.token(s:TOKEN_ISH, 'is#')
  elseif s=~# '^is?'
    call self.reader.getn(3)
    return self.token(s:TOKEN_ISQ, 'is?')
  elseif s =~# '^isnot#'
    call self.reader.getn(6)
    return self.token(s:TOKEN_ISNOTH, 'is#')
  elseif s =~# '^isnot?'
    call self.reader.getn(6)
    return self.token(s:TOKEN_ISNOTQ, 'is?')
  elseif s =~# '^is\>'
    call self.reader.getn(2)
    return self.token(s:TOKEN_IS, 'is')
  elseif s =~# '^isnot\>'
    call self.reader.getn(5)
    return self.token(s:TOKEN_ISNOT, 'isnot')
  elseif s =~# '^<[Ss][Ii][Dd]>\h'
    let s = self.reader.getn(6)
    while self.reader.peekn(1) =~# '\w\|[:#]'
      let s .= self.reader.getn(1)
    endwhile
    return self.token(s:TOKEN_IDENTIFIER, s)
  elseif s =~# '^\h'
    let s = self.reader.getn(1)
    while self.reader.peekn(1) =~# '\w\|[:#]'
      let s .= self.reader.getn(1)
    endwhile
    return self.token(s:TOKEN_IDENTIFIER, s)
  elseif s =~# '^==?'
    call self.reader.getn(3)
    return self.token(s:TOKEN_EQEQQ, '==?')
  elseif s =~# '^==#'
    call self.reader.getn(3)
    return self.token(s:TOKEN_EQEQH, '==#')
  elseif s =~# '^!=?'
    call self.reader.getn(3)
    return self.token(s:TOKEN_NOTEQQ, '!=?')
  elseif s =~# '^!=#'
    call self.reader.getn(3)
    return self.token(s:TOKEN_NOTEQH, '!=#')
  elseif s =~# '^>=?'
    call self.reader.getn(3)
    return self.token(s:TOKEN_GTEQQ, '>=?')
  elseif s =~# '^>=#'
    call self.reader.getn(3)
    return self.token(s:TOKEN_GTEQH, '>=#')
  elseif s =~# '^<=?'
    call self.reader.getn(3)
    return self.token(s:TOKEN_LTEQQ, '<=?')
  elseif s =~# '^<=#'
    call self.reader.getn(3)
    return self.token(s:TOKEN_LTEQH, '<=#')
  elseif s =~# '^=\~?'
    call self.reader.getn(3)
    return self.token(s:TOKEN_EQTILDQ, '=\~?')
  elseif s =~# '^=\~#'
    call self.reader.getn(3)
    return self.token(s:TOKEN_EQTILDH, '=\~#')
  elseif s =~# '^!\~?'
    call self.reader.getn(3)
    return self.token(s:TOKEN_NOTTILDQ, '!\~?')
  elseif s =~# '^!\~#'
    call self.reader.getn(3)
    return self.token(s:TOKEN_NOTTILDH, '!\~#')
  elseif s =~# '^>?'
    call self.reader.getn(2)
    return self.token(s:TOKEN_GTQ, '>?')
  elseif s =~# '^>#'
    call self.reader.getn(2)
    return self.token(s:TOKEN_GTH, '>#')
  elseif s =~# '^<?'
    call self.reader.getn(2)
    return self.token(s:TOKEN_LTQ, '<?')
  elseif s =~# '^<#'
    call self.reader.getn(2)
    return self.token(s:TOKEN_LTH, '<#')
  elseif s =~# '^||'
    call self.reader.getn(2)
    return self.token(s:TOKEN_OROR, '||')
  elseif s =~# '^&&'
    call self.reader.getn(2)
    return self.token(s:TOKEN_ANDAND, '&&')
  elseif s =~# '^=='
    call self.reader.getn(2)
    return self.token(s:TOKEN_EQEQ, '==')
  elseif s =~# '^!='
    call self.reader.getn(2)
    return self.token(s:TOKEN_NOTEQ, '!=')
  elseif s =~# '^>='
    call self.reader.getn(2)
    return self.token(s:TOKEN_GTEQ, '>=')
  elseif s =~# '^<='
    call self.reader.getn(2)
    return self.token(s:TOKEN_LTEQ, '<=')
  elseif s =~# '^=\~'
    call self.reader.getn(2)
    return self.token(s:TOKEN_EQTILD, '=\~')
  elseif s =~# '^!\~'
    call self.reader.getn(2)
    return self.token(s:TOKEN_NOTTILD, '!\~')
  elseif s =~# '^>'
    call self.reader.getn(1)
    return self.token(s:TOKEN_GT, '>')
  elseif s =~# '^<'
    call self.reader.getn(1)
    return self.token(s:TOKEN_LT, '<')
  elseif s =~# '^+'
    call self.reader.getn(1)
    return self.token(s:TOKEN_PLUS, '+')
  elseif s =~# '^-'
    call self.reader.getn(1)
    return self.token(s:TOKEN_MINUS, '-')
  elseif s =~# '^\.'
    call self.reader.getn(1)
    return self.token(s:TOKEN_DOT, '.')
  elseif s =~# '^\*'
    call self.reader.getn(1)
    return self.token(s:TOKEN_STAR, '*')
  elseif s =~# '^/'
    call self.reader.getn(1)
    return self.token(s:TOKEN_SLASH, '/')
  elseif s =~# '^%'
    call self.reader.getn(1)
    return self.token(s:TOKEN_PER, '%')
  elseif s =~# '^!'
    call self.reader.getn(1)
    return self.token(s:TOKEN_NOT, '!')
  elseif s =~# '^?'
    call self.reader.getn(1)
    return self.token(s:TOKEN_QUESTION, '?')
  elseif s =~# '^:'
    call self.reader.getn(1)
    return self.token(s:TOKEN_COLON, ':')
  elseif s =~# '^('
    call self.reader.getn(1)
    return self.token(s:TOKEN_LPAR, '(')
  elseif s =~# '^)'
    call self.reader.getn(1)
    return self.token(s:TOKEN_RPAR, ')')
  elseif s =~# '^\['
    call self.reader.getn(1)
    return self.token(s:TOKEN_LBRA, '[')
  elseif s =~# '^]'
    call self.reader.getn(1)
    return self.token(s:TOKEN_RBRA, ']')
  elseif s =~# '^{'
    call self.reader.getn(1)
    return self.token(s:TOKEN_LBPAR, '{')
  elseif s =~# '^}'
    call self.reader.getn(1)
    return self.token(s:TOKEN_RBPAR, '}')
  elseif s =~# '^,'
    call self.reader.getn(1)
    return self.token(s:TOKEN_COMMA, ',')
  elseif s =~# "^'"
    call self.reader.getn(1)
    return self.token(s:TOKEN_SQUOTE, "'")
  elseif s =~# '^"'
    call self.reader.getn(1)
    return self.token(s:TOKEN_DQUOTE, '"')
  elseif s =~# '^\$\w\+'
    let s = self.reader.getn(1)
    while self.reader.peekn(1) =~# '\w'
      let s .= self.reader.getn(1)
    endwhile
    return self.token(s:TOKEN_ENV, s)
  elseif s =~# '^@.'
    return self.token(s:TOKEN_REG, self.reader.getn(2))
  elseif s =~# '^&\(g:\|l:\|\w\w\)'
    let s = self.reader.getn(3)
    while self.reader.peekn(1) =~# '\w'
      let s .= self.reader.getn(1)
    endwhile
    return self.token(s:TOKEN_OPTION, s)
  elseif s =~# '^='
    call self.reader.getn(1)
    return self.token(s:TOKEN_EQ, '=')
  elseif s =~# '^|'
    call self.reader.getn(1)
    return self.token(s:TOKEN_OR, '|')
  elseif s =~# '^;'
    call self.reader.getn(1)
    return self.token(s:TOKEN_SEMICOLON, ';')
  elseif s =~# '^`'
    call self.reader.getn(1)
    return self.token(s:TOKEN_BACKTICK, '`')
  else
    throw self.err('ExprTokenizer: %s', s)
  endif
endfunction

function s:ExprTokenizer.get_sstring()
  let s = ''
  while self.reader.peekn(1) =~# '\s'
    call self.reader.getn(1)
  endwhile
  let c = self.reader.getn(1)
  if c !=# "'"
    throw sefl.err('ExprTokenizer: unexpected character: %s', c)
  endif
  while 1
    let c = self.reader.getn(1)
    if c ==# ''
      throw self.err('ExprTokenizer: unexpected EOL')
    elseif c ==# "'"
      if self.reader.peekn(1) ==# "'"
        call self.reader.getn(1)
        let s .= c
      else
        break
      endif
    else
      let s .= c
    endif
  endwhile
  return s
endfunction

function s:ExprTokenizer.get_dstring()
  let s = ''
  while self.reader.peekn(1) =~# '\s'
    call self.reader.getn(1)
  endwhile
  let c = self.reader.getn(1)
  if c !=# '"'
    throw self.err('ExprTokenizer: unexpected character: %s', c)
  endif
  while 1
    let c = self.reader.getn(1)
    if c ==# ''
      throw self.err('ExprTokenizer: unexpectd EOL')
    elseif c ==# '"'
      break
    elseif c ==# '\'
      let s .= c
      let c = self.reader.getn(1)
      if c ==# ''
        throw self.err('ExprTokenizer: unexpected EOL')
      endif
      let s .= c
    else
      let s .= c
    endif
  endwhile
  return s
endfunction

let s:ExprParser = {}

function s:ExprParser.new(...)
  let obj = copy(self)
  call call(obj.__init__, a:000, obj)
  return obj
endfunction

function s:ExprParser.__init__(tokenizer)
  let self.tokenizer = a:tokenizer
endfunction

function s:ExprParser.err(...)
  let pos = self.tokenizer.reader.getpos()
  if len(a:000) == 1
    let msg = a:000[0]
  else
    let msg = call('printf', a:000)
  endif
  return printf('%s: line %d col %d', msg, pos.lnum, pos.col)
endfunction

function s:ExprParser.exprnode(type)
  return {'type': a:type}
endfunction

function s:ExprParser.parse()
  return self.parse_expr1()
endfunction

" expr1: expr2 ? expr1 : expr1
function s:ExprParser.parse_expr1()
  let lhs = self.parse_expr2()
  let token = self.tokenizer.peek()
  if token.type == s:TOKEN_QUESTION
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_CONDEXP)
    let node.cond = lhs
    let node.then = self.parse_expr1()
    let token = self.tokenizer.peek()
    if token.type != s:TOKEN_COLON
      throw self.err('ExprParser: unexpected token: %s', token.value)
    endif
    call self.tokenizer.get()
    let node.else = self.parse_expr1()
    let lhs = node
  endif
  return lhs
endfunction

" expr2: expr3 || expr3 ..
function s:ExprParser.parse_expr2()
  let lhs = self.parse_expr3()
  let token = self.tokenizer.peek()
  while token.type == s:TOKEN_OROR
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_LOGOR)
    let node.lhs = lhs
    let node.rhs = self.parse_expr3()
    let lhs = node
    let token = self.tokenizer.peek()
  endwhile
  return lhs
endfunction

" expr3: expr4 && expr4
function s:ExprParser.parse_expr3()
  let lhs = self.parse_expr4()
  let token = self.tokenizer.peek()
  while token.type == s:TOKEN_ANDAND
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_LOGAND)
    let node.lhs = lhs
    let node.rhs = self.parse_expr4()
    let lhs = node
    let token = self.tokenizer.peek()
  endwhile
  return lhs
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
"        expr5 ==?  expr5
"        expr5 ==# expr5
"        etc.
"
"        expr5 is expr5
"        expr5 isnot expr5
function s:ExprParser.parse_expr4()
  let lhs = self.parse_expr5()
  let token = self.tokenizer.peek()
  if token.type == s:TOKEN_EQEQQ
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_EQEQQ)
    let node.lhs = lhs
    let node.rhs = self.parse_expr5()
    let lhs = node
  elseif token.type == s:TOKEN_EQEQH
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_EQEQH)
    let node.lhs = lhs
    let node.rhs = self.parse_expr5()
    let lhs = node
  elseif token.type == s:TOKEN_NOTEQQ
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_NOTEQQ)
    let node.lhs = lhs
    let node.rhs = self.parse_expr5()
    let lhs = node
  elseif token.type == s:TOKEN_NOTEQH
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_NOTEQH)
    let node.lhs = lhs
    let node.rhs = self.parse_expr5()
    let lhs = node
  elseif token.type == s:TOKEN_GTEQQ
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_GTEQQ)
    let node.lhs = lhs
    let node.rhs = self.parse_expr5()
    let lhs = node
  elseif token.type == s:TOKEN_GTEQH
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_GTEQH)
    let node.lhs = lhs
    let node.rhs = self.parse_expr5()
    let lhs = node
  elseif token.type == s:TOKEN_LTEQQ
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_LTEQQ)
    let node.lhs = lhs
    let node.rhs = self.parse_expr5()
    let lhs = node
  elseif token.type == s:TOKEN_LTEQH
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_LTEQH)
    let node.lhs = lhs
    let node.rhs = self.parse_expr5()
    let lhs = node
  elseif token.type == s:TOKEN_EQTILDQ
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_EQTILDQ)
    let node.lhs = lhs
    let node.rhs = self.parse_expr5()
    let lhs = node
  elseif token.type == s:TOKEN_EQTILDH
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_EQTILDH)
    let node.lhs = lhs
    let node.rhs = self.parse_expr5()
    let lhs = node
  elseif token.type == s:TOKEN_NOTTILDQ
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_NOTTILDQ)
    let node.lhs = lhs
    let node.rhs = self.parse_expr5()
    let lhs = node
  elseif token.type == s:TOKEN_NOTTILDH
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_NOTTILDH)
    let node.lhs = lhs
    let node.rhs = self.parse_expr5()
    let lhs = node
  elseif token.type == s:TOKEN_GTQ
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_GTQ)
    let node.lhs = lhs
    let node.rhs = self.parse_expr5()
    let lhs = node
  elseif token.type == s:TOKEN_GTH
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_GTH)
    let node.lhs = lhs
    let node.rhs = self.parse_expr5()
    let lhs = node
  elseif token.type == s:TOKEN_LTQ
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_LTQ)
    let node.lhs = lhs
    let node.rhs = self.parse_expr5()
    let lhs = node
  elseif token.type == s:TOKEN_LTH
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_LTH)
    let node.lhs = lhs
    let node.rhs = self.parse_expr5()
    let lhs = node
  elseif token.type == s:TOKEN_EQEQ
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_EQEQ)
    let node.lhs = lhs
    let node.rhs = self.parse_expr5()
    let lhs = node
  elseif token.type == s:TOKEN_NOTEQ
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_NOTEQ)
    let node.lhs = lhs
    let node.rhs = self.parse_expr5()
    let lhs = node
  elseif token.type == s:TOKEN_GTEQ
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_GTEQ)
    let node.lhs = lhs
    let node.rhs = self.parse_expr5()
    let lhs = node
  elseif token.type == s:TOKEN_LTEQ
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_LTEQ)
    let node.lhs = lhs
    let node.rhs = self.parse_expr5()
    let lhs = node
  elseif token.type == s:TOKEN_EQTILD
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_EQTILD)
    let node.lhs = lhs
    let node.rhs = self.parse_expr5()
    let lhs = node
  elseif token.type == s:TOKEN_NOTTILD
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_NOTTILD)
    let node.lhs = lhs
    let node.rhs = self.parse_expr5()
    let lhs = node
  elseif token.type == s:TOKEN_GT
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_GT)
    let node.lhs = lhs
    let node.rhs = self.parse_expr5()
    let lhs = node
  elseif token.type == s:TOKEN_LT
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_LT)
    let node.lhs = lhs
    let node.rhs = self.parse_expr5()
    let lhs = node
  elseif token.type == s:TOKEN_ISH
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_ISH)
    let node.lhs = lhs
    let node.rhs = self.parse_expr5()
    let lhs = node
  elseif token.type == s:TOKEN_ISQ
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_ISQ)
    let node.lhs = lhs
    let node.rhs = self.parse_expr5()
    let lhs = node
  elseif token.type == s:TOKEN_ISNOTH
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_ISNOTH)
    let node.lhs = lhs
    let node.rhs = self.parse_expr5()
    let lhs = node
  elseif token.type == s:TOKEN_ISNOTQ
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_ISNOTQ)
    let node.lhs = lhs
    let node.rhs = self.parse_expr5()
    let lhs = node
  elseif token.type == s:TOKEN_IS
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_IS)
    let node.lhs = lhs
    let node.rhs = self.parse_expr5()
    let lhs = node
  elseif token.type == s:TOKEN_ISNOT
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_ISNOT)
    let node.lhs = lhs
    let node.rhs = self.parse_expr5()
    let lhs = node
  endif
  return lhs
endfunction

" expr5: expr6 + expr6 ..
"        expr6 - expr6 ..
"        expr6 . expr6 ..
function s:ExprParser.parse_expr5()
  let lhs = self.parse_expr6()
  while 1
    let token = self.tokenizer.peek()
    if token.type == s:TOKEN_PLUS
      call self.tokenizer.get()
      let node = self.exprnode(s:NODE_ADD)
      let node.lhs = lhs
      let node.rhs = self.parse_expr6()
      let lhs = node
    elseif token.type == s:TOKEN_MINUS
      call self.tokenizer.get()
      let node = self.exprnode(s:NODE_SUB)
      let node.lhs = lhs
      let node.rhs = self.parse_expr6()
      let lhs = node
    elseif token.type == s:TOKEN_DOT
      call self.tokenizer.get()
      let node = self.exprnode(s:NODE_CONCAT)
      let node.lhs = lhs
      let node.rhs = self.parse_expr6()
      let lhs = node
    else
      break
    endif
  endwhile
  return lhs
endfunction

" expr6: expr7 * expr7 ..
"        expr7 / expr7 ..
"        expr7 % expr7 ..
function s:ExprParser.parse_expr6()
  let lhs = self.parse_expr7()
  while 1
    let token = self.tokenizer.peek()
    if token.type == s:TOKEN_STAR
      call self.tokenizer.get()
      let node = self.exprnode(s:NODE_MUL)
      let node.lhs = lhs
      let node.rhs = self.parse_expr7()
      let lhs = node
    elseif token.type == s:TOKEN_SLASH
      call self.tokenizer.get()
      let node = self.exprnode(s:NODE_DIV)
      let node.lhs = lhs
      let node.rhs = self.parse_expr7()
      let lhs = node
    elseif token.type == s:TOKEN_PER
      call self.tokenizer.get()
      let node = self.exprnode(s:NODE_MOD)
      let node.lhs = lhs
      let node.rhs = self.parse_expr7()
      let lhs = node
    else
      break
    endif
  endwhile
  return lhs
endfunction

" expr7: ! expr7
"        - expr7
"        + expr7
function s:ExprParser.parse_expr7()
  let token = self.tokenizer.peek()
  if token.type == s:TOKEN_NOT
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_NOT)
    let node.expr = self.parse_expr7()
  elseif token.type == s:TOKEN_MINUS
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_MINUS)
    let node.expr = self.parse_expr7()
  elseif token.type == s:TOKEN_PLUS
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_PLUS)
    let node.expr = self.parse_expr7()
  else
    let node = self.parse_expr8()
  endif
  return node
endfunction

" expr8: expr8[expr1]
"        expr8[expr1 : expr1]
"        expr8.name
"        expr8(expr1, ...)
function s:ExprParser.parse_expr8()
  let lhs = self.parse_expr9()
  while 1
    let token = self.tokenizer.peek()
    let token2 = self.tokenizer.peek_keepspace()
    if token2.type == s:TOKEN_LBRA
      call self.tokenizer.get()
      if self.tokenizer.peek().type == s:TOKEN_COLON
        call self.tokenizer.get()
        let node = self.exprnode(s:NODE_SLICE)
        let node.expr = lhs
        let node.expr1 = s:NIL
        let node.expr2 = s:NIL
        let token = self.tokenizer.peek()
        if token.type != s:TOKEN_RBRA
          let node.expr2 = self.parse_expr1()
        endif
        let token = self.tokenizer.peek()
        if token.type != s:TOKEN_RBRA
          throw self.err('ExprParser: unexpected token: %s', token.value)
        endif
        call self.tokenizer.get()
      else
        let expr1 = self.parse_expr1()
        if self.tokenizer.peek().type == s:TOKEN_COLON
          call self.tokenizer.get()
          let node = self.exprnode(s:NODE_SLICE)
          let node.expr = lhs
          let node.expr1 = expr1
          let node.expr2 = s:NIL
          let token = self.tokenizer.peek()
          if token.type != s:TOKEN_RBRA
            let node.expr2 = self.parse_expr1()
          endif
          let token = self.tokenizer.peek()
          if token.type != s:TOKEN_RBRA
            throw self.err('ExprParser: unexpected token: %s', token.value)
          endif
          call self.tokenizer.get()
        else
          let node = self.exprnode(s:NODE_INDEX)
          let node.expr = lhs
          let node.expr1 = expr1
          let token = self.tokenizer.peek()
          if token.type != s:TOKEN_RBRA
            throw self.err('ExprParser: unexpected token: %s', token.value)
          endif
          call self.tokenizer.get()
        endif
      endif
      let lhs = node
    elseif token.type == s:TOKEN_LPAR
      call self.tokenizer.get()
      let node = self.exprnode(s:NODE_CALL)
      let node.expr = lhs
      let node.args = []
      if self.tokenizer.peek().type == s:TOKEN_RPAR
        call self.tokenizer.get()
      else
        while 1
          call add(node.args, self.parse_expr1())
          let token = self.tokenizer.peek()
          if token.type == s:TOKEN_COMMA
            call self.tokenizer.get()
          elseif token.type == s:TOKEN_RPAR
            call self.tokenizer.get()
            break
          else
            throw self.err('ExprParser: unexpected token: %s', token.value)
          endif
        endwhile
      endif
      let lhs = node
    elseif token2.type == s:TOKEN_DOT
      " INDEX or CONCAT
      let pos = self.tokenizer.reader.getpos()
      call self.tokenizer.get()
      let token2 = self.tokenizer.peek_keepspace()
      if token2.type == s:TOKEN_IDENTIFIER
        let rhs = self.exprnode(s:NODE_IDENTIFIER)
        let rhs.value = self.parse_identifier()
        let node = self.exprnode(s:NODE_DOT)
        let node.lhs = lhs
        let node.rhs = rhs
      else
        " to be CONCAT
        call self.tokenizer.reader.setpos(pos)
        break
      endif
      let lhs = node
    else
      break
    endif
  endwhile
  return lhs
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
function s:ExprParser.parse_expr9()
  let token = self.tokenizer.peek()
  if token.type == s:TOKEN_NUMBER
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_NUMBER)
    let node.value = token.value
  elseif token.type == s:TOKEN_DQUOTE
    let node = self.exprnode(s:NODE_STRING)
    let node.value = '"' . self.tokenizer.get_dstring() . '"'
  elseif token.type == s:TOKEN_SQUOTE
    let node = self.exprnode(s:NODE_STRING)
    let node.value = "'" . self.tokenizer.get_sstring() . "'"
  elseif token.type == s:TOKEN_LBRA
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_LIST)
    let node.items = []
    let token = self.tokenizer.peek()
    if token.type == s:TOKEN_RBRA
      call self.tokenizer.get()
    else
      while 1
        call add(node.items, self.parse_expr1())
        let token = self.tokenizer.peek()
        if token.type == s:TOKEN_COMMA
          call self.tokenizer.get()
          if self.tokenizer.peek().type == s:TOKEN_RBRA
            call self.tokenizer.get()
            break
          endif
        elseif token.type == s:TOKEN_RBRA
          call self.tokenizer.get()
          break
        else
          throw self.err('ExprParser: unexpected token: %s', token.value)
        endif
      endwhile
    endif
  elseif token.type == s:TOKEN_LBPAR
    let pos = self.tokenizer.reader.getpos()
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_DICT)
    let node.items = []
    let token = self.tokenizer.peek()
    if token.type == s:TOKEN_RBPAR
      call self.tokenizer.get()
    else
      while 1
        let key = self.parse_expr1()
        let token = self.tokenizer.get()
        if token.type == s:TOKEN_RBPAR
          if !empty(node.items)
            throw self.err('ExprParser: unexpected token: %s', token.value)
          endif
          call self.tokenizer.reader.setpos(pos)
          let node = self.exprnode(s:NODE_IDENTIFIER)
          let node.value = self.parse_identifier()
          break
        endif
        if token.type != s:TOKEN_COLON
          throw self.err('ExprParser: unexpected token: %s', token.value)
        endif
        let val = self.parse_expr1()
        call add(node.items, [key, val])
        let token = self.tokenizer.peek()
        if token.type == s:TOKEN_COMMA
          call self.tokenizer.get()
          if self.tokenizer.peek().type == s:TOKEN_RBPAR
            call self.tokenizer.get()
            break
          endif
        elseif token.type == s:TOKEN_RBPAR
          call self.tokenizer.get()
          break
        else
          throw self.err('ExprParser: unexpected token: %s', token.value)
        endif
      endwhile
    endif
  elseif token.type == s:TOKEN_LPAR
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_NESTING)
    let node.expr = self.parse_expr1()
    let token = self.tokenizer.get()
    if token.type != s:TOKEN_RPAR
      throw self.err('ExprParser: unexpected token: %s', token.value)
    endif
  elseif token.type == s:TOKEN_OPTION
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_OPTION)
    let node.value = token.value
  elseif token.type == s:TOKEN_IDENTIFIER
    let node = self.exprnode(s:NODE_IDENTIFIER)
    let node.value = self.parse_identifier()
  elseif token.type == s:TOKEN_ENV
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_ENV)
    let node.value = token.value
  elseif token.type == s:TOKEN_REG
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_REG)
    let node.value = token.value
  else
    throw self.err('ExprParser: unexpected token: %s', token.value)
  endif
  return node
endfunction

function s:ExprParser.parse_identifier()
  let id = []
  let token = self.tokenizer.peek()
  while 1
    if token.type == s:TOKEN_IDENTIFIER
      call self.tokenizer.get()
      call add(id, {'curly': 0, 'value': token.value})
    elseif token.type == s:TOKEN_LBPAR
      call self.tokenizer.get()
      let node = self.parse_expr1()
      let token = self.tokenizer.get()
      if token.type != s:TOKEN_RBPAR
        throw self.err('ExprParser: unexpected token: %s', token.value)
      endif
      call add(id, {'curly': 1, 'value': node})
    else
      break
    endif
    let token = self.tokenizer.peek_keepspace()
  endwhile
  return id
endfunction

let s:LvalueParser = copy(s:ExprParser)

function! s:LvalueParser.parse()
  return self.parse_lv8()
endfunction

" expr8: expr8[expr1]
"        expr8[expr1 : expr1]
"        expr8.name
function! s:LvalueParser.parse_lv8()
  let lhs = self.parse_lv9()
  while 1
    let token = self.tokenizer.peek()
    let token2 = self.tokenizer.peek_keepspace()
    if token2.type == s:TOKEN_LBRA
      call self.tokenizer.get()
      if self.tokenizer.peek().type == s:TOKEN_COLON
        call self.tokenizer.get()
        let node = self.exprnode(s:NODE_SLICE)
        let node.expr = lhs
        let node.expr1 = s:NIL
        let node.expr2 = s:NIL
        let token = self.tokenizer.peek()
        if token.type != s:TOKEN_RBRA
          let node.expr2 = self.parse_expr1()
        endif
        let token = self.tokenizer.peek()
        if token.type != s:TOKEN_RBRA
          throw self.err('LvalueParser: unexpected token: %s', token.value)
        endif
        call self.tokenizer.get()
      else
        let expr1 = self.parse_expr1()
        if self.tokenizer.peek().type == s:TOKEN_COLON
          call self.tokenizer.get()
          let node = self.exprnode(s:NODE_SLICE)
          let node.expr = lhs
          let node.expr1 = expr1
          let node.expr2 = s:NIL
          let token = self.tokenizer.peek()
          if token.type != s:TOKEN_RBRA
            let node.expr2 = self.parse_expr1()
          endif
          let token = self.tokenizer.peek()
          if token.type != s:TOKEN_RBRA
            throw self.err('LvalueParser: unexpected token: %s', token.value)
          endif
          call self.tokenizer.get()
        else
          let node = self.exprnode(s:NODE_INDEX)
          let node.expr = lhs
          let node.expr1 = expr1
          let token = self.tokenizer.peek()
          if token.type != s:TOKEN_RBRA
            throw self.err('LvalueParser: unexpected token: %s', token.value)
          endif
          call self.tokenizer.get()
        endif
      endif
      let lhs = node
    elseif token2.type == s:TOKEN_DOT
      " INDEX or CONCAT
      let pos = self.tokenizer.reader.getpos()
      call self.tokenizer.get()
      let token2 = self.tokenizer.peek_keepspace()
      if token2.type == s:TOKEN_IDENTIFIER
        let rhs = self.exprnode(s:NODE_IDENTIFIER)
        let rhs.value = self.parse_identifier()
        let node = self.exprnode(s:NODE_DOT)
        let node.lhs = lhs
        let node.rhs = rhs
      else
        " to be CONCAT
        call self.tokenizer.reader.setpos(pos)
        break
      endif
      let lhs = node
    else
      break
    endif
  endwhile
  return lhs
endfunction

" expr9: &option
"        variable
"        var{ria}ble
"        $VAR
"        @r
function! s:LvalueParser.parse_lv9()
  let token = self.tokenizer.peek()
  if token.type == s:TOKEN_LBPAR
    let node = self.exprnode(s:NODE_IDENTIFIER)
    let node.value = self.parse_identifier()
  elseif token.type == s:TOKEN_OPTION
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_OPTION)
    let node.value = token.value
  elseif token.type == s:TOKEN_IDENTIFIER
    let node = self.exprnode(s:NODE_IDENTIFIER)
    let node.value = self.parse_identifier()
  elseif token.type == s:TOKEN_ENV
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_ENV)
    let node.value = token.value
  elseif token.type == s:TOKEN_REG
    call self.tokenizer.get()
    let node = self.exprnode(s:NODE_REG)
    let node.value = token.value
  else
    throw self.err('LvalueParser: unexpected token: %s', token.value)
  endif
  return node
endfunction

let s:StringReader = {}

function s:StringReader.new(...)
  let obj = copy(self)
  call call(obj.__init__, a:000, obj)
  return obj
endfunction

function s:StringReader.__init__(lines)
  let self.lines = a:lines
  let self.buf = []
  let self.pos = []
  let lnum = 0
  while lnum < len(a:lines)
    let col = 0
    for c in split(a:lines[lnum], '\zs')
      call add(self.buf, c)
      call add(self.pos, [lnum + 1, col + 1])
      let col += len(c)
    endfor
    while lnum + 1 < len(a:lines) && a:lines[lnum + 1] =~# '^\s*\\'
      let skip = 1
      let col = 0
      for c in split(a:lines[lnum + 1], '\zs')
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

function s:StringReader.peek()
  if self.i >= len(self.buf)
    return '<EOF>'
  endif
  return self.buf[self.i]
endfunction

function s:StringReader.get()
  if self.i >= len(self.buf)
    return '<EOF>'
  endif
  let self.i += 1
  return self.buf[self.i - 1]
endfunction

function s:StringReader.peekn(n)
  let pos = self.getpos()
  let r = self.getn(a:n)
  call self.setpos(pos)
  return r
endfunction

function s:StringReader.getn(n)
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

function s:StringReader.peekline()
  return self.peekn(-1)
endfunction

function s:StringReader.readline()
  let r = self.getn(-1)
  call self.get()
  return r
endfunction

function s:StringReader.getstr(begin, end)
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

function s:StringReader.getpos()
  let [lnum, col] = self.pos[self.i]
  return {'i': self.i, 'lnum': lnum, 'col': col}
endfunction

function s:StringReader.setpos(pos)
  let self.i  = a:pos.i
endfunction

let s:Compiler = {}

function s:Compiler.new(...)
  let obj = copy(self)
  call call(obj.__init__, a:000, obj)
  return obj
endfunction

function s:Compiler.__init__()
  let self.indent = ['']
  let self.lines = []
endfunction

function s:Compiler.out(...)
  if len(a:000) == 1
    if a:000[0] =~# '^)\+$'
      let self.lines[-1] .= a:000[0]
    else
      call add(self.lines, self.indent[0] . a:000[0])
    endif
  else
    call add(self.lines, self.indent[0] . call('printf', a:000))
  endif
endfunction

function s:Compiler.incindent(s)
  call insert(self.indent, self.indent[0] . a:s)
endfunction

function s:Compiler.decindent()
  call remove(self.indent, 0)
endfunction

function s:Compiler.compile(node)
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
  elseif a:node.type == s:NODE_CONDEXP
    return self.compile_condexp(a:node)
  elseif a:node.type == s:NODE_LOGOR
    return self.compile_logor(a:node)
  elseif a:node.type == s:NODE_LOGAND
    return self.compile_logand(a:node)
  elseif a:node.type == s:NODE_EQEQQ
    return self.compile_eqeqq(a:node)
  elseif a:node.type == s:NODE_EQEQH
    return self.compile_eqeqh(a:node)
  elseif a:node.type == s:NODE_NOTEQQ
    return self.compile_noteqq(a:node)
  elseif a:node.type == s:NODE_NOTEQH
    return self.compile_noteqh(a:node)
  elseif a:node.type == s:NODE_GTEQQ
    return self.compile_gteqq(a:node)
  elseif a:node.type == s:NODE_GTEQH
    return self.compile_gteqh(a:node)
  elseif a:node.type == s:NODE_LTEQQ
    return self.compile_lteqq(a:node)
  elseif a:node.type == s:NODE_LTEQH
    return self.compile_lteqh(a:node)
  elseif a:node.type == s:NODE_EQTILDQ
    return self.compile_eqtildq(a:node)
  elseif a:node.type == s:NODE_EQTILDH
    return self.compile_eqtildh(a:node)
  elseif a:node.type == s:NODE_NOTTILDQ
    return self.compile_nottildq(a:node)
  elseif a:node.type == s:NODE_NOTTILDH
    return self.compile_nottildh(a:node)
  elseif a:node.type == s:NODE_GTQ
    return self.compile_gtq(a:node)
  elseif a:node.type == s:NODE_GTH
    return self.compile_gth(a:node)
  elseif a:node.type == s:NODE_LTQ
    return self.compile_ltq(a:node)
  elseif a:node.type == s:NODE_LTH
    return self.compile_lth(a:node)
  elseif a:node.type == s:NODE_EQEQ
    return self.compile_eqeq(a:node)
  elseif a:node.type == s:NODE_NOTEQ
    return self.compile_noteq(a:node)
  elseif a:node.type == s:NODE_GTEQ
    return self.compile_gteq(a:node)
  elseif a:node.type == s:NODE_LTEQ
    return self.compile_lteq(a:node)
  elseif a:node.type == s:NODE_EQTILD
    return self.compile_eqtild(a:node)
  elseif a:node.type == s:NODE_NOTTILD
    return self.compile_nottild(a:node)
  elseif a:node.type == s:NODE_GT
    return self.compile_gt(a:node)
  elseif a:node.type == s:NODE_LT
    return self.compile_lt(a:node)
  elseif a:node.type == s:NODE_ISQ
    return self.compile_isq(a:node)
  elseif a:node.type == s:NODE_ISH
    return self.compile_ish(a:node)
  elseif a:node.type == s:NODE_ISNOTQ
    return self.compile_isnotq(a:node)
  elseif a:node.type == s:NODE_ISNOTH
    return self.compile_isnoth(a:node)
  elseif a:node.type == s:NODE_IS
    return self.compile_is(a:node)
  elseif a:node.type == s:NODE_ISNOT
    return self.compile_isnot(a:node)
  elseif a:node.type == s:NODE_ADD
    return self.compile_add(a:node)
  elseif a:node.type == s:NODE_SUB
    return self.compile_sub(a:node)
  elseif a:node.type == s:NODE_CONCAT
    return self.compile_concat(a:node)
  elseif a:node.type == s:NODE_MUL
    return self.compile_mul(a:node)
  elseif a:node.type == s:NODE_DIV
    return self.compile_div(a:node)
  elseif a:node.type == s:NODE_MOD
    return self.compile_mod(a:node)
  elseif a:node.type == s:NODE_NOT
    return self.compile_not(a:node)
  elseif a:node.type == s:NODE_PLUS
    return self.compile_plus(a:node)
  elseif a:node.type == s:NODE_MINUS
    return self.compile_minus(a:node)
  elseif a:node.type == s:NODE_INDEX
    return self.compile_index(a:node)
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
  elseif a:node.type == s:NODE_ENV
    return self.compile_env(a:node)
  elseif a:node.type == s:NODE_REG
    return self.compile_reg(a:node)
  else
    throw self.err('Compiler: unknown node: %s', string(a:node))
  endif
endfunction

function s:Compiler.compile_body(body)
  for node in a:body
    call self.compile(node)
  endfor
endfunction

function s:Compiler.compile_begin(body)
  if len(a:body) == 1
    call self.compile_body(a:body)
  else
    call self.out('(begin')
    call self.incindent('  ')
    call self.compile_body(a:body)
    call self.out(')')
    call self.decindent()
  endif
endfunction

function s:Compiler.compile_toplevel(node)
  call self.compile_body(a:node.body)
  return self.lines
endfunction

function s:Compiler.compile_comment(node)
  call self.out(';%s', a:node.str)
endfunction

function s:Compiler.compile_excmd(node)
  call self.out('(excmd "%s")', escape(a:node.str, '\"'))
endfunction

function s:Compiler.compile_function(node)
  let name = self.compile(a:node.name)
  if !empty(a:node.args) && a:node.args[-1] ==# '...'
    let a:node.args[-1] = '. ...'
  endif
  call self.out('(function %s (%s)', name, join(a:node.args, ' '))
  call self.incindent('  ')
  call self.compile_body(a:node.body)
  call self.out(')')
  call self.decindent()
endfunction

function s:Compiler.compile_delfunction(node)
  call self.out('(delfunction %s)', self.compile(a:node.name))
endfunction

function s:Compiler.compile_return(node)
  if a:node.arg is s:NIL
    call self.out('(return)')
  else
    call self.out('(return %s)', self.compile(a:node.arg))
  endif
endfunction

function s:Compiler.compile_excall(node)
  call self.out('(call %s)', self.compile(a:node.expr))
endfunction

function s:Compiler.compile_let(node)
  let lhs = join(map(a:node.lhs.args, 'self.compile(v:val)'), ' ')
  if a:node.lhs.rest isnot s:NIL
    let lhs .= ' . ' . self.compile(a:node.lhs.rest)
  endif
  let rhs = self.compile(a:node.rhs)
  call self.out('(let %s (%s) %s)', a:node.op, lhs, rhs)
endfunction

function s:Compiler.compile_unlet(node)
  let args = map(a:node.args, 'self.compile(v:val)')
  call self.out('(unlet %s)', join(args, ' '))
endfunction

function s:Compiler.compile_lockvar(node)
  let args = map(a:node.args, 'self.compile(v:val)')
  call self.out('(lockvar %s %s)', a:node.depth, join(args, ' '))
endfunction

function s:Compiler.compile_unlockvar(node)
  let args = map(a:node.args, 'self.compile(v:val)')
  call self.out('(unlockvar %s %s)', a:node.depth, join(args, ' '))
endfunction

function s:Compiler.compile_if(node)
  call self.out('(if %s', self.compile(a:node.cond))
  call self.incindent('  ')
  call self.compile_begin(a:node.body)
  call self.decindent()
  for enode in a:node.elseif
    call self.out(' elseif %s', self.compile(enode.cond))
    call self.incindent('  ')
    call self.compile_begin(enode.body)
    call self.decindent()
  endfor
  if a:node.else isnot s:NIL
    call self.out(' else')
    call self.incindent('  ')
    call self.compile_begin(a:node.else.body)
    call self.decindent()
  endif
  call self.incindent('  ')
  call self.out(')')
  call self.decindent()
endfunction

function s:Compiler.compile_while(node)
  call self.out('(while %s', self.compile(a:node.cond))
  call self.incindent('  ')
  call self.compile_body(a:node.body)
  call self.out(')')
  call self.decindent()
endfunction

function s:Compiler.compile_for(node)
  let lhs = join(map(a:node.lhs.args, 'self.compile(v:val)'), ' ')
  if a:node.lhs.rest isnot s:NIL
    let lhs .= ' . ' . self.compile(a:node.lhs.rest)
  endif
  let rhs = self.compile(a:node.rhs)
  call self.out('(for (%s) %s', lhs, rhs)
  call self.incindent('  ')
  call self.compile_body(a:node.body)
  call self.out(')')
  call self.decindent()
endfunction

function s:Compiler.compile_continue(node)
  call self.out('(continue)')
endfunction

function s:Compiler.compile_break(node)
  call self.out('(break)')
endfunction

function s:Compiler.compile_try(node)
  call self.out('(try')
  call self.incindent('  ')
  call self.compile_begin(a:node.body)
  for cnode in a:node.catch
    if cnode.pattern isnot s:NIL
      call self.out('(#/%s/', cnode.pattern)
      call self.incindent('  ')
      call self.compile_body(cnode.body)
      call self.out(')')
      call self.decindent()
    else
      call self.out('(else')
      call self.incindent('  ')
      call self.compile_body(cnode.body)
      call self.out(')')
      call self.decindent()
    endif
  endfor
  if a:node.finally isnot s:NIL
    call self.out('(finally')
    call self.incindent('  ')
    call self.compile_body(a:node.finally.body)
    call self.out(')')
    call self.decindent()
  endif
  call self.out(')')
  call self.decindent()
endfunction

function s:Compiler.compile_throw(node)
  call self.out('(throw %s)', self.compile(a:node.arg))
endfunction

function s:Compiler.compile_echo(node)
  let args = map(a:node.args, 'self.compile(v:val)')
  call self.out('(echo %s)', join(args, ' '))
endfunction

function s:Compiler.compile_echon(node)
  let args = map(a:node.args, 'self.compile(v:val)')
  call self.out('(echon %s)', join(args, ' '))
endfunction

function s:Compiler.compile_echohl(node)
  call self.out('(echohl "%s")', escape(a:node.name, '\"'))
endfunction

function s:Compiler.compile_echomsg(node)
  let args = map(a:node.args, 'self.compile(v:val)')
  call self.out('(echomsg %s)', join(args, ' '))
endfunction

function s:Compiler.compile_echoerr(node)
  let args = map(a:node.args, 'self.compile(v:val)')
  call self.out('(echoerr %s)', join(args, ' '))
endfunction

function s:Compiler.compile_execute(node)
  let args = map(a:node.args, 'self.compile(v:val)')
  call self.out('(execute %s)', join(args, ' '))
endfunction

function s:Compiler.compile_condexp(node)
  return printf('(?: %s %s %s)', self.compile(a:node.cond), self.compile(a:node.then), self.compile(a:node.else))
endfunction

function s:Compiler.compile_logor(node)
  return printf('(|| %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_logand(node)
  return printf('(&& %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_eqeqq(node)
  return printf('(==? %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_eqeqh(node)
  return printf('(==# %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_noteqq(node)
  return printf('(!=? %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_noteqh(node)
  return printf('(!=# %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_gteqq(node)
  return printf('(>=? %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_gteqh(node)
  return printf('(>=# %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_lteqq(node)
  return printf('(<=? %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_lteqh(node)
  return printf('(<=# %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_eqtildq(node)
  return printf('(=~? %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_eqtildh(node)
  return printf('(=~# %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_nottildq(node)
  return printf('(!~? %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_nottildh(node)
  return printf('(!~# %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_gtq(node)
  return printf('(>? %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_gth(node)
  return printf('(># %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_ltq(node)
  return printf('(<? %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_lth(node)
  return printf('(<# %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_eqeq(node)
  return printf('(== %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_noteq(node)
  return printf('(!= %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_gteq(node)
  return printf('(>= %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_lteq(node)
  return printf('(<= %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_eqtild(node)
  return printf('(=~ %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_nottild(node)
  return printf('(!~ %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_gt(node)
  return printf('(> %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_lt(node)
  return printf('(< %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_isq(node)
  return printf('(is? %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_ish(node)
  return printf('(is# %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_isnotq(node)
  return printf('(isnot? %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_isnoth(node)
  return printf('(isnot# %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_is(node)
  return printf('(is %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_isnot(node)
  return printf('(isnot %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_add(node)
  return printf('(+ %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_sub(node)
  return printf('(- %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_concat(node)
  return printf('(concat %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_mul(node)
  return printf('(* %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_div(node)
  return printf('(/ %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_mod(node)
  return printf('(%% %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_not(node)
  return printf('(! %s)', self.compile(a:node.expr))
endfunction

function s:Compiler.compile_plus(node)
  return printf('(+ %s)', self.compile(a:node.expr))
endfunction

function s:Compiler.compile_minus(node)
  return printf('(- %s)', self.compile(a:node.expr))
endfunction

function s:Compiler.compile_index(node)
  return printf('(index %s %s)', self.compile(a:node.expr), self.compile(a:node.expr1))
endfunction

function s:Compiler.compile_slice(node)
  let expr1 = a:node.expr1 is s:NIL ? 'nil' : self.compile(a:node.expr1)
  let expr2 = a:node.expr2 is s:NIL ? 'nil' : self.compile(a:node.expr2)
  return printf('(slice %s %s %s)', self.compile(a:node.expr), expr1, expr2)
endfunction

function s:Compiler.compile_dot(node)
  return printf('(dot %s %s)', self.compile(a:node.lhs), self.compile(a:node.rhs))
endfunction

function s:Compiler.compile_call(node)
  let args = map(a:node.args, 'self.compile(v:val)')
  return printf('(%s %s)', self.compile(a:node.expr), join(args, ' '))
endfunction

function s:Compiler.compile_number(node)
  return a:node.value
endfunction

function s:Compiler.compile_string(node)
  return a:node.value
endfunction

function s:Compiler.compile_list(node)
  let items = map(a:node.items, 'self.compile(v:val)')
  if empty(items)
    return '(list)'
  else
    return printf('(list %s)', join(items, ' '))
  endif
endfunction

function s:Compiler.compile_dict(node)
  let items = map(a:node.items, '"(" . self.compile(v:val[0]) . " " . self.compile(v:val[1]) . ")"')
  if empty(items)
    return '(dict)'
  else
    return printf('(dict %s)', join(items, ' '))
  endif
endfunction

function s:Compiler.compile_nesting(node)
  return self.compile(a:node.expr)
endfunction

function s:Compiler.compile_option(node)
  return a:node.value
endfunction

function s:Compiler.compile_identifier(node)
  let v = ''
  for x in a:node.value
    if x.curly
      let v .= '{' . self.compile(x.value) . '}'
    else
      let v .= x.value
    endif
  endfor
  return v
endfunction

function s:Compiler.compile_env(node)
  return a:node.value
endfunction

function s:Compiler.compile_reg(node)
  return a:node.value
endfunction

