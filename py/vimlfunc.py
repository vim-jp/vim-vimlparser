#!/usr/bin/env python3
# usage: python3 vimlparser.py [--neovim] foo.vim

import sys
import re
import inspect

def main():
    use_neovim = sys.argv[1] == '--neovim'

    r = StringReader(viml_readfile(sys.argv[-1]))
    p = VimLParser(use_neovim)
    c = Compiler()
    try:
        for line in c.compile(p.parse(r)):
            print(line)
    except VimLParserException as e:
        print(e)
        sys.exit(1)

class VimLParserException(Exception):
    pass

class AttributeDict(dict):
    __getattr__ = dict.__getitem__
    __setattr__ = dict.__setitem__
    __delattr__ = dict.__delitem__

pat_vim2py = {
  "[0-9a-zA-Z]" : "[0-9a-zA-Z]",
  "[@*!=><&~#]" : "[@*!=><&~#]",
  "\\<ARGOPT\\>" : "\\bARGOPT\\b",
  "\\<BANG\\>" : "\\bBANG\\b",
  "\\<EDITCMD\\>" : "\\bEDITCMD\\b",
  "\\<NOTRLCOM\\>" : "\\bNOTRLCOM\\b",
  "\\<TRLBAR\\>" : "\\bTRLBAR\\b",
  "\\<USECTRLV\\>" : "\\bUSECTRLV\\b",
  "\\<USERCMD\\>" : "\\bUSERCMD\\b",
  "\\<\\(XFILE\\|FILES\\|FILE1\\)\\>" : "\\b(XFILE|FILES|FILE1)\\b",
  "\\S" : "\\S",
  "\\a" : "[A-Za-z]",
  "\\d" : "\\d",
  "\\h" : "[A-Za-z_]",
  "\\s" : "\\s",
  "\\v^d%[elete][lp]$" : "^d(elete|elet|ele|el|e)[lp]$",
  "\\v^s%(c[^sr][^i][^p]|g|i[^mlg]|I|r[^e])" : "^s(c[^sr][^i][^p]|g|i[^mlg]|I|r[^e])",
  "\\w" : "[0-9A-Za-z_]",
  "\\w\\|[:#]" : "[0-9A-Za-z_]|[:#]",
  "\\x" : "[0-9A-Fa-f]",
  "^++" : "^\+\+",
  "^++bad=\\(keep\\|drop\\|.\\)\\>" : "^\\+\\+bad=(keep|drop|.)\\b",
  "^++bad=drop" : "^\\+\\+bad=drop",
  "^++bad=keep" : "^\\+\\+bad=keep",
  "^++bin\\>" : "^\\+\\+bin\\b",
  "^++edit\\>" : "^\\+\\+edit\\b",
  "^++enc=\\S" : "^\\+\\+enc=\\S",
  "^++encoding=\\S" : "^\\+\\+encoding=\\S",
  "^++ff=\\(dos\\|unix\\|mac\\)\\>" : "^\\+\\+ff=(dos|unix|mac)\\b",
  "^++fileformat=\\(dos\\|unix\\|mac\\)\\>" : "^\\+\\+fileformat=(dos|unix|mac)\\b",
  "^++nobin\\>" : "^\\+\\+nobin\\b",
  "^[A-Z]" : "^[A-Z]",
  "^\\$\\w\\+" : "^\\$[0-9A-Za-z_]+",
  "^\\(!\\|global\\|vglobal\\)$" : "^(!|global|vglobal)$",
  "^\\(WHILE\\|FOR\\)$" : "^(WHILE|FOR)$",
  "^\\(vimgrep\\|vimgrepadd\\|lvimgrep\\|lvimgrepadd\\)$" : "^(vimgrep|vimgrepadd|lvimgrep|lvimgrepadd)$",
  "^\\d" : "^\\d",
  "^\\h" : "^[A-Za-z_]",
  "^\\s" : "^\\s",
  "^\\s*\\\\" : "^\\s*\\\\",
  "^[ \\t]$" : "^[ \\t]$",
  "^[A-Za-z]$" : "^[A-Za-z]$",
  "^[0-9A-Za-z]$" : "^[0-9A-Za-z]$",
  "^[0-9]$" : "^[0-9]$",
  "^[0-9A-Fa-f]$" : "^[0-9A-Fa-f]$",
  "^[0-9A-Za-z_]$" : "^[0-9A-Za-z_]$",
  "^[A-Za-z_]$" : "^[A-Za-z_]$",
  "^[0-9A-Za-z_:#]$" : "^[0-9A-Za-z_:#]$",
  "^[A-Za-z_][0-9A-Za-z_]*$" : "^[A-Za-z_][0-9A-Za-z_]*$",
  "^[A-Z]$" : "^[A-Z]$",
  "^[a-z]$" : "^[a-z]$",
  "^[vgslabwt]:$\\|^\\([vgslabwt]:\\)\\?[A-Za-z_][0-9A-Za-z_#]*$" : "^[vgslabwt]:$|^([vgslabwt]:)?[A-Za-z_][0-9A-Za-z_#]*$",
  "^[0-7]$" : "^[0-7]$",
  "^[0-9A-Fa-f][0-9A-Fa-f]$" : "^[0-9A-Fa-f][0-9A-Fa-f]$",
  "^\.[0-9A-Fa-f]$" : "^\.[0-9A-Fa-f]$",
  "^[0-9A-Fa-f][^0-9A-Fa-f]$" : "^[0-9A-Fa-f][^0-9A-Fa-f]$",
}

