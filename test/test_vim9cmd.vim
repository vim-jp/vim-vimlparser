" legacy script
vim9cmd var x = {key: 1}
vim9cmd x.key = 2
vim9 echo x.key # comment
let s:d = {}
echowindow 'msg' s:d
def F()
  legacy let s:d = {'a': 1}
  legacy let s:e = 1 " legacy comment
  defer delete('file')
  var y = 1
  y = 2
enddef
