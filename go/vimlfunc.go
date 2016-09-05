package vimlparser

import (
	"fmt"
	"reflect"
	"regexp"
	"strconv"
	"strings"
)

// copied and little modified(^++) from ./py/vimlfunc.py
var patVim2Go = map[string]string{
	"[0-9a-zA-Z]":                       "[0-9a-zA-Z]",
	"[@*!=><&~#]":                       "[@*!=><&~#]",
	"\\<ARGOPT\\>":                      "\\bARGOPT\\b",
	"\\<BANG\\>":                        "\\bBANG\\b",
	"\\<EDITCMD\\>":                     "\\bEDITCMD\\b",
	"\\<NOTRLCOM\\>":                    "\\bNOTRLCOM\\b",
	"\\<TRLBAR\\>":                      "\\bTRLBAR\\b",
	"\\<USECTRLV\\>":                    "\\bUSECTRLV\\b",
	"\\<\\(XFILE\\|FILES\\|FILE1\\)\\>": "\\b(XFILE|FILES|FILE1)\\b",
	"\\S":                                      "\\S",
	"\\a":                                      "[A-Za-z]",
	"\\d":                                      "\\d",
	"\\h":                                      "[A-Za-z_]",
	"\\s":                                      "\\s",
	"\\v^d%[elete][lp]$":                       "^d(elete|elet|ele|el|e)[lp]$",
	"\\v^s%(c[^sr][^i][^p]|g|i[^mlg]|I|r[^e])": "^s(c[^sr][^i][^p]|g|i[^mlg]|I|r[^e])",
	"\\w":        "[0-9A-Za-z_]",
	"\\w\\|[:#]": "[0-9A-Za-z_]|[:#]",
	"\\x":        "[0-9A-Fa-f]",
	"^++":        "^\\+\\+",
	"^++bad=\\(keep\\|drop\\|.\\)\\>":                       "^\\+\\+bad=(keep|drop|.)\\b",
	"^++bad=drop":                                           "^\\+\\+bad=drop",
	"^++bad=keep":                                           "^\\+\\+bad=keep",
	"^++bin\\>":                                             "^\\+\\+bin\\b",
	"^++edit\\>":                                            "^\\+\\+edit\\b",
	"^++enc=\\S":                                            "^\\+\\+enc=\\S",
	"^++encoding=\\S":                                       "^\\+\\+encoding=\\S",
	"^++ff=\\(dos\\|unix\\|mac\\)\\>":                       "^\\+\\+ff=(dos|unix|mac)\\b",
	"^++fileformat=\\(dos\\|unix\\|mac\\)\\>":               "^\\+\\+fileformat=(dos|unix|mac)\\b",
	"^++nobin\\>":                                           "^\\+\\+nobin\\b",
	"^[A-Z]":                                                "^[A-Z]",
	"^\\$\\w\\+":                                            "^\\$[0-9A-Za-z_]+",
	"^\\(!\\|global\\|vglobal\\)$":                          "^(!|global|vglobal)$",
	"^\\(WHILE\\|FOR\\)$":                                   "^(WHILE|FOR)$",
	"^\\(vimgrep\\|vimgrepadd\\|lvimgrep\\|lvimgrepadd\\)$": "^(vimgrep|vimgrepadd|lvimgrep|lvimgrepadd)$",
	"^\\d":                     "^\\d",
	"^\\h":                     "^[A-Za-z_]",
	"^\\s":                     "^\\s",
	"^\\s*\\\\":                "^\\s*\\\\",
	"^[ \\t]$":                 "^[ \\t]$",
	"^[A-Za-z]$":               "^[A-Za-z]$",
	"^[0-9A-Za-z]$":            "^[0-9A-Za-z]$",
	"^[0-9]$":                  "^[0-9]$",
	"^[0-9A-Fa-f]$":            "^[0-9A-Fa-f]$",
	"^[0-9A-Za-z_]$":           "^[0-9A-Za-z_]$",
	"^[A-Za-z_]$":              "^[A-Za-z_]$",
	"^[0-9A-Za-z_:#]$":         "^[0-9A-Za-z_:#]$",
	"^[A-Za-z_][0-9A-Za-z_]*$": "^[A-Za-z_][0-9A-Za-z_]*$",
	"^[A-Z]$":                  "^[A-Z]$",
	"^[a-z]$":                  "^[a-z]$",
	"^[vgslabwt]:$\\|^\\([vgslabwt]:\\)\\?[A-Za-z_][0-9A-Za-z_#]*$": "^[vgslabwt]:$|^([vgslabwt]:)?[A-Za-z_][0-9A-Za-z_#]*$",
	"^[0-7]$": "^[0-7]$",
}

