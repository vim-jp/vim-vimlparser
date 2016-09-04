" typedfes for autoload/vimlparser.vim

let s:typedefs = {
\   'func': {
\     'Err': {
\       'in': ['string', '*pos'],
\       'out': ['string'],
\     },
\   },
\ }

call extend(s:typedefs.func, {
\   'isalpha': { 'in': ['string'], 'out': ['bool'] },
\   'isalnum': { 'in': ['string'], 'out': ['bool'] },
\   'isdigit': { 'in': ['string'], 'out': ['bool'] },
\   'isodigit': { 'in': ['string'], 'out': ['bool'] },
\   'isxdigit': { 'in': ['string'], 'out': ['bool'] },
\   'iswordc': { 'in': ['string'], 'out': ['bool'] },
\   'iswordc1': { 'in': ['string'], 'out': ['bool'] },
\   'iswhite': { 'in': ['string'], 'out': ['bool'] },
\   'isnamec': { 'in': ['string'], 'out': ['bool'] },
\   'isnamec1': { 'in': ['string'], 'out': ['bool'] },
\   'isargname': { 'in': ['string'], 'out': ['bool'] },
\   'isvarname': { 'in': ['string'], 'out': ['bool'] },
\   'isidc': { 'in': ['string'], 'out': ['bool'] },
\   'isupper': { 'in': ['string'], 'out': ['bool'] },
\   'islower': { 'in': ['string'], 'out': ['bool'] },
\ })

call extend(s:typedefs.func, {
\   'VimLParser.push_context': {
\     'in': ['*node'],
\     'out': [],
\   },
\   'VimLParser.find_context': {
\     'in': ['int'],
\     'out': ['int'],
\   },
\   'VimLParser.add_node': {
\     'in': ['*node'],
\     'out': [],
\   },
\   'VimLParser.check_missing_endfunction': { 'in': ['string', '*pos'], 'out': [] },
\   'VimLParser.check_missing_endif': { 'in': ['string', '*pos'], 'out': [] },
\   'VimLParser.check_missing_endtry': { 'in': ['string', '*pos'], 'out': [] },
\   'VimLParser.check_missing_endwhile': { 'in': ['string', '*pos'], 'out': [] },
\   'VimLParser.check_missing_endfor': { 'in': ['string', '*pos'], 'out': [] },
\   'VimLParser.parse': {
\     'in': ['*StringReader'],
\     'out': ['*node'],
\   },
\   'VimLParser.parse_pattern': {
\     'in': ['string'],
\     'out': ['string', 'string'],
\   },
\   'VimLParser.find_command': {
\     'in': [],
\     'out': ['*Cmd'],
\   },
\   'VimLParser.read_cmdarg': {
\     'in': [],
\     'out': ['string'],
\   },
\   'VimLParser.separate_nextcmd': {
\     'in': [],
\     'out': ['*pos'],
\   },
\   'VimLParser.parse_expr': {
\     'in': [],
\     'out': ['*node'],
\   },
\   'VimLParser.parse_exprlist': {
\     'in': [],
\     'out': ['[]*node'],
\   },
\   'VimLParser.parse_lvalue_func': {
\     'in': [],
\     'out': ['*node'],
\   },
\   'VimLParser.parse_lvalue': {
\     'in': [],
\     'out': ['*node'],
\   },
\   'VimLParser.parse_lvaluelist': {
\     'in': [],
\     'out': ['[]*node'],
\   },
\   'VimLParser.parse_letlhs': {
\     'in': [],
\     'out': ['*lhs'],
\   },
\   'VimLParser.ends_excmds': {
\     'in': ['string'],
\     'out': ['bool'],
\   },
\
\   'VimLParser._parse_command': {
\     'in': ['string'],
\     'out': [],
\   },
\ })

