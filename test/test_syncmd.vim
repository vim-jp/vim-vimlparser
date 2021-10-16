if 1 | syntax on | endif
syntax
syntax enable
syntax list GroupName
syn match pythonError "[&|]\{2,}" display
syntax match qfFileName /^\zs\S[^|]\+\/\ze[^|\/]\+\/[^|\/]\+|/ conceal cchar=+
syntax region jsString start=+"+ skip=+\\\("\|$\)+ end=+"\|$+ contains=jsSpecial,@Spell extend
syntax match testCchar conceal cchar=/ /pattern/
syntax match testArgValue contained containedin=parentGroup /pattern/
syntax match testArgsAfterPattern /pattern/ contained containedin=parentGroup
syntax match testPatternDelim contained +pattern+
syntax match testAlphaPatternDelim contained ApatternA
syntax match testPipePatternDelim contained |pattern|
syntax match testQuotePatternDelim contained "pattern"
