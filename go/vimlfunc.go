package vimlparser

type vimlList interface{}

func viml_call(f string, args ...interface{}) interface{} {
	panic("NotImplemented viml_call")
}

func viml_char2nr(c string) int {
	panic("NotImplemented viml_char2nr")
}

func viml_empty(obj interface{}) bool {
	panic("NotImplemented viml_empty")
}

func viml_equalci(a, b string) bool {
	panic("NotImplemented viml_equalci")
}

func viml_eqreg(s, reg string) bool {
	panic("NotImplemented viml_eqreg")
}

func viml_eqregh(s, reg string) bool {
	panic("NotImplemented viml_eqregh")
}

func viml_eqregq(s, reg string) bool {
	panic("NotImplemented viml_eqregq")
}

func viml_escape(s string, chars []string) bool {
	panic("NotImplemented viml_escape")
}

func viml_extend(obj, item interface{}) interface{} {
	panic("NotImplemented viml_extend")
}

func viml_insert(lst vimlList, item interface{}) {
	panic("NotImplemented viml_insert")
}

func viml_join(lst vimlList, sep string) string {
	panic("NotImplemented viml_join")
}

func viml_keys(obj map[string]interface{}) []string {
	panic("NotImplemented viml_keys")
}

func viml_len(obj interface{}) int {
	if xs, ok := obj.([]string); ok {
		return len(xs)
	}
	panic("NotImplemented viml_len")
}

func viml_printf(f string, args ...interface{}) string {
	panic("NotImplemented viml_printf")
}

func viml_range(start, end int) []int {
	panic("NotImplemented viml_range")
}

func viml_readfile(path string) []string {
	panic("NotImplemented viml_readfile")
}

func viml_remove(lst vimlList, idx int) {
	panic("NotImplemented viml_remove")
}

func viml_split(s string, sep string) []string {
	if sep == `\zs` {
		var ss []string
		for _, r := range s {
			ss = append(ss, string(r))
		}
		return ss
	}
	panic("NotImplemented viml_split")
}

func viml_str2nr(s string, base int) int {
	panic("NotImplemented viml_str2nr")
}

func viml_string(obj interface{}) string {
	panic("NotImplemented viml_string")
}

func viml_has_key(obj interface{}, key interface{}) bool {
	panic("NotImplemented viml_has_key")
}

func viml_stridx(a, b string) int {
	panic("NotImplemented viml_stridx")
}

func viml_type(obj interface{}) int {
	panic("NotImplemented viml_type")
}