call extend(s:typedefs.func, {
\   'ExprTokenizer.__init__': {
\     'in': ['*StringReader'],
\     'out': [],
\   },
\   'ExprTokenizer.token': {
\     'in': ['int', 'string', '*pos'],
\     'out': ['*ExprToken'],
\   },
\   'ExprTokenizer.peek': { 'in': [], 'out': ['*ExprToken'] },
\   'ExprTokenizer.get': { 'in': [], 'out': ['*ExprToken'] },
\   'ExprTokenizer.get2': { 'in': [], 'out': ['*ExprToken'] },
\   'ExprTokenizer.get_sstring': { 'in': [], 'out': ['string'] },
\   'ExprTokenizer.get_dstring': { 'in': [], 'out': ['string'] },
\ })

call extend(s:typedefs.func, {
\   'ExprParser.__init__': {
\     'in': ['*StringReader'],
\     'out': [],
\   },
\   'ExprParser.parse': { 'in': [], 'out': ['*node'] },
\   'ExprParser.parse_expr1': { 'in': [], 'out': ['*node'] },
\   'ExprParser.parse_expr2': { 'in': [], 'out': ['*node'] },
\   'ExprParser.parse_expr3': { 'in': [], 'out': ['*node'] },
\   'ExprParser.parse_expr4': { 'in': [], 'out': ['*node'] },
\   'ExprParser.parse_expr5': { 'in': [], 'out': ['*node'] },
\   'ExprParser.parse_expr6': { 'in': [], 'out': ['*node'] },
\   'ExprParser.parse_expr7': { 'in': [], 'out': ['*node'] },
\   'ExprParser.parse_expr8': { 'in': [], 'out': ['*node'] },
\   'ExprParser.parse_expr9': { 'in': [], 'out': ['*node'] },
\   'ExprParser.parse_dot': { 'in': ['*ExprToken', '*node'], 'out': ['*node'] },
\   'ExprParser.parse_identifier': { 'in': [], 'out': ['*node'] },
\   'ExprParser.parse_curly_parts': { 'in': [], 'out': ['[]*node'] },
\ })

call extend(s:typedefs.func, {
\   'LvalueParser.parse': { 'in': [], 'out': ['*node'] },
\   'LvalueParser.parse_lv8': { 'in': [], 'out': ['*node'] },
\   'LvalueParser.parse_lv9': { 'in': [], 'out': ['*node'] },
\ })

call extend(s:typedefs.func, {
\   'StringReader.__init__': {
\     'in': ['[]string'],
\     'out': [],
\   },
\   'StringReader.eof': {
\     'in': [],
\     'out': ['bool'],
\   },
\   'StringReader.tell': {
\     'in': [],
\     'out': ['int'],
\   },
\   'StringReader.seek_set': {
\     'in': ['int'],
\     'out': [],
\   },
\   'StringReader.seek_cur': {
\     'in': ['int'],
\     'out': [],
\   },
\   'StringReader.seek_end': {
\     'in': ['int'],
\     'out': [],
\   },
\   'StringReader.p': {
\     'in': ['int'],
\     'out': ['string'],
\   },
\   'StringReader.peek': {
\     'in': [],
\     'out': ['string'],
\   },
\   'StringReader.get': {
\     'in': [],
\     'out': ['string'],
\   },
\   'StringReader.peekn': {
\     'in': ['int'],
\     'out': ['string'],
\   },
\   'StringReader.getn': {
\     'in': ['int'],
\     'out': ['string'],
\   },
\   'StringReader.peekline': {
\     'in': [],
\     'out': ['string'],
\   },
\   'StringReader.readline': {
\     'in': [],
\     'out': ['string'],
\   },
\   'StringReader.getstr': {
\     'in': ['*pos', '*pos'],
\     'out': ['string'],
\   },
\   'StringReader.getpos': {
\     'in': [],
\     'out': ['*pos'],
\   },
\   'StringReader.setpos': {
\     'in': ['*pos'],
\     'out': [],
\   },
\   'StringReader.read_alpha': { 'in': [], 'out': ['string'] },
\   'StringReader.read_alnum': { 'in': [], 'out': ['string'] },
\   'StringReader.read_digit': { 'in': [], 'out': ['string'] },
\   'StringReader.read_odigit': { 'in': [], 'out': ['string'] },
\   'StringReader.read_xdigit': { 'in': [], 'out': ['string'] },
\   'StringReader.read_integer': { 'in': [], 'out': ['string'] },
\   'StringReader.read_word': { 'in': [], 'out': ['string'] },
\   'StringReader.read_white': { 'in': [], 'out': ['string'] },
\   'StringReader.read_nonwhite': { 'in': [], 'out': ['string'] },
\   'StringReader.read_name': { 'in': [], 'out': ['string'] },
\ })

