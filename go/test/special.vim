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

let self.ea.forceit = 1
let self.ea.forceit = 0
let self.ea.usefilter = 1
let self.ea.usefilter = 0
let node.attr.range = 1
let node.attr.abort = 1
let node.attr.dict = 1

" skip
let self.find_command_cache = {}
let self.cache = {}
let self.buf = []
let self.pos = []
let self.context = {}
let toplevel.body = {}

let node.body = []
let node.rlist = []
let node.attr = {'range': 0, 'abort': 0, 'dict': 0}
let node.endfunction = s:NIL
let node.endif = s:NIL
let node.endfor = s:NIL
let node.endtry = s:NIL
let node.else = s:NIL
let node.elseif = s:NIL
let node.catch = []
let node.finally = []

let node.list = []
let node.depth = s:NIL
let node.pattern = s:NIL

let lhs.list = []
" end skip

" do not skip
let node.list = self.parse_lvaluelist()
let node.depth = hoge
let node.pattern = node
" end do not skip

let p = s:VimLParser.new()
let et = s:ExprTokenizer.new(r)
let ep = s:ExprParser.new(r)
let lp = s:LvalueParser.new(r)
let r = s:StringReader.new(lines)

let nl = s:NIL
