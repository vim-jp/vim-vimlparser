#!/usr/bin/env python3
# usage: python3 vimlparser.py foo.vim

import sys
import re

def main():
    r = StringReader(viml_readfile(sys.argv[1]))
    p = VimLParser()
    c = Compiler()
    for line in c.compile(p.parse(r)):
        print(line)

class AttributeDict(dict):
    __getattribute__ = dict.__getitem__
    __setattr__ = dict.__setitem__
    __delattr__ = dict.__delitem__

pat_vim2py = {
  ":\\|\\s" : ":|\\s",
  "[-+]" : "[-+]",
  "[/?]" : "[/?]",
  "[0-9A-Za-z_]" : "[0-9A-Za-z_]",
  "[0-9a-zA-Z]" : "[0-9a-zA-Z]",
  "[@*!=><&~#]" : "[@*!=><&~#]",
  "[gj]" : "[gj]",
  "\\.\\d" : "\\.\\d",
  "\\<ARGOPT\\>" : "\\bARGOPT\\b",
  "\\<BANG\\>" : "\\bBANG\\b",
  "\\<EDITCMD\\>" : "\\bEDITCMD\\b",
  "\\<NOTRLCOM\\>" : "\\bNOTRLCOM\\b",
  "\\<TRLBAR\\>" : "\\bTRLBAR\\b",
  "\\<USECTRLV\\>" : "\\bUSECTRLV\\b",
  "\\<\\(XFILE\\|FILES\\|FILE1\\)\\>" : "\\b(XFILE|FILES|FILE1)\\b",
  "\\S" : "\\S",
  "\\a" : "[A-Za-z]",
  "\\d" : "\\d",
  "\\h" : "[A-Za-z_]",
  "\\s" : "\\s",
  "\\v^%(IDENTIFIER|INDEX|DOT|OPTION|ENV|REG)$" : "^(IDENTIFIER|INDEX|DOT|OPTION|ENV|REG)$",
  "\\v^%(IF|ELSEIF|ELSE)$" : "^(IF|ELSEIF|ELSE)$",
  "\\v^%(TRY|CATCH|FINALLY)$" : "^(TRY|CATCH|FINALLY)$",
  "\\v^%(substitute|smagic|snomagic)$" : "^(substitute|smagic|snomagic)$",
  "\\v^%(write|update)$" : "^(write|update)$",
  "\\v^d%[elete][lp]$" : "^d(elete|elet|ele|el|e)[lp]$",
  "\\v^s%(c[^sr][^i][^p]|g|i[^mlg]|I|r[^e])" : "^s(c[^sr][^i][^p]|g|i[^mlg]|I|r[^e])",
  "\\w" : "[0-9A-Za-z_]",
  "\\w\\|[:#]" : "[0-9A-Za-z_]|[:#]",
  "\\x" : "[0-9A-Fa-f]",
  "^!" : "^!",
  "^!$" : "^!$",
  "^!=" : "^!=",
  "^!=#" : "^!=#",
  "^!=?" : "^!=\\?",
  "^!\\~" : "^!~",
  "^!\\~#" : "^!~#",
  "^!\\~?" : "^!~\\?",
  "^#$" : "^#$",
  "^%" : "^%",
  "^&$" : "^&$",
  "^&&" : "^&&",
  "^&\\(g:\\|l:\\|\\w\\w\\)" : "^&(g:|l:|[0-9A-Za-z_][0-9A-Za-z_])",
  "^'" : "^'",
  "^(" : "^\(",
  "^)" : "^\)",
  "^)\\+$" : "^\)+$",
  "^+" : "^\+",
  "^++" : "^\+\+",
  "^++bad=\\(keep\\|drop\\|.\\)\\>" : "^\\+\\+bad=(keep|drop|.)\\b",
  "^++bad=drop" : "^\\+\\+bad=drop",
  "^++bad=keep" : "^\\+\\+bad=keep",
  "^++bin\\>" : "^\\+\\+bin\\b",
  "^++edit\\>" : "^\\+\\+edit\\b",
  "^++enc=\\S" : "^\\+\\+enc=\\S",
  "^++encoding=\\S" : "^\\+\\+encoding=\\S",
  "^++ff=\\(dos\\|unix\\|mac\\)\\>" : "^\\+\\+ff=(dos|unix|mac)\\b",
  "^++fileformat=\\(dos\\|unix\\|mac\\)\\>" : "^\\+\\+fileformat=(dos|unix|mac)\\b",
  "^++nobin\\>" : "^\\+\\+nobin\\b",
  "^," : "^,",
  "^-" : "^-",
  "^/" : "^/",
  "^0x\\x" : "^0x[0-9A-Fa-f]",
  "^:" : "^:",
  "^;" : "^;",
  "^<" : "^<",
  "^<#" : "^<#",
  "^<$" : "^<$",
  "^<=" : "^<=",
  "^<=#" : "^<=#",
  "^<=?" : "^<=\\?",
  "^<?" : "^<\\?",
  "^<[Ss][Ii][Dd]>\\h" : "^<[Ss][Ii][Dd]>[A-Za-z_]",
  "^=" : "^=",
  "^=$" : "^=$",
  "^==" : "^==",
  "^==#" : "^==#",
  "^==?" : "^==\\?",
  "^=\\~" : "^=~",
  "^=\\~#" : "^=~#",
  "^=\\~?" : "^=~\\?",
  "^>" : "^>",
  "^>#" : "^>#",
  "^>$" : "^>$",
  "^>=" : "^>=",
  "^>=#" : "^>=#",
  "^>=?" : "^>=\\?",
  "^>?" : "^>\\?",
  "^?" : "^\\?",
  "^@$" : "^@$",
  "^@." : "^@.",
  "^FUNCTION$" : "^FUNCTION$",
  "^N\\%[ext]$" : "^N(ext|ex|e)$",
  "^P\\%[rint]$" : "^P(rint|rin|ri|r)$",
  "^X$" : "^X$",
  "^[<>]$" : "^[<>]$",
  "^[A-Z]" : "^[A-Z]",
  "^\"" : "^\"",
  "^\\$\\w\\+" : "^\\$[0-9A-Za-z_]+",
  "^\\(!\\|global\\|vglobal\\)$" : "^(!|global|vglobal)$",
  "^\\(WHILE\\|FOR\\)$" : "^(WHILE|FOR)$",
  "^\\(vimgrep\\|vimgrepadd\\|lvimgrep\\|lvimgrepadd\\)$" : "^(vimgrep|vimgrepadd|lvimgrep|lvimgrepadd)$",
  "^\\*" : "^\\*",
  "^\\*$" : "^\\*$",
  "^\\." : "^\\.",
  "^\\[" : "^\[",
  "^\\d" : "^\\d",
  "^\\h" : "^[A-Za-z_]",
  "^\\s" : "^\\s",
  "^\\~$" : "^~$",
  "^]" : "^]",
  "^`" : "^`",
  "^a\\%[ppend]$" : "^a(ppend|ppen|ppe|pp|p)?$",
  "^ab\\%[breviate]$" : "^ab(breviate|breviat|brevia|brevi|brev|bre|br|b)?$",
  "^abc\\%[lear]$" : "^abc(lear|lea|le|l)?$",
  "^abo\\%[veleft]$" : "^abo(veleft|velef|vele|vel|ve|v)?$",
  "^al\\%[l]$" : "^al(l)?$",
  "^am\\%[enu]$" : "^am(enu|en|e)?$",
  "^an\\%[oremenu]$" : "^an(oremenu|oremen|oreme|orem|ore|or|o)?$",
  "^ar\\%[gs]$" : "^ar(gs|g)?$",
  "^arga\\%[dd]$" : "^arga(dd|d)?$",
  "^argd\\%[elete]$" : "^argd(elete|elet|ele|el|e)?$",
  "^argdo$" : "^argdo$",
  "^arge\\%[dit]$" : "^arge(dit|di|d)?$",
  "^argg\\%[lobal]$" : "^argg(lobal|loba|lob|lo|l)?$",
  "^argl\\%[ocal]$" : "^argl(ocal|oca|oc|o)?$",
  "^argu\\%[ment]$" : "^argu(ment|men|me|m)?$",
  "^as\\%[cii]$" : "^as(cii|ci|c)?$",
  "^au\\%[tocmd]$" : "^au(tocmd|tocm|toc|to|t)?$",
  "^aug\\%[roup]$" : "^aug(roup|rou|ro|r)?$",
  "^aun\\%[menu]$" : "^aun(menu|men|me|m)?$",
  "^bN\\%[ext]$" : "^bN(ext|ex|e)?$",
  "^b\\%[uffer]$" : "^b(uffer|uffe|uff|uf|u)?$",
  "^ba\\%[ll]$" : "^ba(ll|l)?$",
  "^bad\\%[d]$" : "^bad(d)?$",
  "^bd\\%[elete]$" : "^bd(elete|elet|ele|el|e)?$",
  "^be\\%[have]$" : "^be(have|hav|ha|h)?$",
  "^bel\\%[owright]$" : "^bel(owright|owrigh|owrig|owri|owr|ow|o)?$",
  "^bf\\%[irst]$" : "^bf(irst|irs|ir|i)?$",
  "^bl\\%[ast]$" : "^bl(ast|as|a)?$",
  "^bm\\%[odified]$" : "^bm(odified|odifie|odifi|odif|odi|od|o)?$",
  "^bn\\%[ext]$" : "^bn(ext|ex|e)?$",
  "^bo\\%[tright]$" : "^bo(tright|trigh|trig|tri|tr|t)?$",
  "^bp\\%[revious]$" : "^bp(revious|reviou|revio|revi|rev|re|r)?$",
  "^br\\%[ewind]$" : "^br(ewind|ewin|ewi|ew|e)?$",
  "^brea\\%[k]$" : "^brea(k)?$",
  "^breaka\\%[dd]$" : "^breaka(dd|d)?$",
  "^breakd\\%[el]$" : "^breakd(el|e)?$",
  "^breakl\\%[ist]$" : "^breakl(ist|is|i)?$",
  "^bro\\%[wse]$" : "^bro(wse|ws|w)?$",
  "^bufdo$" : "^bufdo$",
  "^buffers$" : "^buffers$",
  "^bun\\%[load]$" : "^bun(load|loa|lo|l)?$",
  "^bw\\%[ipeout]$" : "^bw(ipeout|ipeou|ipeo|ipe|ip|i)?$",
  "^cN\\%[ext]$" : "^cN(ext|ex|e)?$",
  "^cNf\\%[ile]$" : "^cNf(ile|il|i)?$",
  "^c\\%[hange]$" : "^c(hange|hang|han|ha|h)?$",
  "^ca\\%[bbrev]$" : "^ca(bbrev|bbre|bbr|bb|b)?$",
  "^cabc\\%[lear]$" : "^cabc(lear|lea|le|l)?$",
  "^cad\\%[dexpr]$" : "^cad(dexpr|dexp|dex|de|d)?$",
  "^caddb\\%[uffer]$" : "^caddb(uffer|uffe|uff|uf|u)?$",
  "^caddf\\%[ile]$" : "^caddf(ile|il|i)?$",
  "^cal\\%[l]$" : "^cal(l)?$",
  "^cat\\%[ch]$" : "^cat(ch|c)?$",
  "^cb\\%[uffer]$" : "^cb(uffer|uffe|uff|uf|u)?$",
  "^cc$" : "^cc$",
  "^ccl\\%[ose]$" : "^ccl(ose|os|o)?$",
  "^cd$" : "^cd$",
  "^ce\\%[nter]$" : "^ce(nter|nte|nt|n)?$",
  "^cex\\%[pr]$" : "^cex(pr|p)?$",
  "^cf\\%[ile]$" : "^cf(ile|il|i)?$",
  "^cfir\\%[st]$" : "^cfir(st|s)?$",
  "^cg\\%[etfile]$" : "^cg(etfile|etfil|etfi|etf|et|e)?$",
  "^cgetb\\%[uffer]$" : "^cgetb(uffer|uffe|uff|uf|u)?$",
  "^cgete\\%[xpr]$" : "^cgete(xpr|xp|x)?$",
  "^changes$" : "^changes$",
  "^chd\\%[ir]$" : "^chd(ir|i)?$",
  "^che\\%[ckpath]$" : "^che(ckpath|ckpat|ckpa|ckp|ck|c)?$",
  "^checkt\\%[ime]$" : "^checkt(ime|im|i)?$",
  "^cl\\%[ist]$" : "^cl(ist|is|i)?$",
  "^cla\\%[st]$" : "^cla(st|s)?$",
  "^clo\\%[se]$" : "^clo(se|s)?$",
  "^cm\\%[ap]$" : "^cm(ap|a)?$",
  "^cmapc\\%[lear]$" : "^cmapc(lear|lea|le|l)?$",
  "^cme\\%[nu]$" : "^cme(nu|n)?$",
  "^cn\\%[ext]$" : "^cn(ext|ex|e)?$",
  "^cnew\\%[er]$" : "^cnew(er|e)?$",
  "^cnf\\%[ile]$" : "^cnf(ile|il|i)?$",
  "^cno\\%[remap]$" : "^cno(remap|rema|rem|re|r)?$",
  "^cnorea\\%[bbrev]$" : "^cnorea(bbrev|bbre|bbr|bb|b)?$",
  "^cnoreme\\%[nu]$" : "^cnoreme(nu|n)?$",
  "^co\\%[py]$" : "^co(py|p)?$",
  "^col\\%[der]$" : "^col(der|de|d)?$",
  "^colo\\%[rscheme]$" : "^colo(rscheme|rschem|rsche|rsch|rsc|rs|r)?$",
  "^com\\%[mand]$" : "^com(mand|man|ma|m)?$",
  "^comc\\%[lear]$" : "^comc(lear|lea|le|l)?$",
  "^comp\\%[iler]$" : "^comp(iler|ile|il|i)?$",
  "^con\\%[tinue]$" : "^con(tinue|tinu|tin|ti|t)?$",
  "^conf\\%[irm]$" : "^conf(irm|ir|i)?$",
  "^cope\\%[n]$" : "^cope(n)?$",
  "^cp\\%[revious]$" : "^cp(revious|reviou|revio|revi|rev|re|r)?$",
  "^cpf\\%[ile]$" : "^cpf(ile|il|i)?$",
  "^cq\\%[uit]$" : "^cq(uit|ui|u)?$",
  "^cr\\%[ewind]$" : "^cr(ewind|ewin|ewi|ew|e)?$",
  "^cs\\%[cope]$" : "^cs(cope|cop|co|c)?$",
  "^cst\\%[ag]$" : "^cst(ag|a)?$",
  "^cu\\%[nmap]$" : "^cu(nmap|nma|nm|n)?$",
  "^cuna\\%[bbrev]$" : "^cuna(bbrev|bbre|bbr|bb|b)?$",
  "^cunme\\%[nu]$" : "^cunme(nu|n)?$",
  "^cw\\%[indow]$" : "^cw(indow|indo|ind|in|i)?$",
  "^d\\%[elete]$" : "^d(elete|elet|ele|el|e)?$",
  "^deb\\%[ug]$" : "^deb(ug|u)?$",
  "^debugg\\%[reedy]$" : "^debugg(reedy|reed|ree|re|r)?$",
  "^delc\\%[ommand]$" : "^delc(ommand|omman|omma|omm|om|o)?$",
  "^delf\\%[unction]$" : "^delf(unction|unctio|uncti|unct|unc|un|u)?$",
  "^delm\\%[arks]$" : "^delm(arks|ark|ar|a)?$",
  "^di\\%[splay]$" : "^di(splay|spla|spl|sp|s)?$",
  "^dif\\%[fupdate]$" : "^dif(fupdate|fupdat|fupda|fupd|fup|fu|f)?$",
  "^diffg\\%[et]$" : "^diffg(et|e)?$",
  "^diffo\\%[ff]$" : "^diffo(ff|f)?$",
  "^diffp\\%[atch]$" : "^diffp(atch|atc|at|a)?$",
  "^diffpu\\%[t]$" : "^diffpu(t)?$",
  "^diffs\\%[plit]$" : "^diffs(plit|pli|pl|p)?$",
  "^diffthis$" : "^diffthis$",
  "^dig\\%[raphs]$" : "^dig(raphs|raph|rap|ra|r)?$",
  "^dj\\%[ump]$" : "^dj(ump|um|u)?$",
  "^dl\\%[ist]$" : "^dl(ist|is|i)?$",
  "^do\\%[autocmd]$" : "^do(autocmd|autocm|autoc|auto|aut|au|a)?$",
  "^doautoa\\%[ll]$" : "^doautoa(ll|l)?$",
  "^dr\\%[op]$" : "^dr(op|o)?$",
  "^ds\\%[earch]$" : "^ds(earch|earc|ear|ea|e)?$",
  "^dsp\\%[lit]$" : "^dsp(lit|li|l)?$",
  "^e\\%[dit]$" : "^e(dit|di|d)?$",
  "^ea\\%[rlier]$" : "^ea(rlier|rlie|rli|rl|r)?$",
  "^ec\\%[ho]$" : "^ec(ho|h)?$",
  "^echoe\\%[rr]$" : "^echoe(rr|r)?$",
  "^echoh\\%[l]$" : "^echoh(l)?$",
  "^echom\\%[sg]$" : "^echom(sg|s)?$",
  "^echon$" : "^echon$",
  "^el\\%[se]$" : "^el(se|s)?$",
  "^elsei\\%[f]$" : "^elsei(f)?$",
  "^em\\%[enu]$" : "^em(enu|en|e)?$",
  "^en\\%[dif]$" : "^en(dif|di|d)?$",
  "^endf\\%[unction]$" : "^endf(unction|unctio|uncti|unct|unc|un|u)?$",
  "^endfo\\%[r]$" : "^endfo(r)?$",
  "^endt\\%[ry]$" : "^endt(ry|r)?$",
  "^endw\\%[hile]$" : "^endw(hile|hil|hi|h)?$",
  "^ene\\%[w]$" : "^ene(w)?$",
  "^ex$" : "^ex$",
  "^exe\\%[cute]$" : "^exe(cute|cut|cu|c)?$",
  "^exi\\%[t]$" : "^exi(t)?$",
  "^exu\\%[sage]$" : "^exu(sage|sag|sa|s)?$",
  "^f\\%[ile]$" : "^f(ile|il|i)?$",
  "^files$" : "^files$",
  "^filet\\%[ype]$" : "^filet(ype|yp|y)?$",
  "^fin\\%[d]$" : "^fin(d)?$",
  "^fina\\%[lly]$" : "^fina(lly|ll|l)?$",
  "^fini\\%[sh]$" : "^fini(sh|s)?$",
  "^fir\\%[st]$" : "^fir(st|s)?$",
  "^fix\\%[del]$" : "^fix(del|de|d)?$",
  "^fo\\%[ld]$" : "^fo(ld|l)?$",
  "^foldc\\%[lose]$" : "^foldc(lose|los|lo|l)?$",
  "^foldd\\%[oopen]$" : "^foldd(oopen|oope|oop|oo|o)?$",
  "^folddoc\\%[losed]$" : "^folddoc(losed|lose|los|lo|l)?$",
  "^foldo\\%[pen]$" : "^foldo(pen|pe|p)?$",
  "^for$" : "^for$",
  "^fu\\%[nction]$" : "^fu(nction|nctio|ncti|nct|nc|n)?$",
  "^g\\%[lobal]$" : "^g(lobal|loba|lob|lo|l)?$",
  "^go\\%[to]$" : "^go(to|t)?$",
  "^gr\\%[ep]$" : "^gr(ep|e)?$",
  "^grepa\\%[dd]$" : "^grepa(dd|d)?$",
  "^gu\\%[i]$" : "^gu(i)?$",
  "^gv\\%[im]$" : "^gv(im|i)?$",
  "^h\\%[elp]$" : "^h(elp|el|e)?$",
  "^ha\\%[rdcopy]$" : "^ha(rdcopy|rdcop|rdco|rdc|rd|r)?$",
  "^helpf\\%[ind]$" : "^helpf(ind|in|i)?$",
  "^helpg\\%[rep]$" : "^helpg(rep|re|r)?$",
  "^helpt\\%[ags]$" : "^helpt(ags|ag|a)?$",
  "^hi\\%[ghlight]$" : "^hi(ghlight|ghligh|ghlig|ghli|ghl|gh|g)?$",
  "^hid\\%[e]$" : "^hid(e)?$",
  "^his\\%[tory]$" : "^his(tory|tor|to|t)?$",
  "^i\\%[nsert]$" : "^i(nsert|nser|nse|ns|n)?$",
  "^ia\\%[bbrev]$" : "^ia(bbrev|bbre|bbr|bb|b)?$",
  "^iabc\\%[lear]$" : "^iabc(lear|lea|le|l)?$",
  "^if$" : "^if$",
  "^ij\\%[ump]$" : "^ij(ump|um|u)?$",
  "^il\\%[ist]$" : "^il(ist|is|i)?$",
  "^im\\%[ap]$" : "^im(ap|a)?$",
  "^imapc\\%[lear]$" : "^imapc(lear|lea|le|l)?$",
  "^ime\\%[nu]$" : "^ime(nu|n)?$",
  "^ino\\%[remap]$" : "^ino(remap|rema|rem|re|r)?$",
  "^inorea\\%[bbrev]$" : "^inorea(bbrev|bbre|bbr|bb|b)?$",
  "^inoreme\\%[nu]$" : "^inoreme(nu|n)?$",
  "^int\\%[ro]$" : "^int(ro|r)?$",
  "^is#" : "^is#",
  "^is?" : "^is\\?",
  "^is\\%[earch]$" : "^is(earch|earc|ear|ea|e)?$",
  "^is\\>" : "^is\\b",
  "^isnot#" : "^isnot#",
  "^isnot?" : "^isnot\\?",
  "^isnot\\>" : "^isnot\\b",
  "^isp\\%[lit]$" : "^isp(lit|li|l)?$",
  "^iu\\%[nmap]$" : "^iu(nmap|nma|nm|n)?$",
  "^iuna\\%[bbrev]$" : "^iuna(bbrev|bbre|bbr|bb|b)?$",
  "^iunme\\%[nu]$" : "^iunme(nu|n)?$",
  "^j\\%[oin]$" : "^j(oin|oi|o)?$",
  "^ju\\%[mps]$" : "^ju(mps|mp|m)?$",
  "^k$" : "^k$",
  "^kee\\%[pmarks]$" : "^kee(pmarks|pmark|pmar|pma|pm|p)?$",
  "^keepa\\%[lt]$" : "^keepa(lt|l)?$",
  "^keepj\\%[umps]$" : "^keepj(umps|ump|um|u)?$",
  "^lN\\%[ext]$" : "^lN(ext|ex|e)?$",
  "^lNf\\%[ile]$" : "^lNf(ile|il|i)?$",
  "^l\\%[ist]$" : "^l(ist|is|i)?$",
  "^la\\%[st]$" : "^la(st|s)?$",
  "^lad\\%[dexpr]$" : "^lad(dexpr|dexp|dex|de|d)?$",
  "^laddb\\%[uffer]$" : "^laddb(uffer|uffe|uff|uf|u)?$",
  "^laddf\\%[ile]$" : "^laddf(ile|il|i)?$",
  "^lan\\%[guage]$" : "^lan(guage|guag|gua|gu|g)?$",
  "^lat\\%[er]$" : "^lat(er|e)?$",
  "^lb\\%[uffer]$" : "^lb(uffer|uffe|uff|uf|u)?$",
  "^lc\\%[d]$" : "^lc(d)?$",
  "^lch\\%[dir]$" : "^lch(dir|di|d)?$",
  "^lcl\\%[ose]$" : "^lcl(ose|os|o)?$",
  "^lcs\\%[cope]$" : "^lcs(cope|cop|co|c)?$",
  "^le\\%[ft]$" : "^le(ft|f)?$",
  "^lefta\\%[bove]$" : "^lefta(bove|bov|bo|b)?$",
  "^let$" : "^let$",
  "^lex\\%[pr]$" : "^lex(pr|p)?$",
  "^lf\\%[ile]$" : "^lf(ile|il|i)?$",
  "^lfir\\%[st]$" : "^lfir(st|s)?$",
  "^lg\\%[etfile]$" : "^lg(etfile|etfil|etfi|etf|et|e)?$",
  "^lgetb\\%[uffer]$" : "^lgetb(uffer|uffe|uff|uf|u)?$",
  "^lgete\\%[xpr]$" : "^lgete(xpr|xp|x)?$",
  "^lgr\\%[ep]$" : "^lgr(ep|e)?$",
  "^lgrepa\\%[dd]$" : "^lgrepa(dd|d)?$",
  "^lh\\%[elpgrep]$" : "^lh(elpgrep|elpgre|elpgr|elpg|elp|el|e)?$",
  "^ll$" : "^ll$",
  "^lla\\%[st]$" : "^lla(st|s)?$",
  "^lli\\%[st]$" : "^lli(st|s)?$",
  "^lm\\%[ap]$" : "^lm(ap|a)?$",
  "^lmak\\%[e]$" : "^lmak(e)?$",
  "^lmapc\\%[lear]$" : "^lmapc(lear|lea|le|l)?$",
  "^ln\\%[oremap]$" : "^ln(oremap|orema|orem|ore|or|o)?$",
  "^lne\\%[xt]$" : "^lne(xt|x)?$",
  "^lnew\\%[er]$" : "^lnew(er|e)?$",
  "^lnf\\%[ile]$" : "^lnf(ile|il|i)?$",
  "^lo\\%[adview]$" : "^lo(adview|advie|advi|adv|ad|a)?$",
  "^loadk\\%[eymap]$" : "^loadk(eymap|eyma|eym|ey|e)?$",
  "^loc\\%[kmarks]$" : "^loc(kmarks|kmark|kmar|kma|km|k)?$",
  "^lockv\\%[ar]$" : "^lockv(ar|a)?$",
  "^lol\\%[der]$" : "^lol(der|de|d)?$",
  "^lope\\%[n]$" : "^lope(n)?$",
  "^lp\\%[revious]$" : "^lp(revious|reviou|revio|revi|rev|re|r)?$",
  "^lpf\\%[ile]$" : "^lpf(ile|il|i)?$",
  "^lr\\%[ewind]$" : "^lr(ewind|ewin|ewi|ew|e)?$",
  "^ls$" : "^ls$",
  "^lt\\%[ag]$" : "^lt(ag|a)?$",
  "^lu\\%[nmap]$" : "^lu(nmap|nma|nm|n)?$",
  "^lua$" : "^lua$",
  "^luad\\%[o]$" : "^luad(o)?$",
  "^luaf\\%[ile]$" : "^luaf(ile|il|i)?$",
  "^lv\\%[imgrep]$" : "^lv(imgrep|imgre|imgr|img|im|i)?$",
  "^lvimgrepa\\%[dd]$" : "^lvimgrepa(dd|d)?$",
  "^lw\\%[indow]$" : "^lw(indow|indo|ind|in|i)?$",
  "^m\\%[ove]$" : "^m(ove|ov|o)?$",
  "^ma\\%[rk]$" : "^ma(rk|r)?$",
  "^mak\\%[e]$" : "^mak(e)?$",
  "^map$" : "^map$",
  "^mapc\\%[lear]$" : "^mapc(lear|lea|le|l)?$",
  "^marks$" : "^marks$",
  "^mat\\%[ch]$" : "^mat(ch|c)?$",
  "^me\\%[nu]$" : "^me(nu|n)?$",
  "^menut\\%[ranslate]$" : "^menut(ranslate|ranslat|ransla|ransl|rans|ran|ra|r)?$",
  "^mes\\%[sages]$" : "^mes(sages|sage|sag|sa|s)?$",
  "^mk\\%[exrc]$" : "^mk(exrc|exr|ex|e)?$",
  "^mks\\%[ession]$" : "^mks(ession|essio|essi|ess|es|e)?$",
  "^mksp\\%[ell]$" : "^mksp(ell|el|e)?$",
  "^mkv\\%[imrc]$" : "^mkv(imrc|imr|im|i)?$",
  "^mkvie\\%[w]$" : "^mkvie(w)?$",
  "^mod\\%[e]$" : "^mod(e)?$",
  "^mz\\%[scheme]$" : "^mz(scheme|schem|sche|sch|sc|s)?$",
  "^mzf\\%[ile]$" : "^mzf(ile|il|i)?$",
  "^n\\%[ext]$" : "^n(ext|ex|e)?$",
  "^nb\\%[key]$" : "^nb(key|ke|k)?$",
  "^nbc\\%[lose]$" : "^nbc(lose|los|lo|l)?$",
  "^nbs\\%[art]$" : "^nbs(art|ar|a)?$",
  "^new$" : "^new$",
  "^nm\\%[ap]$" : "^nm(ap|a)?$",
  "^nmapc\\%[lear]$" : "^nmapc(lear|lea|le|l)?$",
  "^nme\\%[nu]$" : "^nme(nu|n)?$",
  "^nn\\%[oremap]$" : "^nn(oremap|orema|orem|ore|or|o)?$",
  "^nnoreme\\%[nu]$" : "^nnoreme(nu|n)?$",
  "^no\\%[remap]$" : "^no(remap|rema|rem|re|r)?$",
  "^noa\\%[utocmd]$" : "^noa(utocmd|utocm|utoc|uto|ut|u)?$",
  "^noh\\%[lsearch]$" : "^noh(lsearch|lsearc|lsear|lsea|lse|ls|l)?$",
  "^norea\\%[bbrev]$" : "^norea(bbrev|bbre|bbr|bb|b)?$",
  "^noreme\\%[nu]$" : "^noreme(nu|n)?$",
  "^norm\\%[al]$" : "^norm(al|a)?$",
  "^nu\\%[mber]$" : "^nu(mber|mbe|mb|m)?$",
  "^nun\\%[map]$" : "^nun(map|ma|m)?$",
  "^nunme\\%[nu]$" : "^nunme(nu|n)?$",
  "^o\\%[pen]$" : "^o(pen|pe|p)?$",
  "^ol\\%[dfiles]$" : "^ol(dfiles|dfile|dfil|dfi|df|d)?$",
  "^om\\%[ap]$" : "^om(ap|a)?$",
  "^omapc\\%[lear]$" : "^omapc(lear|lea|le|l)?$",
  "^ome\\%[nu]$" : "^ome(nu|n)?$",
  "^on\\%[ly]$" : "^on(ly|l)?$",
  "^ono\\%[remap]$" : "^ono(remap|rema|rem|re|r)?$",
  "^onoreme\\%[nu]$" : "^onoreme(nu|n)?$",
  "^opt\\%[ions]$" : "^opt(ions|ion|io|i)?$",
  "^ou\\%[nmap]$" : "^ou(nmap|nma|nm|n)?$",
  "^ounme\\%[nu]$" : "^ounme(nu|n)?$",
  "^ow\\%[nsyntax]$" : "^ow(nsyntax|nsynta|nsynt|nsyn|nsy|ns|n)?$",
  "^p\\%[rint]$" : "^p(rint|rin|ri|r)?$",
  "^pc\\%[lose]$" : "^pc(lose|los|lo|l)?$",
  "^pe\\%[rl]$" : "^pe(rl|r)?$",
  "^ped\\%[it]$" : "^ped(it|i)?$",
  "^perld\\%[o]$" : "^perld(o)?$",
  "^po\\%[p]$" : "^po(p)?$",
  "^popu\\%[p]$" : "^popu(p)?$",
  "^pp\\%[op]$" : "^pp(op|o)?$",
  "^pre\\%[serve]$" : "^pre(serve|serv|ser|se|s)?$",
  "^prev\\%[ious]$" : "^prev(ious|iou|io|i)?$",
  "^pro\\%[mptfind]$" : "^pro(mptfind|mptfin|mptfi|mptf|mpt|mp|m)?$",
  "^prof\\%[ile]$" : "^prof(ile|il|i)?$",
  "^profd\\%[el]$" : "^profd(el|e)?$",
  "^promptr\\%[epl]$" : "^promptr(epl|ep|e)?$",
  "^ps\\%[earch]$" : "^ps(earch|earc|ear|ea|e)?$",
  "^ptN\\%[ext]$" : "^ptN(ext|ex|e)?$",
  "^pt\\%[ag]$" : "^pt(ag|a)?$",
  "^ptf\\%[irst]$" : "^ptf(irst|irs|ir|i)?$",
  "^ptj\\%[ump]$" : "^ptj(ump|um|u)?$",
  "^ptl\\%[ast]$" : "^ptl(ast|as|a)?$",
  "^ptn\\%[ext]$" : "^ptn(ext|ex|e)?$",
  "^ptp\\%[revious]$" : "^ptp(revious|reviou|revio|revi|rev|re|r)?$",
  "^ptr\\%[ewind]$" : "^ptr(ewind|ewin|ewi|ew|e)?$",
  "^pts\\%[elect]$" : "^pts(elect|elec|ele|el|e)?$",
  "^pu\\%[t]$" : "^pu(t)?$",
  "^pw\\%[d]$" : "^pw(d)?$",
  "^py3$" : "^py3$",
  "^py3f\\%[ile]$" : "^py3f(ile|il|i)?$",
  "^py\\%[thon]$" : "^py(thon|tho|th|t)?$",
  "^pyf\\%[ile]$" : "^pyf(ile|il|i)?$",
  "^python3$" : "^python3$",
  "^q\\%[uit]$" : "^q(uit|ui|u)?$",
  "^qa\\%[ll]$" : "^qa(ll|l)?$",
  "^quita\\%[ll]$" : "^quita(ll|l)?$",
  "^r\\%[ead]$" : "^r(ead|ea|e)?$",
  "^rec\\%[over]$" : "^rec(over|ove|ov|o)?$",
  "^red\\%[o]$" : "^red(o)?$",
  "^redi\\%[r]$" : "^redi(r)?$",
  "^redr\\%[aw]$" : "^redr(aw|a)?$",
  "^redraws\\%[tatus]$" : "^redraws(tatus|tatu|tat|ta|t)?$",
  "^reg\\%[isters]$" : "^reg(isters|ister|iste|ist|is|i)?$",
  "^res\\%[ize]$" : "^res(ize|iz|i)?$",
  "^ret\\%[ab]$" : "^ret(ab|a)?$",
  "^retu\\%[rn]$" : "^retu(rn|r)?$",
  "^rew\\%[ind]$" : "^rew(ind|in|i)?$",
  "^ri\\%[ght]$" : "^ri(ght|gh|g)?$",
  "^rightb\\%[elow]$" : "^rightb(elow|elo|el|e)?$",
  "^ru\\%[ntime]$" : "^ru(ntime|ntim|nti|nt|n)?$",
  "^rub\\%[y]$" : "^rub(y)?$",
  "^rubyd\\%[o]$" : "^rubyd(o)?$",
  "^rubyf\\%[ile]$" : "^rubyf(ile|il|i)?$",
  "^rund\\%[o]$" : "^rund(o)?$",
  "^rv\\%[iminfo]$" : "^rv(iminfo|iminf|imin|imi|im|i)?$",
  "^sN\\%[ext]$" : "^sN(ext|ex|e)?$",
  "^s\\%[ubstitute]$" : "^s(ubstitute|ubstitut|ubstitu|ubstit|ubsti|ubst|ubs|ub|u)?$",
  "^sa\\%[rgument]$" : "^sa(rgument|rgumen|rgume|rgum|rgu|rg|r)?$",
  "^sal\\%[l]$" : "^sal(l)?$",
  "^san\\%[dbox]$" : "^san(dbox|dbo|db|d)?$",
  "^sav\\%[eas]$" : "^sav(eas|ea|e)?$",
  "^sbN\\%[ext]$" : "^sbN(ext|ex|e)?$",
  "^sb\\%[uffer]$" : "^sb(uffer|uffe|uff|uf|u)?$",
  "^sba\\%[ll]$" : "^sba(ll|l)?$",
  "^sbf\\%[irst]$" : "^sbf(irst|irs|ir|i)?$",
  "^sbl\\%[ast]$" : "^sbl(ast|as|a)?$",
  "^sbm\\%[odified]$" : "^sbm(odified|odifie|odifi|odif|odi|od|o)?$",
  "^sbn\\%[ext]$" : "^sbn(ext|ex|e)?$",
  "^sbp\\%[revious]$" : "^sbp(revious|reviou|revio|revi|rev|re|r)?$",
  "^sbr\\%[ewind]$" : "^sbr(ewind|ewin|ewi|ew|e)?$",
  "^scrip\\%[tnames]$" : "^scrip(tnames|tname|tnam|tna|tn|t)?$",
  "^scripte\\%[ncoding]$" : "^scripte(ncoding|ncodin|ncodi|ncod|nco|nc|n)?$",
  "^scs\\%[cope]$" : "^scs(cope|cop|co|c)?$",
  "^se\\%[t]$" : "^se(t)?$",
  "^setf\\%[iletype]$" : "^setf(iletype|iletyp|ilety|ilet|ile|il|i)?$",
  "^setg\\%[lobal]$" : "^setg(lobal|loba|lob|lo|l)?$",
  "^setl\\%[ocal]$" : "^setl(ocal|oca|oc|o)?$",
  "^sf\\%[ind]$" : "^sf(ind|in|i)?$",
  "^sfir\\%[st]$" : "^sfir(st|s)?$",
  "^sh\\%[ell]$" : "^sh(ell|el|e)?$",
  "^sig\\%[n]$" : "^sig(n)?$",
  "^sil\\%[ent]$" : "^sil(ent|en|e)?$",
  "^sim\\%[alt]$" : "^sim(alt|al|a)?$",
  "^sl\\%[eep]$" : "^sl(eep|ee|e)?$",
  "^sla\\%[st]$" : "^sla(st|s)?$",
  "^sm\\%[agic]$" : "^sm(agic|agi|ag|a)?$",
  "^smap$" : "^smap$",
  "^smapc\\%[lear]$" : "^smapc(lear|lea|le|l)?$",
  "^sme\\%[nu]$" : "^sme(nu|n)?$",
  "^sn\\%[ext]$" : "^sn(ext|ex|e)?$",
  "^sni\\%[ff]$" : "^sni(ff|f)?$",
  "^sno\\%[magic]$" : "^sno(magic|magi|mag|ma|m)?$",
  "^snor\\%[emap]$" : "^snor(emap|ema|em|e)?$",
  "^snoreme\\%[nu]$" : "^snoreme(nu|n)?$",
  "^so\\%[urce]$" : "^so(urce|urc|ur|u)?$",
  "^sor\\%[t]$" : "^sor(t)?$",
  "^sp\\%[lit]$" : "^sp(lit|li|l)?$",
  "^spe\\%[llgood]$" : "^spe(llgood|llgoo|llgo|llg|ll|l)?$",
  "^spelld\\%[ump]$" : "^spelld(ump|um|u)?$",
  "^spelli\\%[nfo]$" : "^spelli(nfo|nf|n)?$",
  "^spellr\\%[epall]$" : "^spellr(epall|epal|epa|ep|e)?$",
  "^spellu\\%[ndo]$" : "^spellu(ndo|nd|n)?$",
  "^spellw\\%[rong]$" : "^spellw(rong|ron|ro|r)?$",
  "^spr\\%[evious]$" : "^spr(evious|eviou|evio|evi|ev|e)?$",
  "^sre\\%[wind]$" : "^sre(wind|win|wi|w)?$",
  "^st\\%[op]$" : "^st(op|o)?$",
  "^sta\\%[g]$" : "^sta(g)?$",
  "^star\\%[tinsert]$" : "^star(tinsert|tinser|tinse|tins|tin|ti|t)?$",
  "^startg\\%[replace]$" : "^startg(replace|replac|repla|repl|rep|re|r)?$",
  "^startr\\%[eplace]$" : "^startr(eplace|eplac|epla|epl|ep|e)?$",
  "^stj\\%[ump]$" : "^stj(ump|um|u)?$",
  "^stopi\\%[nsert]$" : "^stopi(nsert|nser|nse|ns|n)?$",
  "^sts\\%[elect]$" : "^sts(elect|elec|ele|el|e)?$",
  "^sun\\%[hide]$" : "^sun(hide|hid|hi|h)?$",
  "^sunm\\%[ap]$" : "^sunm(ap|a)?$",
  "^sunme\\%[nu]$" : "^sunme(nu|n)?$",
  "^sus\\%[pend]$" : "^sus(pend|pen|pe|p)?$",
  "^sv\\%[iew]$" : "^sv(iew|ie|i)?$",
  "^sw\\%[apname]$" : "^sw(apname|apnam|apna|apn|ap|a)?$",
  "^sy\\%[ntax]$" : "^sy(ntax|nta|nt|n)?$",
  "^sync\\%[bind]$" : "^sync(bind|bin|bi|b)?$",
  "^t$" : "^t$",
  "^tN\\%[ext]$" : "^tN(ext|ex|e)?$",
  "^ta\\%[g]$" : "^ta(g)?$",
  "^tab$" : "^tab$",
  "^tabN\\%[ext]$" : "^tabN(ext|ex|e)?$",
  "^tabc\\%[lose]$" : "^tabc(lose|los|lo|l)?$",
  "^tabdo$" : "^tabdo$",
  "^tabe\\%[dit]$" : "^tabe(dit|di|d)?$",
  "^tabf\\%[ind]$" : "^tabf(ind|in|i)?$",
  "^tabfir\\%[st]$" : "^tabfir(st|s)?$",
  "^tabl\\%[ast]$" : "^tabl(ast|as|a)?$",
  "^tabm\\%[ove]$" : "^tabm(ove|ov|o)?$",
  "^tabn\\%[ext]$" : "^tabn(ext|ex|e)?$",
  "^tabnew$" : "^tabnew$",
  "^tabo\\%[nly]$" : "^tabo(nly|nl|n)?$",
  "^tabp\\%[revious]$" : "^tabp(revious|reviou|revio|revi|rev|re|r)?$",
  "^tabr\\%[ewind]$" : "^tabr(ewind|ewin|ewi|ew|e)?$",
  "^tabs$" : "^tabs$",
  "^tags$" : "^tags$",
  "^tc\\%[l]$" : "^tc(l)?$",
  "^tcld\\%[o]$" : "^tcld(o)?$",
  "^tclf\\%[ile]$" : "^tclf(ile|il|i)?$",
  "^te\\%[aroff]$" : "^te(aroff|arof|aro|ar|a)?$",
  "^tf\\%[irst]$" : "^tf(irst|irs|ir|i)?$",
  "^th\\%[row]$" : "^th(row|ro|r)?$",
  "^tj\\%[ump]$" : "^tj(ump|um|u)?$",
  "^tl\\%[ast]$" : "^tl(ast|as|a)?$",
  "^tm\\%[enu]$" : "^tm(enu|en|e)?$",
  "^tn\\%[ext]$" : "^tn(ext|ex|e)?$",
  "^to\\%[pleft]$" : "^to(pleft|plef|ple|pl|p)?$",
  "^tp\\%[revious]$" : "^tp(revious|reviou|revio|revi|rev|re|r)?$",
  "^tr\\%[ewind]$" : "^tr(ewind|ewin|ewi|ew|e)?$",
  "^try$" : "^try$",
  "^ts\\%[elect]$" : "^ts(elect|elec|ele|el|e)?$",
  "^tu\\%[nmenu]$" : "^tu(nmenu|nmen|nme|nm|n)?$",
  "^u\\%[ndo]$" : "^u(ndo|nd|n)?$",
  "^una\\%[bbreviate]$" : "^una(bbreviate|bbreviat|bbrevia|bbrevi|bbrev|bbre|bbr|bb|b)?$",
  "^undoj\\%[oin]$" : "^undoj(oin|oi|o)?$",
  "^undol\\%[ist]$" : "^undol(ist|is|i)?$",
  "^unh\\%[ide]$" : "^unh(ide|id|i)?$",
  "^unl\\%[et]$" : "^unl(et|e)?$",
  "^unlo\\%[ckvar]$" : "^unlo(ckvar|ckva|ckv|ck|c)?$",
  "^unm\\%[ap]$" : "^unm(ap|a)?$",
  "^unme\\%[nu]$" : "^unme(nu|n)?$",
  "^uns\\%[ilent]$" : "^uns(ilent|ilen|ile|il|i)?$",
  "^up\\%[date]$" : "^up(date|dat|da|d)?$",
  "^v\\%[global]$" : "^v(global|globa|glob|glo|gl|g)?$",
  "^ve\\%[rsion]$" : "^ve(rsion|rsio|rsi|rs|r)?$",
  "^verb\\%[ose]$" : "^verb(ose|os|o)?$",
  "^vert\\%[ical]$" : "^vert(ical|ica|ic|i)?$",
  "^vi\\%[sual]$" : "^vi(sual|sua|su|s)?$",
  "^vie\\%[w]$" : "^vie(w)?$",
  "^vim\\%[grep]$" : "^vim(grep|gre|gr|g)?$",
  "^vimgrepa\\%[dd]$" : "^vimgrepa(dd|d)?$",
  "^viu\\%[sage]$" : "^viu(sage|sag|sa|s)?$",
  "^vm\\%[ap]$" : "^vm(ap|a)?$",
  "^vmapc\\%[lear]$" : "^vmapc(lear|lea|le|l)?$",
  "^vme\\%[nu]$" : "^vme(nu|n)?$",
  "^vn\\%[oremap]$" : "^vn(oremap|orema|orem|ore|or|o)?$",
  "^vne\\%[w]$" : "^vne(w)?$",
  "^vnoreme\\%[nu]$" : "^vnoreme(nu|n)?$",
  "^vs\\%[plit]$" : "^vs(plit|pli|pl|p)?$",
  "^vu\\%[nmap]$" : "^vu(nmap|nma|nm|n)?$",
  "^vunme\\%[nu]$" : "^vunme(nu|n)?$",
  "^wN\\%[ext]$" : "^wN(ext|ex|e)?$",
  "^w\\%[rite]$" : "^w(rite|rit|ri|r)?$",
  "^wa\\%[ll]$" : "^wa(ll|l)?$",
  "^wh\\%[ile]$" : "^wh(ile|il|i)?$",
  "^wi\\%[nsize]$" : "^wi(nsize|nsiz|nsi|ns|n)?$",
  "^winc\\%[md]$" : "^winc(md|m)?$",
  "^windo$" : "^windo$",
  "^winp\\%[os]$" : "^winp(os|o)?$",
  "^wn\\%[ext]$" : "^wn(ext|ex|e)?$",
  "^wp\\%[revious]$" : "^wp(revious|reviou|revio|revi|rev|re|r)?$",
  "^wq$" : "^wq$",
  "^wqa\\%[ll]$" : "^wqa(ll|l)?$",
  "^ws\\%[verb]$" : "^ws(verb|ver|ve|v)?$",
  "^wu\\%[ndo]$" : "^wu(ndo|nd|n)?$",
  "^wv\\%[iminfo]$" : "^wv(iminfo|iminf|imin|imi|im|i)?$",
  "^x\\%[it]$" : "^x(it|i)?$",
  "^xa\\%[ll]$" : "^xa(ll|l)?$",
  "^xm\\%[ap]$" : "^xm(ap|a)?$",
  "^xmapc\\%[lear]$" : "^xmapc(lear|lea|le|l)?$",
  "^xme\\%[nu]$" : "^xme(nu|n)?$",
  "^xn\\%[oremap]$" : "^xn(oremap|orema|orem|ore|or|o)?$",
  "^xnoreme\\%[nu]$" : "^xnoreme(nu|n)?$",
  "^xu\\%[nmap]$" : "^xu(nmap|nma|nm|n)?$",
  "^xunme\\%[nu]$" : "^xunme(nu|n)?$",
  "^y\\%[ank]$" : "^y(ank|an|a)?$",
  "^z$" : "^z$",
  "^{" : "^{",
  "^|" : "^\\|",
  "^||" : "^\\|\\|",
  "^}" : "^}",
  "[Ee][-+]\\d" : "[Ee][-+]\\d",
  "^\\s*\\\\" : "^\\s*\\\\",
}

