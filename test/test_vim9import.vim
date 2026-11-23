vim9script
import autoload 'mylib.vim'
import './util.vim' as util
import './x.vim' as util2 # trailing comment
export def MyFunc(): string
  return "hello"
enddef
export var myval = 42
import TMP as Imp
import "myscript.vim"
export const MYCONST = 1
export final myfinal = []
export function LegacyFunc()
  return 1
endfunction
echo Imp.y util.Func()
