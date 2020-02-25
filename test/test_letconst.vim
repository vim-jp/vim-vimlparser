let a = {"x": "y"}
let [a, b; c] = [1, 2, 3]
let [a, b; c] += [1, 2, 3]
let [a, b; c] -= [1, 2, 3]
let [a, b; c] .= [1, 2, 3]
let foo.bar.baz = 123
let foo[bar()][baz()] = 456
let foo[bar()].baz = 789
let foo[1:2] = [3, 4]
unlet a b c
lockvar a b c
lockvar 1 a b c
unlockvar a b c
unlockvar 1 a b c
let a = 1
let a += 2
let a *= 3
let a /= 4
let a %= 5
let a ..= 'foo'
let a = '🐥'
const a = 1
const [a, b] = [1, 2]
const [a, b; c] = [1, 2, 3]
let
let var
const
const var