def viml_add(lst, item):
    lst.append(item)

def viml_call(func, *args):
    func(*args)

def viml_empty(obj):
    return len(obj) == 0

def viml_eqreg(s, reg):
    return re.search(pat_vim2py[reg], s, re.IGNORECASE)

def viml_eqregh(s, reg):
    return re.search(pat_vim2py[reg], s)

def viml_eqregq(s, reg):
    return re.search(pat_vim2py[reg], s, re.IGNORECASE)

def viml_escape(s, chars):
    r = ''
    for c in s:
        if c in chars:
            r += "\\" + c
        else:
            r += c
    return r

def viml_extend(obj, item):
    obj.extend(item)

def viml_insert(lst, item, idx = 0):
    lst.insert(idx, item)

def viml_join(lst, sep):
    return sep.join(lst)

def viml_keys(obj):
    return obj.keys()

def viml_len(obj):
    return len(obj)

def viml_printf(*args):
    if len(args) == 1:
        return args[0]
    else:
        return args[0] % args[1:]

def viml_range(start, end=None):
    if end is None:
        return range(start)
    else:
        return range(start, end + 1)

def viml_readfile(path):
    lines = []
    f = open(path)
    for line in f.readlines():
        lines.append(line.rstrip("\r\n"))
    f.close()
    return lines

