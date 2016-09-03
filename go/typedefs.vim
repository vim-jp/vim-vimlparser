" typedfes for autoload/vimlparser.vim

let s:typedefs = {
\   'func': {
\     'Err': {
\       'in': ['string', 'pos'],
\       'out': ['string'],
\     },
\   },
\ }

let s:vimlfunc = {
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
\ }

let s:VimLParser = {
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
\   'VimLParser.check_missing_endfunction': { 'in': ['string', 'pos'], 'out': [] },
\   'VimLParser.check_missing_endif': { 'in': ['string', 'pos'], 'out': [] },
\   'VimLParser.check_missing_endtry': { 'in': ['string', 'pos'], 'out': [] },
\   'VimLParser.check_missing_endwhile': { 'in': ['string', 'pos'], 'out': [] },
\   'VimLParser.check_missing_endfor': { 'in': ['string', 'pos'], 'out': [] },
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
\     'out': ['Cmd'],
\   },
\   'VimLParser.read_cmdarg': {
\     'in': [],
\     'out': ['string'],
\   },
\   'VimLParser.separate_nextcmd': {
\     'in': [],
\     'out': ['pos'],
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
\     'out': ['*[]node'],
\   },
\   'VimLParser.parse_letlhs': {
\     'in': [],
\     'out': ['*lhs'],
\   },
\   'VimLParser.ends_excmds': {
\     'in': ['string'],
\     'out': ['bool'],
\   },
\ }

let s:ExprTokenizer = {
\   'ExprTokenizer.__init__': {
\     'in': ['*StringReader'],
\     'out': [],
\   },
\   'ExprTokenizer.token': {
\     'in': ['int', 'string', 'pos'],
\     'out': ['*ExprToken'],
\   },
\   'ExprTokenizer.peek': { 'in': [], 'out': ['*ExprToken'] },
\   'ExprTokenizer.get': { 'in': [], 'out': ['*ExprToken'] },
\   'ExprTokenizer.get2': { 'in': [], 'out': ['*ExprToken'] },
\   'ExprTokenizer.get_string': { 'in': [], 'out': ['string'] },
\ }

let s:ExprParser = {
\   'ExprParser.__init__': {
\     'in': ['*StringReader'],
\     'out': [],
\   },
\   'ExprParser.parse': { 'in': [], 'out': ['*node'] },
\   'ExprParser.parse1': { 'in': [], 'out': ['*node'] },
\   'ExprParser.parse2': { 'in': [], 'out': ['*node'] },
\   'ExprParser.parse3': { 'in': [], 'out': ['*node'] },
\   'ExprParser.parse4': { 'in': [], 'out': ['*node'] },
\   'ExprParser.parse5': { 'in': [], 'out': ['*node'] },
\   'ExprParser.parse6': { 'in': [], 'out': ['*node'] },
\   'ExprParser.parse7': { 'in': [], 'out': ['*node'] },
\   'ExprParser.parse8': { 'in': [], 'out': ['*node'] },
\   'ExprParser.parse9': { 'in': [], 'out': ['*node'] },
\   'ExprParser.parse_dot': { 'in': [], 'out': ['*node'] },
\   'ExprParser.parse_identifier': { 'in': [], 'out': ['*node'] },
\   'ExprParser.parse_curly_parts': { 'in': [], 'out': ['[]*node'] },
\ }

let s:LvalueParser = {
\   'LvalueParser.parse': { 'in': [], 'out': ['*node'] },
\   'LvalueParser.parse_lv8': { 'in': [], 'out': ['*node'] },
\   'LvalueParser.parse_lv9': { 'in': [], 'out': ['*node'] },
\ }

call extend(s:typedefs.func, s:vimlfunc)
call extend(s:typedefs.func, s:VimLParser)

function! ImportTypedefs() abort
  return s:typedefs
endfunction
