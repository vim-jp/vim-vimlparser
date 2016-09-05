package vimlparser

import "strings"

type ExArg struct {
	forceit      bool
	addr_count   int
	line1        int
	line2        int
	flags        int
	do_ecmd_cmd  string
	do_ecmd_lnum int
	append       int
	usefilter    bool
	amount       int
	regname      int
	force_bin    int
	read_edit    int
	force_ff     string // int
	force_enc    string // int
	bad_char     string // int
	linepos      *pos
	cmdpos       *pos
	argpos       *pos
	cmd          *Cmd
	modifiers    []interface{}
	range_       []interface{} // range -> range_
	argopt       map[string]interface{}
	argcmd       map[string]interface{}
}

type Cmd struct {
	name   string
	minlen int
	flags  string
	parser string
}

type VimNode struct {
	type_ int // type -> type_
	pos   *pos
	left  *VimNode
	right *VimNode
	cond  *VimNode
	rest  *VimNode
	list  []*VimNode
	rlist []*VimNode
	body  []*VimNode
	op    string
	str   string
	depth int
	value interface{}

	ea   *ExArg
	attr *FuncAttr

	endfunction *VimNode
	elseif      []*VimNode
	else_       *VimNode
	endif       *VimNode
	endwhile    *VimNode
	endfor      *VimNode
	endtry      *VimNode

	catch   []*VimNode
	finally *VimNode

	pattern string
	curly   bool
}

type FuncAttr struct {
	range_ bool
	abort  bool
	dict   bool
}

type lhs struct {
	left *VimNode
	list []*VimNode
	rest *VimNode
}

type pos struct {
	i    int
	lnum int
	col  int
}

// Node returns new VimNode.
func Node(type_ int) *VimNode {
	return &VimNode{
		type_: type_,
		attr:  &FuncAttr{},
	}
}

type VimLParser struct {
	find_command_cache map[string]*Cmd
	reader             *StringReader
	context            []*VimNode
	ea                 *ExArg
}

func NewVimLParser() *VimLParser {
	obj := &VimLParser{}
	obj.find_command_cache = make(map[string]*Cmd)
	obj.__init__()
	return obj
}

func (self *VimLParser) push_context(n *VimNode) {
	self.context = append([]*VimNode{n}, self.context...)
}

func (self *VimLParser) pop_context() {
	self.context = self.context[1:]
}

type ExprToken struct {
	type_ int
	value string
	pos   *pos
}

type ExprTokenizer struct {
	reader *StringReader
	cache  map[int][]interface{} // (int, *ExprToken)
}

func NewExprTokenizer(reader *StringReader) *ExprTokenizer {
	obj := &ExprTokenizer{}
	obj.cache = make(map[int][]interface{})
	obj.__init__(reader)
	return obj
}

func (self *ExprTokenizer) token(type_ int, value string, pos *pos) *ExprToken {
	return &ExprToken{type_: type_, value: value, pos: pos}
}

type ExprParser struct {
	reader    *StringReader
	tokenizer *ExprTokenizer
}

func NewExprParser(reader *StringReader) *ExprParser {
	obj := &ExprParser{}
	obj.__init__(reader)
	return obj
}

type LvalueParser struct {
	*ExprParser
}

func NewLvalueParser(reader *StringReader) *LvalueParser {
	obj := &LvalueParser{&ExprParser{}}
	obj.__init__(reader)
	return obj
}

type StringReader struct {
	i   int
	pos [][]interface{} // (lnum, col int)
	buf []string
}

func NewStringReader(lines []string) *StringReader {
	obj := &StringReader{}
	obj.__init__(lines)
	return obj
}

func (self *StringReader) getpos() *pos {
	var p = self.pos[self.i]
	var lnum, col = p[0].(int), p[1].(int)
	return &pos{i: self.i, lnum: lnum, col: col}
}

type Compiler struct {
	indent []string
	lines  []string
}

func NewCompiler() *Compiler {
	obj := &Compiler{}
	obj.__init__()
	return obj
}

func (self *Compiler) __init__() {
	self.indent = []string{""}
	self.lines = []string{}
}

func (self *Compiler) out(f string, args ...interface{}) {
	if viml_len(args) == 0 {
		if string(f[0]) == ")" {
			self.lines[len(self.lines)-1] += f
		} else {
			self.lines = append(self.lines, self.indent[0]+f)
		}
	} else {
		self.lines = append(self.lines, self.indent[0]+viml_printf(f, args...))
	}
}

func (self *Compiler) incindent(s string) {
	self.indent = append([]string{self.indent[0] + s}, self.indent...)
}

func (self *Compiler) decindent() {
	self.indent = self.indent[1:]
}

func (self *Compiler) compile_curlynameexpr(n *VimNode) string {
	return "{" + self.compile(n.value.(*VimNode)).(string) + "}"
}

func (self *Compiler) compile_list(n *VimNode) string {
	var value = func() []string {
		var ss []string
		for _, vval := range n.value.([]interface{}) {
			ss = append(ss, self.compile(vval.(*VimNode)).(string))
		}
		return ss
	}()
	if viml_empty(value) {
		return "(list)"
	} else {
		return viml_printf("(list %s)", viml_join(value, " "))
	}
}

func (self *Compiler) compile_curlyname(n *VimNode) string {
	return viml_join(func() []string {
		var ss []string
		for _, vval := range n.value.([]*VimNode) {
			ss = append(ss, self.compile(vval).(string))
		}
		return ss
	}(), "")
}

func (self *Compiler) compile_dict(n *VimNode) string {
	var value = []string{}
	for _, nn := range n.value.([]interface{}) {
		kv := nn.([]interface{})
		value = append(value, "("+self.compile(kv[0].(*VimNode)).(string)+" "+self.compile(kv[1].(*VimNode)).(string)+")")
	}
	// var value = viml_map(VimNode.value, "\"(\" . self.compile(v:val[0]) . \" \" . self.compile(v:val[1]) . \")\"")
	if viml_empty(value) {
		return "(dict)"
	} else {
		return viml_printf("(dict %s)", strings.Join(value, " "))
	}
}
