vim9script
var n = 0
var l = [1, 2]
var d = {a: 1}
n = 2
n += 1
n ..= 'x'
l[0] = 3
l[0 : 1] = [4, 5]
d.a = 2
d['b'] = 3
[n, l] = [1, [2]]
[n; l] = [1, 2, 3]
g:var = 1
b:var = 2
&tabstop = 8
&l:shiftwidth = 2
$ENV = 'x'
@a = 'reg'
++n
--n
Foo()
g:Foo(1, 2)
l->add(3)
l
  ->add(4)
'text'->setline(1)
"text"->setline(1)
[1, 2]->len()
{a: 1}->len()
(1 + 2)->string()
0z1234->len()
123->string()
foo#bar#Baz()
Generic<number>(1)
var lines = []
lines =<< trim END
  one
END
n = 1 # comment
silent! Foo()
nnoremap = <Nop>
echo n
:%s/a/b/g
:1,2d
{
  echo 'block'
}
silent! :%delete _
if 1
endif "}}}
