" Vim syntax file
" Language:	MHonArc Resource File
" Maintainer:	Earl Hood <earlhood@usa.net>
" Last change:	98/10/10 15:49:20

"	Adapted from the following:
" Language:	HTML
" Maintainer:	Claudio Fleiner <claudio@fleiner.com>
" URL:		http://www.fleiner.com/vim/syntax/html.vim
" Last change:	1998 Mar 28

"   Differences
"   o	HTML tags and arguments are highlighted with
"	Function to separate them from MHonArc markup.
"   o	html_no_rendering is hardcoded to 1.
"   o	htmlSpecialChar is highlighted with Function since
"    	Special is used for resource variables.

let html_no_rendering = 1

" Remove any old syntax stuff hanging around
syn clear
syn case ignore

" Known tag names and arg names are colored the same way
" as statements and types, while unknwon ones as function.

" mark illegal characters
syn match htmlError "[<>&]"

" tags
syn match   htmlSpecial  contained "\\[0-9][0-9][0-9]\|\\."
syn region  htmlString   contained start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=mhaRcVar,htmlSpecial,javaScriptExpression
syn region  htmlString   contained start=+'+ skip=+\\\\\|\\'+ end=+'+ contains=mhaRcVar,htmlSpecial,javaScriptExpression
syn match   htmlValue    contained "=[\t ]*[^'" \t>][^ \t>]*"hs=s+1   contains=mhaRcVar,javaScriptExpression
syn region  htmlEndTag             start=+</+    end=+>+              contains=mhaRcVar,mhaTagName,htmlTagName,htmlTagError
syn region  htmlTag                start=+<[^/]+ end=+>+              contains=mhaTagName,mhaArg,mhaRcVar,htmlString,htmlTagName,htmlArg,htmlValue,htmlTagError,htmlEvent
syn match   htmlTagError contained "[^>]<"ms=s+1

syn region  mhaRcVar	 	   start=+\$+ end=+\$+		      contains=mhaRcVarArg
syn region  mhaRcVarArg	 contained start=+(+  end=+)+
" syn match mhaRcVar	  "\$[^$]*\$"

" MHonArc tag names
syn keyword mhaTagName contained annotate archive authorbegin authorend authsort
syn keyword mhaTagName contained botlinks charsetconverters conlen datefields
syn keyword mhaTagName contained daybegin dayend dbfile decodeheads definederived
syn keyword mhaTagName contained definevar defrcfile defrcname doc docurl
syn keyword mhaTagName contained editidx excs expireage expiredate
syn keyword mhaTagName contained fieldorder fieldsbeg fieldsend fieldstyles
syn keyword mhaTagName contained fldbeg fldend folrefs folupbegin folupend
syn keyword mhaTagName contained foluplitxt footer force fromfields genidx
syn keyword mhaTagName contained gmtdatefmt gzipexe gzipfiles gziplinks headbodysep
syn keyword mhaTagName contained header htmlext icons idxfname idxlabel
syn keyword mhaTagName contained idxpgbegin idxpgend idxprefix idxsize include
syn keyword mhaTagName contained labelbeg labelend labelstyles listbegin listend
syn keyword mhaTagName contained litemplate localdatefmt lock lockdelay locktries
syn keyword mhaTagName contained mailto mailtourl main maxsize mhpattern mimeargs
syn keyword mhaTagName contained mimefilters modtime months monthsabr msgbodyend
syn keyword mhaTagName contained msgfoot msggmtdatefmt msghead msgidlink
syn keyword mhaTagName contained msglocaldatefmt msgpgbegin msgpgend msgprefix
syn keyword mhaTagName contained msgpgs msgsep multipg news nextbutton nextbuttonia
syn keyword mhaTagName contained nextlink nextlinkia nextpglink nextpglinkia
syn keyword mhaTagName contained nofolrefs nomsgpgs noreverse nothread notreverse
syn keyword mhaTagName contained nouselocaltime
syn keyword mhaTagName contained note noteia notetext otherindexes outdir pagenum
syn keyword mhaTagName contained perlinc prevbutton prevbuttonia prevlink
syn keyword mhaTagName contained prevlinkia prevpglink prevpglinkia quiet readdb
syn keyword mhaTagName contained rcfile refsbegin refsend refslitxt reverse
syn keyword mhaTagName contained rmm scan single sort subjectarticlerxp
syn keyword mhaTagName contained subjectbegin subjectend subjectheader
syn keyword mhaTagName contained subjectreplyrxp subjectstripcode subsort
syn keyword mhaTagName contained tcontbegin tcontend tfoot thead thread
syn keyword mhaTagName contained tidxfname tidxlabel tidxpgbegin tidxpgend
syn keyword mhaTagName contained tidxprefix timezones tindentbegin tindentend
syn keyword mhaTagName contained title tlevels tliend tlinone tlinoneend tlitxt
syn keyword mhaTagName contained tnextbutton tnextbuttonia tnextlink tnextlinkia
syn keyword mhaTagName contained tnextpglink tnextpglinkia toplinks tprevbutton
syn keyword mhaTagName contained tprevbuttonia tprevlink tprevlinkia tprevpglink
syn keyword mhaTagName contained tprevpglinkia treverse tsingletxt tslice
syn keyword mhaTagName contained tslicebeg tsliceend tsort tsubjectbeg
syn keyword mhaTagName contained tsubjectend tsublistbeg tsublistend tsubsort
syn keyword mhaTagName contained ttitle ttopbegin ttopend umask uselocaltime
syn keyword mhaTagName contained usinglastpg weekdays weekdaysabr 

