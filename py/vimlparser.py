#!/usr/bin/env python3
# usage: python3 vimlparser.py foo.vim

import sys
import re

def main():
    r = StringReader(viml_readfile(sys.argv[1]))
    p = VimLParser()
    c = Compiler()
    for line in c.compile(p.parse(r)):
        print(line)

class AttributeDict(dict):
    __getattribute__ = dict.__getitem__
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
}

def viml_add(lst, item):
    lst.append(item)

def viml_call(func, *args):
    func(*args)

def viml_empty(obj):
    return len(obj) == 0

def viml_eqreg(s, reg):
    return re.search(pat_vim2py[reg], s, re.IGNORECASE)

def viml_eqregh(s, reg):
    return re.search(pat_vim2py[reg], s)

def viml_eqregq(s, reg):
    return re.search(pat_vim2py[reg], s, re.IGNORECASE)

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
    raise Exception("NotImplemented")

def viml_str2nr(s, base=10):
    return int(s, base)

def viml_string(obj):
    return str(obj)

def viml_has_key(obj, key):
    return key in obj

def viml_stridx(a, b):
    return a.find(b)

NIL = []
NODE_TOPLEVEL = 1
NODE_COMMENT = 2
NODE_EXCMD = 3
NODE_FUNCTION = 4
NODE_ENDFUNCTION = 5
NODE_DELFUNCTION = 6
NODE_RETURN = 7
NODE_EXCALL = 8
NODE_LET = 9
NODE_UNLET = 10
NODE_LOCKVAR = 11
NODE_UNLOCKVAR = 12
NODE_IF = 13
NODE_ELSEIF = 14
NODE_ELSE = 15
NODE_ENDIF = 16
NODE_WHILE = 17
NODE_ENDWHILE = 18
NODE_FOR = 19
NODE_ENDFOR = 20
NODE_CONTINUE = 21
NODE_BREAK = 22
NODE_TRY = 23
NODE_CATCH = 24
NODE_FINALLY = 25
NODE_ENDTRY = 26
NODE_THROW = 27
NODE_ECHO = 28
NODE_ECHON = 29
NODE_ECHOHL = 30
NODE_ECHOMSG = 31
NODE_ECHOERR = 32
NODE_EXECUTE = 33
NODE_TERNARY = 34
NODE_OR = 35
NODE_AND = 36
NODE_EQUAL = 37
NODE_EQUALCI = 38
NODE_EQUALCS = 39
NODE_NEQUAL = 40
NODE_NEQUALCI = 41
NODE_NEQUALCS = 42
NODE_GREATER = 43
NODE_GREATERCI = 44
NODE_GREATERCS = 45
NODE_GEQUAL = 46
NODE_GEQUALCI = 47
NODE_GEQUALCS = 48
NODE_SMALLER = 49
NODE_SMALLERCI = 50
NODE_SMALLERCS = 51
NODE_SEQUAL = 52
NODE_SEQUALCI = 53
NODE_SEQUALCS = 54
NODE_MATCH = 55
NODE_MATCHCI = 56
NODE_MATCHCS = 57
NODE_NOMATCH = 58
NODE_NOMATCHCI = 59
NODE_NOMATCHCS = 60
NODE_IS = 61
NODE_ISCI = 62
NODE_ISCS = 63
NODE_ISNOT = 64
NODE_ISNOTCI = 65
NODE_ISNOTCS = 66
NODE_ADD = 67
NODE_SUBTRACT = 68
NODE_CONCAT = 69
NODE_MULTIPLY = 70
NODE_DIVIDE = 71
NODE_REMAINDER = 72
NODE_NOT = 73
NODE_MINUS = 74
NODE_PLUS = 75
NODE_SUBSCRIPT = 76
NODE_SLICE = 77
NODE_CALL = 78
NODE_DOT = 79
NODE_NUMBER = 80
NODE_STRING = 81
NODE_LIST = 82
NODE_DICT = 83
NODE_NESTING = 84
NODE_OPTION = 85
NODE_IDENTIFIER = 86
NODE_CURLYNAME = 87
NODE_ENV = 88
NODE_REG = 89
TOKEN_EOF = 1
TOKEN_EOL = 2
TOKEN_SPACE = 3
TOKEN_OROR = 4
TOKEN_ANDAND = 5
TOKEN_EQEQ = 6
TOKEN_EQEQCI = 7
TOKEN_EQEQCS = 8
TOKEN_NEQ = 9
TOKEN_NEQCI = 10
TOKEN_NEQCS = 11
TOKEN_GT = 12
TOKEN_GTCI = 13
TOKEN_GTCS = 14
TOKEN_GTEQ = 15
TOKEN_GTEQCI = 16
TOKEN_GTEQCS = 17
TOKEN_LT = 18
TOKEN_LTCI = 19
TOKEN_LTCS = 20
TOKEN_LTEQ = 21
TOKEN_LTEQCI = 22
TOKEN_LTEQCS = 23
TOKEN_MATCH = 24
TOKEN_MATCHCI = 25
TOKEN_MATCHCS = 26
TOKEN_NOMATCH = 27
TOKEN_NOMATCHCI = 28
TOKEN_NOMATCHCS = 29
TOKEN_IS = 30
TOKEN_ISCI = 31
TOKEN_ISCS = 32
TOKEN_ISNOT = 33
TOKEN_ISNOTCI = 34
TOKEN_ISNOTCS = 35
TOKEN_PLUS = 36
TOKEN_MINUS = 37
TOKEN_DOT = 38
TOKEN_STAR = 39
TOKEN_SLASH = 40
TOKEN_PERCENT = 41
TOKEN_NOT = 42
TOKEN_QUESTION = 43
TOKEN_COLON = 44
TOKEN_POPEN = 45
TOKEN_PCLOSE = 46
TOKEN_SQOPEN = 47
TOKEN_SQCLOSE = 48
TOKEN_COPEN = 49
TOKEN_CCLOSE = 50
TOKEN_COMMA = 51
TOKEN_NUMBER = 52
TOKEN_SQUOTE = 53
TOKEN_DQUOTE = 54
TOKEN_OPTION = 55
TOKEN_IDENTIFIER = 56
TOKEN_ENV = 57
TOKEN_REG = 58
TOKEN_EQ = 59
TOKEN_OR = 60
TOKEN_SEMICOLON = 61
TOKEN_BACKTICK = 62
def isalpha(c):
    return viml_eqregh(c, "^[A-Za-z]$")

def isalnum(c):
    return viml_eqregh(c, "^[0-9A-Za-z]$")

def isdigit(c):
    return viml_eqregh(c, "^[0-9]$")

def isxdigit(c):
    return viml_eqregh(c, "^[0-9A-Fa-f]$")

def iswordc(c):
    return viml_eqregh(c, "^[0-9A-Za-z_]$")

def iswordc1(c):
    return viml_eqregh(c, "^[A-Za-z_]$")

def iswhite(c):
    return viml_eqregh(c, "^[ \\t]$")

def isnamec(c):
    return viml_eqregh(c, "^[0-9A-Za-z_:#]$")

def isnamec1(c):
    return viml_eqregh(c, "^[0-9A-Za-z_]$")

# FIXME:
def isidc(c):
    return viml_eqregh(c, "^[0-9A-Za-z_]$")

class VimLParser:
    def __init__(self):
        self.find_command_cache = AttributeDict({})

    def err(self, *a000):
        pos = self.reader.getpos()
        if viml_len(a000) == 1:
            msg = a000[0]
        else:
            msg = viml_printf(*a000)
        return viml_printf("%s: line %d col %d", msg, pos.lnum, pos.col)

    def exnode(self, type):
        node = AttributeDict({"type":type})
        return node

    def blocknode(self, type):
        node = self.exnode(type)
        node.body = []
        return node

    def push_context(self, node):
        viml_insert(self.context, node)

    def pop_context(self):
        viml_remove(self.context, 0)

    def find_context(self, type):
        i = 0
        for node in self.context:
            if node.type == type:
                return i
            i += 1
        return -1

    def add_node(self, node):
        viml_add(self.context[0].body, node)

    def check_missing_endfunction(self, ends):
        if self.context[0].type == NODE_FUNCTION:
            raise Exception(self.err("VimLParser: E126: Missing :endfunction:    %s", ends))

    def check_missing_endif(self, ends):
        if self.context[0].type == NODE_IF or self.context[0].type == NODE_ELSEIF or self.context[0].type == NODE_ELSE:
            raise Exception(self.err("VimLParser: E171: Missing :endif:    %s", ends))

    def check_missing_endtry(self, ends):
        if self.context[0].type == NODE_TRY or self.context[0].type == NODE_CATCH or self.context[0].type == NODE_FINALLY:
            raise Exception(self.err("VimLParser: E600: Missing :endtry:    %s", ends))

    def check_missing_endwhile(self, ends):
        if self.context[0].type == NODE_WHILE:
            raise Exception(self.err("VimLParser: E170: Missing :endwhile:    %s", ends))

    def check_missing_endfor(self, ends):
        if self.context[0].type == NODE_FOR:
            raise Exception(self.err("VimLParser: E170: Missing :endfor:    %s", ends))

    def parse(self, reader):
        self.reader = reader
        self.context = []
        toplevel = self.blocknode(NODE_TOPLEVEL)
        self.push_context(toplevel)
        while self.reader.peek() != "<EOF>":
            self.parse_one_cmd()
        self.check_missing_endfunction("TOPLEVEL")
        self.check_missing_endif("TOPLEVEL")
        self.check_missing_endtry("TOPLEVEL")
        self.check_missing_endwhile("TOPLEVEL")
        self.check_missing_endfor("TOPLEVEL")
        self.pop_context()
        return toplevel

    def parse_one_cmd(self):
        self.ea = AttributeDict({})
        self.ea.forceit = 0
        self.ea.addr_count = 0
        self.ea.line1 = 0
        self.ea.line2 = 0
        self.ea.flags = 0
        self.ea.do_ecmd_cmd = ""
        self.ea.do_ecmd_lnum = 0
        self.ea.append = 0
        self.ea.usefilter = 0
        self.ea.amount = 0
        self.ea.regname = 0
        self.ea.regname = 0
        self.ea.force_bin = 0
        self.ea.read_edit = 0
        self.ea.force_ff = 0
        self.ea.force_enc = 0
        self.ea.bad_char = 0
        self.ea.linepos = []
        self.ea.cmdpos = []
        self.ea.argpos = []
        self.ea.cmd = AttributeDict({})
        self.ea.modifiers = []
        self.ea.range = []
        self.ea.argopt = AttributeDict({})
        self.ea.argcmd = AttributeDict({})
        if self.reader.peekn(2) == "#!":
            self.parse_hashbang()
            self.reader.get()
            return
        self.reader.skip_white_and_colon()
        if self.reader.peekn(1) == "":
            self.reader.get()
            return
        if self.reader.peekn(1) == "\"":
            self.parse_comment()
            self.reader.get()
            return
        self.ea.linepos = self.reader.getpos()
        self.parse_command_modifiers()
        self.parse_range()
        self.parse_command()
        self.parse_trail()

# FIXME:
    def parse_command_modifiers(self):
        modifiers = []
        while 1:
            pos = self.reader.tell()
            if isdigit(self.reader.peekn(1)):
                d = self.reader.read_digit()
                self.reader.skip_white()
            else:
                d = ""
            k = self.reader.read_alpha()
            c = self.reader.peekn(1)
            self.reader.skip_white()
            if viml_stridx("aboveleft", k) == 0 and viml_len(k) >= 3:
                # abo\%[veleft]
                viml_add(modifiers, AttributeDict({"name":"aboveleft"}))
            elif viml_stridx("belowright", k) == 0 and viml_len(k) >= 3:
                # bel\%[owright]
                viml_add(modifiers, AttributeDict({"name":"belowright"}))
            elif viml_stridx("browse", k) == 0 and viml_len(k) >= 3:
                # bro\%[wse]
                viml_add(modifiers, AttributeDict({"name":"browse"}))
            elif viml_stridx("botright", k) == 0 and viml_len(k) >= 2:
                # bo\%[tright]
                viml_add(modifiers, AttributeDict({"name":"botright"}))
            elif viml_stridx("confirm", k) == 0 and viml_len(k) >= 4:
                # conf\%[irm]
                viml_add(modifiers, AttributeDict({"name":"confirm"}))
            elif viml_stridx("keepmarks", k) == 0 and viml_len(k) >= 3:
                # kee\%[pmarks]
                viml_add(modifiers, AttributeDict({"name":"keepmarks"}))
            elif viml_stridx("keepalt", k) == 0 and viml_len(k) >= 5:
                # keepa\%[lt]
                viml_add(modifiers, AttributeDict({"name":"keepalt"}))
            elif viml_stridx("keepjumps", k) == 0 and viml_len(k) >= 5:
                # keepj\%[umps]
                viml_add(modifiers, AttributeDict({"name":"keepjumps"}))
            elif viml_stridx("hide", k) == 0 and viml_len(k) >= 3:
                #hid\%[e]
                if self.ends_excmds(c):
                    break
                viml_add(modifiers, AttributeDict({"name":"hide"}))
            elif viml_stridx("lockmarks", k) == 0 and viml_len(k) >= 3:
                # loc\%[kmarks]
                viml_add(modifiers, AttributeDict({"name":"lockmarks"}))
            elif viml_stridx("leftabove", k) == 0 and viml_len(k) >= 5:
                # lefta\%[bove]
                viml_add(modifiers, AttributeDict({"name":"leftabove"}))
            elif viml_stridx("noautocmd", k) == 0 and viml_len(k) >= 3:
                # noa\%[utocmd]
                viml_add(modifiers, AttributeDict({"name":"noautocmd"}))
            elif viml_stridx("rightbelow", k) == 0 and viml_len(k) >= 6:
                #rightb\%[elow]
                viml_add(modifiers, AttributeDict({"name":"rightbelow"}))
            elif viml_stridx("sandbox", k) == 0 and viml_len(k) >= 3:
                # san\%[dbox]
                viml_add(modifiers, AttributeDict({"name":"sandbox"}))
            elif viml_stridx("silent", k) == 0 and viml_len(k) >= 3:
                # sil\%[ent]
                if c == "!":
                    self.reader.get()
                    viml_add(modifiers, AttributeDict({"name":"silent", "bang":1}))
                else:
                    viml_add(modifiers, AttributeDict({"name":"silent", "bang":0}))
            elif k == "tab":
                # tab
                if d != "":
                    viml_add(modifiers, AttributeDict({"name":"tab", "count":viml_str2nr(d, 10)}))
                else:
                    viml_add(modifiers, AttributeDict({"name":"tab"}))
            elif viml_stridx("topleft", k) == 0 and viml_len(k) >= 2:
                # to\%[pleft]
                viml_add(modifiers, AttributeDict({"name":"topleft"}))
            elif viml_stridx("unsilent", k) == 0 and viml_len(k) >= 3:
                # uns\%[ilent]
                viml_add(modifiers, AttributeDict({"name":"unsilent"}))
            elif viml_stridx("vertical", k) == 0 and viml_len(k) >= 4:
                # vert\%[ical]
                viml_add(modifiers, AttributeDict({"name":"vertical"}))
            elif viml_stridx("verbose", k) == 0 and viml_len(k) >= 4:
                # verb\%[ose]
                if d != "":
                    viml_add(modifiers, AttributeDict({"name":"verbose", "count":viml_str2nr(d, 10)}))
                else:
                    viml_add(modifiers, AttributeDict({"name":"verbose", "count":1}))
            else:
                self.reader.seek_set(pos)
                break
        self.ea.modifiers = modifiers

# FIXME:
    def parse_range(self):
        tokens = []
        while 1:
            while 1:
                self.reader.skip_white()
                c = self.reader.peekn(1)
                if c == "":
                    break
                if c == ".":
                    viml_add(tokens, self.reader.getn(1))
                elif c == "$":
                    viml_add(tokens, self.reader.getn(1))
                elif c == "'":
                    self.reader.getn(1)
                    m = self.reader.getn(1)
                    if m == "":
                        break
                    viml_add(tokens, "'" + m)
                elif c == "/":
                    self.reader.getn(1)
                    pattern, endc = self.parse_pattern(c)
                    viml_add(tokens, pattern)
                elif c == "?":
                    self.reader.getn(1)
                    pattern, endc = self.parse_pattern(c)
                    viml_add(tokens, pattern)
                elif c == "\\":
                    self.reader.getn(1)
                    m = self.reader.getn(1)
                    if m == "&" or m == "?" or m == "/":
                        viml_add(tokens, "\\" + m)
                    else:
                        raise Exception(self.err("VimLParser: E10: \\\\ should be followed by /, ? or &"))
                elif isdigit(c):
                    viml_add(tokens, self.reader.read_digit())
                while 1:
                    self.reader.skip_white()
                    if self.reader.peekn(1) == "":
                        break
                    n = self.reader.read_integer()
                    if n == "":
                        break
                    viml_add(tokens, n)
                if self.reader.p(0) != "/" and self.reader.p(0) != "?":
                    break
            if self.reader.peekn(1) == "%":
                viml_add(tokens, self.reader.getn(1))
            elif self.reader.peekn(1) == "*":
                # && &cpoptions !~ '\*'
                viml_add(tokens, self.reader.getn(1))
            if self.reader.peekn(1) == ";":
                viml_add(tokens, self.reader.getn(1))
                continue
            elif self.reader.peekn(1) == ",":
                viml_add(tokens, self.reader.getn(1))
                continue
            break
        self.ea.range = tokens

