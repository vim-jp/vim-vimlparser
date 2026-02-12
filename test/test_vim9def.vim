vim9script
def Foo()
  echo "hello"
enddef
def Bar(x: number, y: string): bool
  return true
enddef
def Baz(a: number, b: number = 10)
  echo a
enddef
def Qux(a: string, ...extra: list<string>)
  echo a
enddef