def viml_remove(lst, idx):
    del lst[idx]

def viml_split(s, sep):
    if sep == "\\zs":
        return s
    raise Exception("NotImplemented")

def viml_str2nr(s, base=10):
    return int(s, base)

def viml_string(obj):
    return str(obj)

def viml_has_key(obj, key):
    return key in obj

NIL = []
NODE_TOPLEVEL = 1
NODE_COMMENT = 2
NODE_EXCMD = 3
NODE_FUNCTION = 4
NODE_ENDFUNCTION = 5
NODE_DELFUNCTION = 6
NODE_RETURN = 7
NODE_EXCALL = 8
NODE_LET = 9
NODE_UNLET = 10
NODE_LOCKVAR = 11
NODE_UNLOCKVAR = 12
NODE_IF = 13
NODE_ELSEIF = 14
NODE_ELSE = 15
NODE_ENDIF = 16
NODE_WHILE = 17
NODE_ENDWHILE = 18
NODE_FOR = 19
NODE_ENDFOR = 20
NODE_CONTINUE = 21
NODE_BREAK = 22
NODE_TRY = 23
NODE_CATCH = 24
NODE_FINALLY = 25
NODE_ENDTRY = 26
NODE_THROW = 27
NODE_ECHO = 28
NODE_ECHON = 29
NODE_ECHOHL = 30
NODE_ECHOMSG = 31
NODE_ECHOERR = 32
NODE_EXECUTE = 33
NODE_CONDEXP = 34
NODE_LOGOR = 35
NODE_LOGAND = 36
NODE_EQEQQ = 37
NODE_EQEQH = 38
NODE_NOTEQQ = 39
NODE_NOTEQH = 40
NODE_GTEQQ = 41
NODE_GTEQH = 42
NODE_LTEQQ = 43
NODE_LTEQH = 44
NODE_EQTILDQ = 45
NODE_EQTILDH = 46
NODE_NOTTILDQ = 47
NODE_NOTTILDH = 48
NODE_GTQ = 49
NODE_GTH = 50
NODE_LTQ = 51
NODE_LTH = 52
NODE_EQEQ = 53
NODE_NOTEQ = 54
NODE_GTEQ = 55
NODE_LTEQ = 56
NODE_EQTILD = 57
NODE_NOTTILD = 58
NODE_GT = 59
NODE_LT = 60
NODE_ISH = 61
NODE_ISQ = 62
NODE_ISNOTH = 63
NODE_ISNOTQ = 64
NODE_IS = 65
NODE_ISNOT = 66
NODE_ADD = 67
NODE_SUB = 68
NODE_CONCAT = 69
NODE_MUL = 70
NODE_DIV = 71
NODE_MOD = 72
NODE_NOT = 73
NODE_MINUS = 74
NODE_PLUS = 75
NODE_INDEX = 76
NODE_SLICE = 77
NODE_CALL = 78
NODE_DOT = 79
NODE_NUMBER = 80
NODE_STRING = 81
NODE_LIST = 82
NODE_DICT = 83
NODE_NESTING = 84
NODE_OPTION = 85
NODE_IDENTIFIER = 86
NODE_ENV = 87
NODE_REG = 88
TOKEN_EOF = 1
TOKEN_EOL = 2
TOKEN_SPACE = 3
TOKEN_NUMBER = 4
TOKEN_ISH = 5
TOKEN_ISQ = 6
TOKEN_ISNOTH = 7
TOKEN_ISNOTQ = 8
TOKEN_IS = 9
TOKEN_ISNOT = 10
TOKEN_IDENTIFIER = 11
TOKEN_EQEQQ = 12
TOKEN_EQEQH = 13
TOKEN_NOTEQQ = 14
TOKEN_NOTEQH = 15
TOKEN_GTEQQ = 16
TOKEN_GTEQH = 17
TOKEN_LTEQQ = 18
TOKEN_LTEQH = 19
TOKEN_EQTILDQ = 20
TOKEN_EQTILDH = 21
TOKEN_NOTTILDQ = 22
TOKEN_NOTTILDH = 23
TOKEN_GTQ = 24
TOKEN_GTH = 25
TOKEN_LTQ = 26
TOKEN_LTH = 27
TOKEN_OROR = 28
TOKEN_ANDAND = 29
TOKEN_EQEQ = 30
TOKEN_NOTEQ = 31
TOKEN_GTEQ = 32
TOKEN_LTEQ = 33
TOKEN_EQTILD = 34
TOKEN_NOTTILD = 35
TOKEN_GT = 36
TOKEN_LT = 37
TOKEN_PLUS = 38
TOKEN_MINUS = 39
TOKEN_DOT = 40
TOKEN_STAR = 41
TOKEN_SLASH = 42
TOKEN_PER = 43
TOKEN_NOT = 44
TOKEN_QUESTION = 45
TOKEN_COLON = 46
TOKEN_LPAR = 47
TOKEN_RPAR = 48
TOKEN_LBRA = 49
TOKEN_RBRA = 50
TOKEN_LBPAR = 51
TOKEN_RBPAR = 52
TOKEN_COMMA = 53
TOKEN_SQUOTE = 54
TOKEN_DQUOTE = 55
TOKEN_ENV = 56
TOKEN_REG = 57
TOKEN_OPTION = 58
TOKEN_EQ = 59
TOKEN_OR = 60
TOKEN_SEMICOLON = 61
TOKEN_BACKTICK = 62
class VimLParser:
    def __init__(self):
        self.find_command_cache = AttributeDict({})

    def err(self, *a000):
        pos = self.reader.getpos()
        if viml_len(a000) == 1:
            msg = a000[0]
        else:
            msg = viml_printf(*a000)
        return viml_printf("%s: line %d col %d", msg, pos.lnum, pos.col)

    def exnode(self, type):
        node = AttributeDict({"type":type})
        return node

    def blocknode(self, type):
        node = self.exnode(type)
        node.body = []
        return node

    def push_context(self, node):
        viml_insert(self.context, node)

    def pop_context(self):
        viml_remove(self.context, 0)

    def find_context(self, type):
        i = 0
        for node in self.context:
            if node.type == type:
                return i
            i += 1
        return -1

    def add_node(self, node):
        viml_add(self.context[0].body, node)

    def check_missing_endfunction(self, ends):
        if self.context[0].type == NODE_FUNCTION:
            raise Exception(self.err("VimLParser: E126: Missing :endfunction:    %s", ends))

    def check_missing_endif(self, ends):
        if self.context[0].type == NODE_IF or self.context[0].type == NODE_ELSEIF or self.context[0].type == NODE_ELSE:
            raise Exception(self.err("VimLParser: E171: Missing :endif:    %s", ends))

    def check_missing_endtry(self, ends):
        if self.context[0].type == NODE_TRY or self.context[0].type == NODE_CATCH or self.context[0].type == NODE_FINALLY:
            raise Exception(self.err("VimLParser: E600: Missing :endtry:    %s", ends))

    def check_missing_endwhile(self, ends):
        if self.context[0].type == NODE_WHILE:
            raise Exception(self.err("VimLParser: E170: Missing :endwhile:    %s", ends))

    def check_missing_endfor(self, ends):
        if self.context[0].type == NODE_FOR:
            raise Exception(self.err("VimLParser: E170: Missing :endfor:    %s", ends))

    def parse(self, reader):
        self.reader = reader
        self.context = []
        toplevel = self.blocknode(NODE_TOPLEVEL)
        self.push_context(toplevel)
        while self.reader.peek() != "<EOF>":
            self.parse_one_cmd()
        self.check_missing_endfunction("TOPLEVEL")
        self.check_missing_endif("TOPLEVEL")
        self.check_missing_endtry("TOPLEVEL")
        self.check_missing_endwhile("TOPLEVEL")
        self.check_missing_endfor("TOPLEVEL")
        self.pop_context()
        return toplevel

    def parse_one_cmd(self):
        self.ea = AttributeDict({})
        self.ea.forceit = 0
        self.ea.addr_count = 0
        self.ea.line1 = 0
        self.ea.line2 = 0
        self.ea.flags = 0
        self.ea.do_ecmd_cmd = ""
        self.ea.do_ecmd_lnum = 0
        self.ea.append = 0
        self.ea.usefilter = 0
        self.ea.amount = 0
        self.ea.regname = 0
        self.ea.regname = 0
        self.ea.force_bin = 0
        self.ea.read_edit = 0
        self.ea.force_ff = 0
        self.ea.force_enc = 0
        self.ea.bad_char = 0
        self.ea.linepos = []
        self.ea.cmdpos = []
        self.ea.argpos = []
        self.ea.cmd = AttributeDict({})
        self.ea.modifiers = []
        self.ea.range = []
        self.ea.argopt = AttributeDict({})
        self.ea.argcmd = AttributeDict({})
        if self.reader.peekn(2) == "#!":
            self.parse_hashbang()
            self.reader.get()
            return
        self.skip_white_and_colon()
        if self.reader.peekn(1) == "":
            self.reader.get()
            return
        if self.reader.peekn(1) == "\"":
            self.parse_comment()
            self.reader.get()
            return
        self.ea.linepos = self.reader.getpos()
        self.parse_command_modifiers()
        self.parse_range()
        self.parse_command()
        self.parse_trail()

# FIXME:
    def parse_command_modifiers(self):
        modifiers = []
        while 1:
            pos = self.reader.getpos()
            if viml_eqregh(self.reader.peekn(1), "\\d"):
                d = self.read_digits()
                self.skip_white()
            else:
                d = ""
            k = self.read_alpha()
            c = self.reader.peekn(1)
            self.skip_white()
            if viml_eqregh(k, "^abo\\%[veleft]$"):
                viml_add(modifiers, AttributeDict({"name":"aboveleft"}))
            elif viml_eqregh(k, "^bel\\%[owright]$"):
                viml_add(modifiers, AttributeDict({"name":"belowright"}))
            elif viml_eqregh(k, "^bro\\%[wse]$"):
                viml_add(modifiers, AttributeDict({"name":"browse"}))
            elif viml_eqregh(k, "^bo\\%[tright]$"):
                viml_add(modifiers, AttributeDict({"name":"botright"}))
            elif viml_eqregh(k, "^conf\\%[irm]$"):
                viml_add(modifiers, AttributeDict({"name":"confirm"}))
            elif viml_eqregh(k, "^kee\\%[pmarks]$"):
                viml_add(modifiers, AttributeDict({"name":"keepmarks"}))
            elif viml_eqregh(k, "^keepa\\%[lt]$"):
                viml_add(modifiers, AttributeDict({"name":"keepalt"}))
            elif viml_eqregh(k, "^keepj\\%[umps]$"):
                viml_add(modifiers, AttributeDict({"name":"keepjumps"}))
            elif viml_eqregh(k, "^hid\\%[e]$"):
                if self.ends_excmds(c):
                    break
                viml_add(modifiers, AttributeDict({"name":"hide"}))
            elif viml_eqregh(k, "^loc\\%[kmarks]$"):
                viml_add(modifiers, AttributeDict({"name":"lockmarks"}))
            elif viml_eqregh(k, "^lefta\\%[bove]$"):
                viml_add(modifiers, AttributeDict({"name":"leftabove"}))
            elif viml_eqregh(k, "^noa\\%[utocmd]$"):
                viml_add(modifiers, AttributeDict({"name":"noautocmd"}))
            elif viml_eqregh(k, "^rightb\\%[elow]$"):
                viml_add(modifiers, AttributeDict({"name":"rightbelow"}))
            elif viml_eqregh(k, "^san\\%[dbox]$"):
                viml_add(modifiers, AttributeDict({"name":"sandbox"}))
            elif viml_eqregh(k, "^sil\\%[ent]$"):
                if c == "!":
                    self.reader.get()
                    viml_add(modifiers, AttributeDict({"name":"silent", "bang":1}))
                else:
                    viml_add(modifiers, AttributeDict({"name":"silent", "bang":0}))
            elif viml_eqregh(k, "^tab$"):
                if d != "":
                    viml_add(modifiers, AttributeDict({"name":"tab", "count":viml_str2nr(d, 10)}))
                else:
                    viml_add(modifiers, AttributeDict({"name":"tab"}))
            elif viml_eqregh(k, "^to\\%[pleft]$"):
                viml_add(modifiers, AttributeDict({"name":"topleft"}))
            elif viml_eqregh(k, "^uns\\%[ilent]$"):
                viml_add(modifiers, AttributeDict({"name":"unsilent"}))
            elif viml_eqregh(k, "^vert\\%[ical]$"):
                viml_add(modifiers, AttributeDict({"name":"vertical"}))
            elif viml_eqregh(k, "^verb\\%[ose]$"):
                if d != "":
                    viml_add(modifiers, AttributeDict({"name":"verbose", "count":viml_str2nr(d, 10)}))
                else:
                    viml_add(modifiers, AttributeDict({"name":"verbose", "count":1}))
            else:
                self.reader.setpos(pos)
                break
        self.ea.modifiers = modifiers

# FIXME:
    def parse_range(self):
        tokens = []
        while 1:
            while 1:
                self.skip_white()
                c = self.reader.peekn(1)
                if c == "":
                    break
                if c == ".":
                    viml_add(tokens, self.reader.getn(1))
                elif c == "$":
                    viml_add(tokens, self.reader.getn(1))
                elif c == "'":
                    self.reader.getn(1)
                    m = self.reader.getn(1)
                    if m == "":
                        break
                    viml_add(tokens, "'" + m)
                elif c == "/":
                    self.reader.getn(1)
                    pattern, endc = self.parse_pattern(c)
                    viml_add(tokens, pattern)
                elif c == "?":
                    self.reader.getn(1)
                    pattern, endc = self.parse_pattern(c)
                    viml_add(tokens, pattern)
                elif c == "\\":
                    self.reader.getn(1)
                    m = self.reader.getn(1)
                    if m == "&" or m == "?" or m == "/":
                        viml_add(tokens, "\\" + m)
                    else:
                        raise Exception(self.err("VimLParser: E10: \\\\ should be followed by /, ? or &"))
                elif viml_eqregh(c, "\\d"):
                    viml_add(tokens, self.read_digits())
                while 1:
                    self.skip_white()
                    if self.reader.peekn(1) == "":
                        break
                    n = self.read_integer()
                    if n == "":
                        break
                    viml_add(tokens, n)
                if not viml_eqregh(self.reader.peekn(1), "[/?]"):
                    break
            if self.reader.peekn(1) == "%":
                viml_add(tokens, self.reader.getn(1))
            elif self.reader.peekn(1) == "*":
                # && &cpoptions !~ '\*'
                viml_add(tokens, self.reader.getn(1))
            if self.reader.peekn(1) == ";":
                viml_add(tokens, self.reader.getn(1))
                continue
            elif self.reader.peekn(1) == ",":
                viml_add(tokens, self.reader.getn(1))
                continue
            break
        self.ea.range = tokens

# FIXME:
    def parse_pattern(self, delimiter):
        pattern = ""
        endc = ""
        inbracket = 0
        while 1:
            c = self.reader.getn(1)
            if c == "":
                break
            if c == delimiter and inbracket == 0:
                endc = c
                break
            pattern += c
            if c == "\\":
                c = self.reader.getn(1)
                if c == "":
                    raise Exception(self.err("VimLParser: E682: Invalid search pattern or delimiter"))
                pattern += c
            elif c == "[":
                inbracket += 1
            elif c == "]":
                inbracket -= 1
        return [pattern, endc]

    def parse_command(self):
        self.skip_white_and_colon()
        if self.reader.peekn(1) == "" or self.reader.peekn(1) == "\"":
            if not viml_empty(self.ea.modifiers) or not viml_empty(self.ea.range):
                self.parse_cmd_modifier_range()
            return
        self.ea.cmdpos = self.reader.getpos()
        self.ea.cmd = self.find_command()
        if self.ea.cmd is NIL:
            self.reader.setpos(self.ea.cmdpos)
            raise Exception(self.err("VimLParser: E492: Not an editor command: %s", self.reader.peekline()))
        if self.reader.peekn(1) == "!" and not viml_eqregh(self.ea.cmd.name, "\\v^%(substitute|smagic|snomagic)$"):
            self.reader.getn(1)
            self.ea.forceit = 1
        else:
            self.ea.forceit = 0
        if not viml_eqregh(self.ea.cmd.flags, "\\<BANG\\>") and self.ea.forceit:
            raise Exception(self.err("VimLParser: E477: No ! allowed"))
        if self.ea.cmd.name != "!":
            self.skip_white()
        self.ea.argpos = self.reader.getpos()
        if viml_eqregh(self.ea.cmd.flags, "\\<ARGOPT\\>"):
            self.parse_argopt()
        if viml_eqregh(self.ea.cmd.name, "\\v^%(write|update)$"):
            if self.reader.peekn(1) == ">":
                self.reader.getn(1)
                if self.reader.peekn(1) == ">":
                    raise Exception(self.err("VimLParser: E494: Use w or w>>"))
                self.skip_white()
                self.ea.append = 1
            elif self.reader.peekn(1) == "!" and self.ea.cmd.name == "write":
                self.reader.getn(1)
                self.ea.usefilter = 1
        if self.ea.cmd.name == "read":
            if self.ea.forceit:
                self.ea.usefilter = 1
                self.ea.forceit = 0
            elif self.reader.peekn(1) == "!":
                self.reader.getn(1)
                self.ea.usefilter = 1
        if viml_eqregh(self.ea.cmd.name, "^[<>]$"):
            self.ea.amount = 1
            while self.reader.peekn(1) == self.ea.cmd.name:
                self.reader.getn(1)
                self.ea.amount += 1
            self.skip_white()
        if viml_eqregh(self.ea.cmd.flags, "\\<EDITCMD\\>") and not self.ea.usefilter:
            self.parse_argcmd()
        getattr(self, self.ea.cmd.parser)()

    def find_command(self):
        c = self.reader.peekn(1)
        if c == "k":
            self.reader.getn(1)
            name = "k"
        elif c == "s" and viml_eqregh(self.reader.peekn(5), "\\v^s%(c[^sr][^i][^p]|g|i[^mlg]|I|r[^e])"):
            self.reader.getn(1)
            name = "substitute"
        elif viml_eqregh(c, "[@*!=><&~#]"):
            self.reader.getn(1)
            name = c
        elif self.reader.peekn(2) == "py":
            name = self.read_alnum()
        else:
            pos = self.reader.getpos()
            name = self.read_alpha()
            if name != "del" and viml_eqregh(name, "\\v^d%[elete][lp]$"):
                self.reader.setpos(pos)
                name = self.reader.getn(viml_len(name) - 1)
        if viml_has_key(self.find_command_cache, name):
            return self.find_command_cache[name]
        cmd = NIL
        for x in self.builtin_commands:
            if viml_eqregh(name, x.pat):
                del cmd
                cmd = x
                break
        # FIXME: user defined command
        if (cmd is NIL or cmd.name == "Print") and viml_eqregh(name, "^[A-Z]"):
            name += self.read_alnum()
            del cmd
            cmd = AttributeDict({"name":name, "flags":"USERCMD", "parser":"parse_cmd_usercmd"})
        self.find_command_cache[name] = cmd
        return cmd

# TODO:
    def parse_hashbang(self):
        self.reader.getn(-1)

# TODO:
# ++opt=val
    def parse_argopt(self):
        while 1:
            s = self.reader.peekn(20)
            if viml_eqregh(s, "^++bin\\>"):
                self.reader.getn(5)
                self.ea.force_bin = 1
            elif viml_eqregh(s, "^++nobin\\>"):
                self.reader.getn(7)
                self.ea.force_bin = 2
            elif viml_eqregh(s, "^++edit\\>"):
                self.reader.getn(6)
                self.ea.read_edit = 1
            elif viml_eqregh(s, "^++ff=\\(dos\\|unix\\|mac\\)\\>"):
                self.reader.getn(5)
                self.ea.force_ff = self.read_alpha()
            elif viml_eqregh(s, "^++fileformat=\\(dos\\|unix\\|mac\\)\\>"):
                self.reader.getn(13)
                self.ea.force_ff = self.read_alpha()
            elif viml_eqregh(s, "^++enc=\\S"):
                self.reader.getn(6)
                self.ea.force_enc = self.readx("\\S")
            elif viml_eqregh(s, "^++encoding=\\S"):
                self.reader.getn(11)
                self.ea.force_enc = self.readx("\\S")
            elif viml_eqregh(s, "^++bad=\\(keep\\|drop\\|.\\)\\>"):
                self.reader.getn(6)
                if viml_eqregh(s, "^++bad=keep"):
                    self.ea.bad_char = self.reader.getn(4)
                elif viml_eqregh(s, "^++bad=drop"):
                    self.ea.bad_char = self.reader.getn(4)
                else:
                    self.ea.bad_char = self.reader.getn(1)
            elif viml_eqregh(s, "^++"):
                raise Exception("VimLParser: E474: Invalid Argument")
            else:
                break
            self.skip_white()

# TODO:
# +command
    def parse_argcmd(self):
        if self.reader.peekn(1) == "+":
            self.reader.getn(1)
            if self.reader.peekn(1) == " ":
                self.ea.do_ecmd_cmd = "$"
            else:
                self.ea.do_ecmd_cmd = self.read_cmdarg()

    def read_cmdarg(self):
        r = ""
        while 1:
            c = self.reader.peekn(1)
            if c == "" or viml_eqregh(c, "\\s"):
                break
            self.reader.getn(1)
            if c == "\\":
                c = self.reader.getn(1)
            r += c
        return r

    def parse_comment(self):
        c = self.reader.get()
        if c != "\"":
            raise Exception(self.err("VimLParser: unexpected character: %s", c))
        node = self.exnode(NODE_COMMENT)
        node.str = self.reader.getn(-1)
        self.add_node(node)

    def parse_trail(self):
        self.skip_white()
        c = self.reader.peek()
        if c == "<EOF>":
            # pass
            pass
        elif c == "<EOL>":
            self.reader.get()
        elif c == "|":
            self.reader.get()
        elif c == "\"":
            self.parse_comment()
            self.reader.get()
        else:
            raise Exception(self.err("VimLParser: E488: Trailing characters: %s", c))

# modifier or range only command line
    def parse_cmd_modifier_range(self):
        node = self.exnode(NODE_EXCMD)
        node.ea = self.ea
        node.str = self.reader.getstr(self.ea.linepos, self.reader.getpos())
        self.add_node(node)

# TODO:
    def parse_cmd_common(self):
        if viml_eqregh(self.ea.cmd.flags, "\\<TRLBAR\\>") and not self.ea.usefilter:
            end = self.separate_nextcmd()
        elif viml_eqregh(self.ea.cmd.name, "^\\(!\\|global\\|vglobal\\)$") or self.ea.usefilter:
            while 1:
                end = self.reader.getpos()
                if self.reader.getn(1) == "":
                    break
        else:
            while 1:
                end = self.reader.getpos()
                if self.reader.getn(1) == "":
                    break
        node = self.exnode(NODE_EXCMD)
        node.ea = self.ea
        node.str = self.reader.getstr(self.ea.linepos, end)
        self.add_node(node)

    def separate_nextcmd(self):
        if viml_eqregh(self.ea.cmd.name, "^\\(vimgrep\\|vimgrepadd\\|lvimgrep\\|lvimgrepadd\\)$"):
            self.skip_vimgrep_pat()
        pc = ""
        end = self.reader.getpos()
        nospend = end
        while 1:
            end = self.reader.getpos()
            if not viml_eqregh(pc, "\\s"):
                nospend = end
            c = self.reader.peek()
            if c == "<EOF>" or c == "<EOL>":
                break
            elif c == "\<C-V>":
                self.reader.get()
                end = self.reader.getpos()
                nospend = self.reader.getpos()
                c = self.reader.peek()
                if c == "<EOF>" or c == "<EOL>":
                    break
                self.reader.get()
            elif self.reader.peekn(2) == "`=" and viml_eqregh(self.ea.cmd.flags, "\\<\\(XFILE\\|FILES\\|FILE1\\)\\>"):
                self.reader.getn(2)
                self.parse_expr()
                c = self.reader.getn(1)
                if c != "`":
                    raise Exception(self.err("VimLParser: unexpected character: %s", c))
            elif c == "|" or c == "\n" or (c == "\"" and not viml_eqregh(self.ea.cmd.flags, "\\<NOTRLCOM\\>") and ((self.ea.cmd.name != "@" and self.ea.cmd.name != "*") or self.reader.getpos() != self.ea.argpos) and (self.ea.cmd.name != "redir" or self.reader.getpos().i != self.ea.argpos.i + 1 or pc != "@")):
                has_cpo_bar = 0
                # &cpoptions =~ 'b'
                if (not has_cpo_bar or not viml_eqregh(self.ea.cmd.flags, "\\<USECTRLV\\>")) and pc == "\\":
                    self.reader.get()
                else:
                    break
            else:
                self.reader.get()
            pc = c
        if not viml_eqregh(self.ea.cmd.flags, "\\<NOTRLCOM\\>"):
            end = nospend
        return end

