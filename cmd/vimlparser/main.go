package main

import (
	"fmt"
	"log"
	"os"

	"github.com/haya14busa/vim-vimlparser"
)

func main() {
	node, err := vimlparser.Parse(os.Stdin)
	if err != nil {
		log.Fatal(err)
	}
	if err := vimlparser.Compile(os.Stdout, node); err != nil {
		log.Fatal(err)
	}
	fmt.Printf("\n")
}