" MHonArc legal arg names
syn keyword mhaArg     contained chop override

" tag names
syn keyword htmlTagName contained address applet area a base basefont
syn keyword htmlTagName contained big blockquote br caption center
syn keyword htmlTagName contained cite code dd dfn dir div dl dt font
syn keyword htmlTagName contained form hr html img
syn keyword htmlTagName contained input isindex kbd li link map menu
syn keyword htmlTagName contained meta ol option param pre p samp span
syn keyword htmlTagName contained select small strike style sub sup
syn keyword htmlTagName contained table td textarea th tr tt ul var
syn match htmlTagName contained "\<\(b\|i\|u\|h[1-6]\|em\|strong\|head\|body\|title\)\>"

" legal arg names
syn keyword htmlArg contained action
syn keyword htmlArg contained align alink alt archive background bgcolor
syn keyword htmlArg contained border bordercolor cellpadding
syn keyword htmlArg contained cellspacing checked clear code codebase color
syn keyword htmlArg contained cols colspan content coords enctype face
syn keyword htmlArg contained gutter height hspace
syn keyword htmlArg contained link lowsrc marginheight
syn keyword htmlArg contained marginwidth maxlength method name prompt
syn keyword htmlArg contained rel rev rows rowspan scrolling selected shape
syn keyword htmlArg contained size src start target text type url
syn keyword htmlArg contained usemap ismap valign value vlink vspace width wrap
syn match   htmlArg contained "http-equiv"
syn match   htmlArg contained "href"

" Netscape extensions
syn keyword htmlTagName contained frame frameset nobr 
syn keyword htmlTagName contained layer ilayer nolayer spacer
syn keyword htmlArg     contained frameborder noresize pagex pagey above below
syn keyword htmlArg     contained left top visibility clip id noshade
syn match   htmlArg     contained "z-index"

" special characters
syn match htmlSpecialChar "&[^;]*;"

" The real comments (this implements the comments as defined by html,
" but not all html pages actually conform to it. Errors are flagged.
syn region htmlComment                start=+<!+        end=+>+ contains=htmlCommentPart,htmlCommentError
syn region htmlComment                start=+<!DOCTYPE+ end=+>+
syn match  htmlCommentError contained "[^><!]"
syn region htmlCommentPart  contained start=+--+        end=+--+

" server-parsed commands
syn region htmlPreProc start=+<!--#+ end=+-->+