# FIXME
    def skip_vimgrep_pat(self):
        if self.reader.peekn(1) == "":
            # pass
            pass
        elif self.isidc(self.reader.peekn(1)):
            # :vimgrep pattern fname
            self.readx("\\S")
        else:
            # :vimgrep /pattern/[g][j] fname
            c = self.reader.getn(1)
            pattern, endc = self.parse_pattern(c)
            if c != endc:
                return
            while viml_eqregh(self.reader.peekn(1), "[gj]"):
                self.reader.getn(1)

    def parse_cmd_append(self):
        self.reader.setpos(self.ea.linepos)
        cmdline = self.reader.readline()
        lines = [cmdline]
        m = "."
        while 1:
            if self.reader.peek() == "<EOF>":
                break
            line = self.reader.getn(-1)
            viml_add(lines, line)
            if line == m:
                break
            self.reader.get()
        node = self.exnode(NODE_EXCMD)
        node.ea = self.ea
        node.str = viml_join(lines, "\n")
        self.add_node(node)

    def parse_cmd_insert(self):
        return self.parse_cmd_append()

    def parse_cmd_loadkeymap(self):
        self.reader.setpos(self.ea.linepos)
        cmdline = self.reader.readline()
        lines = [cmdline]
        while 1:
            if self.reader.peek() == "<EOF>":
                break
            line = self.reader.readline()
            viml_add(lines, line)
        node = self.exnode(NODE_EXCMD)
        node.ea = self.ea
        node.str = viml_join(lines, "\n")
        self.add_node(node)

    def parse_cmd_lua(self):
        self.skip_white()
        if self.reader.peekn(2) == "<<":
            self.reader.getn(2)
            self.skip_white()
            m = self.reader.readline()
            if m == "":
                m = "."
            self.reader.setpos(self.ea.linepos)
            cmdline = self.reader.getn(-1)
            lines = [cmdline]
            self.reader.get()
            while 1:
                if self.reader.peek() == "<EOF>":
                    break
                line = self.reader.getn(-1)
                viml_add(lines, line)
                if line == m:
                    break
                self.reader.get()
        else:
            self.reader.setpos(self.ea.linepos)
            cmdline = self.reader.getn(-1)
            lines = [cmdline]
        node = self.exnode(NODE_EXCMD)
        node.ea = self.ea
        node.str = viml_join(lines, "\n")
        self.add_node(node)

    def parse_cmd_mzscheme(self):
        return self.parse_cmd_lua()

    def parse_cmd_perl(self):
        return self.parse_cmd_lua()

    def parse_cmd_python(self):
        return self.parse_cmd_lua()

    def parse_cmd_python3(self):
        return self.parse_cmd_lua()

    def parse_cmd_ruby(self):
        return self.parse_cmd_lua()

    def parse_cmd_tcl(self):
        return self.parse_cmd_lua()

    def parse_cmd_finish(self):
        self.parse_cmd_common()
        if self.context[0].type == NODE_TOPLEVEL:
            while self.reader.peek() != "<EOF>":
                self.reader.get()

# FIXME
    def parse_cmd_usercmd(self):
        return self.parse_cmd_common()

    def parse_cmd_function(self):
        pos = self.reader.getpos()
        self.skip_white()
        # :function
        if self.ends_excmds(self.reader.peek()):
            self.reader.setpos(pos)
            return self.parse_cmd_common()
        # :function /pattern
        if self.reader.peekn(1) == "/":
            self.reader.setpos(pos)
            return self.parse_cmd_common()
        name = self.parse_lvalue()
        self.skip_white()
        # :function {name}
        if self.reader.peekn(1) != "(":
            self.reader.setpos(pos)
            return self.parse_cmd_common()
        # :function[!] {name}([arguments]) [range] [abort] [dict]
        node = self.blocknode(NODE_FUNCTION)
        node.ea = self.ea
        node.name = name
        node.args = []
        node.attr = AttributeDict({"range":0, "abort":0, "dict":0})
        node.endfunction = NIL
        self.reader.getn(1)
        c = self.reader.peekn(1)
        if c == ")":
            self.reader.getn(1)
        else:
            while 1:
                self.skip_white()
                if viml_eqregh(self.reader.peekn(1), "\\h"):
                    arg = self.readx("\\w")
                    viml_add(node.args, arg)
                    self.skip_white()
                    c = self.reader.peekn(1)
                    if c == ",":
                        self.reader.getn(1)
                        continue
                    elif c == ")":
                        self.reader.getn(1)
                        break
                    else:
                        raise Exception(self.err("VimLParser: unexpected characters: %s", c))
                elif self.reader.peekn(3) == "...":
                    self.reader.getn(3)
                    viml_add(node.args, "...")
                    self.skip_white()
                    c = self.reader.peekn(1)
                    if c == ")":
                        self.reader.getn(1)
                        break
                    else:
                        raise Exception(self.err("VimLParser: unexpected characters: %s", c))
                else:
                    raise Exception(self.err("VimLParser: unexpected characters: %s", c))
        while 1:
            self.skip_white()
            key = self.read_alpha()
            if key == "":
                break
            elif key == "range":
                node.attr.range = 1
            elif key == "abort":
                node.attr.abort = 1
            elif key == "dict":
                node.attr.dict = 1
            else:
                raise Exception(self.err("VimLParser: unexpected token: %s", key))
        self.add_node(node)
        self.push_context(node)

    def parse_cmd_endfunction(self):
        self.check_missing_endif("ENDFUNCTION")
        self.check_missing_endtry("ENDFUNCTION")
        self.check_missing_endwhile("ENDFUNCTION")
        self.check_missing_endfor("ENDFUNCTION")
        if self.context[0].type != NODE_FUNCTION:
            raise Exception(self.err("VimLParser: E193: :endfunction not inside a function"))
        self.reader.getn(-1)
        node = self.exnode(NODE_ENDFUNCTION)
        node.ea = self.ea
        self.context[0].endfunction = node
        self.pop_context()

    def parse_cmd_delfunction(self):
        node = self.exnode(NODE_DELFUNCTION)
        node.ea = self.ea
        node.name = self.parse_lvalue()
        self.add_node(node)

    def parse_cmd_return(self):
        if self.find_context(NODE_FUNCTION) == -1:
            raise Exception(self.err("VimLParser: E133: :return not inside a function"))
        node = self.exnode(NODE_RETURN)
        node.ea = self.ea
        node.arg = NIL
        self.skip_white()
        c = self.reader.peek()
        if not self.ends_excmds(c):
            node.arg = self.parse_expr()
        self.add_node(node)

    def parse_cmd_call(self):
        node = self.exnode(NODE_EXCALL)
        node.ea = self.ea
        node.expr = NIL
        self.skip_white()
        c = self.reader.peek()
        if self.ends_excmds(c):
            raise Exception(self.err("VimLParser: call error: %s", c))
        node.expr = self.parse_expr()
        if node.expr.type != NODE_CALL:
            raise Exception(self.err("VimLParser: call error: %s", node.expr.type))
        self.add_node(node)

    def parse_cmd_let(self):
        pos = self.reader.getpos()
        self.skip_white()
        # :let
        if self.ends_excmds(self.reader.peek()):
            self.reader.setpos(pos)
            return self.parse_cmd_common()
        lhs = self.parse_letlhs()
        self.skip_white()
        s1 = self.reader.peekn(1)
        s2 = self.reader.peekn(2)
        # :let {var-name} ..
        if self.ends_excmds(s1) or (s2 != "+=" and s2 != "-=" and s2 != ".=" and s1 != "="):
            self.reader.setpos(pos)
            return self.parse_cmd_common()
        # :let lhs op rhs
        node = self.exnode(NODE_LET)
        node.ea = self.ea
        node.op = ""
        node.lhs = lhs
        node.rhs = NIL
        if s2 == "+=" or s2 == "-=" or s2 == ".=":
            self.reader.getn(2)
            node.op = s2
        elif s1 == "=":
            self.reader.getn(1)
            node.op = s1
        else:
            raise Exception("NOT REACHED")
        node.rhs = self.parse_expr()
        self.add_node(node)

    def parse_cmd_unlet(self):
        node = self.exnode(NODE_UNLET)
        node.ea = self.ea
        node.args = self.parse_lvaluelist()
        self.add_node(node)

    def parse_cmd_lockvar(self):
        node = self.exnode(NODE_LOCKVAR)
        node.ea = self.ea
        node.depth = 2
        node.args = []
        self.skip_white()
        if viml_eqregh(self.reader.peekn(1), "\\d"):
            node.depth = viml_str2nr(self.read_digits(), 10)
        node.args = self.parse_lvaluelist()
        self.add_node(node)

    def parse_cmd_unlockvar(self):
        node = self.exnode(NODE_UNLOCKVAR)
        node.ea = self.ea
        node.depth = 2
        node.args = []
        self.skip_white()
        if viml_eqregh(self.reader.peekn(1), "\\d"):
            node.depth = viml_str2nr(self.read_digits(), 10)
        node.args = self.parse_lvaluelist()
        self.add_node(node)

    def parse_cmd_if(self):
        node = self.blocknode(NODE_IF)
        node.ea = self.ea
        node.cond = self.parse_expr()
        node.elseif = []
        node._else = NIL
        node.endif = NIL
        self.add_node(node)
        self.push_context(node)

    def parse_cmd_elseif(self):
        if self.context[0].type != NODE_IF and self.context[0].type != NODE_ELSEIF:
            raise Exception(self.err("VimLParser: E582: :elseif without :if"))
        if self.context[0].type != NODE_IF:
            self.pop_context()
        node = self.blocknode(NODE_ELSEIF)
        node.ea = self.ea
        node.cond = self.parse_expr()
        viml_add(self.context[0].elseif, node)
        self.push_context(node)

    def parse_cmd_else(self):
        if self.context[0].type != NODE_IF and self.context[0].type != NODE_ELSEIF:
            raise Exception(self.err("VimLParser: E581: :else without :if"))
        if self.context[0].type != NODE_IF:
            self.pop_context()
        node = self.blocknode(NODE_ELSE)
        node.ea = self.ea
        self.context[0]._else = node
        self.push_context(node)

    def parse_cmd_endif(self):
        if self.context[0].type != NODE_IF and self.context[0].type != NODE_ELSEIF and self.context[0].type != NODE_ELSE:
            raise Exception(self.err("VimLParser: E580: :endif without :if"))
        if self.context[0].type != NODE_IF:
            self.pop_context()
        node = self.exnode(NODE_ENDIF)
        node.ea = self.ea
        self.context[0].endif = node
        self.pop_context()

    def parse_cmd_while(self):
        node = self.blocknode(NODE_WHILE)
        node.ea = self.ea
        node.cond = self.parse_expr()
        node.endwhile = NIL
        self.add_node(node)
        self.push_context(node)

    def parse_cmd_endwhile(self):
        if self.context[0].type != NODE_WHILE:
            raise Exception(self.err("VimLParser: E588: :endwhile without :while"))
        node = self.exnode(NODE_ENDWHILE)
        node.ea = self.ea
        self.context[0].endwhile = node
        self.pop_context()

    def parse_cmd_for(self):
        node = self.blocknode(NODE_FOR)
        node.ea = self.ea
        node.lhs = NIL
        node.rhs = NIL
        node.endfor = NIL
        node.lhs = self.parse_letlhs()
        self.skip_white()
        if self.read_alpha() != "in":
            raise Exception(self.err("VimLParser: Missing \"in\" after :for"))
        node.rhs = self.parse_expr()
        self.add_node(node)
        self.push_context(node)

    def parse_cmd_endfor(self):
        if self.context[0].type != NODE_FOR:
            raise Exception(self.err("VimLParser: E588: :endfor without :for"))
        node = self.exnode(NODE_ENDFOR)
        node.ea = self.ea
        self.context[0].endfor = node
        self.pop_context()

    def parse_cmd_continue(self):
        if self.find_context(NODE_WHILE) == -1 and self.find_context(NODE_FOR) == -1:
            raise Exception(self.err("VimLParser: E586: :continue without :while or :for"))
        node = self.exnode(NODE_CONTINUE)
        node.ea = self.ea
        self.add_node(node)

    def parse_cmd_break(self):
        if self.find_context(NODE_WHILE) == -1 and self.find_context(NODE_FOR) == -1:
            raise Exception(self.err("VimLParser: E587: :break without :while or :for"))
        node = self.exnode(NODE_BREAK)
        node.ea = self.ea
        self.add_node(node)

    def parse_cmd_try(self):
        node = self.blocknode(NODE_TRY)
        node.ea = self.ea
        node.catch = []
        node._finally = NIL
        node.endtry = NIL
        self.add_node(node)
        self.push_context(node)

    def parse_cmd_catch(self):
        if self.context[0].type == NODE_FINALLY:
            raise Exception(self.err("VimLParser: E604: :catch after :finally"))
        elif self.context[0].type != NODE_TRY and self.context[0].type != NODE_CATCH:
            raise Exception(self.err("VimLParser: E603: :catch without :try"))
        if self.context[0].type != NODE_TRY:
            self.pop_context()
        node = self.blocknode(NODE_CATCH)
        node.ea = self.ea
        node.pattern = NIL
        self.skip_white()
        if not self.ends_excmds(self.reader.peek()):
            node.pattern, endc = self.parse_pattern(self.reader.get())
        viml_add(self.context[0].catch, node)
        self.push_context(node)

    def parse_cmd_finally(self):
        if self.context[0].type != NODE_TRY and self.context[0].type != NODE_CATCH:
            raise Exception(self.err("VimLParser: E606: :finally without :try"))
        if self.context[0].type != NODE_TRY:
            self.pop_context()
        node = self.blocknode(NODE_FINALLY)
        node.ea = self.ea
        self.context[0]._finally = node
        self.push_context(node)

    def parse_cmd_endtry(self):
        if self.context[0].type != NODE_TRY and self.context[0].type != NODE_CATCH and self.context[0].type != NODE_FINALLY:
            raise Exception(self.err("VimLParser: E602: :endtry without :try"))
        if self.context[0].type != NODE_TRY:
            self.pop_context()
        node = self.exnode(NODE_ENDTRY)
        node.ea = self.ea
        self.context[0].endtry = node
        self.pop_context()

    def parse_cmd_throw(self):
        node = self.exnode(NODE_THROW)
        node.ea = self.ea
        node.arg = self.parse_expr()
        self.add_node(node)

    def parse_cmd_echo(self):
        node = self.exnode(NODE_ECHO)
        node.ea = self.ea
        node.args = self.parse_exprlist()
        self.add_node(node)

    def parse_cmd_echon(self):
        node = self.exnode(NODE_ECHON)
        node.ea = self.ea
        node.args = self.parse_exprlist()
        self.add_node(node)

    def parse_cmd_echohl(self):
        node = self.exnode(NODE_ECHOHL)
        node.ea = self.ea
        node.name = ""
        while not self.ends_excmds(self.reader.peek()):
            node.name += self.reader.get()
        self.add_node(node)

    def parse_cmd_echomsg(self):
        node = self.exnode(NODE_ECHOMSG)
        node.ea = self.ea
        node.args = self.parse_exprlist()
        self.add_node(node)

    def parse_cmd_echoerr(self):
        node = self.exnode(NODE_ECHOERR)
        node.ea = self.ea
        node.args = self.parse_exprlist()
        self.add_node(node)

    def parse_cmd_execute(self):
        node = self.exnode(NODE_EXECUTE)
        node.ea = self.ea
        node.args = self.parse_exprlist()
        self.add_node(node)

    def parse_expr(self):
        return ExprParser(ExprTokenizer(self.reader)).parse()

    def parse_exprlist(self):
        args = []
        while 1:
            self.skip_white()
            c = self.reader.peek()
            if c != "\"" and self.ends_excmds(c):
                break
            node = self.parse_expr()
            viml_add(args, node)
        return args

# FIXME:
    def parse_lvalue(self):
        p = LvalueParser(ExprTokenizer(self.reader))
        node = p.parse()
        if node.type == NODE_IDENTIFIER or node.type == NODE_INDEX or node.type == NODE_DOT or node.type == NODE_OPTION or node.type == NODE_ENV or node.type == NODE_REG:
            return node
        raise Exception(self.err("VimLParser: lvalue error: %s", node.value))

    def parse_lvaluelist(self):
        args = []
        node = self.parse_expr()
        viml_add(args, node)
        while 1:
            self.skip_white()
            if self.ends_excmds(self.reader.peek()):
                break
            node = self.parse_lvalue()
            viml_add(args, node)
        return args

# FIXME:
    def parse_letlhs(self):
        values = AttributeDict({"args":[], "rest":NIL})
        tokenizer = ExprTokenizer(self.reader)
        if tokenizer.peek().type == TOKEN_LBRA:
            tokenizer.get()
            while 1:
                node = self.parse_lvalue()
                viml_add(values.args, node)
                if tokenizer.peek().type == TOKEN_RBRA:
                    tokenizer.get()
                    break
                elif tokenizer.peek().type == TOKEN_COMMA:
                    tokenizer.get()
                    continue
                elif tokenizer.peek().type == TOKEN_SEMICOLON:
                    tokenizer.get()
                    node = self.parse_lvalue()
                    values.rest = node
                    token = tokenizer.peek()
                    if token.type == TOKEN_RBRA:
                        tokenizer.get()
                        break
                    else:
                        raise Exception(self.err("VimLParser: E475 Invalid argument: %s", token.value))
                else:
                    raise Exception(self.err("VimLParser: E475 Invalid argument: %s", token.value))
        else:
            node = self.parse_lvalue()
            viml_add(values.args, node)
        return values

    def readx(self, pat):
        r = ""
        while viml_eqregh(self.reader.peekn(1), pat):
            r += self.reader.getn(1)
        return r

    def read_alpha(self):
        return self.readx("\\a")

    def read_digits(self):
        return self.readx("\\d")

    def read_integer(self):
        if viml_eqregh(self.reader.peekn(1), "[-+]"):
            c = self.reader.getn(1)
        else:
            c = ""
        return c + self.read_digits()

    def read_alnum(self):
        return self.readx("[0-9a-zA-Z]")

    def skip_white(self):
        self.readx("\\s")

    def skip_white_and_colon(self):
        self.readx(":\\|\\s")

    def ends_excmds(self, c):
        return c == "" or c == "|" or c == "\"" or c == "<EOF>" or c == "<EOL>"

# FIXME:
    def isidc(self, c):
        return viml_eqregh(c, "[0-9A-Za-z_]")

