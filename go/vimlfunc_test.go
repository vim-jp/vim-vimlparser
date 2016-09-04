package vimlparser

import "testing"

func TestViml_len(t *testing.T) {
	tests := []struct {
		in   interface{}
		want int
	}{
		{in: "hoge", want: 4},
		{in: "あいうえお", want: 15},
		{in: "", want: 0},
		{in: []string{"hoge", "foo"}, want: 2},
		{in: []int{1, 2, 3}, want: 3},
		{in: []interface{}{1, "2", float64(3)}, want: 3},
	}
	for _, tt := range tests {
		got := viml_len(tt.in)
		if got != tt.want {
			t.Errorf("viml_len(%v) = %v, want %v", tt.in, got, tt.want)
		}
	}
}

func TestViml_eqreg(t *testing.T) {
	tests := []struct {
		in   string
		reg  string
		want bool
	}{
		{in: ``, reg: "^\\s*\\\\", want: false},
		{in: `hoge`, reg: "^\\s*\\\\", want: false},
		{in: ` \ hoge`, reg: "^\\s*\\\\", want: true},
		{in: `\`, reg: "^\\s*\\\\", want: true},

		// ^++
		{in: `++hoge`, reg: "^++", want: true},
		{in: `hoge`, reg: "^++", want: false},

		// case
		{in: `deletel`, reg: "\\v^d%[elete][lp]$", want: true},
		{in: `deleteL`, reg: "\\v^d%[elete][lp]$", want: true},
		{in: `++bad=keep`, reg: "^++bad=keep", want: true},
		{in: `++bad=KEEP`, reg: "^++bad=keep", want: true},
	}
	for _, tt := range tests {
		if got := viml_eqreg(tt.in, tt.reg); got != tt.want {
			t.Errorf("viml_eqreg(%q, %q) = %v, want %v", tt.in, tt.reg, got, tt.want)
		}
	}
}

func TestViml_eqregh(t *testing.T) {
	tests := []struct {
		in   string
		reg  string
		want bool
	}{
		{in: `deletel`, reg: "\\v^d%[elete][lp]$", want: true},
		{in: `deleteL`, reg: "\\v^d%[elete][lp]$", want: false},
		{in: `++bad=keep`, reg: "^++bad=keep", want: true},
		{in: `++bad=KEEP`, reg: "^++bad=keep", want: false},
	}
	for _, tt := range tests {
		if got := viml_eqregh(tt.in, tt.reg); got != tt.want {
			t.Errorf("viml_eqregh(%q, %q) = %v, want %v", tt.in, tt.reg, got, tt.want)
		}
	}
}

func TestViml_eqregq(t *testing.T) {
	tests := []struct {
		in   string
		reg  string
		want bool
	}{
		{in: `deletel`, reg: "\\v^d%[elete][lp]$", want: true},
		{in: `deleteL`, reg: "\\v^d%[elete][lp]$", want: true},
		{in: `++bad=keep`, reg: "^++bad=keep", want: true},
		{in: `++bad=KEEP`, reg: "^++bad=keep", want: true},
	}
	for _, tt := range tests {
		if got := viml_eqregq(tt.in, tt.reg); got != tt.want {
			t.Errorf("viml_eqregq(%q, %q) = %v, want %v", tt.in, tt.reg, got, tt.want)
		}
	}
}
