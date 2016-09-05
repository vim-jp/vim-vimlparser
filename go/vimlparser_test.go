package vimlparser

import (
	"runtime/debug"
	"strings"
	"testing"
)

func recovert(t *testing.T) {
	if r := recover(); r != nil {
		t.Errorf("Recovered: %v\n%s", r, debug.Stack())
	}
}

func TestNewStringReader(t *testing.T) {
	defer recovert(t)
	r := NewStringReader([]string{})
	if !r.eof() {
		t.Error("NewStringReader should call __init__ func to initialize")
	}
}

func TestStringReader___init__(t *testing.T) {
	defer recovert(t)
	tests := []struct {
		in  []string
		buf string
	}{
		{in: []string{}, buf: ""},
		{in: []string{""}, buf: "<EOL>"},
		{in: []string{"let x = 1"}, buf: "let x = 1<EOL>"},
		{in: []string{"let x = 1", "let y = x"}, buf: "let x = 1<EOL>let y = x<EOL>"},
		{in: []string{"let x =", `\ 1`}, buf: "let x = 1<EOL>"},
		{in: []string{"あいうえお"}, buf: "あいうえお<EOL>"},
	}
	for _, tt := range tests {
		r := &StringReader{}
		r.__init__(tt.in)
		if got := strings.Join(r.buf, ""); got != tt.buf {
			t.Errorf("StringReader.__init__(%v).buf == %v, want %v", tt.in, got, tt.buf)
		}
	}
}

func TestNewVimLParser(t *testing.T) {
	defer recovert(t)
	NewVimLParser().parse(NewStringReader([]string{}))
}

func TestVimLParser_parse_empty(t *testing.T) {
	defer recovert(t)
	ins := [][]string{
		[]string{},
		[]string{""},
		[]string{"", ""},
	}
	for _, in := range ins {
		NewVimLParser().parse(NewStringReader(in))
	}
}

func TestVimLParser_parse(t *testing.T) {
	defer recovert(t)
	tests := []struct {
		in   []string
		want string
	}{
		{[]string{`" comment`}, "; comment"},
		{[]string{`let x = 1`}, "(let = x 1)"},
		{[]string{`call F(x, y, z)`}, "(call (F x y z))"},
	}
	for _, tt := range tests {
		c := NewCompiler()
		n := NewVimLParser().parse(NewStringReader(tt.in))
		if got := c.compile(n).([]string); strings.Join(got, "\n") != tt.want {
			t.Errorf("c.compile(p.parse(%v)) = %v, want %v", tt.in, got, tt.want)
		}
	}
}
