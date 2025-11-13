vim9script

def A()
enddef

def HasReturnType(): tuple<number, string>
  return { 0: 'a' }
enddef

def NoReturnType()
  return
enddef

def HasArgs(a: number, b: list<number>, c: tuple<string, list<number>>)
enddef

def AllowedArgNames(firstline: number, lastline: number)
enddef

def ArgsWithLineBreak(
    a: number,
    b: list<number>,
)
enddef

def NoArgsWithLineBreak(
)
enddef

def! g:GlobalScope()
enddef