if !exists("html_no_rendering")
  " rendering
  syn region htmlBold start="<b\>" end="</b>"me=e-4 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript,htmlBoldUnderline,htmlBoldItalic
  syn region htmlBold start="<strong\>" end="</strong>"me=e-9 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript,htmlBoldUnderline,htmlBoldItalic
  syn region htmlBoldUnderline contained start="<u\>" end="</u>"me=e-4 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript,htmlBoldUnderlineItalic
  syn region htmlBoldItalic contained start="<i\>" end="</i>"me=e-4 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript,htmlBoldItalicUnderline
  syn region htmlBoldItalic contained start="<em\>" end="</em>"me=e-5 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript,htmlBoldItalicUnderline
  syn region htmlBoldUnderlineItalic contained start="<i\>" end="</i>"me=e-4 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript
  syn region htmlBoldUnderlineItalic contained start="<em\>" end="</em>"me=e-5 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript
  syn region htmlBoldItalicUnderline contained start="<u\>" end="</u>"me=e-4 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript,htmlBoldUnderlineItalic
  
  syn region htmlUnderline start="<u\>" end="</u>"me=e-4 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript,htmlUnderlineBold,htmlUnderlineItalic
  syn region htmlUnderlineBold contained start="<b\>" end="</b>"me=e-4 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript,htmlUnderlineBoldItalic
  syn region htmlUnderlineBold contained start="<strong\>" end="</strong>"me=e-9 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript,htmlUnderlineBoldItalic
  syn region htmlUnderlineItalic contained start="<i\>" end="</i>"me=e-4 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript,htmUnderlineItalicBold
  syn region htmlUnderlineItalic contained start="<em\>" end="</em>"me=e-5 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript,htmUnderlineItalicBold
  syn region htmlUnderlineItalicBold contained start="<b\>" end="</b>"me=e-4 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript
  syn region htmlUnderlineItalicBold contained start="<strong\>" end="</strong>"me=e-9 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript
  syn region htmlUnderlineBoldItalic contained start="<i\>" end="</i>"me=e-4 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript
  syn region htmlUnderlineBoldItalic contained start="<em\>" end="</em>"me=e-5 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript
  
  syn region htmlItalic start="<i\>" end="</i>"me=e-4 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript,htmlItalicBold,htmlItalicUnderline
  syn region htmlItalic start="<em\>" end="</em>"me=e-5 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript
  syn region htmlItalicBold contained start="<b\>" end="</b>"me=e-4 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript,htmlItalicBoldUnderline
  syn region htmlItalicBold contained start="<strong\>" end="</strong>"me=e-9 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript,htmlItalicBoldUnderline
  syn region htmlItalicBoldUnderline contained start="<u\>" end="</u>"me=e-4 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript
  syn region htmlItalicUnderline contained start="<u\>" end="</u>"me=e-4 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript,htmlItalicUnderlineBold
  syn region htmlItalicUnderlineBold contained start="<b\>" end="</b>"me=e-4 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript
  syn region htmlItalicUnderlineBold contained start="<strong\>" end="</strong>"me=e-9 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript
  
  syn region htmlLink start="<a\>[^>]*href\>" end="</a>"me=e-4 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,javaScript
  syn region htmlH1 start="<h1\>" end="</h1>"me=e-5 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript
  syn region htmlH2 start="<h2\>" end="</h2>"me=e-5 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript
  syn region htmlH3 start="<h3\>" end="</h3>"me=e-5 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript
  syn region htmlH4 start="<h4\>" end="</h4>"me=e-5 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript
  syn region htmlH5 start="<h5\>" end="</h5>"me=e-5 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript
  syn region htmlH6 start="<h6\>" end="</h6>"me=e-5 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScript
  syn region htmlHead start="<head\>" end="</head>"me=e-7 end="<body\>"me=e-5 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,htmlTitle,javaScript
  syn region htmlTitle start="<title\>" end="</title>"me=e-8 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,javaScript
endif

" JAVA SCRIPT
syn keyword htmlTagName                contained noscript