VimLParser.builtin_commands = [AttributeDict({"name":"append", "pat":"^a\\%[ppend]$", "flags":"BANG|RANGE|ZEROR|TRLBAR|CMDWIN|MODIFY", "parser":"parse_cmd_append"}), AttributeDict({"name":"abbreviate", "pat":"^ab\\%[breviate]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"abclear", "pat":"^abc\\%[lear]$", "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"aboveleft", "pat":"^abo\\%[veleft]$", "flags":"NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"all", "pat":"^al\\%[l]$", "flags":"BANG|RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"amenu", "pat":"^am\\%[enu]$", "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"anoremenu", "pat":"^an\\%[oremenu]$", "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"args", "pat":"^ar\\%[gs]$", "flags":"BANG|FILES|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"argadd", "pat":"^arga\\%[dd]$", "flags":"BANG|NEEDARG|RANGE|NOTADR|ZEROR|FILES|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"argdelete", "pat":"^argd\\%[elete]$", "flags":"BANG|RANGE|NOTADR|FILES|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"argedit", "pat":"^arge\\%[dit]$", "flags":"BANG|NEEDARG|RANGE|NOTADR|FILE1|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"argdo", "pat":"^argdo$", "flags":"BANG|NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"argglobal", "pat":"^argg\\%[lobal]$", "flags":"BANG|FILES|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"arglocal", "pat":"^argl\\%[ocal]$", "flags":"BANG|FILES|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"argument", "pat":"^argu\\%[ment]$", "flags":"BANG|RANGE|NOTADR|COUNT|EXTRA|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"ascii", "pat":"^as\\%[cii]$", "flags":"TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"autocmd", "pat":"^au\\%[tocmd]$", "flags":"BANG|EXTRA|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"augroup", "pat":"^aug\\%[roup]$", "flags":"BANG|WORD1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"aunmenu", "pat":"^aun\\%[menu]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"buffer", "pat":"^b\\%[uffer]$", "flags":"BANG|RANGE|NOTADR|BUFNAME|BUFUNL|COUNT|EXTRA|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"bNext", "pat":"^bN\\%[ext]$", "flags":"BANG|RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"ball", "pat":"^ba\\%[ll]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"badd", "pat":"^bad\\%[d]$", "flags":"NEEDARG|FILE1|EDITCMD|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"bdelete", "pat":"^bd\\%[elete]$", "flags":"BANG|RANGE|NOTADR|BUFNAME|COUNT|EXTRA|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"behave", "pat":"^be\\%[have]$", "flags":"NEEDARG|WORD1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"belowright", "pat":"^bel\\%[owright]$", "flags":"NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"bfirst", "pat":"^bf\\%[irst]$", "flags":"BANG|RANGE|NOTADR|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"blast", "pat":"^bl\\%[ast]$", "flags":"BANG|RANGE|NOTADR|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"bmodified", "pat":"^bm\\%[odified]$", "flags":"BANG|RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"bnext", "pat":"^bn\\%[ext]$", "flags":"BANG|RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"botright", "pat":"^bo\\%[tright]$", "flags":"NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"bprevious", "pat":"^bp\\%[revious]$", "flags":"BANG|RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"brewind", "pat":"^br\\%[ewind]$", "flags":"BANG|RANGE|NOTADR|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"break", "pat":"^brea\\%[k]$", "flags":"TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_break"}), AttributeDict({"name":"breakadd", "pat":"^breaka\\%[dd]$", "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"breakdel", "pat":"^breakd\\%[el]$", "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"breaklist", "pat":"^breakl\\%[ist]$", "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"browse", "pat":"^bro\\%[wse]$", "flags":"NEEDARG|EXTRA|NOTRLCOM|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"bufdo", "pat":"^bufdo$", "flags":"BANG|NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"buffers", "pat":"^buffers$", "flags":"BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"bunload", "pat":"^bun\\%[load]$", "flags":"BANG|RANGE|NOTADR|BUFNAME|COUNT|EXTRA|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"bwipeout", "pat":"^bw\\%[ipeout]$", "flags":"BANG|RANGE|NOTADR|BUFNAME|BUFUNL|COUNT|EXTRA|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"change", "pat":"^c\\%[hange]$", "flags":"BANG|WHOLEFOLD|RANGE|COUNT|TRLBAR|CMDWIN|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"cNext", "pat":"^cN\\%[ext]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"cNfile", "pat":"^cNf\\%[ile]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"cabbrev", "pat":"^ca\\%[bbrev]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"cabclear", "pat":"^cabc\\%[lear]$", "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"caddbuffer", "pat":"^caddb\\%[uffer]$", "flags":"RANGE|NOTADR|WORD1|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"caddexpr", "pat":"^cad\\%[dexpr]$", "flags":"NEEDARG|WORD1|NOTRLCOM|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"caddfile", "pat":"^caddf\\%[ile]$", "flags":"TRLBAR|FILE1", "parser":"parse_cmd_common"}), AttributeDict({"name":"call", "pat":"^cal\\%[l]$", "flags":"RANGE|NEEDARG|EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_call"}), AttributeDict({"name":"catch", "pat":"^cat\\%[ch]$", "flags":"EXTRA|SBOXOK|CMDWIN", "parser":"parse_cmd_catch"}), AttributeDict({"name":"cbuffer", "pat":"^cb\\%[uffer]$", "flags":"BANG|RANGE|NOTADR|WORD1|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"cc", "pat":"^cc$", "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"cclose", "pat":"^ccl\\%[ose]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"cd", "pat":"^cd$", "flags":"BANG|FILE1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"center", "pat":"^ce\\%[nter]$", "flags":"TRLBAR|RANGE|WHOLEFOLD|EXTRA|CMDWIN|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"cexpr", "pat":"^cex\\%[pr]$", "flags":"NEEDARG|WORD1|NOTRLCOM|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"cfile", "pat":"^cf\\%[ile]$", "flags":"TRLBAR|FILE1|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"cfirst", "pat":"^cfir\\%[st]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"cgetbuffer", "pat":"^cgetb\\%[uffer]$", "flags":"RANGE|NOTADR|WORD1|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"cgetexpr", "pat":"^cgete\\%[xpr]$", "flags":"NEEDARG|WORD1|NOTRLCOM|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"cgetfile", "pat":"^cg\\%[etfile]$", "flags":"TRLBAR|FILE1", "parser":"parse_cmd_common"}), AttributeDict({"name":"changes", "pat":"^changes$", "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"chdir", "pat":"^chd\\%[ir]$", "flags":"BANG|FILE1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"checkpath", "pat":"^che\\%[ckpath]$", "flags":"TRLBAR|BANG|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"checktime", "pat":"^checkt\\%[ime]$", "flags":"RANGE|NOTADR|BUFNAME|COUNT|EXTRA|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"clist", "pat":"^cl\\%[ist]$", "flags":"BANG|EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"clast", "pat":"^cla\\%[st]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"close", "pat":"^clo\\%[se]$", "flags":"BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"cmap", "pat":"^cm\\%[ap]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"cmapclear", "pat":"^cmapc\\%[lear]$", "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"cmenu", "pat":"^cme\\%[nu]$", "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"cnext", "pat":"^cn\\%[ext]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"cnewer", "pat":"^cnew\\%[er]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"cnfile", "pat":"^cnf\\%[ile]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"cnoremap", "pat":"^cno\\%[remap]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"cnoreabbrev", "pat":"^cnorea\\%[bbrev]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"cnoremenu", "pat":"^cnoreme\\%[nu]$", "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"copy", "pat":"^co\\%[py]$", "flags":"RANGE|WHOLEFOLD|EXTRA|TRLBAR|CMDWIN|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"colder", "pat":"^col\\%[der]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"colorscheme", "pat":"^colo\\%[rscheme]$", "flags":"WORD1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"command", "pat":"^com\\%[mand]$", "flags":"EXTRA|BANG|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"comclear", "pat":"^comc\\%[lear]$", "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"compiler", "pat":"^comp\\%[iler]$", "flags":"BANG|TRLBAR|WORD1|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"continue", "pat":"^con\\%[tinue]$", "flags":"TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_continue"}), AttributeDict({"name":"confirm", "pat":"^conf\\%[irm]$", "flags":"NEEDARG|EXTRA|NOTRLCOM|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"copen", "pat":"^cope\\%[n]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"cprevious", "pat":"^cp\\%[revious]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"cpfile", "pat":"^cpf\\%[ile]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"cquit", "pat":"^cq\\%[uit]$", "flags":"TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"crewind", "pat":"^cr\\%[ewind]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"cscope", "pat":"^cs\\%[cope]$", "flags":"EXTRA|NOTRLCOM|XFILE", "parser":"parse_cmd_common"}), AttributeDict({"name":"cstag", "pat":"^cst\\%[ag]$", "flags":"BANG|TRLBAR|WORD1", "parser":"parse_cmd_common"}), AttributeDict({"name":"cunmap", "pat":"^cu\\%[nmap]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"cunabbrev", "pat":"^cuna\\%[bbrev]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"cunmenu", "pat":"^cunme\\%[nu]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"cwindow", "pat":"^cw\\%[indow]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"delete", "pat":"^d\\%[elete]$", "flags":"RANGE|WHOLEFOLD|REGSTR|COUNT|TRLBAR|CMDWIN|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"delmarks", "pat":"^delm\\%[arks]$", "flags":"BANG|EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"debug", "pat":"^deb\\%[ug]$", "flags":"NEEDARG|EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"debuggreedy", "pat":"^debugg\\%[reedy]$", "flags":"RANGE|NOTADR|ZEROR|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"delcommand", "pat":"^delc\\%[ommand]$", "flags":"NEEDARG|WORD1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"delfunction", "pat":"^delf\\%[unction]$", "flags":"NEEDARG|WORD1|CMDWIN", "parser":"parse_cmd_delfunction"}), AttributeDict({"name":"diffupdate", "pat":"^dif\\%[fupdate]$", "flags":"BANG|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"diffget", "pat":"^diffg\\%[et]$", "flags":"RANGE|EXTRA|TRLBAR|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"diffoff", "pat":"^diffo\\%[ff]$", "flags":"BANG|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"diffpatch", "pat":"^diffp\\%[atch]$", "flags":"EXTRA|FILE1|TRLBAR|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"diffput", "pat":"^diffpu\\%[t]$", "flags":"RANGE|EXTRA|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"diffsplit", "pat":"^diffs\\%[plit]$", "flags":"EXTRA|FILE1|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"diffthis", "pat":"^diffthis$", "flags":"TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"digraphs", "pat":"^dig\\%[raphs]$", "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"display", "pat":"^di\\%[splay]$", "flags":"EXTRA|NOTRLCOM|TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"djump", "pat":"^dj\\%[ump]$", "flags":"BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA", "parser":"parse_cmd_common"}), AttributeDict({"name":"dlist", "pat":"^dl\\%[ist]$", "flags":"BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"doautocmd", "pat":"^do\\%[autocmd]$", "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"doautoall", "pat":"^doautoa\\%[ll]$", "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"drop", "pat":"^dr\\%[op]$", "flags":"FILES|EDITCMD|NEEDARG|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"dsearch", "pat":"^ds\\%[earch]$", "flags":"BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"dsplit", "pat":"^dsp\\%[lit]$", "flags":"BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA", "parser":"parse_cmd_common"}), AttributeDict({"name":"edit", "pat":"^e\\%[dit]$", "flags":"BANG|FILE1|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"earlier", "pat":"^ea\\%[rlier]$", "flags":"TRLBAR|EXTRA|NOSPC|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"echo", "pat":"^ec\\%[ho]$", "flags":"EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_echo"}), AttributeDict({"name":"echoerr", "pat":"^echoe\\%[rr]$", "flags":"EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_echoerr"}), AttributeDict({"name":"echohl", "pat":"^echoh\\%[l]$", "flags":"EXTRA|TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_echohl"}), AttributeDict({"name":"echomsg", "pat":"^echom\\%[sg]$", "flags":"EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_echomsg"}), AttributeDict({"name":"echon", "pat":"^echon$", "flags":"EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_echon"}), AttributeDict({"name":"else", "pat":"^el\\%[se]$", "flags":"TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_else"}), AttributeDict({"name":"elseif", "pat":"^elsei\\%[f]$", "flags":"EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_elseif"}), AttributeDict({"name":"emenu", "pat":"^em\\%[enu]$", "flags":"NEEDARG|EXTRA|TRLBAR|NOTRLCOM|RANGE|NOTADR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"endif", "pat":"^en\\%[dif]$", "flags":"TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_endif"}), AttributeDict({"name":"endfor", "pat":"^endfo\\%[r]$", "flags":"TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_endfor"}), AttributeDict({"name":"endfunction", "pat":"^endf\\%[unction]$", "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_endfunction"}), AttributeDict({"name":"endtry", "pat":"^endt\\%[ry]$", "flags":"TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_endtry"}), AttributeDict({"name":"endwhile", "pat":"^endw\\%[hile]$", "flags":"TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_endwhile"}), AttributeDict({"name":"enew", "pat":"^ene\\%[w]$", "flags":"BANG|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"ex", "pat":"^ex$", "flags":"BANG|FILE1|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"execute", "pat":"^exe\\%[cute]$", "flags":"EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_execute"}), AttributeDict({"name":"exit", "pat":"^exi\\%[t]$", "flags":"RANGE|WHOLEFOLD|BANG|FILE1|ARGOPT|DFLALL|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"exusage", "pat":"^exu\\%[sage]$", "flags":"TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"file", "pat":"^f\\%[ile]$", "flags":"RANGE|NOTADR|ZEROR|BANG|FILE1|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"files", "pat":"^files$", "flags":"BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"filetype", "pat":"^filet\\%[ype]$", "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"find", "pat":"^fin\\%[d]$", "flags":"RANGE|NOTADR|BANG|FILE1|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"finally", "pat":"^fina\\%[lly]$", "flags":"TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_finally"}), AttributeDict({"name":"finish", "pat":"^fini\\%[sh]$", "flags":"TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_finish"}), AttributeDict({"name":"first", "pat":"^fir\\%[st]$", "flags":"EXTRA|BANG|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"fixdel", "pat":"^fix\\%[del]$", "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"fold", "pat":"^fo\\%[ld]$", "flags":"RANGE|WHOLEFOLD|TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"foldclose", "pat":"^foldc\\%[lose]$", "flags":"RANGE|BANG|WHOLEFOLD|TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"folddoopen", "pat":"^foldd\\%[oopen]$", "flags":"RANGE|DFLALL|NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"folddoclosed", "pat":"^folddoc\\%[losed]$", "flags":"RANGE|DFLALL|NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"foldopen", "pat":"^foldo\\%[pen]$", "flags":"RANGE|BANG|WHOLEFOLD|TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"for", "pat":"^for$", "flags":"EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_for"}), AttributeDict({"name":"function", "pat":"^fu\\%[nction]$", "flags":"EXTRA|BANG|CMDWIN", "parser":"parse_cmd_function"}), AttributeDict({"name":"global", "pat":"^g\\%[lobal]$", "flags":"RANGE|WHOLEFOLD|BANG|EXTRA|DFLALL|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"goto", "pat":"^go\\%[to]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"grep", "pat":"^gr\\%[ep]$", "flags":"RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE", "parser":"parse_cmd_common"}), AttributeDict({"name":"grepadd", "pat":"^grepa\\%[dd]$", "flags":"RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE", "parser":"parse_cmd_common"}), AttributeDict({"name":"gui", "pat":"^gu\\%[i]$", "flags":"BANG|FILES|EDITCMD|ARGOPT|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"gvim", "pat":"^gv\\%[im]$", "flags":"BANG|FILES|EDITCMD|ARGOPT|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"hardcopy", "pat":"^ha\\%[rdcopy]$", "flags":"RANGE|COUNT|EXTRA|TRLBAR|DFLALL|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"help", "pat":"^h\\%[elp]$", "flags":"BANG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"helpfind", "pat":"^helpf\\%[ind]$", "flags":"EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"helpgrep", "pat":"^helpg\\%[rep]$", "flags":"EXTRA|NOTRLCOM|NEEDARG", "parser":"parse_cmd_common"}), AttributeDict({"name":"helptags", "pat":"^helpt\\%[ags]$", "flags":"NEEDARG|FILES|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"highlight", "pat":"^hi\\%[ghlight]$", "flags":"BANG|EXTRA|TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"hide", "pat":"^hid\\%[e]$", "flags":"BANG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"history", "pat":"^his\\%[tory]$", "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"insert", "pat":"^i\\%[nsert]$", "flags":"BANG|RANGE|TRLBAR|CMDWIN|MODIFY", "parser":"parse_cmd_insert"}), AttributeDict({"name":"iabbrev", "pat":"^ia\\%[bbrev]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"iabclear", "pat":"^iabc\\%[lear]$", "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"if", "pat":"^if$", "flags":"EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_if"}), AttributeDict({"name":"ijump", "pat":"^ij\\%[ump]$", "flags":"BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA", "parser":"parse_cmd_common"}), AttributeDict({"name":"ilist", "pat":"^il\\%[ist]$", "flags":"BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"imap", "pat":"^im\\%[ap]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"imapclear", "pat":"^imapc\\%[lear]$", "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"imenu", "pat":"^ime\\%[nu]$", "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"inoremap", "pat":"^ino\\%[remap]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"inoreabbrev", "pat":"^inorea\\%[bbrev]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"inoremenu", "pat":"^inoreme\\%[nu]$", "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"intro", "pat":"^int\\%[ro]$", "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"isearch", "pat":"^is\\%[earch]$", "flags":"BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"isplit", "pat":"^isp\\%[lit]$", "flags":"BANG|RANGE|DFLALL|WHOLEFOLD|EXTRA", "parser":"parse_cmd_common"}), AttributeDict({"name":"iunmap", "pat":"^iu\\%[nmap]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"iunabbrev", "pat":"^iuna\\%[bbrev]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"iunmenu", "pat":"^iunme\\%[nu]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"join", "pat":"^j\\%[oin]$", "flags":"BANG|RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"jumps", "pat":"^ju\\%[mps]$", "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"k", "pat":"^k$", "flags":"RANGE|WORD1|TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"keepalt", "pat":"^keepa\\%[lt]$", "flags":"NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"keepmarks", "pat":"^kee\\%[pmarks]$", "flags":"NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"keepjumps", "pat":"^keepj\\%[umps]$", "flags":"NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"lNext", "pat":"^lN\\%[ext]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"lNfile", "pat":"^lNf\\%[ile]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"list", "pat":"^l\\%[ist]$", "flags":"RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"laddexpr", "pat":"^lad\\%[dexpr]$", "flags":"NEEDARG|WORD1|NOTRLCOM|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"laddbuffer", "pat":"^laddb\\%[uffer]$", "flags":"RANGE|NOTADR|WORD1|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"laddfile", "pat":"^laddf\\%[ile]$", "flags":"TRLBAR|FILE1", "parser":"parse_cmd_common"}), AttributeDict({"name":"last", "pat":"^la\\%[st]$", "flags":"EXTRA|BANG|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"language", "pat":"^lan\\%[guage]$", "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"later", "pat":"^lat\\%[er]$", "flags":"TRLBAR|EXTRA|NOSPC|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"lbuffer", "pat":"^lb\\%[uffer]$", "flags":"BANG|RANGE|NOTADR|WORD1|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"lcd", "pat":"^lc\\%[d]$", "flags":"BANG|FILE1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"lchdir", "pat":"^lch\\%[dir]$", "flags":"BANG|FILE1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"lclose", "pat":"^lcl\\%[ose]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"lcscope", "pat":"^lcs\\%[cope]$", "flags":"EXTRA|NOTRLCOM|XFILE", "parser":"parse_cmd_common"}), AttributeDict({"name":"left", "pat":"^le\\%[ft]$", "flags":"TRLBAR|RANGE|WHOLEFOLD|EXTRA|CMDWIN|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"leftabove", "pat":"^lefta\\%[bove]$", "flags":"NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"let", "pat":"^let$", "flags":"EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_let"}), AttributeDict({"name":"lexpr", "pat":"^lex\\%[pr]$", "flags":"NEEDARG|WORD1|NOTRLCOM|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"lfile", "pat":"^lf\\%[ile]$", "flags":"TRLBAR|FILE1|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"lfirst", "pat":"^lfir\\%[st]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"lgetbuffer", "pat":"^lgetb\\%[uffer]$", "flags":"RANGE|NOTADR|WORD1|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"lgetexpr", "pat":"^lgete\\%[xpr]$", "flags":"NEEDARG|WORD1|NOTRLCOM|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"lgetfile", "pat":"^lg\\%[etfile]$", "flags":"TRLBAR|FILE1", "parser":"parse_cmd_common"}), AttributeDict({"name":"lgrep", "pat":"^lgr\\%[ep]$", "flags":"RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE", "parser":"parse_cmd_common"}), AttributeDict({"name":"lgrepadd", "pat":"^lgrepa\\%[dd]$", "flags":"RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE", "parser":"parse_cmd_common"}), AttributeDict({"name":"lhelpgrep", "pat":"^lh\\%[elpgrep]$", "flags":"EXTRA|NOTRLCOM|NEEDARG", "parser":"parse_cmd_common"}), AttributeDict({"name":"ll", "pat":"^ll$", "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"llast", "pat":"^lla\\%[st]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"llist", "pat":"^lli\\%[st]$", "flags":"BANG|EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"lmake", "pat":"^lmak\\%[e]$", "flags":"BANG|EXTRA|NOTRLCOM|TRLBAR|XFILE", "parser":"parse_cmd_common"}), AttributeDict({"name":"lmap", "pat":"^lm\\%[ap]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"lmapclear", "pat":"^lmapc\\%[lear]$", "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"lnext", "pat":"^lne\\%[xt]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"lnewer", "pat":"^lnew\\%[er]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"lnfile", "pat":"^lnf\\%[ile]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"lnoremap", "pat":"^ln\\%[oremap]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"loadkeymap", "pat":"^loadk\\%[eymap]$", "flags":"CMDWIN", "parser":"parse_cmd_loadkeymap"}), AttributeDict({"name":"loadview", "pat":"^lo\\%[adview]$", "flags":"FILE1|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"lockmarks", "pat":"^loc\\%[kmarks]$", "flags":"NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"lockvar", "pat":"^lockv\\%[ar]$", "flags":"BANG|EXTRA|NEEDARG|SBOXOK|CMDWIN", "parser":"parse_cmd_lockvar"}), AttributeDict({"name":"lolder", "pat":"^lol\\%[der]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"lopen", "pat":"^lope\\%[n]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"lprevious", "pat":"^lp\\%[revious]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"lpfile", "pat":"^lpf\\%[ile]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"lrewind", "pat":"^lr\\%[ewind]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR|BANG", "parser":"parse_cmd_common"}), AttributeDict({"name":"ls", "pat":"^ls$", "flags":"BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"ltag", "pat":"^lt\\%[ag]$", "flags":"NOTADR|TRLBAR|BANG|WORD1", "parser":"parse_cmd_common"}), AttributeDict({"name":"lunmap", "pat":"^lu\\%[nmap]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"lua", "pat":"^lua$", "flags":"RANGE|EXTRA|NEEDARG|CMDWIN", "parser":"parse_cmd_lua"}), AttributeDict({"name":"luado", "pat":"^luad\\%[o]$", "flags":"RANGE|DFLALL|EXTRA|NEEDARG|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"luafile", "pat":"^luaf\\%[ile]$", "flags":"RANGE|FILE1|NEEDARG|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"lvimgrep", "pat":"^lv\\%[imgrep]$", "flags":"RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE", "parser":"parse_cmd_common"}), AttributeDict({"name":"lvimgrepadd", "pat":"^lvimgrepa\\%[dd]$", "flags":"RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE", "parser":"parse_cmd_common"}), AttributeDict({"name":"lwindow", "pat":"^lw\\%[indow]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"move", "pat":"^m\\%[ove]$", "flags":"RANGE|WHOLEFOLD|EXTRA|TRLBAR|CMDWIN|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"mark", "pat":"^ma\\%[rk]$", "flags":"RANGE|WORD1|TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"make", "pat":"^mak\\%[e]$", "flags":"BANG|EXTRA|NOTRLCOM|TRLBAR|XFILE", "parser":"parse_cmd_common"}), AttributeDict({"name":"map", "pat":"^map$", "flags":"BANG|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"mapclear", "pat":"^mapc\\%[lear]$", "flags":"EXTRA|BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"marks", "pat":"^marks$", "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"match", "pat":"^mat\\%[ch]$", "flags":"RANGE|NOTADR|EXTRA|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"menu", "pat":"^me\\%[nu]$", "flags":"RANGE|NOTADR|ZEROR|BANG|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"menutranslate", "pat":"^menut\\%[ranslate]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"messages", "pat":"^mes\\%[sages]$", "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"mkexrc", "pat":"^mk\\%[exrc]$", "flags":"BANG|FILE1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"mksession", "pat":"^mks\\%[ession]$", "flags":"BANG|FILE1|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"mkspell", "pat":"^mksp\\%[ell]$", "flags":"BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE", "parser":"parse_cmd_common"}), AttributeDict({"name":"mkvimrc", "pat":"^mkv\\%[imrc]$", "flags":"BANG|FILE1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"mkview", "pat":"^mkvie\\%[w]$", "flags":"BANG|FILE1|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"mode", "pat":"^mod\\%[e]$", "flags":"WORD1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"mzscheme", "pat":"^mz\\%[scheme]$", "flags":"RANGE|EXTRA|DFLALL|NEEDARG|CMDWIN|SBOXOK", "parser":"parse_cmd_mzscheme"}), AttributeDict({"name":"mzfile", "pat":"^mzf\\%[ile]$", "flags":"RANGE|FILE1|NEEDARG|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"nbclose", "pat":"^nbc\\%[lose]$", "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"nbkey", "pat":"^nb\\%[key]$", "flags":"EXTRA|NOTADR|NEEDARG", "parser":"parse_cmd_common"}), AttributeDict({"name":"nbstart", "pat":"^nbs\\%[art]$", "flags":"WORD1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"next", "pat":"^n\\%[ext]$", "flags":"RANGE|NOTADR|BANG|FILES|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"new", "pat":"^new$", "flags":"BANG|FILE1|RANGE|NOTADR|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"nmap", "pat":"^nm\\%[ap]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"nmapclear", "pat":"^nmapc\\%[lear]$", "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"nmenu", "pat":"^nme\\%[nu]$", "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"nnoremap", "pat":"^nn\\%[oremap]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"nnoremenu", "pat":"^nnoreme\\%[nu]$", "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"noautocmd", "pat":"^noa\\%[utocmd]$", "flags":"NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"noremap", "pat":"^no\\%[remap]$", "flags":"BANG|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"nohlsearch", "pat":"^noh\\%[lsearch]$", "flags":"TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"noreabbrev", "pat":"^norea\\%[bbrev]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"noremenu", "pat":"^noreme\\%[nu]$", "flags":"RANGE|NOTADR|ZEROR|BANG|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"normal", "pat":"^norm\\%[al]$", "flags":"RANGE|BANG|EXTRA|NEEDARG|NOTRLCOM|USECTRLV|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"number", "pat":"^nu\\%[mber]$", "flags":"RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"nunmap", "pat":"^nun\\%[map]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"nunmenu", "pat":"^nunme\\%[nu]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"oldfiles", "pat":"^ol\\%[dfiles]$", "flags":"BANG|TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"open", "pat":"^o\\%[pen]$", "flags":"RANGE|BANG|EXTRA", "parser":"parse_cmd_common"}), AttributeDict({"name":"omap", "pat":"^om\\%[ap]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"omapclear", "pat":"^omapc\\%[lear]$", "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"omenu", "pat":"^ome\\%[nu]$", "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"only", "pat":"^on\\%[ly]$", "flags":"BANG|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"onoremap", "pat":"^ono\\%[remap]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"onoremenu", "pat":"^onoreme\\%[nu]$", "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"options", "pat":"^opt\\%[ions]$", "flags":"TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"ounmap", "pat":"^ou\\%[nmap]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"ounmenu", "pat":"^ounme\\%[nu]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"ownsyntax", "pat":"^ow\\%[nsyntax]$", "flags":"EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"pclose", "pat":"^pc\\%[lose]$", "flags":"BANG|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"pedit", "pat":"^ped\\%[it]$", "flags":"BANG|FILE1|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"perl", "pat":"^pe\\%[rl]$", "flags":"RANGE|EXTRA|DFLALL|NEEDARG|SBOXOK|CMDWIN", "parser":"parse_cmd_perl"}), AttributeDict({"name":"print", "pat":"^p\\%[rint]$", "flags":"RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN|SBOXOK", "parser":"parse_cmd_common"}), AttributeDict({"name":"profdel", "pat":"^profd\\%[el]$", "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"profile", "pat":"^prof\\%[ile]$", "flags":"BANG|EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"promptfind", "pat":"^pro\\%[mptfind]$", "flags":"EXTRA|NOTRLCOM|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"promptrepl", "pat":"^promptr\\%[epl]$", "flags":"EXTRA|NOTRLCOM|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"perldo", "pat":"^perld\\%[o]$", "flags":"RANGE|EXTRA|DFLALL|NEEDARG|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"pop", "pat":"^po\\%[p]$", "flags":"RANGE|NOTADR|BANG|COUNT|TRLBAR|ZEROR", "parser":"parse_cmd_common"}), AttributeDict({"name":"popup", "pat":"^popu\\%[p]$", "flags":"NEEDARG|EXTRA|BANG|TRLBAR|NOTRLCOM|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"ppop", "pat":"^pp\\%[op]$", "flags":"RANGE|NOTADR|BANG|COUNT|TRLBAR|ZEROR", "parser":"parse_cmd_common"}), AttributeDict({"name":"preserve", "pat":"^pre\\%[serve]$", "flags":"TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"previous", "pat":"^prev\\%[ious]$", "flags":"EXTRA|RANGE|NOTADR|COUNT|BANG|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"psearch", "pat":"^ps\\%[earch]$", "flags":"BANG|RANGE|WHOLEFOLD|DFLALL|EXTRA", "parser":"parse_cmd_common"}), AttributeDict({"name":"ptag", "pat":"^pt\\%[ag]$", "flags":"RANGE|NOTADR|BANG|WORD1|TRLBAR|ZEROR", "parser":"parse_cmd_common"}), AttributeDict({"name":"ptNext", "pat":"^ptN\\%[ext]$", "flags":"RANGE|NOTADR|BANG|TRLBAR|ZEROR", "parser":"parse_cmd_common"}), AttributeDict({"name":"ptfirst", "pat":"^ptf\\%[irst]$", "flags":"RANGE|NOTADR|BANG|TRLBAR|ZEROR", "parser":"parse_cmd_common"}), AttributeDict({"name":"ptjump", "pat":"^ptj\\%[ump]$", "flags":"BANG|TRLBAR|WORD1", "parser":"parse_cmd_common"}), AttributeDict({"name":"ptlast", "pat":"^ptl\\%[ast]$", "flags":"BANG|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"ptnext", "pat":"^ptn\\%[ext]$", "flags":"RANGE|NOTADR|BANG|TRLBAR|ZEROR", "parser":"parse_cmd_common"}), AttributeDict({"name":"ptprevious", "pat":"^ptp\\%[revious]$", "flags":"RANGE|NOTADR|BANG|TRLBAR|ZEROR", "parser":"parse_cmd_common"}), AttributeDict({"name":"ptrewind", "pat":"^ptr\\%[ewind]$", "flags":"RANGE|NOTADR|BANG|TRLBAR|ZEROR", "parser":"parse_cmd_common"}), AttributeDict({"name":"ptselect", "pat":"^pts\\%[elect]$", "flags":"BANG|TRLBAR|WORD1", "parser":"parse_cmd_common"}), AttributeDict({"name":"put", "pat":"^pu\\%[t]$", "flags":"RANGE|WHOLEFOLD|BANG|REGSTR|TRLBAR|ZEROR|CMDWIN|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"pwd", "pat":"^pw\\%[d]$", "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"py3", "pat":"^py3$", "flags":"RANGE|EXTRA|NEEDARG|CMDWIN", "parser":"parse_cmd_python3"}), AttributeDict({"name":"python3", "pat":"^python3$", "flags":"RANGE|EXTRA|NEEDARG|CMDWIN", "parser":"parse_cmd_python3"}), AttributeDict({"name":"py3file", "pat":"^py3f\\%[ile]$", "flags":"RANGE|FILE1|NEEDARG|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"python", "pat":"^py\\%[thon]$", "flags":"RANGE|EXTRA|NEEDARG|CMDWIN", "parser":"parse_cmd_python"}), AttributeDict({"name":"pyfile", "pat":"^pyf\\%[ile]$", "flags":"RANGE|FILE1|NEEDARG|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"quit", "pat":"^q\\%[uit]$", "flags":"BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"quitall", "pat":"^quita\\%[ll]$", "flags":"BANG|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"qall", "pat":"^qa\\%[ll]$", "flags":"BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"read", "pat":"^r\\%[ead]$", "flags":"BANG|RANGE|WHOLEFOLD|FILE1|ARGOPT|TRLBAR|ZEROR|CMDWIN|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"recover", "pat":"^rec\\%[over]$", "flags":"BANG|FILE1|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"redo", "pat":"^red\\%[o]$", "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"redir", "pat":"^redi\\%[r]$", "flags":"BANG|FILES|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"redraw", "pat":"^redr\\%[aw]$", "flags":"BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"redrawstatus", "pat":"^redraws\\%[tatus]$", "flags":"BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"registers", "pat":"^reg\\%[isters]$", "flags":"EXTRA|NOTRLCOM|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"resize", "pat":"^res\\%[ize]$", "flags":"RANGE|NOTADR|TRLBAR|WORD1", "parser":"parse_cmd_common"}), AttributeDict({"name":"retab", "pat":"^ret\\%[ab]$", "flags":"TRLBAR|RANGE|WHOLEFOLD|DFLALL|BANG|WORD1|CMDWIN|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"return", "pat":"^retu\\%[rn]$", "flags":"EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_return"}), AttributeDict({"name":"rewind", "pat":"^rew\\%[ind]$", "flags":"EXTRA|BANG|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"right", "pat":"^ri\\%[ght]$", "flags":"TRLBAR|RANGE|WHOLEFOLD|EXTRA|CMDWIN|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"rightbelow", "pat":"^rightb\\%[elow]$", "flags":"NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"ruby", "pat":"^rub\\%[y]$", "flags":"RANGE|EXTRA|NEEDARG|CMDWIN", "parser":"parse_cmd_ruby"}), AttributeDict({"name":"rubydo", "pat":"^rubyd\\%[o]$", "flags":"RANGE|DFLALL|EXTRA|NEEDARG|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"rubyfile", "pat":"^rubyf\\%[ile]$", "flags":"RANGE|FILE1|NEEDARG|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"rundo", "pat":"^rund\\%[o]$", "flags":"NEEDARG|FILE1", "parser":"parse_cmd_common"}), AttributeDict({"name":"runtime", "pat":"^ru\\%[ntime]$", "flags":"BANG|NEEDARG|FILES|TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"rviminfo", "pat":"^rv\\%[iminfo]$", "flags":"BANG|FILE1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"substitute", "pat":"^s\\%[ubstitute]$", "flags":"RANGE|WHOLEFOLD|EXTRA|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"sNext", "pat":"^sN\\%[ext]$", "flags":"EXTRA|RANGE|NOTADR|COUNT|BANG|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"sandbox", "pat":"^san\\%[dbox]$", "flags":"NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"sargument", "pat":"^sa\\%[rgument]$", "flags":"BANG|RANGE|NOTADR|COUNT|EXTRA|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"sall", "pat":"^sal\\%[l]$", "flags":"BANG|RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"saveas", "pat":"^sav\\%[eas]$", "flags":"BANG|DFLALL|FILE1|ARGOPT|CMDWIN|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"sbuffer", "pat":"^sb\\%[uffer]$", "flags":"BANG|RANGE|NOTADR|BUFNAME|BUFUNL|COUNT|EXTRA|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"sbNext", "pat":"^sbN\\%[ext]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"sball", "pat":"^sba\\%[ll]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"sbfirst", "pat":"^sbf\\%[irst]$", "flags":"TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"sblast", "pat":"^sbl\\%[ast]$", "flags":"TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"sbmodified", "pat":"^sbm\\%[odified]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"sbnext", "pat":"^sbn\\%[ext]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"sbprevious", "pat":"^sbp\\%[revious]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"sbrewind", "pat":"^sbr\\%[ewind]$", "flags":"TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"scriptnames", "pat":"^scrip\\%[tnames]$", "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"scriptencoding", "pat":"^scripte\\%[ncoding]$", "flags":"WORD1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"scscope", "pat":"^scs\\%[cope]$", "flags":"EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"set", "pat":"^se\\%[t]$", "flags":"TRLBAR|EXTRA|CMDWIN|SBOXOK", "parser":"parse_cmd_common"}), AttributeDict({"name":"setfiletype", "pat":"^setf\\%[iletype]$", "flags":"TRLBAR|EXTRA|NEEDARG|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"setglobal", "pat":"^setg\\%[lobal]$", "flags":"TRLBAR|EXTRA|CMDWIN|SBOXOK", "parser":"parse_cmd_common"}), AttributeDict({"name":"setlocal", "pat":"^setl\\%[ocal]$", "flags":"TRLBAR|EXTRA|CMDWIN|SBOXOK", "parser":"parse_cmd_common"}), AttributeDict({"name":"sfind", "pat":"^sf\\%[ind]$", "flags":"BANG|FILE1|RANGE|NOTADR|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"sfirst", "pat":"^sfir\\%[st]$", "flags":"EXTRA|BANG|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"shell", "pat":"^sh\\%[ell]$", "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"simalt", "pat":"^sim\\%[alt]$", "flags":"NEEDARG|WORD1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"sign", "pat":"^sig\\%[n]$", "flags":"NEEDARG|RANGE|NOTADR|EXTRA|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"silent", "pat":"^sil\\%[ent]$", "flags":"NEEDARG|EXTRA|BANG|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"sleep", "pat":"^sl\\%[eep]$", "flags":"RANGE|NOTADR|COUNT|EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"slast", "pat":"^sla\\%[st]$", "flags":"EXTRA|BANG|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"smagic", "pat":"^sm\\%[agic]$", "flags":"RANGE|WHOLEFOLD|EXTRA|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"smap", "pat":"^smap$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"smapclear", "pat":"^smapc\\%[lear]$", "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"smenu", "pat":"^sme\\%[nu]$", "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"snext", "pat":"^sn\\%[ext]$", "flags":"RANGE|NOTADR|BANG|FILES|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"sniff", "pat":"^sni\\%[ff]$", "flags":"EXTRA|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"snomagic", "pat":"^sno\\%[magic]$", "flags":"RANGE|WHOLEFOLD|EXTRA|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"snoremap", "pat":"^snor\\%[emap]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"snoremenu", "pat":"^snoreme\\%[nu]$", "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"sort", "pat":"^sor\\%[t]$", "flags":"RANGE|DFLALL|WHOLEFOLD|BANG|EXTRA|NOTRLCOM|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"source", "pat":"^so\\%[urce]$", "flags":"BANG|FILE1|TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"spelldump", "pat":"^spelld\\%[ump]$", "flags":"BANG|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"spellgood", "pat":"^spe\\%[llgood]$", "flags":"BANG|RANGE|NOTADR|NEEDARG|EXTRA|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"spellinfo", "pat":"^spelli\\%[nfo]$", "flags":"TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"spellrepall", "pat":"^spellr\\%[epall]$", "flags":"TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"spellundo", "pat":"^spellu\\%[ndo]$", "flags":"BANG|RANGE|NOTADR|NEEDARG|EXTRA|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"spellwrong", "pat":"^spellw\\%[rong]$", "flags":"BANG|RANGE|NOTADR|NEEDARG|EXTRA|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"split", "pat":"^sp\\%[lit]$", "flags":"BANG|FILE1|RANGE|NOTADR|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"sprevious", "pat":"^spr\\%[evious]$", "flags":"EXTRA|RANGE|NOTADR|COUNT|BANG|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"srewind", "pat":"^sre\\%[wind]$", "flags":"EXTRA|BANG|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"stop", "pat":"^st\\%[op]$", "flags":"TRLBAR|BANG|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"stag", "pat":"^sta\\%[g]$", "flags":"RANGE|NOTADR|BANG|WORD1|TRLBAR|ZEROR", "parser":"parse_cmd_common"}), AttributeDict({"name":"startinsert", "pat":"^star\\%[tinsert]$", "flags":"BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"startgreplace", "pat":"^startg\\%[replace]$", "flags":"BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"startreplace", "pat":"^startr\\%[eplace]$", "flags":"BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"stopinsert", "pat":"^stopi\\%[nsert]$", "flags":"BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"stjump", "pat":"^stj\\%[ump]$", "flags":"BANG|TRLBAR|WORD1", "parser":"parse_cmd_common"}), AttributeDict({"name":"stselect", "pat":"^sts\\%[elect]$", "flags":"BANG|TRLBAR|WORD1", "parser":"parse_cmd_common"}), AttributeDict({"name":"sunhide", "pat":"^sun\\%[hide]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"sunmap", "pat":"^sunm\\%[ap]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"sunmenu", "pat":"^sunme\\%[nu]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"suspend", "pat":"^sus\\%[pend]$", "flags":"TRLBAR|BANG|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"sview", "pat":"^sv\\%[iew]$", "flags":"BANG|FILE1|RANGE|NOTADR|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"swapname", "pat":"^sw\\%[apname]$", "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"syntax", "pat":"^sy\\%[ntax]$", "flags":"EXTRA|NOTRLCOM|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"syncbind", "pat":"^sync\\%[bind]$", "flags":"TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"t", "pat":"^t$", "flags":"RANGE|WHOLEFOLD|EXTRA|TRLBAR|CMDWIN|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"tNext", "pat":"^tN\\%[ext]$", "flags":"RANGE|NOTADR|BANG|TRLBAR|ZEROR", "parser":"parse_cmd_common"}), AttributeDict({"name":"tabNext", "pat":"^tabN\\%[ext]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"tabclose", "pat":"^tabc\\%[lose]$", "flags":"RANGE|NOTADR|COUNT|BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"tabdo", "pat":"^tabdo$", "flags":"NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"tabedit", "pat":"^tabe\\%[dit]$", "flags":"BANG|FILE1|RANGE|NOTADR|ZEROR|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"tabfind", "pat":"^tabf\\%[ind]$", "flags":"BANG|FILE1|RANGE|NOTADR|ZEROR|EDITCMD|ARGOPT|NEEDARG|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"tabfirst", "pat":"^tabfir\\%[st]$", "flags":"TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"tablast", "pat":"^tabl\\%[ast]$", "flags":"TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"tabmove", "pat":"^tabm\\%[ove]$", "flags":"RANGE|NOTADR|ZEROR|EXTRA|NOSPC|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"tabnew", "pat":"^tabnew$", "flags":"BANG|FILE1|RANGE|NOTADR|ZEROR|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"tabnext", "pat":"^tabn\\%[ext]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"tabonly", "pat":"^tabo\\%[nly]$", "flags":"BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"tabprevious", "pat":"^tabp\\%[revious]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"tabrewind", "pat":"^tabr\\%[ewind]$", "flags":"TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"tabs", "pat":"^tabs$", "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"tab", "pat":"^tab$", "flags":"NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"tag", "pat":"^ta\\%[g]$", "flags":"RANGE|NOTADR|BANG|WORD1|TRLBAR|ZEROR", "parser":"parse_cmd_common"}), AttributeDict({"name":"tags", "pat":"^tags$", "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"tcl", "pat":"^tc\\%[l]$", "flags":"RANGE|EXTRA|NEEDARG|CMDWIN", "parser":"parse_cmd_tcl"}), AttributeDict({"name":"tcldo", "pat":"^tcld\\%[o]$", "flags":"RANGE|DFLALL|EXTRA|NEEDARG|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"tclfile", "pat":"^tclf\\%[ile]$", "flags":"RANGE|FILE1|NEEDARG|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"tearoff", "pat":"^te\\%[aroff]$", "flags":"NEEDARG|EXTRA|TRLBAR|NOTRLCOM|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"tfirst", "pat":"^tf\\%[irst]$", "flags":"RANGE|NOTADR|BANG|TRLBAR|ZEROR", "parser":"parse_cmd_common"}), AttributeDict({"name":"throw", "pat":"^th\\%[row]$", "flags":"EXTRA|NEEDARG|SBOXOK|CMDWIN", "parser":"parse_cmd_throw"}), AttributeDict({"name":"tjump", "pat":"^tj\\%[ump]$", "flags":"BANG|TRLBAR|WORD1", "parser":"parse_cmd_common"}), AttributeDict({"name":"tlast", "pat":"^tl\\%[ast]$", "flags":"BANG|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"tmenu", "pat":"^tm\\%[enu]$", "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"tnext", "pat":"^tn\\%[ext]$", "flags":"RANGE|NOTADR|BANG|TRLBAR|ZEROR", "parser":"parse_cmd_common"}), AttributeDict({"name":"topleft", "pat":"^to\\%[pleft]$", "flags":"NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"tprevious", "pat":"^tp\\%[revious]$", "flags":"RANGE|NOTADR|BANG|TRLBAR|ZEROR", "parser":"parse_cmd_common"}), AttributeDict({"name":"trewind", "pat":"^tr\\%[ewind]$", "flags":"RANGE|NOTADR|BANG|TRLBAR|ZEROR", "parser":"parse_cmd_common"}), AttributeDict({"name":"try", "pat":"^try$", "flags":"TRLBAR|SBOXOK|CMDWIN", "parser":"parse_cmd_try"}), AttributeDict({"name":"tselect", "pat":"^ts\\%[elect]$", "flags":"BANG|TRLBAR|WORD1", "parser":"parse_cmd_common"}), AttributeDict({"name":"tunmenu", "pat":"^tu\\%[nmenu]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"undo", "pat":"^u\\%[ndo]$", "flags":"RANGE|NOTADR|COUNT|ZEROR|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"undojoin", "pat":"^undoj\\%[oin]$", "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"undolist", "pat":"^undol\\%[ist]$", "flags":"TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"unabbreviate", "pat":"^una\\%[bbreviate]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"unhide", "pat":"^unh\\%[ide]$", "flags":"RANGE|NOTADR|COUNT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"unlet", "pat":"^unl\\%[et]$", "flags":"BANG|EXTRA|NEEDARG|SBOXOK|CMDWIN", "parser":"parse_cmd_unlet"}), AttributeDict({"name":"unlockvar", "pat":"^unlo\\%[ckvar]$", "flags":"BANG|EXTRA|NEEDARG|SBOXOK|CMDWIN", "parser":"parse_cmd_unlockvar"}), AttributeDict({"name":"unmap", "pat":"^unm\\%[ap]$", "flags":"BANG|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"unmenu", "pat":"^unme\\%[nu]$", "flags":"BANG|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"unsilent", "pat":"^uns\\%[ilent]$", "flags":"NEEDARG|EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"update", "pat":"^up\\%[date]$", "flags":"RANGE|WHOLEFOLD|BANG|FILE1|ARGOPT|DFLALL|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"vglobal", "pat":"^v\\%[global]$", "flags":"RANGE|WHOLEFOLD|EXTRA|DFLALL|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"version", "pat":"^ve\\%[rsion]$", "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"verbose", "pat":"^verb\\%[ose]$", "flags":"NEEDARG|RANGE|NOTADR|EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"vertical", "pat":"^vert\\%[ical]$", "flags":"NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"vimgrep", "pat":"^vim\\%[grep]$", "flags":"RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE", "parser":"parse_cmd_common"}), AttributeDict({"name":"vimgrepadd", "pat":"^vimgrepa\\%[dd]$", "flags":"RANGE|NOTADR|BANG|NEEDARG|EXTRA|NOTRLCOM|TRLBAR|XFILE", "parser":"parse_cmd_common"}), AttributeDict({"name":"visual", "pat":"^vi\\%[sual]$", "flags":"BANG|FILE1|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"viusage", "pat":"^viu\\%[sage]$", "flags":"TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"view", "pat":"^vie\\%[w]$", "flags":"BANG|FILE1|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"vmap", "pat":"^vm\\%[ap]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"vmapclear", "pat":"^vmapc\\%[lear]$", "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"vmenu", "pat":"^vme\\%[nu]$", "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"vnew", "pat":"^vne\\%[w]$", "flags":"BANG|FILE1|RANGE|NOTADR|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"vnoremap", "pat":"^vn\\%[oremap]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"vnoremenu", "pat":"^vnoreme\\%[nu]$", "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"vsplit", "pat":"^vs\\%[plit]$", "flags":"BANG|FILE1|RANGE|NOTADR|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"vunmap", "pat":"^vu\\%[nmap]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"vunmenu", "pat":"^vunme\\%[nu]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"windo", "pat":"^windo$", "flags":"BANG|NEEDARG|EXTRA|NOTRLCOM", "parser":"parse_cmd_common"}), AttributeDict({"name":"write", "pat":"^w\\%[rite]$", "flags":"RANGE|WHOLEFOLD|BANG|FILE1|ARGOPT|DFLALL|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"wNext", "pat":"^wN\\%[ext]$", "flags":"RANGE|WHOLEFOLD|NOTADR|BANG|FILE1|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"wall", "pat":"^wa\\%[ll]$", "flags":"BANG|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"while", "pat":"^wh\\%[ile]$", "flags":"EXTRA|NOTRLCOM|SBOXOK|CMDWIN", "parser":"parse_cmd_while"}), AttributeDict({"name":"winsize", "pat":"^wi\\%[nsize]$", "flags":"EXTRA|NEEDARG|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"wincmd", "pat":"^winc\\%[md]$", "flags":"NEEDARG|WORD1|RANGE|NOTADR", "parser":"parse_cmd_common"}), AttributeDict({"name":"winpos", "pat":"^winp\\%[os]$", "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"wnext", "pat":"^wn\\%[ext]$", "flags":"RANGE|NOTADR|BANG|FILE1|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"wprevious", "pat":"^wp\\%[revious]$", "flags":"RANGE|NOTADR|BANG|FILE1|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"wq", "pat":"^wq$", "flags":"RANGE|WHOLEFOLD|BANG|FILE1|ARGOPT|DFLALL|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"wqall", "pat":"^wqa\\%[ll]$", "flags":"BANG|FILE1|ARGOPT|DFLALL|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"wsverb", "pat":"^ws\\%[verb]$", "flags":"EXTRA|NOTADR|NEEDARG", "parser":"parse_cmd_common"}), AttributeDict({"name":"wundo", "pat":"^wu\\%[ndo]$", "flags":"BANG|NEEDARG|FILE1", "parser":"parse_cmd_common"}), AttributeDict({"name":"wviminfo", "pat":"^wv\\%[iminfo]$", "flags":"BANG|FILE1|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"xit", "pat":"^x\\%[it]$", "flags":"RANGE|WHOLEFOLD|BANG|FILE1|ARGOPT|DFLALL|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"xall", "pat":"^xa\\%[ll]$", "flags":"BANG|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"xmapclear", "pat":"^xmapc\\%[lear]$", "flags":"EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"xmap", "pat":"^xm\\%[ap]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"xmenu", "pat":"^xme\\%[nu]$", "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"xnoremap", "pat":"^xn\\%[oremap]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"xnoremenu", "pat":"^xnoreme\\%[nu]$", "flags":"RANGE|NOTADR|ZEROR|EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"xunmap", "pat":"^xu\\%[nmap]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"xunmenu", "pat":"^xunme\\%[nu]$", "flags":"EXTRA|TRLBAR|NOTRLCOM|USECTRLV|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"yank", "pat":"^y\\%[ank]$", "flags":"RANGE|WHOLEFOLD|REGSTR|COUNT|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"z", "pat":"^z$", "flags":"RANGE|WHOLEFOLD|EXTRA|EXFLAGS|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"!", "pat":"^!$", "flags":"RANGE|WHOLEFOLD|BANG|FILES|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"#", "pat":"^#$", "flags":"RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"&", "pat":"^&$", "flags":"RANGE|WHOLEFOLD|EXTRA|CMDWIN|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"*", "pat":"^\\*$", "flags":"RANGE|WHOLEFOLD|EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"<", "pat":"^<$", "flags":"RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"=", "pat":"^=$", "flags":"RANGE|TRLBAR|DFLALL|EXFLAGS|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":">", "pat":"^>$", "flags":"RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN|MODIFY", "parser":"parse_cmd_common"}), AttributeDict({"name":"@", "pat":"^@$", "flags":"RANGE|WHOLEFOLD|EXTRA|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"Next", "pat":"^N\\%[ext]$", "flags":"EXTRA|RANGE|NOTADR|COUNT|BANG|EDITCMD|ARGOPT|TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"Print", "pat":"^P\\%[rint]$", "flags":"RANGE|WHOLEFOLD|COUNT|EXFLAGS|TRLBAR|CMDWIN", "parser":"parse_cmd_common"}), AttributeDict({"name":"X", "pat":"^X$", "flags":"TRLBAR", "parser":"parse_cmd_common"}), AttributeDict({"name":"~", "pat":"^\\~$", "flags":"RANGE|WHOLEFOLD|EXTRA|CMDWIN|MODIFY", "parser":"parse_cmd_common"})]
class ExprTokenizer:
    def __init__(self, reader):
        self.reader = reader
        self.cache = AttributeDict({})

    def err(self, *a000):
        pos = self.reader.getpos()
        if viml_len(a000) == 1:
            msg = a000[0]
        else:
            msg = viml_printf(*a000)
        return viml_printf("%s: line %d col %d", msg, pos.lnum, pos.col)

    def token(self, type, value):
        return AttributeDict({"type":type, "value":value})

    def peek(self):
        pos = self.reader.getpos()
        r = self.get()
        self.reader.setpos(pos)
        return r

    def get(self):
        while 1:
            r = self.get_keepspace()
            if r.type != TOKEN_SPACE:
                return r

    def peek_keepspace(self):
        pos = self.reader.getpos()
        r = self.get_keepspace()
        self.reader.setpos(pos)
        return r

    def get_keepspace(self):
        # FIXME: remove dirty hack
        if viml_has_key(self.cache, self.reader.i):
            x = self.cache[self.reader.i]
            self.reader.i = x[0]
            return x[1]
        i = self.reader.i
        r = self.get_keepspace2()
        self.cache[i] = [self.reader.i, r]
        return r

    def get_keepspace2(self):
        c = self.reader.peek()
        s = self.reader.peekn(10)
        if c == "<EOF>":
            return self.token(TOKEN_EOF, c)
        elif c == "<EOL>":
            self.reader.get()
            return self.token(TOKEN_EOL, c)
        elif viml_eqregh(s, "^\\s"):
            s = ""
            while viml_eqregh(self.reader.peekn(1), "\\s"):
                s += self.reader.getn(1)
            return self.token(TOKEN_SPACE, s)
        elif viml_eqregh(s, "^0x\\x"):
            s = self.reader.getn(3)
            while viml_eqregh(self.reader.peekn(1), "\\x"):
                s += self.reader.getn(1)
            return self.token(TOKEN_NUMBER, s)
        elif viml_eqregh(s, "^\\d"):
            s = ""
            while viml_eqregh(self.reader.peekn(1), "\\d"):
                s += self.reader.getn(1)
            if viml_eqregh(self.reader.peekn(2), "\\.\\d"):
                s += self.reader.getn(1)
                while viml_eqregh(self.reader.peekn(1), "\\d"):
                    s += self.reader.getn(1)
                if viml_eqregh(self.reader.peekn(3), "[Ee][-+]\\d"):
                    s += self.reader.getn(3)
                    while viml_eqregh(self.reader.peekn(1), "\\d"):
                        s += self.reader.getn(1)
            return self.token(TOKEN_NUMBER, s)
        elif viml_eqregh(s, "^is#"):
            self.reader.getn(3)
            return self.token(TOKEN_ISH, "is#")
        elif viml_eqregh(s, "^is?"):
            self.reader.getn(3)
            return self.token(TOKEN_ISQ, "is?")
        elif viml_eqregh(s, "^isnot#"):
            self.reader.getn(6)
            return self.token(TOKEN_ISNOTH, "is#")
        elif viml_eqregh(s, "^isnot?"):
            self.reader.getn(6)
            return self.token(TOKEN_ISNOTQ, "is?")
        elif viml_eqregh(s, "^is\\>"):
            self.reader.getn(2)
            return self.token(TOKEN_IS, "is")
        elif viml_eqregh(s, "^isnot\\>"):
            self.reader.getn(5)
            return self.token(TOKEN_ISNOT, "isnot")
        elif viml_eqregh(s, "^<[Ss][Ii][Dd]>\\h"):
            s = self.reader.getn(6)
            while viml_eqregh(self.reader.peekn(1), "\\w\\|[:#]"):
                s += self.reader.getn(1)
            return self.token(TOKEN_IDENTIFIER, s)
        elif viml_eqregh(s, "^\\h"):
            s = self.reader.getn(1)
            while viml_eqregh(self.reader.peekn(1), "\\w\\|[:#]"):
                s += self.reader.getn(1)
            return self.token(TOKEN_IDENTIFIER, s)
        elif viml_eqregh(s, "^==?"):
            self.reader.getn(3)
            return self.token(TOKEN_EQEQQ, "==?")
        elif viml_eqregh(s, "^==#"):
            self.reader.getn(3)
            return self.token(TOKEN_EQEQH, "==#")
        elif viml_eqregh(s, "^!=?"):
            self.reader.getn(3)
            return self.token(TOKEN_NOTEQQ, "!=?")
        elif viml_eqregh(s, "^!=#"):
            self.reader.getn(3)
            return self.token(TOKEN_NOTEQH, "!=#")
        elif viml_eqregh(s, "^>=?"):
            self.reader.getn(3)
            return self.token(TOKEN_GTEQQ, ">=?")
        elif viml_eqregh(s, "^>=#"):
            self.reader.getn(3)
            return self.token(TOKEN_GTEQH, ">=#")
        elif viml_eqregh(s, "^<=?"):
            self.reader.getn(3)
            return self.token(TOKEN_LTEQQ, "<=?")
        elif viml_eqregh(s, "^<=#"):
            self.reader.getn(3)
            return self.token(TOKEN_LTEQH, "<=#")
        elif viml_eqregh(s, "^=\\~?"):
            self.reader.getn(3)
            return self.token(TOKEN_EQTILDQ, "=\\~?")
        elif viml_eqregh(s, "^=\\~#"):
            self.reader.getn(3)
            return self.token(TOKEN_EQTILDH, "=\\~#")
        elif viml_eqregh(s, "^!\\~?"):
            self.reader.getn(3)
            return self.token(TOKEN_NOTTILDQ, "!\\~?")
        elif viml_eqregh(s, "^!\\~#"):
            self.reader.getn(3)
            return self.token(TOKEN_NOTTILDH, "!\\~#")
        elif viml_eqregh(s, "^>?"):
            self.reader.getn(2)
            return self.token(TOKEN_GTQ, ">?")
        elif viml_eqregh(s, "^>#"):
            self.reader.getn(2)
            return self.token(TOKEN_GTH, ">#")
        elif viml_eqregh(s, "^<?"):
            self.reader.getn(2)
            return self.token(TOKEN_LTQ, "<?")
        elif viml_eqregh(s, "^<#"):
            self.reader.getn(2)
            return self.token(TOKEN_LTH, "<#")
        elif viml_eqregh(s, "^||"):
            self.reader.getn(2)
            return self.token(TOKEN_OROR, "||")
        elif viml_eqregh(s, "^&&"):
            self.reader.getn(2)
            return self.token(TOKEN_ANDAND, "&&")
        elif viml_eqregh(s, "^=="):
            self.reader.getn(2)
            return self.token(TOKEN_EQEQ, "==")
        elif viml_eqregh(s, "^!="):
            self.reader.getn(2)
            return self.token(TOKEN_NOTEQ, "!=")
        elif viml_eqregh(s, "^>="):
            self.reader.getn(2)
            return self.token(TOKEN_GTEQ, ">=")
        elif viml_eqregh(s, "^<="):
            self.reader.getn(2)
            return self.token(TOKEN_LTEQ, "<=")
        elif viml_eqregh(s, "^=\\~"):
            self.reader.getn(2)
            return self.token(TOKEN_EQTILD, "=\\~")
        elif viml_eqregh(s, "^!\\~"):
            self.reader.getn(2)
            return self.token(TOKEN_NOTTILD, "!\\~")
        elif viml_eqregh(s, "^>"):
            self.reader.getn(1)
            return self.token(TOKEN_GT, ">")
        elif viml_eqregh(s, "^<"):
            self.reader.getn(1)
            return self.token(TOKEN_LT, "<")
        elif viml_eqregh(s, "^+"):
            self.reader.getn(1)
            return self.token(TOKEN_PLUS, "+")
        elif viml_eqregh(s, "^-"):
            self.reader.getn(1)
            return self.token(TOKEN_MINUS, "-")
        elif viml_eqregh(s, "^\\."):
            self.reader.getn(1)
            return self.token(TOKEN_DOT, ".")
        elif viml_eqregh(s, "^\\*"):
            self.reader.getn(1)
            return self.token(TOKEN_STAR, "*")
        elif viml_eqregh(s, "^/"):
            self.reader.getn(1)
            return self.token(TOKEN_SLASH, "/")
        elif viml_eqregh(s, "^%"):
            self.reader.getn(1)
            return self.token(TOKEN_PER, "%")
        elif viml_eqregh(s, "^!"):
            self.reader.getn(1)
            return self.token(TOKEN_NOT, "!")
        elif viml_eqregh(s, "^?"):
            self.reader.getn(1)
            return self.token(TOKEN_QUESTION, "?")
        elif viml_eqregh(s, "^:"):
            self.reader.getn(1)
            return self.token(TOKEN_COLON, ":")
        elif viml_eqregh(s, "^("):
            self.reader.getn(1)
            return self.token(TOKEN_LPAR, "(")
        elif viml_eqregh(s, "^)"):
            self.reader.getn(1)
            return self.token(TOKEN_RPAR, ")")
        elif viml_eqregh(s, "^\\["):
            self.reader.getn(1)
            return self.token(TOKEN_LBRA, "[")
        elif viml_eqregh(s, "^]"):
            self.reader.getn(1)
            return self.token(TOKEN_RBRA, "]")
        elif viml_eqregh(s, "^{"):
            self.reader.getn(1)
            return self.token(TOKEN_LBPAR, "{")
        elif viml_eqregh(s, "^}"):
            self.reader.getn(1)
            return self.token(TOKEN_RBPAR, "}")
        elif viml_eqregh(s, "^,"):
            self.reader.getn(1)
            return self.token(TOKEN_COMMA, ",")
        elif viml_eqregh(s, "^'"):
            self.reader.getn(1)
            return self.token(TOKEN_SQUOTE, "'")
        elif viml_eqregh(s, "^\""):
            self.reader.getn(1)
            return self.token(TOKEN_DQUOTE, "\"")
        elif viml_eqregh(s, "^\\$\\w\\+"):
            s = self.reader.getn(1)
            while viml_eqregh(self.reader.peekn(1), "\\w"):
                s += self.reader.getn(1)
            return self.token(TOKEN_ENV, s)
        elif viml_eqregh(s, "^@."):
            return self.token(TOKEN_REG, self.reader.getn(2))
        elif viml_eqregh(s, "^&\\(g:\\|l:\\|\\w\\w\\)"):
            s = self.reader.getn(3)
            while viml_eqregh(self.reader.peekn(1), "\\w"):
                s += self.reader.getn(1)
            return self.token(TOKEN_OPTION, s)
        elif viml_eqregh(s, "^="):
            self.reader.getn(1)
            return self.token(TOKEN_EQ, "=")
        elif viml_eqregh(s, "^|"):
            self.reader.getn(1)
            return self.token(TOKEN_OR, "|")
        elif viml_eqregh(s, "^;"):
            self.reader.getn(1)
            return self.token(TOKEN_SEMICOLON, ";")
        elif viml_eqregh(s, "^`"):
            self.reader.getn(1)
            return self.token(TOKEN_BACKTICK, "`")
        else:
            raise Exception(self.err("ExprTokenizer: %s", s))

    def get_sstring(self):
        s = ""
        while viml_eqregh(self.reader.peekn(1), "\\s"):
            self.reader.getn(1)
        c = self.reader.getn(1)
        if c != "'":
            raise Exception(sefl.err("ExprTokenizer: unexpected character: %s", c))
        while 1:
            c = self.reader.getn(1)
            if c == "":
                raise Exception(self.err("ExprTokenizer: unexpected EOL"))
            elif c == "'":
                if self.reader.peekn(1) == "'":
                    self.reader.getn(1)
                    s += c
                else:
                    break
            else:
                s += c
        return s

    def get_dstring(self):
        s = ""
        while viml_eqregh(self.reader.peekn(1), "\\s"):
            self.reader.getn(1)
        c = self.reader.getn(1)
        if c != "\"":
            raise Exception(self.err("ExprTokenizer: unexpected character: %s", c))
        while 1:
            c = self.reader.getn(1)
            if c == "":
                raise Exception(self.err("ExprTokenizer: unexpectd EOL"))
            elif c == "\"":
                break
            elif c == "\\":
                s += c
                c = self.reader.getn(1)
                if c == "":
                    raise Exception(self.err("ExprTokenizer: unexpected EOL"))
                s += c
            else:
                s += c
        return s

