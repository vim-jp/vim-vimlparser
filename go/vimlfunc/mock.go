package vimlparser

func (self *VimLParser) __init__()                   {}
func (self *ExprTokenizer) __init__(r *StringReader) {}
func (self *ExprParser) __init__(r *StringReader)    {}
func (self *LvalueParser) __init__(r *StringReader)  {}
func (self *StringReader) __init__(lines []string)   {}
