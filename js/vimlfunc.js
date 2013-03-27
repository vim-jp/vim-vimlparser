//!/usr/bin/env nodejs
// usage: nodejs vimlparser.js foo.vim

var fs = require('fs');
var util = require('util');

function main() {
    var r = new StringReader(viml_readfile(process.argv[2]));
    var p = new VimLParser();
    var c = new Compiler();
    var lines = c.compile(p.parse(r))
    for (var i in lines) {
        process.stdout.write(lines[i] + "\n");
    }
}

var pat_vim2js = {
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
  "^[A-Za-z_][0-9A-Za-z_]*$" : "^[A-Za-z_][0-9A-Za-z_]*$",
  "^[A-Z]$" : "^[A-Z]$",
  "^[a-z]$" : "^[a-z]$",
  "^[vgslabwt]:$\\|^\\([vgslabwt]:\\)\\?[A-Za-z_][0-9A-Za-z_]*$" : "^[vgslabwt]:$|^([vgslabwt]:)?[A-Za-z_][0-9A-Za-z_]*$",
}

function viml_add(lst, item) {
    lst.push(item);
}

function viml_call(func, args) {
    return func.apply(null, args);
}

function viml_empty(obj) {
    return obj.length == 0;
}

function viml_equalci(a, b) {
    return a.toLowerCase() == b.toLowerCase();
}

function viml_eqreg(s, reg) {
    var mx = new RegExp(pat_vim2js[reg]);
    return mx.exec(s) != null;
}

function viml_eqregh(s, reg) {
    var mx = new RegExp(pat_vim2js[reg]);
    return mx.exec(s) != null;
}

function viml_eqregq(s, reg) {
    var mx = new RegExp(pat_vim2js[reg], "i");
    return mx.exec(s) != null;
}

function viml_escape(s, chars) {
    var r = '';
    for (var i = 0; i < s.length; ++i) {
        if (chars.indexOf(s.charAt(i)) != -1) {
            r = r + "\\" + s.charAt(i);
        } else {
            r = r + s.charAt(i);
        }
    }
    return r;
}

function viml_extend(obj, item) {
    obj.push.apply(obj, item);
}

function viml_insert(lst, item) {
    var idx = arguments.length >= 3 ? arguments[2] : 0;
    lst.splice(0, 0, item);
}

function viml_join(lst, sep) {
    return lst.join(sep);
}

function viml_keys(obj) {
    return Object.keys(obj);
}

function viml_len(obj) {
    return obj.length;
}

function viml_printf() {
    var a000 = Array.prototype.slice.call(arguments, 0);
    if (a000.length == 1) {
        return a000[0];
    } else {
        return util.format.apply(null, a000);
    }
}

function viml_range(start) {
    var end = arguments.length >= 2 ? arguments[1] : null;
    if (end == null) {
        var x = [];
        for (var i = 0; i < start; ++i) {
            x.push(i);
        }
        return x;
    } else {
        var x = []
        for (var i = start; i <= end; ++i) {
            x.push(i);
        }
        return x;
    }
}

function viml_readfile(path) {
    // FIXME: newline?
    return fs.readFileSync(path, 'utf-8').split(/\n/);
}

function viml_remove(lst, idx) {
    lst.splice(idx, 1);
}

function viml_split(s, sep) {
    if (sep == "\\zs") {
        return s.split("");
    }
    throw "NotImplemented";
}

function viml_str2nr(s) {
    var base = arguments.length >= 2 ? arguments[1] : 10;
    return parseInt(s, base);
}

function viml_string(obj) {
    return obj.toString();
}

function viml_has_key(obj, key) {
    return obj[key] !== undefined;
}

function viml_stridx(a, b) {
    return a.indexOf(b);
}

function viml_type(obj) {
  if (typeof obj == 'number' && Math.round(obj) == obj) {
    return 0;
  } else if (typeof obj == 'string') {
    return 1;
  } else if (typeof obj == 'function') {
    return 2;
  } else if (obj instanceof Array) {
    return 3;
  } else if (obj instanceof Object) {
    return 4;
  } else if (typeof obj == 'number') {
    return 5;
  }
  throw 'Unknown Type';
}

