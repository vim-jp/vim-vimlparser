vim9script
var a: any | var b: bool
var s: string
var l: list<dict<number>> = []
var [first, _, last] = ['A', 'M', 'Z']
var [name, _, country; _] = GetNameCountry()
var [d: number, e: string; rest] = (1, 'I', 'one')
var lines =<< trim END
  text
END
final f: list<number> = [7]
const NAMES = ['Paul', 'Mary']
const I09: func: number = (n: number) => n + 1
const I12: func(number): number = (n): number => n + 1
var t: tuple<number, string> = (1, 'a')
for x: number in [1, 2]
  echo x
endfor
for [k: string, v: any] in items({})
  echo k v
endfor
for b:i in [1, 2, 3]
endfor
var count: number
count += 1
var
