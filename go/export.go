package vimlparser

type ExportExArg struct {
	Forceit    bool
	AddrCount  int
	Line1      int
	Line2      int
	Flags      int
	DoEcmdCmd  string
	DoEcmdLnum int
	Append     int
	Usefilter  bool
	Amount     int
	Regname    int
	ForceBin   int
	ReadEdit   int
	ForceFf    string // int
	ForceEnc   string // int
	BadChar    string // int
	Linepos    *ExportPos
	Cmdpos     *ExportPos
	Argpos     *ExportPos
	Cmd        *ExportCmd
	Modifiers  []interface{}
	Range      []interface{}
	Argopt     map[string]interface{}
	Argcmd     map[string]interface{}
}

func NewExportExArg(ea *ExArg) *ExportExArg {
	return &ExportExArg{
		Forceit:    ea.forceit,
		AddrCount:  ea.addr_count,
		Line1:      ea.line1,
		Line2:      ea.line2,
		Flags:      ea.flags,
		DoEcmdCmd:  ea.do_ecmd_cmd,
		DoEcmdLnum: ea.do_ecmd_lnum,
		Append:     ea.append,
		Usefilter:  ea.usefilter,
		Amount:     ea.amount,
		Regname:    ea.regname,
		ForceBin:   ea.force_bin,
		ReadEdit:   ea.read_edit,
		ForceFf:    ea.force_ff,
		ForceEnc:   ea.force_enc,
		BadChar:    ea.bad_char,
		Linepos:    NewExportPos(ea.linepos),
		Cmdpos:     NewExportPos(ea.cmdpos),
		Argpos:     NewExportPos(ea.argpos),
		Cmd:        NewExportCmd(ea.cmd),
		Modifiers:  ea.modifiers,
		Range:      ea.range_,
		Argopt:     ea.argopt,
		Argcmd:     ea.argcmd,
	}
}

type ExportCmd struct {
	Name   string
	Minlen int
	Flags  string
	Parser string
}

func NewExportCmd(c *Cmd) *ExportCmd {
	return &ExportCmd{
		Name:   c.name,
		Minlen: c.minlen,
		Flags:  c.flags,
		Parser: c.parser,
	}
}

type ExportPos struct {
	I    int
	Lnum int
	Col  int
}

func NewExportPos(p *pos) *ExportPos {
	return &ExportPos{
		I:    p.i,
		Lnum: p.lnum,
		Col:  p.col,
	}
}

type ExportNode struct {
	Type  int
	Pos   *ExportPos
	Left  *ExportNode
	Right *ExportNode
	Cond  *ExportNode
	Rest  *ExportNode
	List  []*ExportNode
	Rlist []*ExportNode
	Body  []*ExportNode
	Op    string
	Str   string
	Depth int
	Value interface{}

	Ea   *ExportExArg
	Attr *ExportFuncAttr

	Endfunction *ExportNode
	Elseif      []*ExportNode
	Else        *ExportNode
	Endif       *ExportNode
	Endwhile    *ExportNode
	Endfor      *ExportNode
	Endtry      *ExportNode

	Catch   []*ExportNode
	Finally *ExportNode

	Pattern string
	Curly   bool
}

func NewExportNode(n *VimNode) *ExportNode {
	list := make([]*ExportNode, len(n.list))
	for _, n := range n.list {
		list = append(list, NewExportNode(n))
	}
	rlist := make([]*ExportNode, len(n.rlist))
	for _, n := range n.rlist {
		rlist = append(rlist, NewExportNode(n))
	}
	body := make([]*ExportNode, len(n.body))
	for _, n := range n.body {
		body = append(body, NewExportNode(n))
	}
	elseif := make([]*ExportNode, len(n.elseif))
	for _, n := range n.elseif {
		elseif = append(elseif, NewExportNode(n))
	}
	catch := make([]*ExportNode, len(n.catch))
	for _, n := range n.catch {
		catch = append(catch, NewExportNode(n))
	}
	return &ExportNode{
		Type:  n.type_,
		Pos:   NewExportPos(n.pos),
		Left:  NewExportNode(n.left),
		Right: NewExportNode(n.right),
		Cond:  NewExportNode(n.cond),
		Rest:  NewExportNode(n.rest),
		List:  list,
		Rlist: rlist,
		Body:  body,
		Op:    n.op,
		Str:   n.str,
		Depth: n.depth,
		Value: n.value,

		Ea:   NewExportExArg(n.ea),
		Attr: NewExportFuncAttr(n.attr),

		Endfunction: NewExportNode(n.endfunction),
		Elseif:      elseif,
		Else:        NewExportNode(n.else_),
		Endif:       NewExportNode(n.endif),
		Endwhile:    NewExportNode(n.endwhile),
		Endfor:      NewExportNode(n.endfor),
		Endtry:      NewExportNode(n.endtry),

		Catch:   catch,
		Finally: NewExportNode(n.finally),

		Pattern: n.pattern,
		Curly:   n.curly,
	}
}

