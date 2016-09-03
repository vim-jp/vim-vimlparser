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

call extend(s:typedefs.func, s:vimlfunc)
call extend(s:typedefs.func, s:VimLParser)

function! ImportTypedefs() abort
  return s:typedefs
endfunction