class ExprParser:
    def __init__(self, tokenizer):
        self.tokenizer = tokenizer

    def err(self, *a000):
        pos = self.tokenizer.reader.getpos()
        if viml_len(a000) == 1:
            msg = a000[0]
        else:
            msg = viml_printf(*a000)
        return viml_printf("%s: line %d col %d", msg, pos.lnum, pos.col)

    def exprnode(self, type):
        return AttributeDict({"type":type})

    def parse(self):
        return self.parse_expr1()

# expr1: expr2 ? expr1 : expr1
    def parse_expr1(self):
        lhs = self.parse_expr2()
        token = self.tokenizer.peek()
        if token.type == TOKEN_QUESTION:
            self.tokenizer.get()
            node = self.exprnode(NODE_CONDEXP)
            node.cond = lhs
            node.then = self.parse_expr1()
            token = self.tokenizer.peek()
            if token.type != TOKEN_COLON:
                raise Exception(self.err("ExprParser: unexpected token: %s", token.value))
            self.tokenizer.get()
            node._else = self.parse_expr1()
            lhs = node
        return lhs

# expr2: expr3 || expr3 ..
    def parse_expr2(self):
        lhs = self.parse_expr3()
        token = self.tokenizer.peek()
        while token.type == TOKEN_OROR:
            self.tokenizer.get()
            node = self.exprnode(NODE_LOGOR)
            node.lhs = lhs
            node.rhs = self.parse_expr3()
            lhs = node
            token = self.tokenizer.peek()
        return lhs

