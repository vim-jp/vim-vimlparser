package vimlparser

import "testing"

func TestNewStringReader(t *testing.T) {
	defer func() {
		if r := recover(); r != nil {
			t.Errorf("Recovered: %v", r)
		}
	}()
	NewStringReader([]string{})
}
