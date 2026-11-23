vim9script
var F1 = (n) => n + 1
var F2 = (n: number): number => n + 1
var F3 = () => 0
var F4 = (_, val: number): bool =>
  val > 0
var F5 = (...args: list<string>): dict<any> => {
  var opts = {}
  for arg in args
    echo arg
  endfor
  return opts
}
var timer = timer_start(700, (_): void => {
    echo 'x'
  }, {repeat: 3})
var t0 = ()
var t1 = (1,)
var t2 = (1, 'a', [2])
var p = (1 + 2) * 3
var c = [1, <number>g:two]
var m = [3, 1]->sort((a, b) => a - b)
