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
	force_ff     int
	force_enc    int
	bad_char     int
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
	value *value
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

type value interface{}

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
	pos   pos
}

type ExprTokenizer struct {
	reader *StringReader
	cache  map[int]*ExprToken
}

func NewExprTokenizer(reader *StringReader) *ExprTokenizer {
	obj := &ExprTokenizer{}
	obj.__init__(reader)
	return obj
}

func (self *ExprTokenizer) token(type_ int, value string, pos pos) *ExprToken {
	return &ExprToken{}
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

type vimlList interface{}

func viml_add(lst vimlList, item interface{}) vimlList {
	panic("NotImplemented")
	// should use go builtin append() func
}

func viml_call(f string, args ...interface{}) interface{} {
	panic("NotImplemented")
}

func viml_char2nr(c string) int {
	panic("NotImplemented")
}

func viml_empty(obj interface{}) bool {
	panic("NotImplemented")
}

func viml_equalci(a, b string) bool {
	panic("NotImplemented")
}

func viml_eqreg(s, reg string) bool {
	panic("NotImplemented")
}

func viml_eqregh(s, reg string) bool {
	panic("NotImplemented")
}

func viml_eqregq(s, reg string) bool {
	panic("NotImplemented")
}

func viml_escape(s string, chars []string) bool {
	panic("NotImplemented")
}

func viml_extend(obj, item interface{}) interface{} {
	panic("NotImplemented")
}

func viml_insert(lst vimlList, item interface{}) {
	panic("NotImplemented")
}

func viml_join(lst []string, sep string) string {
	panic("NotImplemented")
}

func viml_keys(obj map[string]interface{}) []string {
	panic("NotImplemented")
}

func viml_len(obj interface{}) int {
	panic("NotImplemented")
}

func viml_printf(f string, args ...interface{}) string {
	panic("NotImplemented")
}

func viml_range(start, end int) []int {
	panic("NotImplemented")
}

func viml_readfile(path string) []string {
	panic("NotImplemented")
}

func viml_remove(lst vimlList, idx int) {
	panic("NotImplemented")
}

func viml_split(s string, sep string) []string {
	if sep == `\zs` {
		var ss []string
		for _, r := range s {
			ss = append(ss, string(r))
		}
		return ss
	}
	panic("NotImplemented")
}

func viml_str2nr(s string, base int) int {
	panic("NotImplemented")
}

func viml_string(obj interface{}) string {
	panic("NotImplemented")
}

func viml_has_key(obj map[string]interface{}, key string) bool {
	panic("NotImplemented")
}

func viml_stridx(a, b string) int {
	panic("NotImplemented")
}

func viml_type(obj interface{}) int {
	panic("NotImplemented")
}
