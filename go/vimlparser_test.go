package vimlparser

import (
	"runtime/debug"
	"testing"
)

func TestNewStringReader(t *testing.T) {
	defer func() {
		if r := recover(); r != nil {
			t.Errorf("Recovered: %v\n%s", r, debug.Stack())
		}
	}()
	NewStringReader([]string{})
}