# expr3: expr4 && expr4
    def parse_expr3(self):
        lhs = self.parse_expr4()
        token = self.tokenizer.peek()
        while token.type == TOKEN_ANDAND:
            self.tokenizer.get()
            node = self.exprnode(NODE_LOGAND)
            node.lhs = lhs
            node.rhs = self.parse_expr4()
            lhs = node
            token = self.tokenizer.peek()
        return lhs

# expr4: expr5 == expr5
#        expr5 != expr5
#        expr5 >  expr5
#        expr5 >= expr5
#        expr5 <  expr5
#        expr5 <= expr5
#        expr5 =~ expr5
#        expr5 !~ expr5
#
#        expr5 ==?  expr5
#        expr5 ==# expr5
#        etc.
#
#        expr5 is expr5
#        expr5 isnot expr5
    def parse_expr4(self):
        lhs = self.parse_expr5()
        token = self.tokenizer.peek()
        if token.type == TOKEN_EQEQQ:
            self.tokenizer.get()
            node = self.exprnode(NODE_EQEQQ)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_EQEQH:
            self.tokenizer.get()
            node = self.exprnode(NODE_EQEQH)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_NOTEQQ:
            self.tokenizer.get()
            node = self.exprnode(NODE_NOTEQQ)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_NOTEQH:
            self.tokenizer.get()
            node = self.exprnode(NODE_NOTEQH)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_GTEQQ:
            self.tokenizer.get()
            node = self.exprnode(NODE_GTEQQ)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_GTEQH:
            self.tokenizer.get()
            node = self.exprnode(NODE_GTEQH)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_LTEQQ:
            self.tokenizer.get()
            node = self.exprnode(NODE_LTEQQ)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_LTEQH:
            self.tokenizer.get()
            node = self.exprnode(NODE_LTEQH)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_EQTILDQ:
            self.tokenizer.get()
            node = self.exprnode(NODE_EQTILDQ)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_EQTILDH:
            self.tokenizer.get()
            node = self.exprnode(NODE_EQTILDH)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_NOTTILDQ:
            self.tokenizer.get()
            node = self.exprnode(NODE_NOTTILDQ)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_NOTTILDH:
            self.tokenizer.get()
            node = self.exprnode(NODE_NOTTILDH)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_GTQ:
            self.tokenizer.get()
            node = self.exprnode(NODE_GTQ)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_GTH:
            self.tokenizer.get()
            node = self.exprnode(NODE_GTH)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_LTQ:
            self.tokenizer.get()
            node = self.exprnode(NODE_LTQ)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_LTH:
            self.tokenizer.get()
            node = self.exprnode(NODE_LTH)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_EQEQ:
            self.tokenizer.get()
            node = self.exprnode(NODE_EQEQ)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_NOTEQ:
            self.tokenizer.get()
            node = self.exprnode(NODE_NOTEQ)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_GTEQ:
            self.tokenizer.get()
            node = self.exprnode(NODE_GTEQ)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_LTEQ:
            self.tokenizer.get()
            node = self.exprnode(NODE_LTEQ)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_EQTILD:
            self.tokenizer.get()
            node = self.exprnode(NODE_EQTILD)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_NOTTILD:
            self.tokenizer.get()
            node = self.exprnode(NODE_NOTTILD)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_GT:
            self.tokenizer.get()
            node = self.exprnode(NODE_GT)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_LT:
            self.tokenizer.get()
            node = self.exprnode(NODE_LT)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_ISH:
            self.tokenizer.get()
            node = self.exprnode(NODE_ISH)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_ISQ:
            self.tokenizer.get()
            node = self.exprnode(NODE_ISQ)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_ISNOTH:
            self.tokenizer.get()
            node = self.exprnode(NODE_ISNOTH)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_ISNOTQ:
            self.tokenizer.get()
            node = self.exprnode(NODE_ISNOTQ)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_IS:
            self.tokenizer.get()
            node = self.exprnode(NODE_IS)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        elif token.type == TOKEN_ISNOT:
            self.tokenizer.get()
            node = self.exprnode(NODE_ISNOT)
            node.lhs = lhs
            node.rhs = self.parse_expr5()
            lhs = node
        return lhs

# expr5: expr6 + expr6 ..
#        expr6 - expr6 ..
#        expr6 . expr6 ..
    def parse_expr5(self):
        lhs = self.parse_expr6()
        while 1:
            token = self.tokenizer.peek()
            if token.type == TOKEN_PLUS:
                self.tokenizer.get()
                node = self.exprnode(NODE_ADD)
                node.lhs = lhs
                node.rhs = self.parse_expr6()
                lhs = node
            elif token.type == TOKEN_MINUS:
                self.tokenizer.get()
                node = self.exprnode(NODE_SUB)
                node.lhs = lhs
                node.rhs = self.parse_expr6()
                lhs = node
            elif token.type == TOKEN_DOT:
                self.tokenizer.get()
                node = self.exprnode(NODE_CONCAT)
                node.lhs = lhs
                node.rhs = self.parse_expr6()
                lhs = node
            else:
                break
        return lhs

# expr6: expr7 * expr7 ..
#        expr7 / expr7 ..
#        expr7 % expr7 ..
    def parse_expr6(self):
        lhs = self.parse_expr7()
        while 1:
            token = self.tokenizer.peek()
            if token.type == TOKEN_STAR:
                self.tokenizer.get()
                node = self.exprnode(NODE_MUL)
                node.lhs = lhs
                node.rhs = self.parse_expr7()
                lhs = node
            elif token.type == TOKEN_SLASH:
                self.tokenizer.get()
                node = self.exprnode(NODE_DIV)
                node.lhs = lhs
                node.rhs = self.parse_expr7()
                lhs = node
            elif token.type == TOKEN_PER:
                self.tokenizer.get()
                node = self.exprnode(NODE_MOD)
                node.lhs = lhs
                node.rhs = self.parse_expr7()
                lhs = node
            else:
                break
        return lhs

# expr7: ! expr7
#        - expr7
#        + expr7
    def parse_expr7(self):
        token = self.tokenizer.peek()
        if token.type == TOKEN_NOT:
            self.tokenizer.get()
            node = self.exprnode(NODE_NOT)
            node.expr = self.parse_expr7()
        elif token.type == TOKEN_MINUS:
            self.tokenizer.get()
            node = self.exprnode(NODE_MINUS)
            node.expr = self.parse_expr7()
        elif token.type == TOKEN_PLUS:
            self.tokenizer.get()
            node = self.exprnode(NODE_PLUS)
            node.expr = self.parse_expr7()
        else:
            node = self.parse_expr8()
        return node

# expr8: expr8[expr1]
#        expr8[expr1 : expr1]
#        expr8.name
#        expr8(expr1, ...)
    def parse_expr8(self):
        lhs = self.parse_expr9()
        while 1:
            token = self.tokenizer.peek()
            token2 = self.tokenizer.peek_keepspace()
            if token2.type == TOKEN_LBRA:
                self.tokenizer.get()
                if self.tokenizer.peek().type == TOKEN_COLON:
                    self.tokenizer.get()
                    node = self.exprnode(NODE_SLICE)
                    node.expr = lhs
                    node.expr1 = NIL
                    node.expr2 = NIL
                    token = self.tokenizer.peek()
                    if token.type != TOKEN_RBRA:
                        node.expr2 = self.parse_expr1()
                    token = self.tokenizer.peek()
                    if token.type != TOKEN_RBRA:
                        raise Exception(self.err("ExprParser: unexpected token: %s", token.value))
                    self.tokenizer.get()
                else:
                    expr1 = self.parse_expr1()
                    if self.tokenizer.peek().type == TOKEN_COLON:
                        self.tokenizer.get()
                        node = self.exprnode(NODE_SLICE)
                        node.expr = lhs
                        node.expr1 = expr1
                        node.expr2 = NIL
                        token = self.tokenizer.peek()
                        if token.type != TOKEN_RBRA:
                            node.expr2 = self.parse_expr1()
                        token = self.tokenizer.peek()
                        if token.type != TOKEN_RBRA:
                            raise Exception(self.err("ExprParser: unexpected token: %s", token.value))
                        self.tokenizer.get()
                    else:
                        node = self.exprnode(NODE_INDEX)
                        node.expr = lhs
                        node.expr1 = expr1
                        token = self.tokenizer.peek()
                        if token.type != TOKEN_RBRA:
                            raise Exception(self.err("ExprParser: unexpected token: %s", token.value))
                        self.tokenizer.get()
                lhs = node
            elif token.type == TOKEN_LPAR:
                self.tokenizer.get()
                node = self.exprnode(NODE_CALL)
                node.expr = lhs
                node.args = []
                if self.tokenizer.peek().type == TOKEN_RPAR:
                    self.tokenizer.get()
                else:
                    while 1:
                        viml_add(node.args, self.parse_expr1())
                        token = self.tokenizer.peek()
                        if token.type == TOKEN_COMMA:
                            self.tokenizer.get()
                        elif token.type == TOKEN_RPAR:
                            self.tokenizer.get()
                            break
                        else:
                            raise Exception(self.err("ExprParser: unexpected token: %s", token.value))
                lhs = node
            elif token2.type == TOKEN_DOT:
                # INDEX or CONCAT
                pos = self.tokenizer.reader.getpos()
                self.tokenizer.get()
                token2 = self.tokenizer.peek_keepspace()
                if token2.type == TOKEN_IDENTIFIER:
                    rhs = self.exprnode(NODE_IDENTIFIER)
                    rhs.value = self.parse_identifier()
                    node = self.exprnode(NODE_DOT)
                    node.lhs = lhs
                    node.rhs = rhs
                else:
                    # to be CONCAT
                    self.tokenizer.reader.setpos(pos)
                    break
                lhs = node
            else:
                break
        return lhs

