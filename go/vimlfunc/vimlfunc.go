package vimlparser

type ExArg struct {
	forceit      int
	addr_count   int
	line1        int
	line2        int
	flags        int
	do_ecmd_cmd  string
	do_ecmd_lnum int
	append       int
	usefilter    int
	amount       int
	regname      int
	force_bin    int
	read_edit    int
	force_ff     int
	force_enc    int
	bad_char     int
	linepos      *pos
	cmdpos       []interface{}
	argpos       []interface{}
	// cmd          map[string]interface{}
	cmd       Cmd
	modifiers []interface{}
	range_    []interface{} // range -> range_
	argopt    map[string]interface{}
	argcmd    map[string]interface{}
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

type ExprToken struct {
	type_ int
	value string
	pos   pos
}

func (self *ExprTokenizer) token(type_ int, value string, pos pos) *ExprToken {
	return &ExprToken{}
}

func (self *StringReader) getpos() *pos {
	var p = self.pos[self.i]
	var lnum, col = p[0], p[1]
	return &pos{i: self.i, lnum: lnum, col: col}
}
