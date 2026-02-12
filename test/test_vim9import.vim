vim9script
import autoload 'mylib.vim'
import './util.vim' as util
export def MyFunc(): string
  return "hello"
enddef
export var myval = 42
