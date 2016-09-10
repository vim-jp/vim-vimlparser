package vimlparser

import internal "github.com/haya14busa/vim-vimlparser/go"

type ExArg struct {
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
	Linepos    *Pos
	Cmdpos     *Pos
	Argpos     *Pos
	Cmd        *Cmd
	Modifiers  []interface{}
	Range      []interface{}
	Argopt     map[string]interface{}
	Argcmd     map[string]interface{}
}

func newExArg(ea *internal.ExportExArg) *ExArg {
	if ea == nil {
		return nil
	}
	return &ExArg{
		Forceit:    ea.Forceit,
		AddrCount:  ea.AddrCount,
		Line1:      ea.Line1,
		Line2:      ea.Line2,
		Flags:      ea.Flags,
		DoEcmdCmd:  ea.DoEcmdCmd,
		DoEcmdLnum: ea.DoEcmdLnum,
		Append:     ea.Append,
		Usefilter:  ea.Usefilter,
		Amount:     ea.Amount,
		Regname:    ea.Regname,
		ForceBin:   ea.ForceBin,
		ReadEdit:   ea.ReadEdit,
		ForceFf:    ea.ForceFf,
		ForceEnc:   ea.ForceEnc,
		BadChar:    ea.BadChar,
		Linepos:    newPos(ea.Linepos),
		Cmdpos:     newPos(ea.Cmdpos),
		Argpos:     newPos(ea.Argpos),
		Cmd:        newCmd(ea.Cmd),
		Modifiers:  ea.Modifiers,
		Range:      ea.Range,
		Argopt:     ea.Argopt,
		Argcmd:     ea.Argcmd,
	}
}

type Cmd struct {
	Name   string
	Minlen int
	Flags  string
	Parser string
}

func newCmd(c *internal.ExportCmd) *Cmd {
	if c == nil {
		return nil
	}
	return &Cmd{
		Name:   c.Name,
		Minlen: c.Minlen,
		Flags:  c.Flags,
		Parser: c.Parser,
	}
}

type Pos struct {
	I    int
	Lnum int
	Col  int
}

func newPos(p *internal.ExportPos) *Pos {
	if p == nil {
		return nil
	}
	return &Pos{
		I:    p.I,
		Lnum: p.Lnum,
		Col:  p.Col,
	}
}

type Node struct {
	Type  int
	Pos   *Pos
	Left  *Node
	Right *Node
	Cond  *Node
	Rest  *Node
	List  []*Node
	Rlist []*Node
	Body  []*Node
	Op    string
	Str   string
	Depth int
	Value interface{}

	Ea   *ExArg
	Attr *FuncAttr

	Endfunction *Node
	Elseif      []*Node
	Else        *Node
	Endif       *Node
	Endwhile    *Node
	Endfor      *Node
	Endtry      *Node

	Catch   []*Node
	Finally *Node

	Pattern string
	Curly   bool
}

func newNode(n *internal.ExportNode) *Node {
	if n == nil {
		return nil
	}
	var list []*Node
	for _, n := range n.List {
		list = append(list, newNode(n))
	}
	var rlist []*Node
	for _, n := range n.Rlist {
		rlist = append(rlist, newNode(n))
	}
	var body []*Node
	for _, n := range n.Body {
		body = append(body, newNode(n))
	}
	var elseif []*Node
	for _, n := range n.Elseif {
		elseif = append(elseif, newNode(n))
	}
	var catch []*Node
	for _, n := range n.Catch {
		catch = append(catch, newNode(n))
	}
	return &Node{
		Type:  n.Type,
		Pos:   newPos(n.Pos),
		Left:  newNode(n.Left),
		Right: newNode(n.Right),
		Cond:  newNode(n.Cond),
		Rest:  newNode(n.Rest),
		List:  list,
		Rlist: rlist,
		Body:  body,
		Op:    n.Op,
		Str:   n.Str,
		Depth: n.Depth,
		Value: n.Value,

		Ea:   newExArg(n.Ea),
		Attr: newFuncAttr(n.Attr),

		Endfunction: newNode(n.Endfunction),
		Elseif:      elseif,
		Else:        newNode(n.Else),
		Endif:       newNode(n.Endif),
		Endwhile:    newNode(n.Endwhile),
		Endfor:      newNode(n.Endfor),
		Endtry:      newNode(n.Endtry),

		Catch:   catch,
		Finally: newNode(n.Finally),

		Pattern: n.Pattern,
		Curly:   n.Curly,
	}
}