_pat_compiled = {}

def viml_add(lst, item):
    lst.append(item)

def viml_call(func, *args):
    func(*args)

def viml_char2nr(c):
    return ord(c)

def viml_empty(obj):
    return len(obj) == 0

def viml_equalci(a, b):
    return a.lower() == b.lower()

def _get_compiled_pat(reg, flags):
    key = (reg, flags)
    try:
        return _pat_compiled[key]
    except KeyError:
        pat = re.compile(reg, flags)
        _pat_compiled[key] = pat
        return pat

def viml_eqreg(s, reg):
    return _get_compiled_pat(reg, re.IGNORECASE).search(s)

def viml_eqregh(s, reg):
    return _get_compiled_pat(reg, 0).search(s)

def viml_eqregq(s, reg):
    return _get_compiled_pat(reg, re.IGNORECASE).search(s)

def viml_escape(s, chars):
    r = ''
    for c in s:
        if c in chars:
            r += "\\" + c
        else:
            r += c
    return r

def viml_extend(obj, item):
    obj.extend(item)

def viml_insert(lst, item, idx = 0):
    lst.insert(idx, item)

def viml_join(lst, sep):
    return sep.join(lst)

def viml_keys(obj):
    return obj.keys()

def viml_len(obj):
    if type(obj) is str:
        if sys.version_info < (3, 0):
            b = bytes(obj)
        else:
            b = bytes(obj, 'utf8')
        return len(b)
    return len(obj)

def viml_printf(*args):
    if len(args) == 1:
        return args[0]
    else:
        return args[0] % args[1:]

def viml_range(start, end=None):
    if end is None:
        return range(start)
    else:
        return range(start, end + 1)

def viml_readfile(path):
    lines = []
    f = open(path)
    for line in f.readlines():
        lines.append(line.rstrip("\r\n"))
    f.close()
    return lines

def viml_remove(lst, idx):
    del lst[idx]

def viml_split(s, sep):
    if sep == "\\zs":
        return s
    raise VimLParserException("NotImplemented")

def viml_str2nr(s, base=10):
    return int(s, base)

def viml_string(obj):
    return str(obj)

def viml_has_key(obj, key):
    return key in obj

def viml_stridx(a, b):
    return a.find(b)

