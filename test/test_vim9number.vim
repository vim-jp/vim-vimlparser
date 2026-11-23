vim9script
var big = 1'000'000
var s = $"{big} is {big > 0 ? 'positive' : 'not'}"
var f = big ?? 0