# FIXME:
    def parse_pattern(self, delimiter):
        pattern = ""
        endc = ""
        inbracket = 0
        while 1:
            c = self.reader.getn(1)
            if c == "":
                break
            if c == delimiter and inbracket == 0:
                endc = c
                break
            pattern += c
            if c == "\\":
                c = self.reader.getn(1)
                if c == "":
                    raise Exception(self.err("VimLParser: E682: Invalid search pattern or delimiter"))
                pattern += c
            elif c == "[":
                inbracket += 1
            elif c == "]":
                inbracket -= 1
        return [pattern, endc]

    def parse_command(self):
        self.reader.skip_white_and_colon()
        if self.reader.peekn(1) == "" or self.reader.peekn(1) == "\"":
            if not viml_empty(self.ea.modifiers) or not viml_empty(self.ea.range):
                self.parse_cmd_modifier_range()
            return
        self.ea.cmdpos = self.reader.getpos()
        self.ea.cmd = self.find_command()
        if self.ea.cmd is NIL:
            self.reader.setpos(self.ea.cmdpos)
            raise Exception(self.err("VimLParser: E492: Not an editor command: %s", self.reader.peekline()))
        if self.reader.peekn(1) == "!" and self.ea.cmd.name != "substitute" and self.ea.cmd.name != "smagic" and self.ea.cmd.name != "snomagic":
            self.reader.getn(1)
            self.ea.forceit = 1
        else:
            self.ea.forceit = 0
        if not viml_eqregh(self.ea.cmd.flags, "\\<BANG\\>") and self.ea.forceit:
            raise Exception(self.err("VimLParser: E477: No ! allowed"))
        if self.ea.cmd.name != "!":
            self.reader.skip_white()
        self.ea.argpos = self.reader.getpos()
        if viml_eqregh(self.ea.cmd.flags, "\\<ARGOPT\\>"):
            self.parse_argopt()
        if self.ea.cmd.name == "write" or self.ea.cmd.name == "update":
            if self.reader.peekn(1) == ">":
                self.reader.getn(1)
                if self.reader.peekn(1) == ">":
                    raise Exception(self.err("VimLParser: E494: Use w or w>>"))
                self.reader.skip_white()
                self.ea.append = 1
            elif self.reader.peekn(1) == "!" and self.ea.cmd.name == "write":
                self.reader.getn(1)
                self.ea.usefilter = 1
        if self.ea.cmd.name == "read":
            if self.ea.forceit:
                self.ea.usefilter = 1
                self.ea.forceit = 0
            elif self.reader.peekn(1) == "!":
                self.reader.getn(1)
                self.ea.usefilter = 1
        if self.ea.cmd.name == "<" or self.ea.cmd.name == ">":
            self.ea.amount = 1
            while self.reader.peekn(1) == self.ea.cmd.name:
                self.reader.getn(1)
                self.ea.amount += 1
            self.reader.skip_white()
        if viml_eqregh(self.ea.cmd.flags, "\\<EDITCMD\\>") and not self.ea.usefilter:
            self.parse_argcmd()
        getattr(self, self.ea.cmd.parser)()

    def find_command(self):
        c = self.reader.peekn(1)
        if c == "k":
            self.reader.getn(1)
            name = "k"
        elif c == "s" and viml_eqregh(self.reader.peekn(5), "\\v^s%(c[^sr][^i][^p]|g|i[^mlg]|I|r[^e])"):
            self.reader.getn(1)
            name = "substitute"
        elif viml_eqregh(c, "[@*!=><&~#]"):
            self.reader.getn(1)
            name = c
        elif self.reader.peekn(2) == "py":
            name = self.reader.read_alnum()
        else:
            pos = self.reader.tell()
            name = self.reader.read_alpha()
            if name != "del" and viml_eqregh(name, "\\v^d%[elete][lp]$"):
                self.reader.seek_set(pos)
                name = self.reader.getn(viml_len(name) - 1)
        if viml_has_key(self.find_command_cache, name):
            return self.find_command_cache[name]
        cmd = NIL
        for x in self.builtin_commands:
            if viml_stridx(x.name, name) == 0 and viml_len(name) >= x.minlen:
                del cmd
                cmd = x
                break
        # FIXME: user defined command
        if (cmd is NIL or cmd.name == "Print") and viml_eqregh(name, "^[A-Z]"):
            name += self.reader.read_alnum()
            del cmd
            cmd = AttributeDict({"name":name, "flags":"USERCMD", "parser":"parse_cmd_usercmd"})
        self.find_command_cache[name] = cmd
        return cmd

# TODO:
    def parse_hashbang(self):
        self.reader.getn(-1)

# TODO:
# ++opt=val
    def parse_argopt(self):
        while self.reader.p(0) == "+" and self.reader.p(1) == "+":
            s = self.reader.peekn(20)
            if viml_eqregh(s, "^++bin\\>"):
                self.reader.getn(5)
                self.ea.force_bin = 1
            elif viml_eqregh(s, "^++nobin\\>"):
                self.reader.getn(7)
                self.ea.force_bin = 2
            elif viml_eqregh(s, "^++edit\\>"):
                self.reader.getn(6)
                self.ea.read_edit = 1
            elif viml_eqregh(s, "^++ff=\\(dos\\|unix\\|mac\\)\\>"):
                self.reader.getn(5)
                self.ea.force_ff = self.reader.read_alpha()
            elif viml_eqregh(s, "^++fileformat=\\(dos\\|unix\\|mac\\)\\>"):
                self.reader.getn(13)
                self.ea.force_ff = self.reader.read_alpha()
            elif viml_eqregh(s, "^++enc=\\S"):
                self.reader.getn(6)
                self.ea.force_enc = self.reader.read_nonwhite()
            elif viml_eqregh(s, "^++encoding=\\S"):
                self.reader.getn(11)
                self.ea.force_enc = self.reader.read_nonwhite()
            elif viml_eqregh(s, "^++bad=\\(keep\\|drop\\|.\\)\\>"):
                self.reader.getn(6)
                if viml_eqregh(s, "^++bad=keep"):
                    self.ea.bad_char = self.reader.getn(4)
                elif viml_eqregh(s, "^++bad=drop"):
                    self.ea.bad_char = self.reader.getn(4)
                else:
                    self.ea.bad_char = self.reader.getn(1)
            elif viml_eqregh(s, "^++"):
                raise Exception("VimLParser: E474: Invalid Argument")
            else:
                break
            self.reader.skip_white()

# TODO:
# +command
    def parse_argcmd(self):
        if self.reader.peekn(1) == "+":
            self.reader.getn(1)
            if self.reader.peekn(1) == " ":
                self.ea.do_ecmd_cmd = "$"
            else:
                self.ea.do_ecmd_cmd = self.read_cmdarg()

    def read_cmdarg(self):
        r = ""
        while 1:
            c = self.reader.peekn(1)
            if c == "" or iswhite(c):
                break
            self.reader.getn(1)
            if c == "\\":
                c = self.reader.getn(1)
            r += c
        return r

    def parse_comment(self):
        c = self.reader.get()
        if c != "\"":
            raise Exception(self.err("VimLParser: unexpected character: %s", c))
        node = self.exnode(NODE_COMMENT)
        node.str = self.reader.getn(-1)
        self.add_node(node)

    def parse_trail(self):
        self.reader.skip_white()
        c = self.reader.peek()
        if c == "<EOF>":
            # pass
            pass
        elif c == "<EOL>":
            self.reader.get()
        elif c == "|":
            self.reader.get()
        elif c == "\"":
            self.parse_comment()
            self.reader.get()
        else:
            raise Exception(self.err("VimLParser: E488: Trailing characters: %s", c))

# modifier or range only command line
    def parse_cmd_modifier_range(self):
        node = self.exnode(NODE_EXCMD)
        node.ea = self.ea
        node.str = self.reader.getstr(self.ea.linepos, self.reader.getpos())
        self.add_node(node)

# TODO:
    def parse_cmd_common(self):
        if viml_eqregh(self.ea.cmd.flags, "\\<TRLBAR\\>") and not self.ea.usefilter:
            end = self.separate_nextcmd()
        elif self.ea.cmd.name == "!" or self.ea.cmd.name == "global" or self.ea.cmd.name == "vglobal" or self.ea.usefilter:
            while 1:
                end = self.reader.getpos()
                if self.reader.getn(1) == "":
                    break
        else:
            while 1:
                end = self.reader.getpos()
                if self.reader.getn(1) == "":
                    break
        node = self.exnode(NODE_EXCMD)
        node.ea = self.ea
        node.str = self.reader.getstr(self.ea.linepos, end)
        self.add_node(node)

    def separate_nextcmd(self):
        if self.ea.cmd.name == "vimgrep" or self.ea.cmd.name == "vimgrepadd" or self.ea.cmd.name == "lvimgrep" or self.ea.cmd.name == "lvimgrepadd":
            self.skip_vimgrep_pat()
        pc = ""
        end = self.reader.getpos()
        nospend = end
        while 1:
            end = self.reader.getpos()
            if not iswhite(pc):
                nospend = end
            c = self.reader.peek()
            if c == "<EOF>" or c == "<EOL>":
                break
            elif c == "\<C-V>":
                self.reader.get()
                end = self.reader.getpos()
                nospend = self.reader.getpos()
                c = self.reader.peek()
                if c == "<EOF>" or c == "<EOL>":
                    break
                self.reader.get()
            elif self.reader.peekn(2) == "`=" and viml_eqregh(self.ea.cmd.flags, "\\<\\(XFILE\\|FILES\\|FILE1\\)\\>"):
                self.reader.getn(2)
                self.parse_expr()
                c = self.reader.getn(1)
                if c != "`":
                    raise Exception(self.err("VimLParser: unexpected character: %s", c))
            elif c == "|" or c == "\n" or (c == "\"" and not viml_eqregh(self.ea.cmd.flags, "\\<NOTRLCOM\\>") and ((self.ea.cmd.name != "@" and self.ea.cmd.name != "*") or self.reader.getpos() != self.ea.argpos) and (self.ea.cmd.name != "redir" or self.reader.getpos().i != self.ea.argpos.i + 1 or pc != "@")):
                has_cpo_bar = 0
                # &cpoptions =~ 'b'
                if (not has_cpo_bar or not viml_eqregh(self.ea.cmd.flags, "\\<USECTRLV\\>")) and pc == "\\":
                    self.reader.get()
                else:
                    break
            else:
                self.reader.get()
            pc = c
        if not viml_eqregh(self.ea.cmd.flags, "\\<NOTRLCOM\\>"):
            end = nospend
        return end

# FIXME
    def skip_vimgrep_pat(self):
        if self.reader.peekn(1) == "":
            # pass
            pass
        elif isidc(self.reader.peekn(1)):
            # :vimgrep pattern fname
            self.reader.read_nonwhite()
        else:
            # :vimgrep /pattern/[g][j] fname
            c = self.reader.getn(1)
            pattern, endc = self.parse_pattern(c)
            if c != endc:
                return
            while self.reader.p(0) == "g" or self.reader.p(0) == "j":
                self.reader.getn(1)

    def parse_cmd_append(self):
        self.reader.setpos(self.ea.linepos)
        cmdline = self.reader.readline()
        lines = [cmdline]
        m = "."
        while 1:
            if self.reader.peek() == "<EOF>":
                break
            line = self.reader.getn(-1)
            viml_add(lines, line)
            if line == m:
                break
            self.reader.get()
        node = self.exnode(NODE_EXCMD)
        node.ea = self.ea
        node.str = viml_join(lines, "\n")
        self.add_node(node)

    def parse_cmd_insert(self):
        return self.parse_cmd_append()

    def parse_cmd_loadkeymap(self):
        self.reader.setpos(self.ea.linepos)
        cmdline = self.reader.readline()
        lines = [cmdline]
        while 1:
            if self.reader.peek() == "<EOF>":
                break
            line = self.reader.readline()
            viml_add(lines, line)
        node = self.exnode(NODE_EXCMD)
        node.ea = self.ea
        node.str = viml_join(lines, "\n")
        self.add_node(node)

    def parse_cmd_lua(self):
        self.reader.skip_white()
        if self.reader.peekn(2) == "<<":
            self.reader.getn(2)
            self.reader.skip_white()
            m = self.reader.readline()
            if m == "":
                m = "."
            self.reader.setpos(self.ea.linepos)
            cmdline = self.reader.getn(-1)
            lines = [cmdline]
            self.reader.get()
            while 1:
                if self.reader.peek() == "<EOF>":
                    break
                line = self.reader.getn(-1)
                viml_add(lines, line)
                if line == m:
                    break
                self.reader.get()
        else:
            self.reader.setpos(self.ea.linepos)
            cmdline = self.reader.getn(-1)
            lines = [cmdline]
        node = self.exnode(NODE_EXCMD)
        node.ea = self.ea
        node.str = viml_join(lines, "\n")
        self.add_node(node)

    def parse_cmd_mzscheme(self):
        return self.parse_cmd_lua()

    def parse_cmd_perl(self):
        return self.parse_cmd_lua()

    def parse_cmd_python(self):
        return self.parse_cmd_lua()

    def parse_cmd_python3(self):
        return self.parse_cmd_lua()

    def parse_cmd_ruby(self):
        return self.parse_cmd_lua()

    def parse_cmd_tcl(self):
        return self.parse_cmd_lua()

    def parse_cmd_finish(self):
        self.parse_cmd_common()
        if self.context[0].type == NODE_TOPLEVEL:
            self.reader.seek_end(0)

