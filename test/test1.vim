" test1
function s:foo(a, b, ...)
  return 0
endfunction
if 1
  echo "if 1"
elseif 2
  echo "elseif 2"
else
  echo "else"
endif
while 1
  continue
  break
endwhile
for [a, b; c] in d
  echo a b c
endfor
delfunction s:foo
call s:foo(1, 2, 3)
try
  throw "err"
catch /err/
  echo "catch /err/"
catch
  echo "catch"
finally
  echo "finally"
endtry
echohl Error
echon "echon"
echomsg "echomsg"
echoerr "echoerr"
execute "normal ihello"
echo [] [1,2,3] [1,2,3,]
echo {} {"x":"y"} {"x":"y","z":"w",}
echo x[0] x[y]
echo x[1:2] x[1:] x[:2] x[:]
echo x.y x.y.z
echo ('foo' .. 'bar')..'baz'
