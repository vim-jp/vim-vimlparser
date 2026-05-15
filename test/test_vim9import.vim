vim9script
import autoload 'mylib.vim'
import './util.vim' as util
import './x.vim' as util2 # trailing comment
export def MyFunc(): string
  return "hello"
enddef
export var myval = 42
