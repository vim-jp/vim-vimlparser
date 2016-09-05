package vimlparser

import (
	"bytes"
	"strings"
	"testing"
)

func TestParse_Compile(t *testing.T) {
	node, err := Parse(strings.NewReader("let x = 1"))
	if err != nil {
		t.Fatal(err)
	}
	b := new(bytes.Buffer)
	if err := Compile(b, node); err != nil {
		t.Fatal(err)
	}
	if got, want := b.String(), "(let = x 1)"; got != want {
		t.Errorf("Compile(Parse(\"let x = 1\")) = %v, want %v", got, want)
	}
}

func TestParse_Compile_err(t *testing.T) {
	want := "go-vimlparser:Parse: vimlparser: E492: Not an editor command: hoge: line 1 col 1"
	_, err := Parse(strings.NewReader("hoge"))
	if err != nil {
		if got := err.Error(); want != got {
			t.Errorf("Parse(\"hoge\") = %v, want %v", got, want)
		}
	}
}

func TestParseExpr_Compile(t *testing.T) {
	node, err := ParseExpr(strings.NewReader("x + 1"))
	if err != nil {
		t.Fatal(err)
	}
	b := new(bytes.Buffer)
	if err := Compile(b, node); err != nil {
		t.Fatal(err)
	}
	if got, want := b.String(), "(+ x 1)"; got != want {
		t.Errorf("Compile(Parse(\"x + 1\")) = %v, want %v", got, want)
	}
}

func TestParseExpr_Compile_err(t *testing.T) {
	want := "go-vimlparser:Parse: vimlparser: unexpected token: /: line 1 col 4"
	_, err := ParseExpr(strings.NewReader("1 // 2"))
	if err != nil {
		if got := err.Error(); want != got {
			t.Errorf("ParseExpr(\"1 // 2\") = %v, want %v", got, want)
		}
	}
}
