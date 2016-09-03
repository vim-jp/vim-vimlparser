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

function! ImportTypedefs() abort
  return s:typedefs
endfunction