type ExportFuncAttr struct {
	Range bool
	Abort bool
	Dict  bool
}

func NewExportFuncAttr(attr *FuncAttr) *ExportFuncAttr {
	return &ExportFuncAttr{
		Range: attr.range_,
		Abort: attr.abort,
		Dict:  attr.dict,
	}
}

func (self *VimLParser) Parse(reader *StringReader) *ExportNode {
	return NewExportNode(self.parse(reader))
}

func (self *Compiler) Compile(node *ExportNode) []string {
	return NewCompiler().compile(newInternalNode(node)).([]string)
}

func newInternalNode(n *ExportNode) *VimNode {
	list := make([]*VimNode, len(n.List))
	for _, n := range n.List {
		list = append(list, newInternalNode(n))
	}
	rlist := make([]*VimNode, len(n.Rlist))
	for _, n := range n.Rlist {
		rlist = append(rlist, newInternalNode(n))
	}
	body := make([]*VimNode, len(n.Body))
	for _, n := range n.Body {
		body = append(body, newInternalNode(n))
	}
	elseif := make([]*VimNode, len(n.Elseif))
	for _, n := range n.Elseif {
		elseif = append(elseif, newInternalNode(n))
	}
	catch := make([]*VimNode, len(n.Catch))
	for _, n := range n.Catch {
		catch = append(catch, newInternalNode(n))
	}
	return &VimNode{
		type_: n.Type,
		pos:   newInternalPos(n.Pos),
		left:  newInternalNode(n.Left),
		right: newInternalNode(n.Right),
		cond:  newInternalNode(n.Cond),
		rest:  newInternalNode(n.Rest),
		list:  list,
		rlist: rlist,
		body:  body,
		op:    n.Op,
		str:   n.Str,
		depth: n.Depth,
		value: n.Value,

		ea:   newInternalExArg(n.Ea),
		attr: newInternalFuncAttr(n.Attr),

		endfunction: newInternalNode(n.Endfunction),
		elseif:      elseif,
		else_:       newInternalNode(n.Else),
		endif:       newInternalNode(n.Endif),
		endwhile:    newInternalNode(n.Endwhile),
		endfor:      newInternalNode(n.Endfor),
		endtry:      newInternalNode(n.Endtry),

		catch:   catch,
		finally: newInternalNode(n.Finally),

		pattern: n.Pattern,
		curly:   n.Curly,
	}
}

func newInternalPos(p *ExportPos) *pos {
	return &pos{
		i:    p.I,
		lnum: p.Lnum,
		col:  p.Col,
	}
}

func newInternalFuncAttr(attr *ExportFuncAttr) *FuncAttr {
	return &FuncAttr{
		range_: attr.Range,
		abort:  attr.Abort,
		dict:   attr.Dict,
	}
}

func newInternalExArg(ea *ExportExArg) *ExArg {
	return &ExArg{
		forceit:      ea.Forceit,
		addr_count:   ea.AddrCount,
		line1:        ea.Line1,
		line2:        ea.Line2,
		flags:        ea.Flags,
		do_ecmd_cmd:  ea.DoEcmdCmd,
		do_ecmd_lnum: ea.DoEcmdLnum,
		append:       ea.Append,
		usefilter:    ea.Usefilter,
		amount:       ea.Amount,
		regname:      ea.Regname,
		force_bin:    ea.ForceBin,
		read_edit:    ea.ReadEdit,
		force_ff:     ea.ForceFf,
		force_enc:    ea.ForceEnc,
		bad_char:     ea.BadChar,
		linepos:      newInternalPos(ea.Linepos),
		cmdpos:       newInternalPos(ea.Cmdpos),
		argpos:       newInternalPos(ea.Argpos),
		cmd:          newInternalCmd(ea.Cmd),
		modifiers:    ea.Modifiers,
		range_:       ea.Range,
		argopt:       ea.Argopt,
		argcmd:       ea.Argcmd,
	}
}

func newInternalCmd(c *ExportCmd) *Cmd {
	return &Cmd{
		name:   c.Name,
		minlen: c.Minlen,
		flags:  c.Flags,
		parser: c.Parser,
	}
}