# expr9: number
#        "string"
#        'string'
#        [expr1, ...]
#        {expr1: expr1, ...}
#        &option
#        (expr1)
#        variable
#        var{ria}ble
#        $VAR
#        @r
#        function(expr1, ...)
#        func{ti}on(expr1, ...)
    def parse_expr9(self):
        token = self.tokenizer.peek()
        if token.type == TOKEN_NUMBER:
            self.tokenizer.get()
            node = self.exprnode(NODE_NUMBER)
            node.value = token.value
        elif token.type == TOKEN_DQUOTE:
            node = self.exprnode(NODE_STRING)
            node.value = "\"" + self.tokenizer.get_dstring() + "\""
        elif token.type == TOKEN_SQUOTE:
            node = self.exprnode(NODE_STRING)
            node.value = "'" + self.tokenizer.get_sstring() + "'"
        elif token.type == TOKEN_LBRA:
            self.tokenizer.get()
            node = self.exprnode(NODE_LIST)
            node.items = []
            token = self.tokenizer.peek()
            if token.type == TOKEN_RBRA:
                self.tokenizer.get()
            else:
                while 1:
                    viml_add(node.items, self.parse_expr1())
                    token = self.tokenizer.peek()
                    if token.type == TOKEN_COMMA:
                        self.tokenizer.get()
                        if self.tokenizer.peek().type == TOKEN_RBRA:
                            self.tokenizer.get()
                            break
                    elif token.type == TOKEN_RBRA:
                        self.tokenizer.get()
                        break
                    else:
                        raise Exception(self.err("ExprParser: unexpected token: %s", token.value))
        elif token.type == TOKEN_LBPAR:
            pos = self.tokenizer.reader.getpos()
            self.tokenizer.get()
            node = self.exprnode(NODE_DICT)
            node.items = []
            token = self.tokenizer.peek()
            if token.type == TOKEN_RBPAR:
                self.tokenizer.get()
            else:
                while 1:
                    key = self.parse_expr1()
                    token = self.tokenizer.get()
                    if token.type == TOKEN_RBPAR:
                        if not viml_empty(node.items):
                            raise Exception(self.err("ExprParser: unexpected token: %s", token.value))
                        self.tokenizer.reader.setpos(pos)
                        node = self.exprnode(NODE_IDENTIFIER)
                        node.value = self.parse_identifier()
                        break
                    if token.type != TOKEN_COLON:
                        raise Exception(self.err("ExprParser: unexpected token: %s", token.value))
                    val = self.parse_expr1()
                    viml_add(node.items, [key, val])
                    token = self.tokenizer.peek()
                    if token.type == TOKEN_COMMA:
                        self.tokenizer.get()
                        if self.tokenizer.peek().type == TOKEN_RBPAR:
                            self.tokenizer.get()
                            break
                    elif token.type == TOKEN_RBPAR:
                        self.tokenizer.get()
                        break
                    else:
                        raise Exception(self.err("ExprParser: unexpected token: %s", token.value))
        elif token.type == TOKEN_LPAR:
            self.tokenizer.get()
            node = self.exprnode(NODE_NESTING)
            node.expr = self.parse_expr1()
            token = self.tokenizer.get()
            if token.type != TOKEN_RPAR:
                raise Exception(self.err("ExprParser: unexpected token: %s", token.value))
        elif token.type == TOKEN_OPTION:
            self.tokenizer.get()
            node = self.exprnode(NODE_OPTION)
            node.value = token.value
        elif token.type == TOKEN_IDENTIFIER:
            node = self.exprnode(NODE_IDENTIFIER)
            node.value = self.parse_identifier()
        elif token.type == TOKEN_ENV:
            self.tokenizer.get()
            node = self.exprnode(NODE_ENV)
            node.value = token.value
        elif token.type == TOKEN_REG:
            self.tokenizer.get()
            node = self.exprnode(NODE_REG)
            node.value = token.value
        else:
            raise Exception(self.err("ExprParser: unexpected token: %s", token.value))
        return node

    def parse_identifier(self):
        id = []
        token = self.tokenizer.peek()
        while 1:
            if token.type == TOKEN_IDENTIFIER:
                self.tokenizer.get()
                viml_add(id, AttributeDict({"curly":0, "value":token.value}))
            elif token.type == TOKEN_LBPAR:
                self.tokenizer.get()
                node = self.parse_expr1()
                token = self.tokenizer.get()
                if token.type != TOKEN_RBPAR:
                    raise Exception(self.err("ExprParser: unexpected token: %s", token.value))
                viml_add(id, AttributeDict({"curly":1, "value":node}))
            else:
                break
            token = self.tokenizer.peek_keepspace()
        return id

class LvalueParser(ExprParser):
    def parse(self):
        return self.parse_lv8()

# expr8: expr8[expr1]
#        expr8[expr1 : expr1]
#        expr8.name
    def parse_lv8(self):
        lhs = self.parse_lv9()
        while 1:
            token = self.tokenizer.peek()
            token2 = self.tokenizer.peek_keepspace()
            if token2.type == TOKEN_LBRA:
                self.tokenizer.get()
                if self.tokenizer.peek().type == TOKEN_COLON:
                    self.tokenizer.get()
                    node = self.exprnode(NODE_SLICE)
                    node.expr = lhs
                    node.expr1 = NIL
                    node.expr2 = NIL
                    token = self.tokenizer.peek()
                    if token.type != TOKEN_RBRA:
                        node.expr2 = self.parse_expr1()
                    token = self.tokenizer.peek()
                    if token.type != TOKEN_RBRA:
                        raise Exception(self.err("LvalueParser: unexpected token: %s", token.value))
                    self.tokenizer.get()
                else:
                    expr1 = self.parse_expr1()
                    if self.tokenizer.peek().type == TOKEN_COLON:
                        self.tokenizer.get()
                        node = self.exprnode(NODE_SLICE)
                        node.expr = lhs
                        node.expr1 = expr1
                        node.expr2 = NIL
                        token = self.tokenizer.peek()
                        if token.type != TOKEN_RBRA:
                            node.expr2 = self.parse_expr1()
                        token = self.tokenizer.peek()
                        if token.type != TOKEN_RBRA:
                            raise Exception(self.err("LvalueParser: unexpected token: %s", token.value))
                        self.tokenizer.get()
                    else:
                        node = self.exprnode(NODE_INDEX)
                        node.expr = lhs
                        node.expr1 = expr1
                        token = self.tokenizer.peek()
                        if token.type != TOKEN_RBRA:
                            raise Exception(self.err("LvalueParser: unexpected token: %s", token.value))
                        self.tokenizer.get()
                lhs = node
            elif token2.type == TOKEN_DOT:
                # INDEX or CONCAT
                pos = self.tokenizer.reader.getpos()
                self.tokenizer.get()
                token2 = self.tokenizer.peek_keepspace()
                if token2.type == TOKEN_IDENTIFIER:
                    rhs = self.exprnode(NODE_IDENTIFIER)
                    rhs.value = self.parse_identifier()
                    node = self.exprnode(NODE_DOT)
                    node.lhs = lhs
                    node.rhs = rhs
                else:
                    # to be CONCAT
                    self.tokenizer.reader.setpos(pos)
                    break
                lhs = node
            else:
                break
        return lhs

# expr9: &option
#        variable
#        var{ria}ble
#        $VAR
#        @r
    def parse_lv9(self):
        token = self.tokenizer.peek()
        if token.type == TOKEN_LBPAR:
            node = self.exprnode(NODE_IDENTIFIER)
            node.value = self.parse_identifier()
        elif token.type == TOKEN_OPTION:
            self.tokenizer.get()
            node = self.exprnode(NODE_OPTION)
            node.value = token.value
        elif token.type == TOKEN_IDENTIFIER:
            node = self.exprnode(NODE_IDENTIFIER)
            node.value = self.parse_identifier()
        elif token.type == TOKEN_ENV:
            self.tokenizer.get()
            node = self.exprnode(NODE_ENV)
            node.value = token.value
        elif token.type == TOKEN_REG:
            self.tokenizer.get()
            node = self.exprnode(NODE_REG)
            node.value = token.value
        else:
            raise Exception(self.err("LvalueParser: unexpected token: %s", token.value))
        return node

class StringReader:
    def __init__(self, lines):
        self.lines = lines
        self.buf = []
        self.pos = []
        lnum = 0
        while lnum < viml_len(lines):
            col = 0
            for c in viml_split(lines[lnum], "\\zs"):
                viml_add(self.buf, c)
                viml_add(self.pos, [lnum + 1, col + 1])
                col += viml_len(c)
            while lnum + 1 < viml_len(lines) and viml_eqregh(lines[lnum + 1], "^\\s*\\\\"):
                skip = 1
                col = 0
                for c in viml_split(lines[lnum + 1], "\\zs"):
                    if skip:
                        if c == "\\":
                            skip = 0
                    else:
                        viml_add(self.buf, c)
                        viml_add(self.pos, [lnum + 1, col + 1])
                    col += viml_len(c)
                lnum += 1
            viml_add(self.buf, "<EOL>")
            viml_add(self.pos, [lnum + 1, col + 1])
            lnum += 1
        # for <EOF>
        viml_add(self.pos, [lnum + 1, 0])
        self.i = 0

    def peek(self):
        if self.i >= viml_len(self.buf):
            return "<EOF>"
        return self.buf[self.i]

    def get(self):
        if self.i >= viml_len(self.buf):
            return "<EOF>"
        self.i += 1
        return self.buf[self.i - 1]

    def peekn(self, n):
        pos = self.getpos()
        r = self.getn(n)
        self.setpos(pos)
        return r

    def getn(self, n):
        r = ""
        j = 0
        while self.i < viml_len(self.buf) and (n < 0 or j < n):
            c = self.buf[self.i]
            if c == "<EOL>":
                break
            r += c
            self.i += 1
            j += 1
        return r

    def peekline(self):
        return self.peekn(-1)

    def readline(self):
        r = self.getn(-1)
        self.get()
        return r

    def getstr(self, begin, end):
        r = ""
        for i in viml_range(begin.i, end.i - 1):
            if i >= viml_len(self.buf):
                break
            c = self.buf[i]
            if c == "<EOL>":
                c = "\n"
            r += c
        return r

    def getpos(self):
        lnum, col = self.pos[self.i]
        return AttributeDict({"i":self.i, "lnum":lnum, "col":col})

    def setpos(self, pos):
        self.i = pos.i

class Compiler:
    def __init__(self):
        self.indent = [""]
        self.lines = []

    def out(self, *a000):
        if viml_len(a000) == 1:
            if viml_eqregh(a000[0], "^)\\+$"):
                self.lines[-1] += a000[0]
            else:
                viml_add(self.lines, self.indent[0] + a000[0])
        else:
            viml_add(self.lines, self.indent[0] + viml_printf(*a000))

    def incindent(self, s):
        viml_insert(self.indent, self.indent[0] + s)

    def decindent(self):
        viml_remove(self.indent, 0)

    def compile(self, node):
        if node.type == NODE_TOPLEVEL:
            return self.compile_toplevel(node)
        elif node.type == NODE_COMMENT:
            return self.compile_comment(node)
        elif node.type == NODE_EXCMD:
            return self.compile_excmd(node)
        elif node.type == NODE_FUNCTION:
            return self.compile_function(node)
        elif node.type == NODE_DELFUNCTION:
            return self.compile_delfunction(node)
        elif node.type == NODE_RETURN:
            return self.compile_return(node)
        elif node.type == NODE_EXCALL:
            return self.compile_excall(node)
        elif node.type == NODE_LET:
            return self.compile_let(node)
        elif node.type == NODE_UNLET:
            return self.compile_unlet(node)
        elif node.type == NODE_LOCKVAR:
            return self.compile_lockvar(node)
        elif node.type == NODE_UNLOCKVAR:
            return self.compile_unlockvar(node)
        elif node.type == NODE_IF:
            return self.compile_if(node)
        elif node.type == NODE_WHILE:
            return self.compile_while(node)
        elif node.type == NODE_FOR:
            return self.compile_for(node)
        elif node.type == NODE_CONTINUE:
            return self.compile_continue(node)
        elif node.type == NODE_BREAK:
            return self.compile_break(node)
        elif node.type == NODE_TRY:
            return self.compile_try(node)
        elif node.type == NODE_THROW:
            return self.compile_throw(node)
        elif node.type == NODE_ECHO:
            return self.compile_echo(node)
        elif node.type == NODE_ECHON:
            return self.compile_echon(node)
        elif node.type == NODE_ECHOHL:
            return self.compile_echohl(node)
        elif node.type == NODE_ECHOMSG:
            return self.compile_echomsg(node)
        elif node.type == NODE_ECHOERR:
            return self.compile_echoerr(node)
        elif node.type == NODE_EXECUTE:
            return self.compile_execute(node)
        elif node.type == NODE_CONDEXP:
            return self.compile_condexp(node)
        elif node.type == NODE_LOGOR:
            return self.compile_logor(node)
        elif node.type == NODE_LOGAND:
            return self.compile_logand(node)
        elif node.type == NODE_EQEQQ:
            return self.compile_eqeqq(node)
        elif node.type == NODE_EQEQH:
            return self.compile_eqeqh(node)
        elif node.type == NODE_NOTEQQ:
            return self.compile_noteqq(node)
        elif node.type == NODE_NOTEQH:
            return self.compile_noteqh(node)
        elif node.type == NODE_GTEQQ:
            return self.compile_gteqq(node)
        elif node.type == NODE_GTEQH:
            return self.compile_gteqh(node)
        elif node.type == NODE_LTEQQ:
            return self.compile_lteqq(node)
        elif node.type == NODE_LTEQH:
            return self.compile_lteqh(node)
        elif node.type == NODE_EQTILDQ:
            return self.compile_eqtildq(node)
        elif node.type == NODE_EQTILDH:
            return self.compile_eqtildh(node)
        elif node.type == NODE_NOTTILDQ:
            return self.compile_nottildq(node)
        elif node.type == NODE_NOTTILDH:
            return self.compile_nottildh(node)
        elif node.type == NODE_GTQ:
            return self.compile_gtq(node)
        elif node.type == NODE_GTH:
            return self.compile_gth(node)
        elif node.type == NODE_LTQ:
            return self.compile_ltq(node)
        elif node.type == NODE_LTH:
            return self.compile_lth(node)
        elif node.type == NODE_EQEQ:
            return self.compile_eqeq(node)
        elif node.type == NODE_NOTEQ:
            return self.compile_noteq(node)
        elif node.type == NODE_GTEQ:
            return self.compile_gteq(node)
        elif node.type == NODE_LTEQ:
            return self.compile_lteq(node)
        elif node.type == NODE_EQTILD:
            return self.compile_eqtild(node)
        elif node.type == NODE_NOTTILD:
            return self.compile_nottild(node)
        elif node.type == NODE_GT:
            return self.compile_gt(node)
        elif node.type == NODE_LT:
            return self.compile_lt(node)
        elif node.type == NODE_ISQ:
            return self.compile_isq(node)
        elif node.type == NODE_ISH:
            return self.compile_ish(node)
        elif node.type == NODE_ISNOTQ:
            return self.compile_isnotq(node)
        elif node.type == NODE_ISNOTH:
            return self.compile_isnoth(node)
        elif node.type == NODE_IS:
            return self.compile_is(node)
        elif node.type == NODE_ISNOT:
            return self.compile_isnot(node)
        elif node.type == NODE_ADD:
            return self.compile_add(node)
        elif node.type == NODE_SUB:
            return self.compile_sub(node)
        elif node.type == NODE_CONCAT:
            return self.compile_concat(node)
        elif node.type == NODE_MUL:
            return self.compile_mul(node)
        elif node.type == NODE_DIV:
            return self.compile_div(node)
        elif node.type == NODE_MOD:
            return self.compile_mod(node)
        elif node.type == NODE_NOT:
            return self.compile_not(node)
        elif node.type == NODE_PLUS:
            return self.compile_plus(node)
        elif node.type == NODE_MINUS:
            return self.compile_minus(node)
        elif node.type == NODE_INDEX:
            return self.compile_index(node)
        elif node.type == NODE_SLICE:
            return self.compile_slice(node)
        elif node.type == NODE_DOT:
            return self.compile_dot(node)
        elif node.type == NODE_CALL:
            return self.compile_call(node)
        elif node.type == NODE_NUMBER:
            return self.compile_number(node)
        elif node.type == NODE_STRING:
            return self.compile_string(node)
        elif node.type == NODE_LIST:
            return self.compile_list(node)
        elif node.type == NODE_DICT:
            return self.compile_dict(node)
        elif node.type == NODE_NESTING:
            return self.compile_nesting(node)
        elif node.type == NODE_OPTION:
            return self.compile_option(node)
        elif node.type == NODE_IDENTIFIER:
            return self.compile_identifier(node)
        elif node.type == NODE_ENV:
            return self.compile_env(node)
        elif node.type == NODE_REG:
            return self.compile_reg(node)
        else:
            raise Exception(self.err("Compiler: unknown node: %s", viml_string(node)))

    def compile_body(self, body):
        for node in body:
            self.compile(node)

    def compile_begin(self, body):
        if viml_len(body) == 1:
            self.compile_body(body)
        else:
            self.out("(begin")
            self.incindent("  ")
            self.compile_body(body)
            self.out(")")
            self.decindent()

    def compile_toplevel(self, node):
        self.compile_body(node.body)
        return self.lines

    def compile_comment(self, node):
        self.out(";%s", node.str)

    def compile_excmd(self, node):
        self.out("(excmd \"%s\")", viml_escape(node.str, "\\\""))

    def compile_function(self, node):
        name = self.compile(node.name)
        if not viml_empty(node.args) and node.args[-1] == "...":
            node.args[-1] = ". ..."
        self.out("(function %s (%s)", name, viml_join(node.args, " "))
        self.incindent("  ")
        self.compile_body(node.body)
        self.out(")")
        self.decindent()

    def compile_delfunction(self, node):
        self.out("(delfunction %s)", self.compile(node.name))

    def compile_return(self, node):
        if node.arg is NIL:
            self.out("(return)")
        else:
            self.out("(return %s)", self.compile(node.arg))

    def compile_excall(self, node):
        self.out("(call %s)", self.compile(node.expr))

    def compile_let(self, node):
        lhs = viml_join([self.compile(vval) for vval in node.lhs.args], " ")
        if node.lhs.rest is not NIL:
            lhs += " . " + self.compile(node.lhs.rest)
        rhs = self.compile(node.rhs)
        self.out("(let %s (%s) %s)", node.op, lhs, rhs)

    def compile_unlet(self, node):
        args = [self.compile(vval) for vval in node.args]
        self.out("(unlet %s)", viml_join(args, " "))

    def compile_lockvar(self, node):
        args = [self.compile(vval) for vval in node.args]
        self.out("(lockvar %s %s)", node.depth, viml_join(args, " "))

    def compile_unlockvar(self, node):
        args = [self.compile(vval) for vval in node.args]
        self.out("(unlockvar %s %s)", node.depth, viml_join(args, " "))

    def compile_if(self, node):
        self.out("(if %s", self.compile(node.cond))
        self.incindent("  ")
        self.compile_begin(node.body)
        self.decindent()
        for enode in node.elseif:
            self.out(" elseif %s", self.compile(enode.cond))
            self.incindent("  ")
            self.compile_begin(enode.body)
            self.decindent()
        if node._else is not NIL:
            self.out(" else")
            self.incindent("  ")
            self.compile_begin(node._else.body)
            self.decindent()
        self.incindent("  ")
        self.out(")")
        self.decindent()

    def compile_while(self, node):
        self.out("(while %s", self.compile(node.cond))
        self.incindent("  ")
        self.compile_body(node.body)
        self.out(")")
        self.decindent()

    def compile_for(self, node):
        lhs = viml_join([self.compile(vval) for vval in node.lhs.args], " ")
        if node.lhs.rest is not NIL:
            lhs += " . " + self.compile(node.lhs.rest)
        rhs = self.compile(node.rhs)
        self.out("(for (%s) %s", lhs, rhs)
        self.incindent("  ")
        self.compile_body(node.body)
        self.out(")")
        self.decindent()

    def compile_continue(self, node):
        self.out("(continue)")

    def compile_break(self, node):
        self.out("(break)")

    def compile_try(self, node):
        self.out("(try")
        self.incindent("  ")
        self.compile_begin(node.body)
        for cnode in node.catch:
            if cnode.pattern is not NIL:
                self.out("(#/%s/", cnode.pattern)
                self.incindent("  ")
                self.compile_body(cnode.body)
                self.out(")")
                self.decindent()
            else:
                self.out("(else")
                self.incindent("  ")
                self.compile_body(cnode.body)
                self.out(")")
                self.decindent()
        if node._finally is not NIL:
            self.out("(finally")
            self.incindent("  ")
            self.compile_body(node._finally.body)
            self.out(")")
            self.decindent()
        self.out(")")
        self.decindent()

    def compile_throw(self, node):
        self.out("(throw %s)", self.compile(node.arg))

    def compile_echo(self, node):
        args = [self.compile(vval) for vval in node.args]
        self.out("(echo %s)", viml_join(args, " "))

    def compile_echon(self, node):
        args = [self.compile(vval) for vval in node.args]
        self.out("(echon %s)", viml_join(args, " "))

    def compile_echohl(self, node):
        self.out("(echohl \"%s\")", viml_escape(node.name, "\\\""))

    def compile_echomsg(self, node):
        args = [self.compile(vval) for vval in node.args]
        self.out("(echomsg %s)", viml_join(args, " "))

    def compile_echoerr(self, node):
        args = [self.compile(vval) for vval in node.args]
        self.out("(echoerr %s)", viml_join(args, " "))

    def compile_execute(self, node):
        args = [self.compile(vval) for vval in node.args]
        self.out("(execute %s)", viml_join(args, " "))

    def compile_condexp(self, node):
        return viml_printf("(?: %s %s %s)", self.compile(node.cond), self.compile(node.then), self.compile(node._else))

    def compile_logor(self, node):
        return viml_printf("(|| %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_logand(self, node):
        return viml_printf("(&& %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_eqeqq(self, node):
        return viml_printf("(==? %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_eqeqh(self, node):
        return viml_printf("(==# %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_noteqq(self, node):
        return viml_printf("(!=? %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_noteqh(self, node):
        return viml_printf("(!=# %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_gteqq(self, node):
        return viml_printf("(>=? %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_gteqh(self, node):
        return viml_printf("(>=# %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_lteqq(self, node):
        return viml_printf("(<=? %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_lteqh(self, node):
        return viml_printf("(<=# %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_eqtildq(self, node):
        return viml_printf("(=~? %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_eqtildh(self, node):
        return viml_printf("(=~# %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_nottildq(self, node):
        return viml_printf("(!~? %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_nottildh(self, node):
        return viml_printf("(!~# %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_gtq(self, node):
        return viml_printf("(>? %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_gth(self, node):
        return viml_printf("(># %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_ltq(self, node):
        return viml_printf("(<? %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_lth(self, node):
        return viml_printf("(<# %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_eqeq(self, node):
        return viml_printf("(== %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_noteq(self, node):
        return viml_printf("(!= %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_gteq(self, node):
        return viml_printf("(>= %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_lteq(self, node):
        return viml_printf("(<= %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_eqtild(self, node):
        return viml_printf("(=~ %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_nottild(self, node):
        return viml_printf("(!~ %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_gt(self, node):
        return viml_printf("(> %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_lt(self, node):
        return viml_printf("(< %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_isq(self, node):
        return viml_printf("(is? %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_ish(self, node):
        return viml_printf("(is# %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_isnotq(self, node):
        return viml_printf("(isnot? %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_isnoth(self, node):
        return viml_printf("(isnot# %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_is(self, node):
        return viml_printf("(is %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_isnot(self, node):
        return viml_printf("(isnot %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_add(self, node):
        return viml_printf("(+ %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_sub(self, node):
        return viml_printf("(- %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_concat(self, node):
        return viml_printf("(concat %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_mul(self, node):
        return viml_printf("(* %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_div(self, node):
        return viml_printf("(/ %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_mod(self, node):
        return viml_printf("(%% %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_not(self, node):
        return viml_printf("(! %s)", self.compile(node.expr))

    def compile_plus(self, node):
        return viml_printf("(+ %s)", self.compile(node.expr))

    def compile_minus(self, node):
        return viml_printf("(- %s)", self.compile(node.expr))

    def compile_index(self, node):
        return viml_printf("(index %s %s)", self.compile(node.expr), self.compile(node.expr1))

    def compile_slice(self, node):
        expr1 = "nil" if node.expr1 is NIL else self.compile(node.expr1)
        expr2 = "nil" if node.expr2 is NIL else self.compile(node.expr2)
        return viml_printf("(slice %s %s %s)", self.compile(node.expr), expr1, expr2)

    def compile_dot(self, node):
        return viml_printf("(dot %s %s)", self.compile(node.lhs), self.compile(node.rhs))

    def compile_call(self, node):
        args = [self.compile(vval) for vval in node.args]
        return viml_printf("(%s %s)", self.compile(node.expr), viml_join(args, " "))

    def compile_number(self, node):
        return node.value

    def compile_string(self, node):
        return node.value

    def compile_list(self, node):
        items = [self.compile(vval) for vval in node.items]
        if viml_empty(items):
            return "(list)"
        else:
            return viml_printf("(list %s)", viml_join(items, " "))

    def compile_dict(self, node):
        items = ["(" + self.compile(vval[0]) + " " + self.compile(vval[1]) + ")" for vval in node.items]
        if viml_empty(items):
            return "(dict)"
        else:
            return viml_printf("(dict %s)", viml_join(items, " "))

    def compile_nesting(self, node):
        return self.compile(node.expr)

    def compile_option(self, node):
        return node.value

    def compile_identifier(self, node):
        v = ""
        for x in node.value:
            if x.curly:
                v += "{" + self.compile(x.value) + "}"
            else:
                v += x.value
        return v

    def compile_env(self, node):
        return node.value

    def compile_reg(self, node):
        return node.value


main()
