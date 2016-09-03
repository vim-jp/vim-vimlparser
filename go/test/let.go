var x = 1
func Funcname() {
	var y = 1
	y = 2
	x = 1
}

func Funcname(z) {
	z = z
}

func (self *VimLParser) hoge(a) {
	a = a
}

var b, c = d
b, c = d
node.pattern, b = hoge
