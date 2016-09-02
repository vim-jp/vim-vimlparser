package vimlparser

type ExArg struct {
	forceit      int
	addr_count   int
	line1        int
	line2        int
	flags        int
	do_ecmd_cmd  string
	do_ecmd_lnum int
	append       int
	usefilter    int
	amount       int
	regname      int
	force_bin    int
	read_edit    int
	force_ff     int
	force_enc    int
	bad_char     int
	linepos      []interface{}
	cmdpos       []interface{}
	argpos       []interface{}
	cmd          map[string]interface{}
	modifiers    []interface{}
	range_       []interface{} // range -> range_
	argopt       map[string]interface{}
	argcmd       map[string]interface{}
}
