let s:VimLParser = {}

function! s:VimLParser.new(...)
  " skip .new()
  let obj = copy(self)
  call call(obj.__init__, a:000, obj)
  return obj
endfunction

function! s:ExprTokenizer.token()
  " skip ExprTokenizer.token
endfunction

function! s:StringReader.getpos()
  " skip StringReader.getpos
endfunction

function! s:VimLParser.__init__()
  let x = 1
endfunction

let y = s:ExArg()

function! s:ExArg()
  " skip ExArg definition
endfunction

let self.hoge = 1
let self.ea.range = 1
let xxx.x = 1
let z = self.ea.range
let xs = range(10)

function! s:Node()
  " skip Node definition
endfunction

call s:Node()

let type = 1
let t = type
let at = a:type

let lhs = {}
let lhs = hoge()

for x in self.builtin_commands
endfor
function! s:LvalueParser.pos1() abort
  let pos = self.reader.tell()
endfunction
function! s:LvalueParser.pos2() abort
  let pos = self.reader.tell()
endfunction