" html events (i.e. arguments that include javascript commands)
syn region htmlEvent        contained start=+on[a-z]\+\s*=[\t ]*'+ skip=+\\\\\|\\'+ end=+'+ contains=javaScriptSpecial,javaScriptNumber,javaScriptLineComment,javaScriptComment,javaScriptStringD,javaStringCharacter,javaStringSpecialCharacter,javaScriptConditional,javaScriptRepeat,javaScriptBranch,javaScriptOperator,javaScriptType,javaScriptStatement,javaScriptFunction,javaScriptBoolean,javaScriptBraces,javaScriptParen,javaScriptParenError
syn region htmlEvent        contained start=+on[a-z]\+\s*=[\t ]*"+ skip=+\\\\\|\\"+ end=+"+ contains=javaScriptSpecial,javaScriptNumber,javaScriptLineComment,javaScriptComment,javaScriptStringS,javaStringCharacter,javaStringSpecialCharacter,javaScriptConditional,javaScriptRepeat,javaScriptBranch,javaScriptOperator,javaScriptType,javaScriptStatement,javaScriptFunction,javaScriptBoolean,javaScriptBraces,javaScriptParen,javaScriptParenError

" a javascript expression is used as an arg value
syn region  javaScriptExpression                 start=+&{+ end=+};+ contains=javaScriptSpecial,javaScriptNumber,javaScriptLineComment,javaScriptComment,javaScriptStringS,javaScriptStringD,javaStringCharacter,javaScriptSpecialCharacter,javaScriptConditional,javaScriptRepeat,javaScriptBranch,javaScriptOperator,javaScriptType,javaScriptStatement,javaScriptBoolean,javaScriptFunction

" javascript starts with <SCRIPT and ends with </SCRIPT>
syn region  javaScript                           start=+<script+ end=+</script>+ contains=javaScriptSpecial,javaScriptNumber,javaScriptLineComment,javaScriptComment,javaScriptStringS,javaScriptStringD,javaStringCharacter,javaStringSpecialCharacter,javaScriptConditional,javaScriptRepeat,javaScriptBranch,javaScriptOperator,javaScriptType,javaScriptStatement,javaScriptFunction,javaScriptBoolean,javaScriptBraces,javaScriptParen,javaScriptParenError
syn match   javaScriptLineComment      contained "\/\/.*$"
syn match   javaScriptCommentSkip      contained "^\s*\*\($\|\s\+\)"
syn region  javaScriptCommentString    contained start=+"+  skip=+\\\\\|\\"+  end=+"+ end=+\*/+me=s-1,he=s-1 contains=javaScriptSpecial,javaScriptCommentSkip
syn region  javaScriptComment2String   contained start=+"+  skip=+\\\\\|\\"+  end=+$\|"+  contains=javaScriptSpecial
syn region  javaScriptComment          contained start="/\*"  end="\*/" contains=javaScriptCommentString,javaScriptCharacter,javaScriptNumber
syn match   javaScriptSpecial          contained "\\[0-9][0-9][0-9]\|\\."
syn region  javaScriptStringD          contained start=+"+  skip=+\\\\\|\\"+  end=+"+  contains=javaScriptSpecial
syn region  javaScriptStringS          contained start=+'+  skip=+\\\\\|\\'+  end=+'+  contains=javaScriptSpecial
syn match   javaScriptSpecialCharacter contained "'\\.'"
syn match   javaScriptNumber           contained "-\=\<[0-9]\+L\=\>\|0[xX][0-9a-fA-F]\+\>"
syn keyword javaScriptConditional      contained if else
syn keyword javaScriptRepeat           contained while for
syn keyword javaScriptBranch           contained break continue
syn keyword javaScriptOperator         contained new in
syn keyword javaScriptType             contained this var
syn keyword javaScriptStatement        contained return with
syn keyword javaScriptFunction         contained function
syn keyword javaScriptBoolean          contained true false
syn match   javaScriptBraces           contained "[{}]"
" catch errors caused by wrong parenthesis
syn region  javaScriptParen            contained start="(" end=")" contains=javaScriptSpecial,javaScriptNumber,javaScriptLineComment,javaScriptComment,javaScriptStringS,javaScriptStringD,javaStringCharacter,javaStringSpecialCharacter,javaScriptConditional,javaScriptRepeat,javaScriptBranch,javaScriptOperator,javaScriptType,javaScriptStatement,javaScriptFunction,javaScriptBoolean,javaScriptBraces,javaScriptParen
syn match   javaScriptParenError       contained ")"
syn match   javaScriptInParen          contained "[{}]"

