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
