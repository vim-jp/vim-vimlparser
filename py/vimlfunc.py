#!/usr/bin/env python3
# usage: python3 vimlparser.py [--neovim] foo.vim

import sys
import re


def main():
    use_neovim = sys.argv[1] == "--neovim"

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


def viml_eqreg(s, reg):
    return re.search(reg, s, re.IGNORECASE)


def viml_eqregh(s, reg):
    return re.search(reg, s)


def viml_eqregq(s, reg):
    return re.search(reg, s, re.IGNORECASE)


def viml_escape(s, chars):
    r = ""
    for c in s:
        if c in chars:
            r += "\\" + c
        else:
            r += c
    return r


def viml_extend(obj, item):
    obj.extend(item)


def viml_insert(lst, item, idx=0):
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
            b = bytes(obj, "utf8")
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