" synchronizing (does not always work if a comment includes legal
" html tags, but doing it right would mean to always start
" at the first line, which is too slow)
syn sync match htmlHighlight groupthere NONE "<[/a-zA-Z]"
syn sync match htmlHighlight groupthere javaScript "<script"
syn sync match htmlHighlightSkip "^.*['\"].*$"
syn sync minlines=10

if !exists("did_html_syntax_inits")
  let did_html_syntax_inits = 1
  " The default methods for highlighting.  Can be overridden later
  hi link mhaTagName              htmlStatement
  hi link mhaArg                  Type

  hi link htmlTag                 Function
  hi link htmlEndTag              Identifier
  " hi link htmlArg                 Type
  hi link htmlArg                 Function
  " hi link htmlTagName             htmlStatement
  hi link htmlTagName             Function
  hi link htmlValue               Value
  hi link htmlSpecialChar         Special

  if !exists("html_no_rendering") 
    hi link htmlH1                  Title
    hi link htmlH2                  htmlH1
    hi link htmlH3                  htmlH2
    hi link htmlH4                  htmlH3
    hi link htmlH5                  htmlH4
    hi link htmlH6                  htmlH5
    hi link htmlHead                PreProc
    hi link htmlTitle               Title
    hi link htmlBoldItalicUnderline htmlBoldUnderlineItalic
    hi link htmlUnderlineBold       htmlBoldUnderline 
    hi link htmlUnderlineItalicBold htmlBoldUnderlineItalic
    hi link htmlUnderlineBoldItalic htmlBoldUnderlineItalic
    hi link htmlItalicUnderline     htmlUnderlineItalic
    hi link htmlItalicBold          htmlBoldItalic
    hi link htmlItalicBoldUnderline htmlBoldUnderlineItalic
    hi link htmlItalicUnderlineBold htmlBoldUnderlineItalic
    if !exists("html_my_rendering")
      hi htmlLink                term=underline cterm=underline ctermfg=blue gui=underline guifg=blue
      hi htmlBold                term=bold cterm=bold gui=bold
      hi htmlBoldUnderline       term=bold,underline cterm=bold,underline gui=bold,underline
      hi htmlBoldItalic          term=bold,italic cterm=bold,italic gui=bold,italic
      hi htmlBoldUnderlineItalic term=bold,italic,underline cterm=bold,italic,underline gui=bold,italic,underline
      hi htmlUnderline           term=underline cterm=underline gui=underline
      hi htmlUnderlineItalic     term=italic,underline cterm=italic,underline gui=italic,underline
      hi htmlItalic              term=italic cterm=italic gui=italic
    endif
  endif

  hi link mhaRcVar                      Special
  hi link mhaRcVarArg                   String

  hi link htmlSpecial                   Special
  " hi link htmlSpecialChar               Special
  hi link htmlSpecialChar               Function
  hi link htmlString                    String
  hi link htmlStatement                 Statement
  hi link htmlComment                   Comment
  hi link htmlCommentPart               Comment
  hi link htmlPreProc                   PreProc
  hi link htmlValue                     String
  hi link htmlCommentError              htmlError
  hi link htmlTagError                  htmlError
  hi link htmlEvent                     javaScript
  hi link htmlError			Error

  hi link javaScript                    Special
  hi link javaScriptExpression          javaScript
  hi link javaScriptComment             Comment
  hi link javaScriptLineComment         Comment
  hi link javaScriptSpecial             javaScript
  hi link javaScriptStringS             String
  hi link javaScriptStringD             String
  hi link javaScriptCharacter           Character
  hi link javaScriptSpecialCharacter    javaScriptSpecial
  hi link javaScriptNumber              javaScriptValue
  hi link javaScriptConditional         Conditional
  hi link javaScriptRepeat              Repeat
  hi link javaScriptBranch              Conditional
  hi link javaScriptOperator            Operator
  hi link javaScriptType                Type
  hi link javaScriptStatement           Statement
  hi link javaScriptFunction            Function
  hi link javaScriptBoolean             Boolean
  hi link javaScriptError               Error
  hi link javaScriptBraces              Function
  hi link javaScriptParenError          javaScriptError
  hi link javaScriptInParen             javaScriptError
  hi link javaScriptParen               javaScript

endif

let b:current_syntax = "html"

" vim: ts=8