# FIXME
    def parse_cmd_usercmd(self):
        return self.parse_cmd_common()

    def parse_cmd_function(self):
        pos = self.reader.tell()
        self.reader.skip_white()
        # :function
        if self.ends_excmds(self.reader.peek()):
            self.reader.seek_set(pos)
            return self.parse_cmd_common()
        # :function /pattern
        if self.reader.peekn(1) == "/":
            self.reader.seek_set(pos)
            return self.parse_cmd_common()
        name = self.parse_lvalue()
        self.reader.skip_white()
        # :function {name}
        if self.reader.peekn(1) != "(":
            self.reader.seek_set(pos)
            return self.parse_cmd_common()
        # :function[!] {name}([arguments]) [range] [abort] [dict]
        node = self.blocknode(NODE_FUNCTION)
        node.ea = self.ea
        node.name = name
        node.args = []
        node.attr = AttributeDict({"range":0, "abort":0, "dict":0})
        node.endfunction = NIL
        self.reader.getn(1)
        c = self.reader.peekn(1)
        if c == ")":
            self.reader.getn(1)
        else:
            while 1:
                self.reader.skip_white()
                if iswordc1(self.reader.peekn(1)):
                    arg = self.reader.read_word()
                    viml_add(node.args, arg)
                    self.reader.skip_white()
                    c = self.reader.peekn(1)
                    if c == ",":
                        self.reader.getn(1)
                        continue
                    elif c == ")":
                        self.reader.getn(1)
                        break
                    else:
                        raise Exception(self.err("VimLParser: unexpected characters: %s", c))
                elif self.reader.peekn(3) == "...":
                    self.reader.getn(3)
                    viml_add(node.args, "...")
                    self.reader.skip_white()
                    c = self.reader.peekn(1)
                    if c == ")":
                        self.reader.getn(1)
                        break
                    else:
                        raise Exception(self.err("VimLParser: unexpected characters: %s", c))
                else:
                    raise Exception(self.err("VimLParser: unexpected characters: %s", c))
        while 1:
            self.reader.skip_white()
            key = self.reader.read_alpha()
            if key == "":
                break
            elif key == "range":
                node.attr.range = 1
            elif key == "abort":
                node.attr.abort = 1
            elif key == "dict":
                node.attr.dict = 1
            else:
                raise Exception(self.err("VimLParser: unexpected token: %s", key))
        self.add_node(node)
        self.push_context(node)

    def parse_cmd_endfunction(self):
        self.check_missing_endif("ENDFUNCTION")
        self.check_missing_endtry("ENDFUNCTION")
        self.check_missing_endwhile("ENDFUNCTION")
        self.check_missing_endfor("ENDFUNCTION")
        if self.context[0].type != NODE_FUNCTION:
            raise Exception(self.err("VimLParser: E193: :endfunction not inside a function"))
        self.reader.getn(-1)
        node = self.exnode(NODE_ENDFUNCTION)
        node.ea = self.ea
        self.context[0].endfunction = node
        self.pop_context()

    def parse_cmd_delfunction(self):
        node = self.exnode(NODE_DELFUNCTION)
        node.ea = self.ea
        node.name = self.parse_lvalue()
        self.add_node(node)

    def parse_cmd_return(self):
        if self.find_context(NODE_FUNCTION) == -1:
            raise Exception(self.err("VimLParser: E133: :return not inside a function"))
        node = self.exnode(NODE_RETURN)
        node.ea = self.ea
        node.arg = NIL
        self.reader.skip_white()
        c = self.reader.peek()
        if not self.ends_excmds(c):
            node.arg = self.parse_expr()
        self.add_node(node)

    def parse_cmd_call(self):
        node = self.exnode(NODE_EXCALL)
        node.ea = self.ea
        node.expr = NIL
        self.reader.skip_white()
        c = self.reader.peek()
        if self.ends_excmds(c):
            raise Exception(self.err("VimLParser: call error: %s", c))
        node.expr = self.parse_expr()
        if node.expr.type != NODE_CALL:
            raise Exception(self.err("VimLParser: call error: %s", node.expr.type))
        self.add_node(node)

    def parse_cmd_let(self):
        pos = self.reader.tell()
        self.reader.skip_white()
        # :let
        if self.ends_excmds(self.reader.peek()):
            self.reader.seek_set(pos)
            return self.parse_cmd_common()
        lhs = self.parse_letlhs()
        self.reader.skip_white()
        s1 = self.reader.peekn(1)
        s2 = self.reader.peekn(2)
        # :let {var-name} ..
        if self.ends_excmds(s1) or (s2 != "+=" and s2 != "-=" and s2 != ".=" and s1 != "="):
            self.reader.seek_set(pos)
            return self.parse_cmd_common()
        # :let lhs op rhs
        node = self.exnode(NODE_LET)
        node.ea = self.ea
        node.op = ""
        node.lhs = lhs
        node.rhs = NIL
        if s2 == "+=" or s2 == "-=" or s2 == ".=":
            self.reader.getn(2)
            node.op = s2
        elif s1 == "=":
            self.reader.getn(1)
            node.op = s1
        else:
            raise Exception("NOT REACHED")
        node.rhs = self.parse_expr()
        self.add_node(node)

    def parse_cmd_unlet(self):
        node = self.exnode(NODE_UNLET)
        node.ea = self.ea
        node.args = self.parse_lvaluelist()
        self.add_node(node)

    def parse_cmd_lockvar(self):
        node = self.exnode(NODE_LOCKVAR)
        node.ea = self.ea
        node.depth = 2
        node.args = []
        self.reader.skip_white()
        if isdigit(self.reader.peekn(1)):
            node.depth = viml_str2nr(self.reader.read_digit(), 10)
        node.args = self.parse_lvaluelist()
        self.add_node(node)

    def parse_cmd_unlockvar(self):
        node = self.exnode(NODE_UNLOCKVAR)
        node.ea = self.ea
        node.depth = 2
        node.args = []
        self.reader.skip_white()
        if isdigit(self.reader.peekn(1)):
            node.depth = viml_str2nr(self.reader.read_digit(), 10)
        node.args = self.parse_lvaluelist()
        self.add_node(node)

    def parse_cmd_if(self):
        node = self.blocknode(NODE_IF)
        node.ea = self.ea
        node.cond = self.parse_expr()
        node.elseif = []
        node._else = NIL
        node.endif = NIL
        self.add_node(node)
        self.push_context(node)

    def parse_cmd_elseif(self):
        if self.context[0].type != NODE_IF and self.context[0].type != NODE_ELSEIF:
            raise Exception(self.err("VimLParser: E582: :elseif without :if"))
        if self.context[0].type != NODE_IF:
            self.pop_context()
        node = self.blocknode(NODE_ELSEIF)
        node.ea = self.ea
        node.cond = self.parse_expr()
        viml_add(self.context[0].elseif, node)
        self.push_context(node)

    def parse_cmd_else(self):
        if self.context[0].type != NODE_IF and self.context[0].type != NODE_ELSEIF:
            raise Exception(self.err("VimLParser: E581: :else without :if"))
        if self.context[0].type != NODE_IF:
            self.pop_context()
        node = self.blocknode(NODE_ELSE)
        node.ea = self.ea
        self.context[0]._else = node
        self.push_context(node)

    def parse_cmd_endif(self):
        if self.context[0].type != NODE_IF and self.context[0].type != NODE_ELSEIF and self.context[0].type != NODE_ELSE:
            raise Exception(self.err("VimLParser: E580: :endif without :if"))
        if self.context[0].type != NODE_IF:
            self.pop_context()
        node = self.exnode(NODE_ENDIF)
        node.ea = self.ea
        self.context[0].endif = node
        self.pop_context()

    def parse_cmd_while(self):
        node = self.blocknode(NODE_WHILE)
        node.ea = self.ea
        node.cond = self.parse_expr()
        node.endwhile = NIL
        self.add_node(node)
        self.push_context(node)

    def parse_cmd_endwhile(self):
        if self.context[0].type != NODE_WHILE:
            raise Exception(self.err("VimLParser: E588: :endwhile without :while"))
        node = self.exnode(NODE_ENDWHILE)
        node.ea = self.ea
        self.context[0].endwhile = node
        self.pop_context()

    def parse_cmd_for(self):
        node = self.blocknode(NODE_FOR)
        node.ea = self.ea
        node.lhs = NIL
        node.rhs = NIL
        node.endfor = NIL
        node.lhs = self.parse_letlhs()
        self.reader.skip_white()
        if self.reader.read_alpha() != "in":
            raise Exception(self.err("VimLParser: Missing \"in\" after :for"))
        node.rhs = self.parse_expr()
        self.add_node(node)
        self.push_context(node)

    def parse_cmd_endfor(self):
        if self.context[0].type != NODE_FOR:
            raise Exception(self.err("VimLParser: E588: :endfor without :for"))
        node = self.exnode(NODE_ENDFOR)
        node.ea = self.ea
        self.context[0].endfor = node
        self.pop_context()

    def parse_cmd_continue(self):
        if self.find_context(NODE_WHILE) == -1 and self.find_context(NODE_FOR) == -1:
            raise Exception(self.err("VimLParser: E586: :continue without :while or :for"))
        node = self.exnode(NODE_CONTINUE)
        node.ea = self.ea
        self.add_node(node)

    def parse_cmd_break(self):
        if self.find_context(NODE_WHILE) == -1 and self.find_context(NODE_FOR) == -1:
            raise Exception(self.err("VimLParser: E587: :break without :while or :for"))
        node = self.exnode(NODE_BREAK)
        node.ea = self.ea
        self.add_node(node)

    def parse_cmd_try(self):
        node = self.blocknode(NODE_TRY)
        node.ea = self.ea
        node.catch = []
        node._finally = NIL
        node.endtry = NIL
        self.add_node(node)
        self.push_context(node)

    def parse_cmd_catch(self):
        if self.context[0].type == NODE_FINALLY:
            raise Exception(self.err("VimLParser: E604: :catch after :finally"))
        elif self.context[0].type != NODE_TRY and self.context[0].type != NODE_CATCH:
            raise Exception(self.err("VimLParser: E603: :catch without :try"))
        if self.context[0].type != NODE_TRY:
            self.pop_context()
        node = self.blocknode(NODE_CATCH)
        node.ea = self.ea
        node.pattern = NIL
        self.reader.skip_white()
        if not self.ends_excmds(self.reader.peek()):
            node.pattern, endc = self.parse_pattern(self.reader.get())
        viml_add(self.context[0].catch, node)
        self.push_context(node)

    def parse_cmd_finally(self):
        if self.context[0].type != NODE_TRY and self.context[0].type != NODE_CATCH:
            raise Exception(self.err("VimLParser: E606: :finally without :try"))
        if self.context[0].type != NODE_TRY:
            self.pop_context()
        node = self.blocknode(NODE_FINALLY)
        node.ea = self.ea
        self.context[0]._finally = node
        self.push_context(node)

    def parse_cmd_endtry(self):
        if self.context[0].type != NODE_TRY and self.context[0].type != NODE_CATCH and self.context[0].type != NODE_FINALLY:
            raise Exception(self.err("VimLParser: E602: :endtry without :try"))
        if self.context[0].type != NODE_TRY:
            self.pop_context()
        node = self.exnode(NODE_ENDTRY)
        node.ea = self.ea
        self.context[0].endtry = node
        self.pop_context()

    def parse_cmd_throw(self):
        node = self.exnode(NODE_THROW)
        node.ea = self.ea
        node.arg = self.parse_expr()
        self.add_node(node)

    def parse_cmd_echo(self):
        node = self.exnode(NODE_ECHO)
        node.ea = self.ea
        node.args = self.parse_exprlist()
        self.add_node(node)

    def parse_cmd_echon(self):
        node = self.exnode(NODE_ECHON)
        node.ea = self.ea
        node.args = self.parse_exprlist()
        self.add_node(node)

    def parse_cmd_echohl(self):
        node = self.exnode(NODE_ECHOHL)
        node.ea = self.ea
        node.name = ""
        while not self.ends_excmds(self.reader.peek()):
            node.name += self.reader.get()
        self.add_node(node)

    def parse_cmd_echomsg(self):
        node = self.exnode(NODE_ECHOMSG)
        node.ea = self.ea
        node.args = self.parse_exprlist()
        self.add_node(node)

    def parse_cmd_echoerr(self):
        node = self.exnode(NODE_ECHOERR)
        node.ea = self.ea
        node.args = self.parse_exprlist()
        self.add_node(node)

    def parse_cmd_execute(self):
        node = self.exnode(NODE_EXECUTE)
        node.ea = self.ea
        node.args = self.parse_exprlist()
        self.add_node(node)

    def parse_expr(self):
        return ExprParser(ExprTokenizer(self.reader)).parse()

    def parse_exprlist(self):
        args = []
        while 1:
            self.reader.skip_white()
            c = self.reader.peek()
            if c != "\"" and self.ends_excmds(c):
                break
            node = self.parse_expr()
            viml_add(args, node)
        return args

# FIXME:
    def parse_lvalue(self):
        p = LvalueParser(ExprTokenizer(self.reader))
        node = p.parse()
        if node.type == NODE_IDENTIFIER or node.type == NODE_CURLYNAME or node.type == NODE_SUBSCRIPT or node.type == NODE_DOT or node.type == NODE_OPTION or node.type == NODE_ENV or node.type == NODE_REG:
            return node
        raise Exception(self.err("VimLParser: lvalue error: %s", node.value))

    def parse_lvaluelist(self):
        args = []
        node = self.parse_expr()
        viml_add(args, node)
        while 1:
            self.reader.skip_white()
            if self.ends_excmds(self.reader.peek()):
                break
            node = self.parse_lvalue()
            viml_add(args, node)
        return args