var patVim2GoRegh = make(map[string]*regexp.Regexp)
var patVim2GoRegq = make(map[string]*regexp.Regexp)

func init() {
	for k, v := range patVim2Go {
		patVim2GoRegh[k] = regexp.MustCompile(v)
		patVim2GoRegq[k] = regexp.MustCompile("(?i)" + v)
	}
}

type vimlList interface{}

func viml_call(f string, args ...interface{}) interface{} {
	panic("NotImplemented viml_call")
}

func viml_char2nr(c string) int {
	panic("NotImplemented viml_char2nr")
}

func viml_empty(obj interface{}) bool {
	return viml_len(obj) == 0
}

func viml_equalci(a, b string) bool {
	return strings.ToLower(a) == strings.ToLower(b)
}
func viml_eqreg(s, reg string) bool {
	if r, ok := patVim2GoRegq[reg]; ok {
		return r.MatchString(s)
	}
	panic(fmt.Errorf("NotImplemented viml_eqreg for %v", reg))
}

func viml_eqregh(s, reg string) bool {
	if r, ok := patVim2GoRegh[reg]; ok {
		return r.MatchString(s)
	}
	panic("NotImplemented viml_eqregh")
}

func viml_eqregq(s, reg string) bool {
	if r, ok := patVim2GoRegq[reg]; ok {
		return r.MatchString(s)
	}
	panic("NotImplemented viml_eqregq")
}

func viml_escape(s string, chars string) string {
	r := ""
	for _, c := range s {
		if strings.IndexRune(chars, c) != -1 {
			r += `\` + string(c)
		} else {
			r += string(c)
		}
	}
	return r
}

func viml_extend(obj, item interface{}) interface{} {
	panic("NotImplemented viml_extend")
}

func viml_join(lst vimlList, sep string) string {
	var ss []string
	s := reflect.ValueOf(lst)
	for i := 0; i < s.Len(); i++ {
		ss = append(ss, fmt.Sprintf("%v", s.Index(i)))
	}
	return strings.Join(ss, sep)
}

func viml_keys(obj map[string]interface{}) []string {
	panic("NotImplemented viml_keys")
}

func viml_len(obj interface{}) int {
	return reflect.ValueOf(obj).Len()
}

func viml_printf(f string, args ...interface{}) string {
	return fmt.Sprintf(f, args...)
}

func viml_range(start, end int) []int {
	var rs []int
	for i := start; i <= end; i++ {
		rs = append(rs, i)
	}
	return rs
}

func viml_readfile(path string) []string {
	panic("NotImplemented viml_readfile")
}

func viml_split(s string, sep string) []string {
	if sep == `\zs` {
		var ss []string
		for _, r := range s {
			ss = append(ss, string(r))
		}
		return ss
	}
	panic("NotImplemented viml_split")
}

func viml_str2nr(s string, base int) int {
	r, err := strconv.ParseInt(s, base, 32)
	if err != nil {
		panic(fmt.Errorf("viml_str2nr: %v", err))
	}
	return int(r)
}

func viml_string(obj interface{}) string {
	panic("NotImplemented viml_string")
}

func viml_has_key(obj interface{}, key interface{}) bool {
	m := reflect.ValueOf(obj)
	v := m.MapIndex(reflect.ValueOf(key))
	return v.Kind() != reflect.Invalid
}

func viml_stridx(a, b string) int {
	return strings.Index(a, b)
}

func viml_type(obj interface{}) int {
	panic("NotImplemented viml_type")
}

func viml_ternary(cond bool, a interface{}, b interface{}) interface{} {
	panic("NotImplemented viml_ternary")
}
