vim9script
var d = {key: 1, 'q': 2, "dq": 3, [1 + 1]: 4, 09: 5, a-b: 6}
var e = {}
var g = g:foo .. b:bar .. v:true
var l = [
  1,  # one
  # comment line

  2,
]
var m = {
  a: 1,
  b: [1,
      2],
}
var text = 'V'
  .. 'i'
  .. 'm'
var version = 9 *
  100
  + 2
var latest = v:version == 902
  ? 'current' :
  'out-of-date'
var s = d.key .. d
  .q
var r = [1, 2]
  ->reverse()
var call = Foo(1,
  2)
var slice = l[1 : 2]
var nested = d.a.b[0].c
echo "done"
