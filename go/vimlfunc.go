package vimlparser

type vimlList interface{}

func viml_add(lst vimlList, item interface{}) {
	panic("NotImplemented")
	// should use go builtin append() func
}

func viml_call(f string, args ...interface{}) interface{} {
	panic("NotImplemented")
}

func viml_char2nr(c string) int {
	panic("NotImplemented")
}

func viml_empty(obj interface{}) bool {
	panic("NotImplemented")
}

func viml_equalci(a, b string) bool {
	panic("NotImplemented")
}

func viml_eqreg(s, reg string) bool {
	panic("NotImplemented")
}

func viml_eqregh(s, reg string) bool {
	panic("NotImplemented")
}

func viml_eqregq(s, reg string) bool {
	panic("NotImplemented")
}

func viml_escape(s string, chars []string) bool {
	panic("NotImplemented")
}

func viml_extend(obj, item interface{}) interface{} {
	panic("NotImplemented")
}

func viml_insert(lst vimlList, item interface{}) {
	panic("NotImplemented")
}

func viml_join(lst vimlList, sep string) string {
	panic("NotImplemented")
}

func viml_keys(obj map[string]interface{}) []string {
	panic("NotImplemented")
}

func viml_len(obj interface{}) int {
	panic("NotImplemented")
}

func viml_printf(f string, args ...interface{}) string {
	panic("NotImplemented")
}

func viml_range(start, end int) []int {
	panic("NotImplemented")
}

func viml_readfile(path string) []string {
	panic("NotImplemented")
}

func viml_remove(lst vimlList, idx int) {
	panic("NotImplemented")
}

func viml_split(s string, sep string) []string {
	if sep == `\zs` {
		var ss []string
		for _, r := range s {
			ss = append(ss, string(r))
		}
		return ss
	}
	panic("NotImplemented")
}

func viml_str2nr(s string, base int) int {
	panic("NotImplemented")
}

func viml_string(obj interface{}) string {
	panic("NotImplemented")
}

func viml_has_key(obj interface{}, key interface{}) bool {
	panic("NotImplemented")
}

func viml_stridx(a, b string) int {
	panic("NotImplemented")
}

func viml_type(obj interface{}) int {
	panic("NotImplemented")
}
