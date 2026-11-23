vim9script
if true
  var put = 1
  put = 2
endif
put = 3
def F()
  if false
    var file = 1
  elseif true
    file = 2
  else
    var file = 3
    file = 4
  endif
  for edit in [1]
    echo edit
  endfor
  edit = 6
  try
    var new = 1
  catch
    new = 7
  finally
    new = 8
  endtry
  {
    var file = 1
    if true
      file = 9
    endif
  }
  file = 10
  while true
    var put = 1
    break
  endwhile
  put = 11
enddef