type FuncAttr struct {
	Range bool
	Abort bool
	Dict  bool
}

func newFuncAttr(attr *internal.ExportFuncAttr) *FuncAttr {
	if attr == nil {
		return nil
	}
	return &FuncAttr{
		Range: attr.Range,
		Abort: attr.Abort,
		Dict:  attr.Dict,
	}
}

func newExportNode(n *Node) *internal.ExportNode {
	if n == nil {
		return nil
	}
	var list []*internal.ExportNode
	for _, n := range n.List {
		list = append(list, newExportNode(n))
	}
	var rlist []*internal.ExportNode
	for _, n := range n.Rlist {
		rlist = append(rlist, newExportNode(n))
	}
	var body []*internal.ExportNode
	for _, n := range n.Body {
		body = append(body, newExportNode(n))
	}
	var elseif []*internal.ExportNode
	for _, n := range n.Elseif {
		elseif = append(elseif, newExportNode(n))
	}
	var catch []*internal.ExportNode
	for _, n := range n.Catch {
		catch = append(catch, newExportNode(n))
	}
	return &internal.ExportNode{
		Type:  n.Type,
		Pos:   newExportPos(n.Pos),
		Left:  newExportNode(n.Left),
		Right: newExportNode(n.Right),
		Cond:  newExportNode(n.Cond),
		Rest:  newExportNode(n.Rest),
		List:  list,
		Rlist: rlist,
		Body:  body,
		Op:    n.Op,
		Str:   n.Str,
		Depth: n.Depth,
		Value: n.Value,

		Ea:   newExportExArg(n.Ea),
		Attr: newExportFuncAttr(n.Attr),

		Endfunction: newExportNode(n.Endfunction),
		Elseif:      elseif,
		Else:        newExportNode(n.Else),
		Endif:       newExportNode(n.Endif),
		Endwhile:    newExportNode(n.Endwhile),
		Endfor:      newExportNode(n.Endfor),
		Endtry:      newExportNode(n.Endtry),

		Catch:   catch,
		Finally: newExportNode(n.Finally),

		Pattern: n.Pattern,
		Curly:   n.Curly,
	}
}

func newExportPos(p *Pos) *internal.ExportPos {
	if p == nil {
		return nil
	}
	return &internal.ExportPos{
		I:    p.I,
		Lnum: p.Lnum,
		Col:  p.Col,
	}
}

func newExportExArg(ea *ExArg) *internal.ExportExArg {
	if ea == nil {
		return nil
	}
	return &internal.ExportExArg{
		Forceit:    ea.Forceit,
		AddrCount:  ea.AddrCount,
		Line1:      ea.Line1,
		Line2:      ea.Line2,
		Flags:      ea.Flags,
		DoEcmdCmd:  ea.DoEcmdCmd,
		DoEcmdLnum: ea.DoEcmdLnum,
		Append:     ea.Append,
		Usefilter:  ea.Usefilter,
		Amount:     ea.Amount,
		Regname:    ea.Regname,
		ForceBin:   ea.ForceBin,
		ReadEdit:   ea.ReadEdit,
		ForceFf:    ea.ForceFf,
		ForceEnc:   ea.ForceEnc,
		BadChar:    ea.BadChar,
		Linepos:    newExportPos(ea.Linepos),
		Cmdpos:     newExportPos(ea.Cmdpos),
		Argpos:     newExportPos(ea.Argpos),
		Cmd:        newExportCmd(ea.Cmd),
		Modifiers:  ea.Modifiers,
		Range:      ea.Range,
		Argopt:     ea.Argopt,
		Argcmd:     ea.Argcmd,
	}
}

func newExportCmd(c *Cmd) *internal.ExportCmd {
	if c == nil {
		return nil
	}
	return &internal.ExportCmd{
		Name:   c.Name,
		Minlen: c.Minlen,
		Flags:  c.Flags,
		Parser: c.Parser,
	}
}

func newExportFuncAttr(attr *FuncAttr) *internal.ExportFuncAttr {
	if attr == nil {
		return nil
	}
	return &internal.ExportFuncAttr{
		Range: attr.Range,
		Abort: attr.Abort,
		Dict:  attr.Dict,
	}
}