call extend(s:typedefs.func, {
\   'Compiler.out': {
\     'in': ['...interface{}'],
\     'out': [],
\   },
\   'Compiler.incindent': {
\     'in': ['string'],
\     'out': [],
\   },
\   'Compiler.compile': {
\     'in': ['*node'],
\     'out': ['interface{}'],
\   },
\   'Compiler.compile_body': {
\     'in': ['[]*node'],
\     'out': [],
\   },
\   'Compiler.compile_toplevel': {
\     'in': ['*node'],
\     'out': ['[]string'],
\   },
\   'Compiler.compile_comment': { 'in': ['*node'], 'out': [] },
\   'Compiler.compile_excmd': { 'in': ['*node'], 'out': [] },
\   'Compiler.compile_function': { 'in': ['*node'], 'out': [] },
\   'Compiler.compile_delfunction': { 'in': ['*node'], 'out': [] },
\   'Compiler.compile_return': { 'in': ['*node'], 'out': [] },
\   'Compiler.compile_excall': { 'in': ['*node'], 'out': [] },
\   'Compiler.compile_let': { 'in': ['*node'], 'out': [] },
\   'Compiler.compile_unlet': { 'in': ['*node'], 'out': [] },
\   'Compiler.compile_lockvar': { 'in': ['*node'], 'out': [] },
\   'Compiler.compile_unlockvar': { 'in': ['*node'], 'out': [] },
\   'Compiler.compile_if': { 'in': ['*node'], 'out': [] },
\   'Compiler.compile_while': { 'in': ['*node'], 'out': [] },
\   'Compiler.compile_for': { 'in': ['*node'], 'out': [] },
\   'Compiler.compile_continue': { 'in': ['*node'], 'out': [] },
\   'Compiler.compile_break': { 'in': ['*node'], 'out': [] },
\   'Compiler.compile_try': { 'in': ['*node'], 'out': [] },
\   'Compiler.compile_throw': { 'in': ['*node'], 'out': [] },
\   'Compiler.compile_echo': { 'in': ['*node'], 'out': [] },
\   'Compiler.compile_echon': { 'in': ['*node'], 'out': [] },
\   'Compiler.compile_echohl': { 'in': ['*node'], 'out': [] },
\   'Compiler.compile_echomsg': { 'in': ['*node'], 'out': [] },
\   'Compiler.compile_echoerr': { 'in': ['*node'], 'out': [] },
\   'Compiler.compile_execute': { 'in': ['*node'], 'out': [] },
\
\   'Compiler.compile_ternary': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_or': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_and': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_equal': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_equalci': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_equalcs': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_nequal': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_nequalci': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_nequalcs': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_greater': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_greaterci': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_greatercs': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_gequal': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_gequalci': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_gequalcs': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_smaller': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_smallerci': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_smallercs': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_sequal': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_sequalci': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_sequalcs': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_match': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_matchci': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_matchcs': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_nomatch': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_nomatchci': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_nomatchcs': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_is': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_isci': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_iscs': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_isnot': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_isnotci': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_isnotcs': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_add': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_subtract': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_concat': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_multiply': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_divide': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_remainder': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_not': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_plus': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_minus': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_subscript': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_slice': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_dot': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_call': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_number': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_string': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_list': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_dict': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_option': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_identifier': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_curlyname': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_env': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_reg': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_curlynamepart': { 'in': ['*node'], 'out': ['string'] },
\   'Compiler.compile_curlynameexpr': { 'in': ['*node'], 'out': ['string'] },
\ })

function! ImportTypedefs() abort
  return s:typedefs
endfunction