# FIXME:
    def parse_letlhs(self):
        values = AttributeDict({"args":[], "rest":NIL})
        tokenizer = ExprTokenizer(self.reader)
        if tokenizer.peek().type == TOKEN_SQOPEN:
            tokenizer.get()
            while 1:
                node = self.parse_lvalue()
                viml_add(values.args, node)
                token = tokenizer.get()
                if token.type == TOKEN_SQCLOSE:
                    break
                elif token.type == TOKEN_COMMA:
                    continue
                elif token.type == TOKEN_SEMICOLON:
                    node = self.parse_lvalue()
                    values.rest = node
                    token = tokenizer.get()
                    if token.type == TOKEN_SQCLOSE:
                        break
                    else:
                        raise Exception(self.err("VimLParser: E475 Invalid argument: %s", token.value))
                else:
                    raise Exception(self.err("VimLParser: E475 Invalid argument: %s", token.value))
        else:
            node = self.parse_lvalue()
            viml_add(values.args, node)
        return values

    def ends_excmds(self, c):
        return c == "" or c == "|" or c == "\"" or c == "<EOF>" or c == "<EOL>"

    builtin_commands = [AttributeDict({"name":"append", "minlen":1, "flags":"BANG|RANGE|ZEROR|TRLBAR|CMDWIN|MODIFY", "parser":"parse_cmd_append"}), AttributeDict({"name":"abbreviate", "minlen":2, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"abclear", "minlen":3, "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"aboveleft", "minlen":3, "flags":"NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"all", "minlen":2, "flags":"BANG|RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"amenu", "minlen":2, "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"anoremenu", "minlen":2, "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"args", "minlen":2, "flags":"BANG|FILES|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"argadd", "minlen":4, "flags":"BANG|NEEDARG|RANGE|NOTADR|ZEROR|FILES|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"argdelete", "minlen":4, "flags":"BANG|RANGE|NOTADR|FILES|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"argedit", "minlen":4, "flags":"BANG|NEEDARG|RANGE|NOTADR|FILE1|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"argdo", "minlen":5, "flags":"BANG|NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"argglobal", "minlen":4, "flags":"BANG|FILES|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"arglocal", "minlen":4, "flags":"BANG|FILES|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"argument", "minlen":4, "flags":"BANG|RANGE|NOTADR|COUNT|EXTRA|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"ascii", "minlen":2, "flags":"TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"autocmd", "minlen":2, "flags":"BANG|EXTRA|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"augroup", "minlen":3, "flags":"BANG|WORD1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"aunmenu", "minlen":3, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"buffer", "minlen":1, "flags":"BANG|RANGE|NOTADR|BUFNAME|BUFUNL|COUNT|EXTRA|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"bNext", "minlen":2, "flags":"BANG|RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"ball", "minlen":2, "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"badd", "minlen":3, "flags":"NEEDARG|FILE1|EDITCMD|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"bdelete", "minlen":2, "flags":"BANG|RANGE|NOTADR|BUFNAME|COUNT|EXTRA|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"behave", "minlen":2, "flags":"NEEDARG|WORD1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"belowright", "minlen":3, "flags":"NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"bfirst", "minlen":2, "flags":"BANG|RANGE|NOTADR|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"blast", "minlen":2, "flags":"BANG|RANGE|NOTADR|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"bmodified", "minlen":2, "flags":"BANG|RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"bnext", "minlen":2, "flags":"BANG|RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"botright", "minlen":2, "flags":"NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"bprevious", "minlen":2, "flags":"BANG|RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"brewind", "minlen":2, "flags":"BANG|RANGE|NOTADR|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"break", "minlen":4, "flags":"TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_break"}), AttributeDict({"name":"breakadd", "minlen":6, "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"breakdel", "minlen":6, "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"breaklist", "minlen":6, "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"browse", "minlen":3, "flags":"NEEDARG|EXTRA|NOTRLCOM|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"bufdo", "minlen":5, "flags":"BANG|NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"buffers", "minlen":7, "flags":"BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"bunload", "minlen":3, "flags":"BANG|RANGE|NOTADR|BUFNAME|COUNT|EXTRA|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"bwipeout", "minlen":2, "flags":"BANG|RANGE|NOTADR|BUFNAME|BUFUNL|COUNT|EXTRA|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"change", "minlen":1, "flags":"BANG|WHOLEFOLD|RANGE|COUNT|TRLBAR|CMDWIN|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"cNext", "minlen":2, "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"cNfile", "minlen":3, "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"cabbrev", "minlen":2, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"cabclear", "minlen":4, "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"caddbuffer", "minlen":5, "flags":"RANGE|NOTADR|WORD1|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"caddexpr", "minlen":3, "flags":"NEEDARG|WORD1|NOTRLCOM|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"caddfile", "minlen":5, "flags":"TRLBAR|FILE1", "parser":"parse_cmd_common"}), AttributeDict({"name":"call", "minlen":3, "flags":"RANGE|NEEDARG|EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_call"}), AttributeDict({"name":"catch", "minlen":3, "flags":"EXTRA|SBOXOK|CMDWIN", "parser":"parse_cmd_catch"}), AttributeDict({"name":"cbuffer", "minlen":2, "flags":"BANG|RANGE|NOTADR|WORD1|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"cc", "minlen":2, "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"cclose", "minlen":3, "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"cd", "minlen":2, "flags":"BANG|FILE1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"center", "minlen":2, "flags":"TRLBAR|RANGE|WHOLEFOLD|EXTRA|CMDWIN|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"cexpr", "minlen":3, "flags":"NEEDARG|WORD1|NOTRLCOM|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"cfile", "minlen":2, "flags":"TRLBAR|FILE1|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"cfirst", "minlen":4, "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"cgetbuffer", "minlen":5, "flags":"RANGE|NOTADR|WORD1|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"cgetexpr", "minlen":5, "flags":"NEEDARG|WORD1|NOTRLCOM|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"cgetfile", "minlen":2, "flags":"TRLBAR|FILE1", "parser":"parse_cmd_common"}), AttributeDict({"name":"changes", "minlen":7, "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"chdir", "minlen":3, "flags":"BANG|FILE1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"checkpath", "minlen":3, "flags":"TRLBAR|BANG|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"checktime", "minlen":6, "flags":"RANGE|NOTADR|BUFNAME|COUNT|EXTRA|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"clist", "minlen":2, "flags":"BANG|EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"clast", "minlen":3, "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"close", "minlen":3, "flags":"BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"cmap", "minlen":2, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"cmapclear", "minlen":5, "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"cmenu", "minlen":3, "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"cnext", "minlen":2, "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"cnewer", "minlen":4, "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"cnfile", "minlen":3, "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"cnoremap", "minlen":3, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"cnoreabbrev", "minlen":6, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"cnoremenu", "minlen":7, "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"copy", "minlen":2, "flags":"RANGE|WHOLEFOLD|EXTRA|TRLBAR|CMDWIN|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"colder", "minlen":3, "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"colorscheme", "minlen":4, "flags":"WORD1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"command", "minlen":3, "flags":"EXTRA|BANG|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"comclear", "minlen":4, "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"compiler", "minlen":4, "flags":"BANG|TRLBAR|WORD1|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"continue", "minlen":3, "flags":"TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_continue"}), AttributeDict({"name":"confirm", "minlen":4, "flags":"NEEDARG|EXTRA|NOTRLCOM|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"copen", "minlen":4, "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"cprevious", "minlen":2, "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"cpfile", "minlen":3, "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"cquit", "minlen":2, "flags":"TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"crewind", "minlen":2, "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"cscope", "minlen":2, "flags":"EXTRA|NOTRLCOM|XFILE", "parser":"parse_cmd_common"}), AttributeDict({"name":"cstag", "minlen":3, "flags":"BANG|TRLBAR|WORD1", "parser":"parse_cmd_common"}), AttributeDict({"name":"cunmap", "minlen":2, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"cunabbrev", "minlen":4, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"cunmenu", "minlen":5, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"cwindow", "minlen":2, "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"delete", "minlen":1, "flags":"RANGE|WHOLEFOLD|REGSTR|COUNT|TRLBAR|CMDWIN|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"delmarks", "minlen":4, "flags":"BANG|EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"debug", "minlen":3, "flags":"NEEDARG|EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"debuggreedy", "minlen":6, "flags":"RANGE|NOTADR|ZEROR|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"delcommand", "minlen":4, "flags":"NEEDARG|WORD1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"delfunction", "minlen":4, "flags":"NEEDARG|WORD1|CMDWIN", "parser":"parse_cmd_delfunction"}), AttributeDict({"name":"diffupdate", "minlen":3, "flags":"BANG|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"diffget", "minlen":5, "flags":"RANGE|EXTRA|TRLBAR|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"diffoff", "minlen":5, "flags":"BANG|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"diffpatch", "minlen":5, "flags":"EXTRA|FILE1|TRLBAR|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"diffput", "minlen":6, "flags":"RANGE|EXTRA|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"diffsplit", "minlen":5, "flags":"EXTRA|FILE1|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"diffthis", "minlen":8, "flags":"TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"digraphs", "minlen":3, "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"display", "minlen":2, "flags":"EXTRA|NOTRLCOM|TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"djump", "minlen":2, "flags":"BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA", "parser":"parse_cmd_common"}), AttributeDict({"name":"dlist", "minlen":2, "flags":"BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"doautocmd", "minlen":2, "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"doautoall", "minlen":7, "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"drop", "minlen":2, "flags":"FILES|EDITCMD|NEEDARG|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"dsearch", "minlen":2, "flags":"BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"dsplit", "minlen":3, "flags":"BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA", "parser":"parse_cmd_common"}), AttributeDict({"name":"edit", "minlen":1, "flags":"BANG|FILE1|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"earlier", "minlen":2, "flags":"TRLBAR|EXTRA|NOSPC|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"echo", "minlen":2, "flags":"EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_echo"}), AttributeDict({"name":"echoerr", "minlen":5, "flags":"EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_echoerr"}), AttributeDict({"name":"echohl", "minlen":5, "flags":"EXTRA|TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_echohl"}), AttributeDict({"name":"echomsg", "minlen":5, "flags":"EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_echomsg"}), AttributeDict({"name":"echon", "minlen":5, "flags":"EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_echon"}), AttributeDict({"name":"else", "minlen":2, "flags":"TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_else"}), AttributeDict({"name":"elseif", "minlen":5, "flags":"EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_elseif"}), AttributeDict({"name":"emenu", "minlen":2, "flags":"NEEDARG|EXTRA|TRLBAR|NOTRLCOM|RANGE|NOTADR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"endif", "minlen":2, "flags":"TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_endif"}), AttributeDict({"name":"endfor", "minlen":5, "flags":"TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_endfor"}), AttributeDict({"name":"endfunction", "minlen":4, "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_endfunction"}), AttributeDict({"name":"endtry", "minlen":4, "flags":"TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_endtry"}), AttributeDict({"name":"endwhile", "minlen":4, "flags":"TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_endwhile"}), AttributeDict({"name":"enew", "minlen":3, "flags":"BANG|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"ex", "minlen":2, "flags":"BANG|FILE1|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"execute", "minlen":3, "flags":"EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_execute"}), AttributeDict({"name":"exit", "minlen":3, "flags":"RANGE|WHOLEFOLD|BANG|FILE1|ARGOPT|DFLALL|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"exusage", "minlen":3, "flags":"TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"file", "minlen":1, "flags":"RANGE|NOTADR|ZEROR|BANG|FILE1|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"files", "minlen":5, "flags":"BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"filetype", "minlen":5, "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"find", "minlen":3, "flags":"RANGE|NOTADR|BANG|FILE1|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"finally", "minlen":4, "flags":"TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_finally"}), AttributeDict({"name":"finish", "minlen":4, "flags":"TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_finish"}), AttributeDict({"name":"first", "minlen":3, "flags":"EXTRA|BANG|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"fixdel", "minlen":3, "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"fold", "minlen":2, "flags":"RANGE|WHOLEFOLD|TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"foldclose", "minlen":5, "flags":"RANGE|BANG|WHOLEFOLD|TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"folddoopen", "minlen":5, "flags":"RANGE|DFLALL|NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"folddoclosed", "minlen":7, "flags":"RANGE|DFLALL|NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"foldopen", "minlen":5, "flags":"RANGE|BANG|WHOLEFOLD|TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"for", "minlen":3, "flags":"EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_for"}), AttributeDict({"name":"function", "minlen":2, "flags":"EXTRA|BANG|CMDWIN", "parser":"parse_cmd_function"}), AttributeDict({"name":"global", "minlen":1, "flags":"RANGE|WHOLEFOLD|BANG|EXTRA|DFLALL|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"goto", "minlen":2, "flags":"RANGE|NOTADR|COUNT|TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"grep", "minlen":2, "flags":"RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE", "parser":"parse_cmd_common"}), AttributeDict({"name":"grepadd", "minlen":5, "flags":"RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE", "parser":"parse_cmd_common"}), AttributeDict({"name":"gui", "minlen":2, "flags":"BANG|FILES|EDITCMD|ARGOPT|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"gvim", "minlen":2, "flags":"BANG|FILES|EDITCMD|ARGOPT|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"hardcopy", "minlen":2, "flags":"RANGE|COUNT|EXTRA|TRLBAR|DFLALL|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"help", "minlen":1, "flags":"BANG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"helpfind", "minlen":5, "flags":"EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"helpgrep", "minlen":5, "flags":"EXTRA|NOTRLCOM|NEEDARG", "parser":"parse_cmd_common"}), AttributeDict({"name":"helptags", "minlen":5, "flags":"NEEDARG|FILES|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"highlight", "minlen":2, "flags":"BANG|EXTRA|TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"hide", "minlen":3, "flags":"BANG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"history", "minlen":3, "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"insert", "minlen":1, "flags":"BANG|RANGE|TRLBAR|CMDWIN|MODIFY", "parser":"parse_cmd_insert"}), AttributeDict({"name":"iabbrev", "minlen":2, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"iabclear", "minlen":4, "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"if", "minlen":2, "flags":"EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_if"}), AttributeDict({"name":"ijump", "minlen":2, "flags":"BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA", "parser":"parse_cmd_common"}), AttributeDict({"name":"ilist", "minlen":2, "flags":"BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"imap", "minlen":2, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"imapclear", "minlen":5, "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"imenu", "minlen":3, "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"inoremap", "minlen":3, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"inoreabbrev", "minlen":6, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"inoremenu", "minlen":7, "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"intro", "minlen":3, "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"isearch", "minlen":2, "flags":"BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"isplit", "minlen":3, "flags":"BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA", "parser":"parse_cmd_common"}), AttributeDict({"name":"iunmap", "minlen":2, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"iunabbrev", "minlen":4, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"iunmenu", "minlen":5, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"join", "minlen":1, "flags":"BANG|RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"jumps", "minlen":2, "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"k", "minlen":1, "flags":"RANGE|WORD1|TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"keepalt", "minlen":5, "flags":"NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"keepmarks", "minlen":3, "flags":"NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"keepjumps", "minlen":5, "flags":"NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"lNext", "minlen":2, "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"lNfile", "minlen":3, "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"list", "minlen":1, "flags":"RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"laddexpr", "minlen":3, "flags":"NEEDARG|WORD1|NOTRLCOM|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"laddbuffer", "minlen":5, "flags":"RANGE|NOTADR|WORD1|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"laddfile", "minlen":5, "flags":"TRLBAR|FILE1", "parser":"parse_cmd_common"}), AttributeDict({"name":"last", "minlen":2, "flags":"EXTRA|BANG|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"language", "minlen":3, "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"later", "minlen":3, "flags":"TRLBAR|EXTRA|NOSPC|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"lbuffer", "minlen":2, "flags":"BANG|RANGE|NOTADR|WORD1|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"lcd", "minlen":2, "flags":"BANG|FILE1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"lchdir", "minlen":3, "flags":"BANG|FILE1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"lclose", "minlen":3, "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"lcscope", "minlen":3, "flags":"EXTRA|NOTRLCOM|XFILE", "parser":"parse_cmd_common"}), AttributeDict({"name":"left", "minlen":2, "flags":"TRLBAR|RANGE|WHOLEFOLD|EXTRA|CMDWIN|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"leftabove", "minlen":5, "flags":"NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"let", "minlen":3, "flags":"EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_let"}), AttributeDict({"name":"lexpr", "minlen":3, "flags":"NEEDARG|WORD1|NOTRLCOM|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"lfile", "minlen":2, "flags":"TRLBAR|FILE1|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"lfirst", "minlen":4, "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"lgetbuffer", "minlen":5, "flags":"RANGE|NOTADR|WORD1|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"lgetexpr", "minlen":5, "flags":"NEEDARG|WORD1|NOTRLCOM|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"lgetfile", "minlen":2, "flags":"TRLBAR|FILE1", "parser":"parse_cmd_common"}), AttributeDict({"name":"lgrep", "minlen":3, "flags":"RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE", "parser":"parse_cmd_common"}), AttributeDict({"name":"lgrepadd", "minlen":6, "flags":"RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE", "parser":"parse_cmd_common"}), AttributeDict({"name":"lhelpgrep", "minlen":2, "flags":"EXTRA|NOTRLCOM|NEEDARG", "parser":"parse_cmd_common"}), AttributeDict({"name":"ll", "minlen":2, "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"llast", "minlen":3, "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"llist", "minlen":3, "flags":"BANG|EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"lmake", "minlen":4, "flags":"BANG|EXTRA|NOTRLCOM|TRLBAR|XFILE", "parser":"parse_cmd_common"}), AttributeDict({"name":"lmap", "minlen":2, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"lmapclear", "minlen":5, "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"lnext", "minlen":3, "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"lnewer", "minlen":4, "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"lnfile", "minlen":3, "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"lnoremap", "minlen":2, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"loadkeymap", "minlen":5, "flags":"CMDWIN", "parser":"parse_cmd_loadkeymap"}), AttributeDict({"name":"loadview", "minlen":2, "flags":"FILE1|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"lockmarks", "minlen":3, "flags":"NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"lockvar", "minlen":5, "flags":"BANG|EXTRA|NEEDARG|SBOXOK|CMDWIN", "parser":"parse_cmd_lockvar"}), AttributeDict({"name":"lolder", "minlen":3, "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"lopen", "minlen":4, "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"lprevious", "minlen":2, "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"lpfile", "minlen":3, "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"lrewind", "minlen":2, "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"ls", "minlen":2, "flags":"BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"ltag", "minlen":2, "flags":"NOTADR|TRLBAR|BANG|WORD1", "parser":"parse_cmd_common"}), AttributeDict({"name":"lunmap", "minlen":2, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"lua", "minlen":3, "flags":"RANGE|EXTRA|NEEDARG|CMDWIN", "parser":"parse_cmd_lua"}), AttributeDict({"name":"luado", "minlen":4, "flags":"RANGE|DFLALL|EXTRA|NEEDARG|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"luafile", "minlen":4, "flags":"RANGE|FILE1|NEEDARG|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"lvimgrep", "minlen":2, "flags":"RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE", "parser":"parse_cmd_common"}), AttributeDict({"name":"lvimgrepadd", "minlen":9, "flags":"RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE", "parser":"parse_cmd_common"}), AttributeDict({"name":"lwindow", "minlen":2, "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"move", "minlen":1, "flags":"RANGE|WHOLEFOLD|EXTRA|TRLBAR|CMDWIN|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"mark", "minlen":2, "flags":"RANGE|WORD1|TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"make", "minlen":3, "flags":"BANG|EXTRA|NOTRLCOM|TRLBAR|XFILE", "parser":"parse_cmd_common"}), AttributeDict({"name":"map", "minlen":3, "flags":"BANG|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"mapclear", "minlen":4, "flags":"EXTRA|BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"marks", "minlen":5, "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"match", "minlen":3, "flags":"RANGE|NOTADR|EXTRA|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"menu", "minlen":2, "flags":"RANGE|NOTADR|ZEROR|BANG|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"menutranslate", "minlen":5, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"messages", "minlen":3, "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"mkexrc", "minlen":2, "flags":"BANG|FILE1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"mksession", "minlen":3, "flags":"BANG|FILE1|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"mkspell", "minlen":4, "flags":"BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE", "parser":"parse_cmd_common"}), AttributeDict({"name":"mkvimrc", "minlen":3, "flags":"BANG|FILE1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"mkview", "minlen":5, "flags":"BANG|FILE1|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"mode", "minlen":3, "flags":"WORD1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"mzscheme", "minlen":2, "flags":"RANGE|EXTRA|DFLALL|NEEDARG|CMDWIN|SBOXOK", "parser":"parse_cmd_mzscheme"}), AttributeDict({"name":"mzfile", "minlen":3, "flags":"RANGE|FILE1|NEEDARG|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"nbclose", "minlen":3, "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"nbkey", "minlen":2, "flags":"EXTRA|NOTADR|NEEDARG", "parser":"parse_cmd_common"}), AttributeDict({"name":"nbstart", "minlen":3, "flags":"WORD1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"next", "minlen":1, "flags":"RANGE|NOTADR|BANG|FILES|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"new", "minlen":3, "flags":"BANG|FILE1|RANGE|NOTADR|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"nmap", "minlen":2, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"nmapclear", "minlen":5, "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"nmenu", "minlen":3, "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"nnoremap", "minlen":2, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"nnoremenu", "minlen":7, "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"noautocmd", "minlen":3, "flags":"NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"noremap", "minlen":2, "flags":"BANG|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"nohlsearch", "minlen":3, "flags":"TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"noreabbrev", "minlen":5, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"noremenu", "minlen":6, "flags":"RANGE|NOTADR|ZEROR|BANG|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"normal", "minlen":4, "flags":"RANGE|BANG|EXTRA|NEEDARG|NOTRLCOM|USECTRLV|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"number", "minlen":2, "flags":"RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"nunmap", "minlen":3, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"nunmenu", "minlen":5, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"oldfiles", "minlen":2, "flags":"BANG|TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"open", "minlen":1, "flags":"RANGE|BANG|EXTRA", "parser":"parse_cmd_common"}), AttributeDict({"name":"omap", "minlen":2, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"omapclear", "minlen":5, "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"omenu", "minlen":3, "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"only", "minlen":2, "flags":"BANG|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"onoremap", "minlen":3, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"onoremenu", "minlen":7, "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"options", "minlen":3, "flags":"TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"ounmap", "minlen":2, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"ounmenu", "minlen":5, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"ownsyntax", "minlen":2, "flags":"EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"pclose", "minlen":2, "flags":"BANG|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"pedit", "minlen":3, "flags":"BANG|FILE1|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"perl", "minlen":2, "flags":"RANGE|EXTRA|DFLALL|NEEDARG|SBOXOK|CMDWIN", "parser":"parse_cmd_perl"}), AttributeDict({"name":"print", "minlen":1, "flags":"RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN|SBOXOK", "parser":"parse_cmd_common"}), AttributeDict({"name":"profdel", "minlen":5, "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"profile", "minlen":4, "flags":"BANG|EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"promptfind", "minlen":3, "flags":"EXTRA|NOTRLCOM|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"promptrepl", "minlen":7, "flags":"EXTRA|NOTRLCOM|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"perldo", "minlen":5, "flags":"RANGE|EXTRA|DFLALL|NEEDARG|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"pop", "minlen":2, "flags":"RANGE|NOTADR|BANG|COUNT|TRLBAR|ZEROR", "parser":"parse_cmd_common"}), AttributeDict({"name":"popup", "minlen":4, "flags":"NEEDARG|EXTRA|BANG|TRLBAR|NOTRLCOM|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"ppop", "minlen":2, "flags":"RANGE|NOTADR|BANG|COUNT|TRLBAR|ZEROR", "parser":"parse_cmd_common"}), AttributeDict({"name":"preserve", "minlen":3, "flags":"TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"previous", "minlen":4, "flags":"EXTRA|RANGE|NOTADR|COUNT|BANG|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"psearch", "minlen":2, "flags":"BANG|RANGE|WHOLEFOLD|DFLALL|EXTRA", "parser":"parse_cmd_common"}), AttributeDict({"name":"ptag", "minlen":2, "flags":"RANGE|NOTADR|BANG|WORD1|TRLBAR|ZEROR", "parser":"parse_cmd_common"}), AttributeDict({"name":"ptNext", "minlen":3, "flags":"RANGE|NOTADR|BANG|TRLBAR|ZEROR", "parser":"parse_cmd_common"}), AttributeDict({"name":"ptfirst", "minlen":3, "flags":"RANGE|NOTADR|BANG|TRLBAR|ZEROR", "parser":"parse_cmd_common"}), AttributeDict({"name":"ptjump", "minlen":3, "flags":"BANG|TRLBAR|WORD1", "parser":"parse_cmd_common"}), AttributeDict({"name":"ptlast", "minlen":3, "flags":"BANG|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"ptnext", "minlen":3, "flags":"RANGE|NOTADR|BANG|TRLBAR|ZEROR", "parser":"parse_cmd_common"}), AttributeDict({"name":"ptprevious", "minlen":3, "flags":"RANGE|NOTADR|BANG|TRLBAR|ZEROR", "parser":"parse_cmd_common"}), AttributeDict({"name":"ptrewind", "minlen":3, "flags":"RANGE|NOTADR|BANG|TRLBAR|ZEROR", "parser":"parse_cmd_common"}), AttributeDict({"name":"ptselect", "minlen":3, "flags":"BANG|TRLBAR|WORD1", "parser":"parse_cmd_common"}), AttributeDict({"name":"put", "minlen":2, "flags":"RANGE|WHOLEFOLD|BANG|REGSTR|TRLBAR|ZEROR|CMDWIN|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"pwd", "minlen":2, "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"py3", "minlen":3, "flags":"RANGE|EXTRA|NEEDARG|CMDWIN", "parser":"parse_cmd_python3"}), AttributeDict({"name":"python3", "minlen":7, "flags":"RANGE|EXTRA|NEEDARG|CMDWIN", "parser":"parse_cmd_python3"}), AttributeDict({"name":"py3file", "minlen":4, "flags":"RANGE|FILE1|NEEDARG|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"python", "minlen":2, "flags":"RANGE|EXTRA|NEEDARG|CMDWIN", "parser":"parse_cmd_python"}), AttributeDict({"name":"pyfile", "minlen":3, "flags":"RANGE|FILE1|NEEDARG|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"quit", "minlen":1, "flags":"BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"quitall", "minlen":5, "flags":"BANG|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"qall", "minlen":2, "flags":"BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"read", "minlen":1, "flags":"BANG|RANGE|WHOLEFOLD|FILE1|ARGOPT|TRLBAR|ZEROR|CMDWIN|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"recover", "minlen":3, "flags":"BANG|FILE1|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"redo", "minlen":3, "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"redir", "minlen":4, "flags":"BANG|FILES|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"redraw", "minlen":4, "flags":"BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"redrawstatus", "minlen":7, "flags":"BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"registers", "minlen":3, "flags":"EXTRA|NOTRLCOM|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"resize", "minlen":3, "flags":"RANGE|NOTADR|TRLBAR|WORD1", "parser":"parse_cmd_common"}), AttributeDict({"name":"retab", "minlen":3, "flags":"TRLBAR|RANGE|WHOLEFOLD|DFLALL|BANG|WORD1|CMDWIN|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"return", "minlen":4, "flags":"EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_return"}), AttributeDict({"name":"rewind", "minlen":3, "flags":"EXTRA|BANG|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"right", "minlen":2, "flags":"TRLBAR|RANGE|WHOLEFOLD|EXTRA|CMDWIN|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"rightbelow", "minlen":6, "flags":"NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"ruby", "minlen":3, "flags":"RANGE|EXTRA|NEEDARG|CMDWIN", "parser":"parse_cmd_ruby"}), AttributeDict({"name":"rubydo", "minlen":5, "flags":"RANGE|DFLALL|EXTRA|NEEDARG|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"rubyfile", "minlen":5, "flags":"RANGE|FILE1|NEEDARG|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"rundo", "minlen":4, "flags":"NEEDARG|FILE1", "parser":"parse_cmd_common"}), AttributeDict({"name":"runtime", "minlen":2, "flags":"BANG|NEEDARG|FILES|TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"rviminfo", "minlen":2, "flags":"BANG|FILE1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"substitute", "minlen":1, "flags":"RANGE|WHOLEFOLD|EXTRA|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"sNext", "minlen":2, "flags":"EXTRA|RANGE|NOTADR|COUNT|BANG|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"sandbox", "minlen":3, "flags":"NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"sargument", "minlen":2, "flags":"BANG|RANGE|NOTADR|COUNT|EXTRA|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"sall", "minlen":3, "flags":"BANG|RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"saveas", "minlen":3, "flags":"BANG|DFLALL|FILE1|ARGOPT|CMDWIN|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"sbuffer", "minlen":2, "flags":"BANG|RANGE|NOTADR|BUFNAME|BUFUNL|COUNT|EXTRA|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"sbNext", "minlen":3, "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"sball", "minlen":3, "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"sbfirst", "minlen":3, "flags":"TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"sblast", "minlen":3, "flags":"TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"sbmodified", "minlen":3, "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"sbnext", "minlen":3, "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"sbprevious", "minlen":3, "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"sbrewind", "minlen":3, "flags":"TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"scriptnames", "minlen":5, "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"scriptencoding", "minlen":7, "flags":"WORD1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"scscope", "minlen":3, "flags":"EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"set", "minlen":2, "flags":"TRLBAR|EXTRA|CMDWIN|SBOXOK", "parser":"parse_cmd_common"}), AttributeDict({"name":"setfiletype", "minlen":4, "flags":"TRLBAR|EXTRA|NEEDARG|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"setglobal", "minlen":4, "flags":"TRLBAR|EXTRA|CMDWIN|SBOXOK", "parser":"parse_cmd_common"}), AttributeDict({"name":"setlocal", "minlen":4, "flags":"TRLBAR|EXTRA|CMDWIN|SBOXOK", "parser":"parse_cmd_common"}), AttributeDict({"name":"sfind", "minlen":2, "flags":"BANG|FILE1|RANGE|NOTADR|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"sfirst", "minlen":4, "flags":"EXTRA|BANG|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"shell", "minlen":2, "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"simalt", "minlen":3, "flags":"NEEDARG|WORD1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"sign", "minlen":3, "flags":"NEEDARG|RANGE|NOTADR|EXTRA|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"silent", "minlen":3, "flags":"NEEDARG|EXTRA|BANG|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"sleep", "minlen":2, "flags":"RANGE|NOTADR|COUNT|EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"slast", "minlen":3, "flags":"EXTRA|BANG|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"smagic", "minlen":2, "flags":"RANGE|WHOLEFOLD|EXTRA|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"smap", "minlen":4, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"smapclear", "minlen":5, "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"smenu", "minlen":3, "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"snext", "minlen":2, "flags":"RANGE|NOTADR|BANG|FILES|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"sniff", "minlen":3, "flags":"EXTRA|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"snomagic", "minlen":3, "flags":"RANGE|WHOLEFOLD|EXTRA|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"snoremap", "minlen":4, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"snoremenu", "minlen":7, "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"sort", "minlen":3, "flags":"RANGE|DFLALL|WHOLEFOLD|BANG|EXTRA|NOTRLCOM|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"source", "minlen":2, "flags":"BANG|FILE1|TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"spelldump", "minlen":6, "flags":"BANG|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"spellgood", "minlen":3, "flags":"BANG|RANGE|NOTADR|NEEDARG|EXTRA|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"spellinfo", "minlen":6, "flags":"TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"spellrepall", "minlen":6, "flags":"TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"spellundo", "minlen":6, "flags":"BANG|RANGE|NOTADR|NEEDARG|EXTRA|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"spellwrong", "minlen":6, "flags":"BANG|RANGE|NOTADR|NEEDARG|EXTRA|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"split", "minlen":2, "flags":"BANG|FILE1|RANGE|NOTADR|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"sprevious", "minlen":3, "flags":"EXTRA|RANGE|NOTADR|COUNT|BANG|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"srewind", "minlen":3, "flags":"EXTRA|BANG|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"stop", "minlen":2, "flags":"TRLBAR|BANG|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"stag", "minlen":3, "flags":"RANGE|NOTADR|BANG|WORD1|TRLBAR|ZEROR", "parser":"parse_cmd_common"}), AttributeDict({"name":"startinsert", "minlen":4, "flags":"BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"startgreplace", "minlen":6, "flags":"BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"startreplace", "minlen":6, "flags":"BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"stopinsert", "minlen":5, "flags":"BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"stjump", "minlen":3, "flags":"BANG|TRLBAR|WORD1", "parser":"parse_cmd_common"}), AttributeDict({"name":"stselect", "minlen":3, "flags":"BANG|TRLBAR|WORD1", "parser":"parse_cmd_common"}), AttributeDict({"name":"sunhide", "minlen":3, "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"sunmap", "minlen":4, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"sunmenu", "minlen":5, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"suspend", "minlen":3, "flags":"TRLBAR|BANG|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"sview", "minlen":2, "flags":"BANG|FILE1|RANGE|NOTADR|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"swapname", "minlen":2, "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"syntax", "minlen":2, "flags":"EXTRA|NOTRLCOM|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"syncbind", "minlen":4, "flags":"TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"t", "minlen":1, "flags":"RANGE|WHOLEFOLD|EXTRA|TRLBAR|CMDWIN|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"tNext", "minlen":2, "flags":"RANGE|NOTADR|BANG|TRLBAR|ZEROR", "parser":"parse_cmd_common"}), AttributeDict({"name":"tabNext", "minlen":4, "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"tabclose", "minlen":4, "flags":"RANGE|NOTADR|COUNT|BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"tabdo", "minlen":5, "flags":"NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"tabedit", "minlen":4, "flags":"BANG|FILE1|RANGE|NOTADR|ZEROR|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"tabfind", "minlen":4, "flags":"BANG|FILE1|RANGE|NOTADR|ZEROR|EDITCMD|ARGOPT|NEEDARG|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"tabfirst", "minlen":6, "flags":"TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"tablast", "minlen":4, "flags":"TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"tabmove", "minlen":4, "flags":"RANGE|NOTADR|ZEROR|EXTRA|NOSPC|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"tabnew", "minlen":6, "flags":"BANG|FILE1|RANGE|NOTADR|ZEROR|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"tabnext", "minlen":4, "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"tabonly", "minlen":4, "flags":"BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"tabprevious", "minlen":4, "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"tabrewind", "minlen":4, "flags":"TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"tabs", "minlen":4, "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"tab", "minlen":3, "flags":"NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"tag", "minlen":2, "flags":"RANGE|NOTADR|BANG|WORD1|TRLBAR|ZEROR", "parser":"parse_cmd_common"}), AttributeDict({"name":"tags", "minlen":4, "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"tcl", "minlen":2, "flags":"RANGE|EXTRA|NEEDARG|CMDWIN", "parser":"parse_cmd_tcl"}), AttributeDict({"name":"tcldo", "minlen":4, "flags":"RANGE|DFLALL|EXTRA|NEEDARG|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"tclfile", "minlen":4, "flags":"RANGE|FILE1|NEEDARG|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"tearoff", "minlen":2, "flags":"NEEDARG|EXTRA|TRLBAR|NOTRLCOM|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"tfirst", "minlen":2, "flags":"RANGE|NOTADR|BANG|TRLBAR|ZEROR", "parser":"parse_cmd_common"}), AttributeDict({"name":"throw", "minlen":2, "flags":"EXTRA|NEEDARG|SBOXOK|CMDWIN", "parser":"parse_cmd_throw"}), AttributeDict({"name":"tjump", "minlen":2, "flags":"BANG|TRLBAR|WORD1", "parser":"parse_cmd_common"}), AttributeDict({"name":"tlast", "minlen":2, "flags":"BANG|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"tmenu", "minlen":2, "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"tnext", "minlen":2, "flags":"RANGE|NOTADR|BANG|TRLBAR|ZEROR", "parser":"parse_cmd_common"}), AttributeDict({"name":"topleft", "minlen":2, "flags":"NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"tprevious", "minlen":2, "flags":"RANGE|NOTADR|BANG|TRLBAR|ZEROR", "parser":"parse_cmd_common"}), AttributeDict({"name":"trewind", "minlen":2, "flags":"RANGE|NOTADR|BANG|TRLBAR|ZEROR", "parser":"parse_cmd_common"}), AttributeDict({"name":"try", "minlen":3, "flags":"TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_try"}), AttributeDict({"name":"tselect", "minlen":2, "flags":"BANG|TRLBAR|WORD1", "parser":"parse_cmd_common"}), AttributeDict({"name":"tunmenu", "minlen":2, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"undo", "minlen":1, "flags":"RANGE|NOTADR|COUNT|ZEROR|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"undojoin", "minlen":5, "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"undolist", "minlen":5, "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"unabbreviate", "minlen":3, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"unhide", "minlen":3, "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"unlet", "minlen":3, "flags":"BANG|EXTRA|NEEDARG|SBOXOK|CMDWIN", "parser":"parse_cmd_unlet"}), AttributeDict({"name":"unlockvar", "minlen":4, "flags":"BANG|EXTRA|NEEDARG|SBOXOK|CMDWIN", "parser":"parse_cmd_unlockvar"}), AttributeDict({"name":"unmap", "minlen":3, "flags":"BANG|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"unmenu", "minlen":4, "flags":"BANG|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"unsilent", "minlen":3, "flags":"NEEDARG|EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"update", "minlen":2, "flags":"RANGE|WHOLEFOLD|BANG|FILE1|ARGOPT|DFLALL|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"vglobal", "minlen":1, "flags":"RANGE|WHOLEFOLD|EXTRA|DFLALL|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"version", "minlen":2, "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"verbose", "minlen":4, "flags":"NEEDARG|RANGE|NOTADR|EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"vertical", "minlen":4, "flags":"NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"vimgrep", "minlen":3, "flags":"RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE", "parser":"parse_cmd_common"}), AttributeDict({"name":"vimgrepadd", "minlen":8, "flags":"RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE", "parser":"parse_cmd_common"}), AttributeDict({"name":"visual", "minlen":2, "flags":"BANG|FILE1|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"viusage", "minlen":3, "flags":"TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"view", "minlen":3, "flags":"BANG|FILE1|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"vmap", "minlen":2, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"vmapclear", "minlen":5, "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"vmenu", "minlen":3, "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"vnew", "minlen":3, "flags":"BANG|FILE1|RANGE|NOTADR|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"vnoremap", "minlen":2, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"vnoremenu", "minlen":7, "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"vsplit", "minlen":2, "flags":"BANG|FILE1|RANGE|NOTADR|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"vunmap", "minlen":2, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"vunmenu", "minlen":5, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"windo", "minlen":5, "flags":"BANG|NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"write", "minlen":1, "flags":"RANGE|WHOLEFOLD|BANG|FILE1|ARGOPT|DFLALL|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"wNext", "minlen":2, "flags":"RANGE|WHOLEFOLD|NOTADR|BANG|FILE1|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"wall", "minlen":2, "flags":"BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"while", "minlen":2, "flags":"EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_while"}), AttributeDict({"name":"winsize", "minlen":2, "flags":"EXTRA|NEEDARG|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"wincmd", "minlen":4, "flags":"NEEDARG|WORD1|RANGE|NOTADR", "parser":"parse_cmd_common"}), AttributeDict({"name":"winpos", "minlen":4, "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"wnext", "minlen":2, "flags":"RANGE|NOTADR|BANG|FILE1|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"wprevious", "minlen":2, "flags":"RANGE|NOTADR|BANG|FILE1|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"wq", "minlen":2, "flags":"RANGE|WHOLEFOLD|BANG|FILE1|ARGOPT|DFLALL|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"wqall", "minlen":3, "flags":"BANG|FILE1|ARGOPT|DFLALL|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"wsverb", "minlen":2, "flags":"EXTRA|NOTADR|NEEDARG", "parser":"parse_cmd_common"}), AttributeDict({"name":"wundo", "minlen":2, "flags":"BANG|NEEDARG|FILE1", "parser":"parse_cmd_common"}), AttributeDict({"name":"wviminfo", "minlen":2, "flags":"BANG|FILE1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"xit", "minlen":1, "flags":"RANGE|WHOLEFOLD|BANG|FILE1|ARGOPT|DFLALL|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"xall", "minlen":2, "flags":"BANG|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"xmapclear", "minlen":5, "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"xmap", "minlen":2, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"xmenu", "minlen":3, "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"xnoremap", "minlen":2, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"xnoremenu", "minlen":7, "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"xunmap", "minlen":2, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"xunmenu", "minlen":5, "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"yank", "minlen":1, "flags":"RANGE|WHOLEFOLD|REGSTR|COUNT|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"z", "minlen":1, "flags":"RANGE|WHOLEFOLD|EXTRA|EXFLAGS|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"!", "minlen":1, "flags":"RANGE|WHOLEFOLD|BANG|FILES|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"#", "minlen":1, "flags":"RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"&", "minlen":1, "flags":"RANGE|WHOLEFOLD|EXTRA|CMDWIN|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"*", "minlen":1, "flags":"RANGE|WHOLEFOLD|EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"<", "minlen":1, "flags":"RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"=", "minlen":1, "flags":"RANGE|TRLBAR|DFLALL|EXFLAGS|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":">", "minlen":1, "flags":"RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"@", "minlen":1, "flags":"RANGE|WHOLEFOLD|EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"Next", "minlen":1, "flags":"EXTRA|RANGE|NOTADR|COUNT|BANG|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"Print", "minlen":1, "flags":"RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"X", "minlen":1, "flags":"TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"~", "minlen":1, "flags":"RANGE|WHOLEFOLD|EXTRA|CMDWIN|MODIFY", "parser":"parse_cmd_common"})]
class ExprTokenizer:
    def __init__(self, reader):
        self.reader = reader
        self.cache = AttributeDict({})

    def err(self, *a000):
        pos = self.reader.getpos()
        if viml_len(a000) == 1:
            msg = a000[0]
        else:
            msg = viml_printf(*a000)
        return viml_printf("%s: line %d col %d", msg, pos.lnum, pos.col)

    def token(self, type, value):
        return AttributeDict({"type":type, "value":value})

    def peek(self):
        pos = self.reader.tell()
        r = self.get()
        self.reader.seek_set(pos)
        return r

    def get(self):
        # FIXME: remove dirty hack
        if viml_has_key(self.cache, self.reader.tell()):
            x = self.cache[self.reader.tell()]
            self.reader.seek_set(x[0])
            return x[1]
        pos = self.reader.tell()
        self.reader.skip_white()
        r = self.get2()
        self.cache[pos] = [self.reader.tell(), r]
        return r

    def get2(self):
        r = self.reader
        c = r.peek()
        if c == "<EOF>":
            return self.token(TOKEN_EOF, c)
        elif c == "<EOL>":
            r.seek_cur(1)
            return self.token(TOKEN_EOL, c)
        elif iswhite(c):
            s = r.read_white()
            return self.token(TOKEN_SPACE, s)
        elif c == "0" and (r.p(1) == "X" or r.p(1) == "x") and isxdigit(r.p(2)):
            s = r.getn(3)
            s += r.read_xdigit()
            return self.token(TOKEN_NUMBER, s)
        elif isdigit(c):
            s = r.read_digit()
            if r.p(0) == "." and isdigit(r.p(1)):
                s += r.getn(1)
                s += r.read_digit()
                if (r.p(0) == "E" or r.p(0) == "e") and (r.p(1) == "-" or r.p(1) == "+") and isdigit(r.p(2)):
                    s += r.getn(3)
                    s += r.read_digit()
            return self.token(TOKEN_NUMBER, s)
        elif c == "i" and r.p(1) == "s" and not isidc(r.p(2)):
            if r.p(2) == "?":
                r.seek_cur(3)
                return self.token(TOKEN_ISCI, "is?")
            elif r.p(2) == "#":
                r.seek_cur(3)
                return self.token(TOKEN_ISCS, "is#")
            else:
                r.seek_cur(2)
                return self.token(TOKEN_IS, "is")
        elif c == "i" and r.p(1) == "s" and r.p(2) == "n" and r.p(3) == "o" and r.p(4) == "t" and not isidc(r.p(5)):
            if r.p(5) == "?":
                r.seek_cur(6)
                return self.token(TOKEN_ISNOTCI, "isnot?")
            elif r.p(5) == "#":
                r.seek_cur(6)
                return self.token(TOKEN_ISNOTCS, "isnot#")
            else:
                r.seek_cur(5)
                return self.token(TOKEN_ISNOT, "isnot")
        elif isnamec1(c):
            s = r.read_name()
            return self.token(TOKEN_IDENTIFIER, s)
        elif c == "|" and r.p(1) == "|":
            r.seek_cur(2)
            return self.token(TOKEN_OROR, "||")
        elif c == "&" and r.p(1) == "&":
            r.seek_cur(2)
            return self.token(TOKEN_ANDAND, "&&")
        elif c == "=" and r.p(1) == "=":
            if r.p(2) == "?":
                r.seek_cur(3)
                return self.token(TOKEN_EQEQCI, "==?")
            elif r.p(2) == "#":
                r.seek_cur(3)
                return self.token(TOKEN_EQEQCS, "==#")
            else:
                r.seek_cur(2)
                return self.token(TOKEN_EQEQ, "==")
        elif c == "!" and r.p(1) == "=":
            if r.p(2) == "?":
                r.seek_cur(3)
                return self.token(TOKEN_NEQCI, "!=?")
            elif r.p(2) == "#":
                r.seek_cur(3)
                return self.token(TOKEN_NEQCS, "!=#")
            else:
                r.seek_cur(2)
                return self.token(TOKEN_NEQ, "!=")
        elif c == ">" and r.p(1) == "=":
            if r.p(2) == "?":
                r.seek_cur(3)
                return self.token(TOKEN_GTEQCI, ">=?")
            elif r.p(2) == "#":
                r.seek_cur(3)
                return self.token(TOKEN_GTEQCS, ">=#")
            else:
                r.seek_cur(2)
                return self.token(TOKEN_GTEQ, ">=")
        elif c == "<" and r.p(1) == "=":
            if r.p(2) == "?":
                r.seek_cur(3)
                return self.token(TOKEN_LTEQCI, "<=?")
            elif r.p(2) == "#":
                r.seek_cur(3)
                return self.token(TOKEN_LTEQCS, "<=#")
            else:
                r.seek_cur(2)
                return self.token(TOKEN_LTEQ, "<=")
        elif c == "=" and r.p(1) == "~":
            if r.p(2) == "?":
                r.seek_cur(3)
                return self.token(TOKEN_MATCHCI, "=~?")
            elif r.p(2) == "#":
                r.seek_cur(3)
                return self.token(TOKEN_MATCHCS, "=~#")
            else:
                r.seek_cur(2)
                return self.token(TOKEN_MATCH, "=~")
        elif c == "!" and r.p(1) == "~":
            if r.p(2) == "?":
                r.seek_cur(3)
                return self.token(TOKEN_NOMATCHCI, "!~?")
            elif r.p(2) == "#":
                r.seek_cur(3)
                return self.token(TOKEN_NOMATCHCS, "!~#")
            else:
                r.seek_cur(2)
                return self.token(TOKEN_NOMATCH, "!~")
        elif c == ">":
            if r.p(1) == "?":
                r.seek_cur(2)
                return self.token(TOKEN_GTCI, ">?")
            elif r.p(1) == "#":
                r.seek_cur(2)
                return self.token(TOKEN_GTCS, ">#")
            else:
                r.seek_cur(1)
                return self.token(TOKEN_GT, ">")
        elif c == "<":
            if r.p(1) == "?":
                r.seek_cur(2)
                return self.token(TOKEN_LTCI, "<?")
            elif r.p(1) == "#":
                r.seek_cur(2)
                return self.token(TOKEN_LTCS, "<#")
            else:
                r.seek_cur(1)
                return self.token(TOKEN_LT, "<")
        elif c == "+":
            r.seek_cur(1)
            return self.token(TOKEN_PLUS, "+")
        elif c == "-":
            r.seek_cur(1)
            return self.token(TOKEN_MINUS, "-")
        elif c == ".":
            r.seek_cur(1)
            return self.token(TOKEN_DOT, ".")
        elif c == "*":
            r.seek_cur(1)
            return self.token(TOKEN_STAR, "*")
        elif c == "/":
            r.seek_cur(1)
            return self.token(TOKEN_SLASH, "/")
        elif c == "%":
            r.seek_cur(1)
            return self.token(TOKEN_PERCENT, "%")
        elif c == "!":
            r.seek_cur(1)
            return self.token(TOKEN_NOT, "!")
        elif c == "?":
            r.seek_cur(1)
            return self.token(TOKEN_QUESTION, "?")
        elif c == ":":
            r.seek_cur(1)
            return self.token(TOKEN_COLON, ":")
        elif c == "(":
            r.seek_cur(1)
            return self.token(TOKEN_POPEN, "(")
        elif c == ")":
            r.seek_cur(1)
            return self.token(TOKEN_PCLOSE, ")")
        elif c == "[":
            r.seek_cur(1)
            return self.token(TOKEN_SQOPEN, "[")
        elif c == "]":
            r.seek_cur(1)
            return self.token(TOKEN_SQCLOSE, "]")
        elif c == "{":
            r.seek_cur(1)
            return self.token(TOKEN_COPEN, "{")
        elif c == "}":
            r.seek_cur(1)
            return self.token(TOKEN_CCLOSE, "}")
        elif c == ",":
            r.seek_cur(1)
            return self.token(TOKEN_COMMA, ",")
        elif c == "'":
            r.seek_cur(1)
            return self.token(TOKEN_SQUOTE, "'")
        elif c == "\"":
            r.seek_cur(1)
            return self.token(TOKEN_DQUOTE, "\"")
        elif c == "$":
            s = r.getn(1)
            s += r.read_word()
            return self.token(TOKEN_ENV, s)
        elif c == "@":
            # @<EOL> is treated as @"
            return self.token(TOKEN_REG, r.getn(2))
        elif c == "&":
            if (r.p(1) == "g" or r.p(1) == "l") and r.p(2) == ":":
                s = r.getn(3) + r.read_word()
            else:
                s = r.getn(1) + r.read_word()
            return self.token(TOKEN_OPTION, s)
        elif c == "=":
            r.seek_cur(1)
            return self.token(TOKEN_EQ, "=")
        elif c == "|":
            r.seek_cur(1)
            return self.token(TOKEN_OR, "|")
        elif c == ";":
            r.seek_cur(1)
            return self.token(TOKEN_SEMICOLON, ";")
        elif c == "`":
            r.seek_cur(1)
            return self.token(TOKEN_BACKTICK, "`")
        else:
            raise Exception(self.err("ExprTokenizer: %s", c))

    def get_sstring(self):
        self.reader.skip_white()
        c = self.reader.getn(1)
        if c != "'":
            raise Exception(sefl.err("ExprTokenizer: unexpected character: %s", c))
        s = ""
        while 1:
            c = self.reader.getn(1)
            if c == "":
                raise Exception(self.err("ExprTokenizer: unexpected EOL"))
            elif c == "'":
                if self.reader.peekn(1) == "'":
                    self.reader.getn(1)
                    s += c
                else:
                    break
            else:
                s += c
        return s

    def get_dstring(self):
        self.reader.skip_white()
        c = self.reader.getn(1)
        if c != "\"":
            raise Exception(self.err("ExprTokenizer: unexpected character: %s", c))
        s = ""
        while 1:
            c = self.reader.getn(1)
            if c == "":
                raise Exception(self.err("ExprTokenizer: unexpectd EOL"))
            elif c == "\"":
                break
            elif c == "\\":
                s += c
                c = self.reader.getn(1)
                if c == "":
                    raise Exception(self.err("ExprTokenizer: unexpected EOL"))
                s += c
            else:
                s += c
        return s

class ExprParser:
    def __init__(self, tokenizer):
        self.tokenizer = tokenizer

    def err(self, *a000):
        pos = self.tokenizer.reader.getpos()
        if viml_len(a000) == 1:
            msg = a000[0]
        else:
            msg = viml_printf(*a000)
        return viml_printf("%s: line %d col %d", msg, pos.lnum, pos.col)

    def exprnode(self, type):
        return AttributeDict({"type":type})

    def parse(self):
        return self.parse_expr1()

# expr1: expr2 ? expr1 : expr1
    def parse_expr1(self):
        lhs = self.parse_expr2()
        pos = self.tokenizer.reader.tell()
        token = self.tokenizer.get()
        if token.type == TOKEN_QUESTION:
            node = self.exprnode(NODE_TERNARY)
            node.cond = lhs
            node.then = self.parse_expr1()
            token = self.tokenizer.get()
            if token.type != TOKEN_COLON:
                raise Exception(self.err("ExprParser: unexpected token: %s", token.value))
            node._else = self.parse_expr1()
            lhs = node
        else:
            self.tokenizer.reader.seek_set(pos)
        return lhs

# expr2: expr3 || expr3 ..
    def parse_expr2(self):
        lhs = self.parse_expr3()
        while 1:
            pos = self.tokenizer.reader.tell()
            token = self.tokenizer.get()
            if token.type == TOKEN_OROR:
                node = self.exprnode(NODE_OR)
                node.lhs = lhs
                node.rhs = self.parse_expr3()
                lhs = node
            else:
                self.tokenizer.reader.seek_set(pos)
                break
        return lhs

# expr3: expr4 && expr4
    def parse_expr3(self):
        lhs = self.parse_expr4()
        while 1:
            pos = self.tokenizer.reader.tell()
            token = self.tokenizer.get()
            if token.type == TOKEN_ANDAND:
                node = self.exprnode(NODE_AND)
                node.lhs = lhs
                node.rhs = self.parse_expr4()
                lhs = node
            else:
                self.tokenizer.reader.seek_set(pos)
                break
        return lhs

# expr4: expr5 == expr5
#        expr5 != expr5
#        expr5 >  expr5
#        expr5 >= expr5
#        expr5 <  expr5
#        expr5 <= expr5
#        expr5 =~ expr5
#        expr5 !~ expr5
#
#        expr5 ==? expr5
#        expr5 ==# expr5
#        etc.
#
#        expr5 is expr5
#        expr5 isnot expr5
    def parse_expr4(self):
        lhs = self.parse_expr5()
        pos = self.tokenizer.reader.tell()
        token = self.tokenizer.get()
        if token.type == TOKEN_EQEQ:
            node = self.exprnode(NODE_EQUAL)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_EQEQCI:
            node = self.exprnode(NODE_EQUALCI)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_EQEQCS:
            node = self.exprnode(NODE_EQUALCS)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_NEQ:
            node = self.exprnode(NODE_NEQUAL)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_NEQCI:
            node = self.exprnode(NODE_NEQUALCI)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_NEQCS:
            node = self.exprnode(NODE_NEQUALCS)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_GT:
            node = self.exprnode(NODE_GREATER)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_GTCI:
            node = self.exprnode(NODE_GREATERCI)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_GTCS:
            node = self.exprnode(NODE_GREATERCS)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_GTEQ:
            node = self.exprnode(NODE_GEQUAL)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_GTEQCI:
            node = self.exprnode(NODE_GEQUALCI)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_GTEQCS:
            node = self.exprnode(NODE_GEQUALCS)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_LT:
            node = self.exprnode(NODE_SMALLER)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_LTCI:
            node = self.exprnode(NODE_SMALLERCI)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_LTCS:
            node = self.exprnode(NODE_SMALLERCS)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_LTEQ:
            node = self.exprnode(NODE_SEQUAL)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_LTEQCI:
            node = self.exprnode(NODE_SEQUALCI)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_LTEQCS:
            node = self.exprnode(NODE_SEQUALCS)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_MATCH:
            node = self.exprnode(NODE_MATCH)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_MATCHCI:
            node = self.exprnode(NODE_MATCHCI)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_MATCHCS:
            node = self.exprnode(NODE_MATCHCS)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_NOMATCH:
            node = self.exprnode(NODE_NOMATCH)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_NOMATCHCI:
            node = self.exprnode(NODE_NOMATCHCI)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_NOMATCHCS:
            node = self.exprnode(NODE_NOMATCHCS)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_IS:
            node = self.exprnode(NODE_IS)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_ISCI:
            node = self.exprnode(NODE_ISCI)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_ISCS:
            node = self.exprnode(NODE_ISCS)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_ISNOT:
            node = self.exprnode(NODE_ISNOT)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_ISNOTCI:
            node = self.exprnode(NODE_ISNOTCI)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_ISNOTCS:
            node = self.exprnode(NODE_ISNOTCS)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        else:
            self.tokenizer.reader.seek_set(pos)
        return lhs

# expr5: expr6 + expr6 ..
#        expr6 - expr6 ..
#        expr6 . expr6 ..
    def parse_expr5(self):
        lhs = self.parse_expr6()
        while 1:
            pos = self.tokenizer.reader.tell()
            token = self.tokenizer.get()
            if token.type == TOKEN_PLUS:
                node = self.exprnode(NODE_ADD)
                node.lhs = lhs
                node.rhs = self.parse_expr6()
                lhs = node
            elif token.type == TOKEN_MINUS:
                node = self.exprnode(NODE_SUBTRACT)
                node.lhs = lhs
                node.rhs = self.parse_expr6()
                lhs = node
            elif token.type == TOKEN_DOT:
                node = self.exprnode(NODE_CONCAT)
                node.lhs = lhs
                node.rhs = self.parse_expr6()
                lhs = node
            else:
                self.tokenizer.reader.seek_set(pos)
                break
        return lhs

# expr6: expr7 * expr7 ..
#        expr7 / expr7 ..
#        expr7 % expr7 ..
    def parse_expr6(self):
        lhs = self.parse_expr7()
        while 1:
            pos = self.tokenizer.reader.tell()
            token = self.tokenizer.get()
            if token.type == TOKEN_STAR:
                node = self.exprnode(NODE_MULTIPLY)
                node.lhs = lhs
                node.rhs = self.parse_expr7()
                lhs = node
            elif token.type == TOKEN_SLASH:
                node = self.exprnode(NODE_DIVIDE)
                node.lhs = lhs
                node.rhs = self.parse_expr7()
                lhs = node
            elif token.type == TOKEN_PERCENT:
                node = self.exprnode(NODE_REMAINDER)
                node.lhs = lhs
                node.rhs = self.parse_expr7()
                lhs = node
            else:
                self.tokenizer.reader.seek_set(pos)
                break
        return lhs

# expr7: ! expr7
#        - expr7
#        + expr7
    def parse_expr7(self):
        pos = self.tokenizer.reader.tell()
        token = self.tokenizer.get()
        if token.type == TOKEN_NOT:
            node = self.exprnode(NODE_NOT)
            node.expr = self.parse_expr7()
        elif token.type == TOKEN_MINUS:
            node = self.exprnode(NODE_MINUS)
            node.expr = self.parse_expr7()
        elif token.type == TOKEN_PLUS:
            node = self.exprnode(NODE_PLUS)
            node.expr = self.parse_expr7()
        else:
            self.tokenizer.reader.seek_set(pos)
            node = self.parse_expr8()
        return node

# expr8: expr8[expr1]
#        expr8[expr1 : expr1]
#        expr8.name
#        expr8(expr1, ...)
    def parse_expr8(self):
        lhs = self.parse_expr9()
        while 1:
            pos = self.tokenizer.reader.tell()
            c = self.tokenizer.reader.peek()
            token = self.tokenizer.get()
            if not iswhite(c) and token.type == TOKEN_SQOPEN:
                if self.tokenizer.peek().type == TOKEN_COLON:
                    self.tokenizer.get()
                    node = self.exprnode(NODE_SLICE)
                    node.expr = lhs
                    node.expr1 = NIL
                    node.expr2 = NIL
                    token = self.tokenizer.peek()
                    if token.type != TOKEN_SQCLOSE:
                        node.expr2 = self.parse_expr1()
                    token = self.tokenizer.get()
                    if token.type != TOKEN_SQCLOSE:
                        raise Exception(self.err("ExprParser: unexpected token: %s", token.value))
                else:
                    expr1 = self.parse_expr1()
                    if self.tokenizer.peek().type == TOKEN_COLON:
                        self.tokenizer.get()
                        node = self.exprnode(NODE_SLICE)
                        node.expr = lhs
                        node.expr1 = expr1
                        node.expr2 = NIL
                        token = self.tokenizer.peek()
                        if token.type != TOKEN_SQCLOSE:
                            node.expr2 = self.parse_expr1()
                        token = self.tokenizer.get()
                        if token.type != TOKEN_SQCLOSE:
                            raise Exception(self.err("ExprParser: unexpected token: %s", token.value))
                    else:
                        node = self.exprnode(NODE_SUBSCRIPT)
                        node.expr = lhs
                        node.expr1 = expr1
                        token = self.tokenizer.get()
                        if token.type != TOKEN_SQCLOSE:
                            raise Exception(self.err("ExprParser: unexpected token: %s", token.value))
                lhs = node
            elif token.type == TOKEN_POPEN:
                node = self.exprnode(NODE_CALL)
                node.expr = lhs
                node.args = []
                if self.tokenizer.peek().type == TOKEN_PCLOSE:
                    self.tokenizer.get()
                else:
                    while 1:
                        viml_add(node.args, self.parse_expr1())
                        token = self.tokenizer.get()
                        if token.type == TOKEN_COMMA:
                            pass
                        elif token.type == TOKEN_PCLOSE:
                            break
                        else:
                            raise Exception(self.err("ExprParser: unexpected token: %s", token.value))
                lhs = node
            elif not iswhite(c) and token.type == TOKEN_DOT:
                # SUBSCRIPT or CONCAT
                c = self.tokenizer.reader.peek()
                token = self.tokenizer.peek()
                if not iswhite(c) and token.type == TOKEN_IDENTIFIER:
                    node = self.exprnode(NODE_DOT)
                    node.lhs = lhs
                    node.rhs = self.parse_identifier()
                else:
                    # to be CONCAT
                    self.tokenizer.reader.seek_set(pos)
                    break
                lhs = node
            else:
                self.tokenizer.reader.seek_set(pos)
                break
        return lhs

# expr9: number
#        "string"
#        'string'
#        [expr1, ...]
#        {expr1: expr1, ...}
#        &option
#        (expr1)
#        variable
#        var{ria}ble
#        $VAR
#        @r
#        function(expr1, ...)
#        func{ti}on(expr1, ...)
    def parse_expr9(self):
        pos = self.tokenizer.reader.tell()
        token = self.tokenizer.get()
        if token.type == TOKEN_NUMBER:
            node = self.exprnode(NODE_NUMBER)
            node.value = token.value
        elif token.type == TOKEN_DQUOTE:
            self.tokenizer.reader.seek_set(pos)
            node = self.exprnode(NODE_STRING)
            node.value = "\"" + self.tokenizer.get_dstring() + "\""
        elif token.type == TOKEN_SQUOTE:
            self.tokenizer.reader.seek_set(pos)
            node = self.exprnode(NODE_STRING)
            node.value = "'" + self.tokenizer.get_sstring() + "'"
        elif token.type == TOKEN_SQOPEN:
            node = self.exprnode(NODE_LIST)
            node.items = []
            token = self.tokenizer.peek()
            if token.type == TOKEN_SQCLOSE:
                self.tokenizer.get()
            else:
                while 1:
                    viml_add(node.items, self.parse_expr1())
                    token = self.tokenizer.peek()
                    if token.type == TOKEN_COMMA:
                        self.tokenizer.get()
                        if self.tokenizer.peek().type == TOKEN_SQCLOSE:
                            self.tokenizer.get()
                            break
                    elif token.type == TOKEN_SQCLOSE:
                        self.tokenizer.get()
                        break
                    else:
                        raise Exception(self.err("ExprParser: unexpected token: %s", token.value))
        elif token.type == TOKEN_COPEN:
            node = self.exprnode(NODE_DICT)
            node.items = []
            token = self.tokenizer.peek()
            if token.type == TOKEN_CCLOSE:
                self.tokenizer.get()
            else:
                while 1:
                    key = self.parse_expr1()
                    token = self.tokenizer.get()
                    if token.type == TOKEN_CCLOSE:
                        if not viml_empty(node.items):
                            raise Exception(self.err("ExprParser: unexpected token: %s", token.value))
                        self.tokenizer.reader.seek_set(pos)
                        node = self.parse_identifier()
                        break
                    if token.type != TOKEN_COLON:
                        raise Exception(self.err("ExprParser: unexpected token: %s", token.value))
                    val = self.parse_expr1()
                    viml_add(node.items, [key, val])
                    token = self.tokenizer.get()
                    if token.type == TOKEN_COMMA:
                        if self.tokenizer.peek().type == TOKEN_CCLOSE:
                            self.tokenizer.get()
                            break
                    elif token.type == TOKEN_CCLOSE:
                        break
                    else:
                        raise Exception(self.err("ExprParser: unexpected token: %s", token.value))
        elif token.type == TOKEN_POPEN:
            node = self.exprnode(NODE_NESTING)
            node.expr = self.parse_expr1()
            token = self.tokenizer.get()
            if token.type != TOKEN_PCLOSE:
                raise Exception(self.err("ExprParser: unexpected token: %s", token.value))
        elif token.type == TOKEN_OPTION:
            node = self.exprnode(NODE_OPTION)
            node.value = token.value
        elif token.type == TOKEN_IDENTIFIER:
            self.tokenizer.reader.seek_set(pos)
            node = self.parse_identifier()
        elif token.type == TOKEN_LT and self.tokenizer.reader.getn(4).lower() == "SID>".lower():
            self.tokenizer.reader.seek_set(pos)
            node = self.parse_identifier()
        elif token.type == TOKEN_ENV:
            node = self.exprnode(NODE_ENV)
            node.value = token.value
        elif token.type == TOKEN_REG:
            node = self.exprnode(NODE_REG)
            node.value = token.value
        else:
            raise Exception(self.err("ExprParser: unexpected token: %s", token.value))
        return node

    def parse_identifier(self):
        id = []
        self.tokenizer.reader.skip_white()
        c = self.tokenizer.reader.peek()
        if c == "<" and self.tokenizer.reader.peekn(5).lower() == "<SID>".lower():
            name = self.tokenizer.reader.getn(5)
            viml_add(id, AttributeDict({"curly":0, "value":name}))
        while 1:
            c = self.tokenizer.reader.peek()
            if isnamec(c):
                name = self.tokenizer.reader.read_name()
                viml_add(id, AttributeDict({"curly":0, "value":name}))
            elif c == "{":
                self.tokenizer.reader.get()
                node = self.parse_expr1()
                self.tokenizer.reader.skip_white()
                c = self.tokenizer.reader.get()
                if c != "}":
                    raise Exception(self.err("ExprParser: unexpected token: %s", c))
                viml_add(id, AttributeDict({"curly":1, "value":node}))
            else:
                break
        if viml_len(id) == 1 and id[0].curly == 0:
            node = self.exprnode(NODE_IDENTIFIER)
            node.value = id[0].value
        else:
            node = self.exprnode(NODE_CURLYNAME)
            node.value = id
        return node

class LvalueParser(ExprParser):
    def parse(self):
        return self.parse_lv8()

# expr8: expr8[expr1]
#        expr8[expr1 : expr1]
#        expr8.name
    def parse_lv8(self):
        lhs = self.parse_lv9()
        while 1:
            pos = self.tokenizer.reader.tell()
            c = self.tokenizer.reader.peek()
            token = self.tokenizer.get()
            if not iswhite(c) and token.type == TOKEN_SQOPEN:
                if self.tokenizer.peek().type == TOKEN_COLON:
                    self.tokenizer.get()
                    node = self.exprnode(NODE_SLICE)
                    node.expr = lhs
                    node.expr1 = NIL
                    node.expr2 = NIL
                    token = self.tokenizer.peek()
                    if token.type != TOKEN_SQCLOSE:
                        node.expr2 = self.parse_expr1()
                    token = self.tokenizer.get()
                    if token.type != TOKEN_SQCLOSE:
                        raise Exception(self.err("LvalueParser: unexpected token: %s", token.value))
                else:
                    expr1 = self.parse_expr1()
                    if self.tokenizer.peek().type == TOKEN_COLON:
                        self.tokenizer.get()
                        node = self.exprnode(NODE_SLICE)
                        node.expr = lhs
                        node.expr1 = expr1
                        node.expr2 = NIL
                        token = self.tokenizer.peek()
                        if token.type != TOKEN_SQCLOSE:
                            node.expr2 = self.parse_expr1()
                        token = self.tokenizer.get()
                        if token.type != TOKEN_SQCLOSE:
                            raise Exception(self.err("LvalueParser: unexpected token: %s", token.value))
                    else:
                        node = self.exprnode(NODE_SUBSCRIPT)
                        node.expr = lhs
                        node.expr1 = expr1
                        token = self.tokenizer.get()
                        if token.type != TOKEN_SQCLOSE:
                            raise Exception(self.err("LvalueParser: unexpected token: %s", token.value))
                lhs = node
            elif token.type == TOKEN_DOT:
                # SUBSCRIPT or CONCAT
                c = self.tokenizer.reader.peek()
                token = self.tokenizer.peek()
                if not iswhite(c) and token.type == TOKEN_IDENTIFIER:
                    node = self.exprnode(NODE_DOT)
                    node.lhs = lhs
                    node.rhs = self.parse_identifier()
                else:
                    # to be CONCAT
                    self.tokenizer.reader.seek_set(pos)
                    break
                lhs = node
            else:
                self.tokenizer.reader.seek_set(pos)
                break
        return lhs

# expr9: &option
#        variable
#        var{ria}ble
#        $VAR
#        @r
    def parse_lv9(self):
        pos = self.tokenizer.reader.tell()
        token = self.tokenizer.get()
        if token.type == TOKEN_COPEN:
            self.tokenizer.reader.seek_set(pos)
            node = self.parse_identifier()
        elif token.type == TOKEN_OPTION:
            node = self.exprnode(NODE_OPTION)
            node.value = token.value
        elif token.type == TOKEN_IDENTIFIER:
            self.tokenizer.reader.seek_set(pos)
            node = self.parse_identifier()
        elif token.type == TOKEN_LT and self.tokenizer.reader.getn(4).lower() == "SID>".lower():
            self.tokenizer.reader.seek_set(pos)
            node = self.parse_identifier()
        elif token.type == TOKEN_ENV:
            node = self.exprnode(NODE_ENV)
            node.value = token.value
        elif token.type == TOKEN_REG:
            node = self.exprnode(NODE_REG)
            node.value = token.value
        else:
            raise Exception(self.err("LvalueParser: unexpected token: %s", token.value))
        return node

class StringReader:
    def __init__(self, lines):
        self.lines = lines
        self.buf = []
        self.pos = []
        lnum = 0
        while lnum < viml_len(lines):
            col = 0
            for c in viml_split(lines[lnum], "\\zs"):
                viml_add(self.buf, c)
                viml_add(self.pos, [lnum + 1, col + 1])
                col += viml_len(c)
            while lnum + 1 < viml_len(lines) and viml_eqregh(lines[lnum + 1], "^\\s*\\\\"):
                skip = 1
                col = 0
                for c in viml_split(lines[lnum + 1], "\\zs"):
                    if skip:
                        if c == "\\":
                            skip = 0
                    else:
                        viml_add(self.buf, c)
                        viml_add(self.pos, [lnum + 1, col + 1])
                    col += viml_len(c)
                lnum += 1
            viml_add(self.buf, "<EOL>")
            viml_add(self.pos, [lnum + 1, col + 1])
            lnum += 1
        # for <EOF>
        viml_add(self.pos, [lnum + 1, 0])
        self.i = 0

    def eof(self):
        return self.i >= viml_len(self.buf)

    def tell(self):
        return self.i

    def seek_set(self, i):
        self.i = i

    def seek_cur(self, i):
        self.i = self.i + i

    def seek_end(self, i):
        self.i = viml_len(self.buf) + i

    def p(self, i):
        if self.i >= viml_len(self.buf):
            return "<EOF>"
        return self.buf[self.i + i]

    def peek(self):
        if self.i >= viml_len(self.buf):
            return "<EOF>"
        return self.buf[self.i]

    def get(self):
        if self.i >= viml_len(self.buf):
            return "<EOF>"
        self.i += 1
        return self.buf[self.i - 1]

    def peekn(self, n):
        pos = self.tell()
        r = self.getn(n)
        self.seek_set(pos)
        return r

    def getn(self, n):
        r = ""
        j = 0
        while self.i < viml_len(self.buf) and (n < 0 or j < n):
            c = self.buf[self.i]
            if c == "<EOL>":
                break
            r += c
            self.i += 1
            j += 1
        return r

    def peekline(self):
        return self.peekn(-1)

    def readline(self):
        r = self.getn(-1)
        self.get()
        return r

    def getstr(self, begin, end):
        r = ""
        for i in viml_range(begin.i, end.i - 1):
            if i >= viml_len(self.buf):
                break
            c = self.buf[i]
            if c == "<EOL>":
                c = "\n"
            r += c
        return r

    def getpos(self):
        lnum, col = self.pos[self.i]
        return AttributeDict({"i":self.i, "lnum":lnum, "col":col})

    def setpos(self, pos):
        self.i = pos.i

    def read_alpha(self):
        r = ""
        while isalpha(self.peekn(1)):
            r += self.getn(1)
        return r

    def read_alnum(self):
        r = ""
        while isalnum(self.peekn(1)):
            r += self.getn(1)
        return r

    def read_digit(self):
        r = ""
        while isdigit(self.peekn(1)):
            r += self.getn(1)
        return r

    def read_xdigit(self):
        r = ""
        while isxdigit(self.peekn(1)):
            r += self.getn(1)
        return r

    def read_integer(self):
        r = ""
        c = self.peekn(1)
        if c == "-" or c == "+":
            r = self.getn(1)
        return r + self.read_digit()

    def read_word(self):
        r = ""
        while iswordc(self.peekn(1)):
            r += self.getn(1)
        return r

    def read_white(self):
        r = ""
        while iswhite(self.peekn(1)):
            r += self.getn(1)
        return r

    def read_nonwhite(self):
        r = ""
        while not iswhite(self.peekn(1)):
            r += self.getn(1)
        return r

    def read_name(self):
        r = ""
        while isnamec(self.peekn(1)):
            r += self.getn(1)
        return r

    def skip_white(self):
        while iswhite(self.peekn(1)):
            self.seek_cur(1)

    def skip_white_and_colon(self):
        while 1:
            c = self.peekn(1)
            if not iswhite(c) and c != ":":
                break
            self.seek_cur(1)

class Compiler:
    def __init__(self):
        self.indent = [""]
        self.lines = []

    def out(self, *a000):
        if viml_len(a000) == 1:
            if a000[0][0] == ")":
                self.lines[-1] += a000[0]
            else:
                viml_add(self.lines, self.indent[0] + a000[0])
        else:
            viml_add(self.lines, self.indent[0] + viml_printf(*a000))

    def incindent(self, s):
        viml_insert(self.indent, self.indent[0] + s)

    def decindent(self):
        viml_remove(self.indent, 0)

    def compile(self, node):
        if node.type == NODE_TOPLEVEL:
            return self.compile_toplevel(node)
        elif node.type == NODE_COMMENT:
            return self.compile_comment(node)
        elif node.type == NODE_EXCMD:
            return self.compile_excmd(node)
        elif node.type == NODE_FUNCTION:
            return self.compile_function(node)
        elif node.type == NODE_DELFUNCTION:
            return self.compile_delfunction(node)
        elif node.type == NODE_RETURN:
            return self.compile_return(node)
        elif node.type == NODE_EXCALL:
            return self.compile_excall(node)
        elif node.type == NODE_LET:
            return self.compile_let(node)
        elif node.type == NODE_UNLET:
            return self.compile_unlet(node)
        elif node.type == NODE_LOCKVAR:
            return self.compile_lockvar(node)
        elif node.type == NODE_UNLOCKVAR:
            return self.compile_unlockvar(node)
        elif node.type == NODE_IF:
            return self.compile_if(node)
        elif node.type == NODE_WHILE:
            return self.compile_while(node)
        elif node.type == NODE_FOR:
            return self.compile_for(node)
        elif node.type == NODE_CONTINUE:
            return self.compile_continue(node)
        elif node.type == NODE_BREAK:
            return self.compile_break(node)
        elif node.type == NODE_TRY:
            return self.compile_try(node)
        elif node.type == NODE_THROW:
            return self.compile_throw(node)
        elif node.type == NODE_ECHO:
            return self.compile_echo(node)
        elif node.type == NODE_ECHON:
            return self.compile_echon(node)
        elif node.type == NODE_ECHOHL:
            return self.compile_echohl(node)
        elif node.type == NODE_ECHOMSG:
            return self.compile_echomsg(node)
        elif node.type == NODE_ECHOERR:
            return self.compile_echoerr(node)
        elif node.type == NODE_EXECUTE:
            return self.compile_execute(node)
        elif node.type == NODE_TERNARY:
            return self.compile_ternary(node)
        elif node.type == NODE_OR:
            return self.compile_or(node)
        elif node.type == NODE_AND:
            return self.compile_and(node)
        elif node.type == NODE_EQUAL:
            return self.compile_equal(node)
        elif node.type == NODE_EQUALCI:
            return self.compile_equalci(node)
        elif node.type == NODE_EQUALCS:
            return self.compile_equalcs(node)
        elif node.type == NODE_NEQUAL:
            return self.compile_nequal(node)
        elif node.type == NODE_NEQUALCI:
            return self.compile_nequalci(node)
        elif node.type == NODE_NEQUALCS:
            return self.compile_nequalcs(node)
        elif node.type == NODE_GREATER:
            return self.compile_greater(node)
        elif node.type == NODE_GREATERCI:
            return self.compile_greaterci(node)
        elif node.type == NODE_GREATERCS:
            return self.compile_greatercs(node)
        elif node.type == NODE_GEQUAL:
            return self.compile_gequal(node)
        elif node.type == NODE_GEQUALCI:
            return self.compile_gequalci(node)
        elif node.type == NODE_GEQUALCS:
            return self.compile_gequalcs(node)
        elif node.type == NODE_SMALLER:
            return self.compile_smaller(node)
        elif node.type == NODE_SMALLERCI:
            return self.compile_smallerci(node)
        elif node.type == NODE_SMALLERCS:
            return self.compile_smallercs(node)
        elif node.type == NODE_SEQUAL:
            return self.compile_sequal(node)
        elif node.type == NODE_SEQUALCI:
            return self.compile_sequalci(node)
        elif node.type == NODE_SEQUALCS:
            return self.compile_sequalcs(node)
        elif node.type == NODE_MATCH:
            return self.compile_match(node)
        elif node.type == NODE_MATCHCI:
            return self.compile_matchci(node)
        elif node.type == NODE_MATCHCS:
            return self.compile_matchcs(node)
        elif node.type == NODE_NOMATCH:
            return self.compile_nomatch(node)
        elif node.type == NODE_NOMATCHCI:
            return self.compile_nomatchci(node)
        elif node.type == NODE_NOMATCHCS:
            return self.compile_nomatchcs(node)
        elif node.type == NODE_IS:
            return self.compile_is(node)
        elif node.type == NODE_ISCI:
            return self.compile_isci(node)
        elif node.type == NODE_ISCS:
            return self.compile_iscs(node)
        elif node.type == NODE_ISNOT:
            return self.compile_isnot(node)
        elif node.type == NODE_ISNOTCI:
            return self.compile_isnotci(node)
        elif node.type == NODE_ISNOTCS:
            return self.compile_isnotcs(node)
        elif node.type == NODE_ADD:
            return self.compile_add(node)
        elif node.type == NODE_SUBTRACT:
            return self.compile_subtract(node)
        elif node.type == NODE_CONCAT:
            return self.compile_concat(node)
        elif node.type == NODE_MULTIPLY:
            return self.compile_multiply(node)
        elif node.type == NODE_DIVIDE:
            return self.compile_divide(node)
        elif node.type == NODE_REMAINDER:
            return self.compile_remainder(node)
        elif node.type == NODE_NOT:
            return self.compile_not(node)
        elif node.type == NODE_PLUS:
            return self.compile_plus(node)
        elif node.type == NODE_MINUS:
            return self.compile_minus(node)
        elif node.type == NODE_SUBSCRIPT:
            return self.compile_subscript(node)
        elif node.type == NODE_SLICE:
            return self.compile_slice(node)
        elif node.type == NODE_DOT:
            return self.compile_dot(node)
        elif node.type == NODE_CALL:
            return self.compile_call(node)
        elif node.type == NODE_NUMBER:
            return self.compile_number(node)
        elif node.type == NODE_STRING:
            return self.compile_string(node)
        elif node.type == NODE_LIST:
            return self.compile_list(node)
        elif node.type == NODE_DICT:
            return self.compile_dict(node)
        elif node.type == NODE_NESTING:
            return self.compile_nesting(node)
        elif node.type == NODE_OPTION:
            return self.compile_option(node)
        elif node.type == NODE_IDENTIFIER:
            return self.compile_identifier(node)
        elif node.type == NODE_CURLYNAME:
            return self.compile_curlyname(node)
        elif node.type == NODE_ENV:
            return self.compile_env(node)
        elif node.type == NODE_REG:
            return self.compile_reg(node)
        else:
            raise Exception(self.err("Compiler: unknown node: %s", viml_string(node)))

    def compile_body(self, body):
        for node in body:
            self.compile(node)

    def compile_begin(self, body):
        if viml_len(body) == 1:
            self.compile_body(body)
        else:
            self.out("(begin")
            self.incindent("  ")
            self.compile_body(body)
            self.out(")")
            self.decindent()

    def compile_toplevel(self, node):
        self.compile_body(node.body)
        return self.lines

    def compile_comment(self, node):
        self.out(";%s", node.str)

    def compile_excmd(self, node):
        self.out("(excmd \"%s\")", viml_escape(node.str, "\\\""))

    def compile_function(self, node):
        name = self.compile(node.name)
        if not viml_empty(node.args) and node.args[-1] == "...":
            node.args[-1] = ". ..."
        self.out("(function %s (%s)", name, viml_join(node.args, " "))
        self.incindent("  ")
        self.compile_body(node.body)
        self.out(")")
        self.decindent()

    def compile_delfunction(self, node):
        self.out("(delfunction %s)", self.compile(node.name))

    def compile_return(self, node):
        if node.arg is NIL:
            self.out("(return)")
        else:
            self.out("(return %s)", self.compile(node.arg))

    def compile_excall(self, node):
        self.out("(call %s)", self.compile(node.expr))

    def compile_let(self, node):
        lhs = viml_join([self.compile(vval) for vval in node.lhs.args], " ")
        if node.lhs.rest is not NIL:
            lhs += " . " + self.compile(node.lhs.rest)
        rhs = self.compile(node.rhs)
        self.out("(let %s (%s) %s)", node.op, lhs, rhs)

    def compile_unlet(self, node):
        args = [self.compile(vval) for vval in node.args]
        self.out("(unlet %s)", viml_join(args, " "))

    def compile_lockvar(self, node):
        args = [self.compile(vval) for vval in node.args]
        self.out("(lockvar %s %s)", node.depth, viml_join(args, " "))

    def compile_unlockvar(self, node):
        args = [self.compile(vval) for vval in node.args]
        self.out("(unlockvar %s %s)", node.depth, viml_join(args, " "))

    def compile_if(self, node):
        self.out("(if %s", self.compile(node.cond))
        self.incindent("  ")
        self.compile_begin(node.body)
        self.decindent()
        for enode in node.elseif:
            self.out(" elseif %s", self.compile(enode.cond))
            self.incindent("  ")
            self.compile_begin(enode.body)
            self.decindent()
        if node._else is not NIL:
            self.out(" else")
            self.incindent("  ")
            self.compile_begin(node._else.body)
            self.decindent()
        self.incindent("  ")
        self.out(")")
        self.decindent()

    def compile_while(self, node):
        self.out("(while %s", self.compile(node.cond))
        self.incindent("  ")
        self.compile_body(node.body)
        self.out(")")
        self.decindent()

    def compile_for(self, node):
        lhs = viml_join([self.compile(vval) for vval in node.lhs.args], " ")
        if node.lhs.rest is not NIL:
            lhs += " . " + self.compile(node.lhs.rest)
        rhs = self.compile(node.rhs)
        self.out("(for (%s) %s", lhs, rhs)
        self.incindent("  ")
        self.compile_body(node.body)
        self.out(")")
        self.decindent()

    def compile_continue(self, node):
        self.out("(continue)")

    def compile_break(self, node):
        self.out("(break)")

    def compile_try(self, node):
        self.out("(try")
        self.incindent("  ")
        self.compile_begin(node.body)
        for cnode in node.catch:
            if cnode.pattern is not NIL:
                self.out("(#/%s/", cnode.pattern)
                self.incindent("  ")
                self.compile_body(cnode.body)
                self.out(")")
                self.decindent()
            else:
                self.out("(else")
                self.incindent("  ")
                self.compile_body(cnode.body)
                self.out(")")
                self.decindent()
        if node._finally is not NIL:
            self.out("(finally")
            self.incindent("  ")
            self.compile_body(node._finally.body)
            self.out(")")
            self.decindent()
        self.out(")")
        self.decindent()

    def compile_throw(self, node):
        self.out("(throw %s)", self.compile(node.arg))

    def compile_echo(self, node):
        args = [self.compile(vval) for vval in node.args]
        self.out("(echo %s)", viml_join(args, " "))

    def compile_echon(self, node):
        args = [self.compile(vval) for vval in node.args]
        self.out("(echon %s)", viml_join(args, " "))

    def compile_echohl(self, node):
        self.out("(echohl \"%s\")", viml_escape(node.name, "\\\""))

    def compile_echomsg(self, node):
        args = [self.compile(vval) for vval in node.args]
        self.out("(echomsg %s)", viml_join(args, " "))

    def compile_echoerr(self, node):
        args = [self.compile(vval) for vval in node.args]
        self.out("(echoerr %s)", viml_join(args, " "))

    def compile_execute(self, node):
        args = [self.compile(vval) for vval in node.args]
        self.out("(execute %s)", viml_join(args, " "))

    def compile_ternary(self, node):
        return viml_printf("(?: %s %s %s)", self.compile(node.cond), self.compile(node.then), self.compile(node._else))

    def compile_or(self, node):
        return viml_printf("(|| %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_and(self, node):
        return viml_printf("(&& %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_equal(self, node):
        return viml_printf("(== %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_equalci(self, node):
        return viml_printf("(==? %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_equalcs(self, node):
        return viml_printf("(==# %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_nequal(self, node):
        return viml_printf("(!= %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_nequalci(self, node):
        return viml_printf("(!=? %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_nequalcs(self, node):
        return viml_printf("(!=# %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_greater(self, node):
        return viml_printf("(> %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_greaterci(self, node):
        return viml_printf("(>? %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_greatercs(self, node):
        return viml_printf("(># %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_gequal(self, node):
        return viml_printf("(>= %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_gequalci(self, node):
        return viml_printf("(>=? %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_gequalcs(self, node):
        return viml_printf("(>=# %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_smaller(self, node):
        return viml_printf("(< %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_smallerci(self, node):
        return viml_printf("(<? %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_smallercs(self, node):
        return viml_printf("(<# %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_sequal(self, node):
        return viml_printf("(<= %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_sequalci(self, node):
        return viml_printf("(<=? %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_sequalcs(self, node):
        return viml_printf("(<=# %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_match(self, node):
        return viml_printf("(=~ %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_matchci(self, node):
        return viml_printf("(=~? %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_matchcs(self, node):
        return viml_printf("(=~# %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_nomatch(self, node):
        return viml_printf("(!~ %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_nomatchci(self, node):
        return viml_printf("(!~? %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_nomatchcs(self, node):
        return viml_printf("(!~# %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_is(self, node):
        return viml_printf("(is %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_isci(self, node):
        return viml_printf("(is? %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_iscs(self, node):
        return viml_printf("(is# %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_isnot(self, node):
        return viml_printf("(isnot %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_isnotci(self, node):
        return viml_printf("(isnot? %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_isnotcs(self, node):
        return viml_printf("(isnot# %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_add(self, node):
        return viml_printf("(+ %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_subtract(self, node):
        return viml_printf("(- %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_concat(self, node):
        return viml_printf("(concat %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_multiply(self, node):
        return viml_printf("(* %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_divide(self, node):
        return viml_printf("(/ %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_remainder(self, node):
        return viml_printf("(%% %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_not(self, node):
        return viml_printf("(! %s)", self.compile(node.expr))

    def compile_plus(self, node):
        return viml_printf("(+ %s)", self.compile(node.expr))

    def compile_minus(self, node):
        return viml_printf("(- %s)", self.compile(node.expr))

    def compile_subscript(self, node):
        return viml_printf("(subscript %s %s)", self.compile(node.expr), self.compile(node.expr1))

    def compile_slice(self, node):
        expr1 = "nil" if node.expr1 is NIL else self.compile(node.expr1)
        expr2 = "nil" if node.expr2 is NIL else self.compile(node.expr2)
        return viml_printf("(slice %s %s %s)", self.compile(node.expr), expr1, expr2)

    def compile_dot(self, node):
        return viml_printf("(dot %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_call(self, node):
        args = [self.compile(vval) for vval in node.args]
        if viml_empty(args):
            return viml_printf("(%s)", self.compile(node.expr))
        else:
            return viml_printf("(%s %s)", self.compile(node.expr), viml_join(args, " "))

    def compile_number(self, node):
        return node.value

    def compile_string(self, node):
        return node.value

    def compile_list(self, node):
        items = [self.compile(vval) for vval in node.items]
        if viml_empty(items):
            return "(list)"
        else:
            return viml_printf("(list %s)", viml_join(items, " "))

    def compile_dict(self, node):
        items = ["(" + self.compile(vval[0]) + " " + self.compile(vval[1]) + ")" for vval in node.items]
        if viml_empty(items):
            return "(dict)"
        else:
            return viml_printf("(dict %s)", viml_join(items, " "))

    def compile_nesting(self, node):
        return self.compile(node.expr)

    def compile_option(self, node):
        return node.value

    def compile_identifier(self, node):
        return node.value

    def compile_curlyname(self, node):
        name = ""
        for x in node.value:
            if x.curly:
                name += "{" + self.compile(x.value) + "}"
            else:
                name += x.value
        return name

    def compile_env(self, node):
        return node.value

    def compile_reg(self, node):
        return node.value


main()
