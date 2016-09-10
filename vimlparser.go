package vimlparser

import (
	"bufio"
	"fmt"
	"io"
	"strings"

	internal "github.com/haya14busa/vim-vimlparser/go"
)

// Parse parses Vim script.
func Parse(r io.Reader) (node *Node, err error) {
	defer func() {
		if r := recover(); r != nil {
			node = nil
			err = fmt.Errorf("go-vimlparser:Parse: %v", r)
			// log.Printf("%s", debug.Stack())
		}
	}()
	lines := readlines(r)
	reader := internal.NewStringReader(lines)
	node = newNode(internal.NewVimLParser().Parse(reader))
	return
}

// ParseExpr parses Vim expression.
func ParseExpr(r io.Reader) (node *Node, err error) {
	defer func() {
		if r := recover(); r != nil {
			node = nil
			err = fmt.Errorf("go-vimlparser:Parse: %v", r)
			// log.Printf("%s", debug.Stack())
		}
	}()
	lines := readlines(r)
	reader := internal.NewStringReader(lines)
	p := internal.NewExprParser(reader)
	node = newNode(p.Parse())
	return
}

// Compile compiles Vim script AST into S-expression like format.
func Compile(w io.Writer, node *Node) (err error) {
	defer func() {
		if r := recover(); r != nil {
			err = fmt.Errorf("go-vimlparser:Compile: %v", r)
			// log.Printf("%s", debug.Stack())
		}
	}()
	c := internal.NewCompiler()
	out := c.Compile(newExportNode(node))
	_, err = w.Write([]byte(strings.Join(out, "\n")))
	return nil
}

func readlines(r io.Reader) []string {
	lines := []string{}
	scanner := bufio.NewScanner(r)
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}
	return lines
}
