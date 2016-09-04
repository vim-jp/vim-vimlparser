package vimlparser

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

type node struct {
	type_ int // type -> type_
	pos   *pos
	left  *node
	right *node
	cond  *node
	rest  *node
	list  []*node
	rlist []*node
	body  []*node
	op    string
	str   string
	depth int
	value interface{}

	ea   *ExArg
	attr *FuncAttr

	endfunction *node
	elseif      []*node
	else_       *node
	endif       *node
	endwhile    *node
	endfor      *node
	endtry      *node

	catch   []*node
	finally *node

	pattern string
	curly   bool
}

type FuncAttr struct {
	range_ bool
	abort  bool
	dict   bool
}

type lhs struct {
	left *node
	list []*node
	rest *node
}

type pos struct {
	i    int
	lnum int
	col  int
}

// Node returns new node.
func Node(type_ int) *node {
	return &node{type_: type_}
}

// TODO: generate from vimlparser.vim
var builtin_commands = []*Cmd{}

type VimLParser struct {
	find_command_cache map[string]*Cmd
	reader             *StringReader
	context            []*node
	ea                 *ExArg
}

func NewVimLParser() *VimLParser {
	obj := &VimLParser{}
	obj.__init__()
	return obj
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
	obj := &LvalueParser{}
	obj.__init__(reader)
	return obj
}

type StringReader struct {
	i   int
	pos [][2]int
	buf []string
}

func NewStringReader(lines []string) *StringReader {
	obj := &StringReader{}
	obj.__init__(lines)
	return obj
}

func (self *StringReader) getpos() *pos {
	var p = self.pos[self.i]
	var lnum, col = p[0], p[1]
	return &pos{i: self.i, lnum: lnum, col: col}
}
