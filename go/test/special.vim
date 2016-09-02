let s:VimLParser = {}

function! s:VimLParser.new(...)
  " skip .new()
  let obj = copy(self)
  call call(obj.__init__, a:000, obj)
  return obj
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
let z = self.ea.range
let xs = range(10)
