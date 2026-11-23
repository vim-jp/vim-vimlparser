vim9script
var F = (edit) => edit
edit = 3
def A()
  var file = 'a'
  file = 'b'
enddef
def B()
  file = 'x'
enddef
var G = (n) => {
  var put = n
  return put
}
put = 1
