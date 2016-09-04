package vimlparser

import (
	"runtime/debug"
	"strings"
	"testing"
)

func TestNewStringReader(t *testing.T) {
	defer func() {
		if r := recover(); r != nil {
			t.Errorf("Recovered: %v\n%s", r, debug.Stack())
		}
	}()
	r := NewStringReader([]string{})
	if !r.eof() {
		t.Error("NewStringReader should call __init__ func to initialize")
	}
}

func TestStringReader___init__(t *testing.T) {
	defer func() {
		if r := recover(); r != nil {
			t.Errorf("Recovered: %v\n%s", r, debug.Stack())
		}
	}()
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
	defer func() {
		if r := recover(); r != nil {
			t.Errorf("Recovered: %v\n%s", r, debug.Stack())
		}
	}()
	r := NewStringReader([]string{})
	p := NewVimLParser()
	p.parse(r)
}
