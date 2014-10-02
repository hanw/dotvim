<<<<<<< HEAD
" Language:     Verilog/SystemVerilog HDL
" Maintainer:	Amit Sethi <amitrajsethi@yahoo.com>
" Last Change:	Thu Jul 27 12:09:48 IST 2006
=======
" Language:     SystemVerilog HDL
" Maintainer:   WeiChung Wu <exelion04 at gmail dot com>
" Last Change:  Thu Aug 22 18:53:42 CST 2011
>>>>>>> 3e1a07b35122d6d8d8d5efc4a6e32bd0ce08c7c2
"
" Credits:
"   Originally created by
"       Chih-Tsun Huang <cthuang@larc.ee.nthu.edu.tw>
<<<<<<< HEAD
" 	http://larc.ee.nthu.edu.tw/~cthuang/vim/indent/verilog.vim
"   Suggestions for improvement, bug reports by
"     Leo Butlero <lbutler@brocade.com>
"
" Buffer Variables:
"     b:verilog_indent_modules : indenting after the declaration
"				 of module blocks
"     b:verilog_indent_width   : indenting width
"     b:verilog_indent_verbose : verbose to each indenting
"
" Revision Comments:
"     Amit Sethi - Wed Jun 28 18:20:44 IST 2006
"       Added SystemVerilog specific indentations
"     Amit Sethi - Thu Jul 27 12:09:48 IST 2006
"       Changed conflicting function name
=======
"       http://larc.ee.nthu.edu.tw/~cthuang/vim/indent/verilog.vim
"
" Buffer Variables:
"     b:sv_indent_modules : indenting after the declaration
"                                of module blocks
"     b:sv_indent_width   : indenting width
"     b:sv_indent_verbose : verbose to each indenting
"
" Revision Comments:
>>>>>>> 3e1a07b35122d6d8d8d5efc4a6e32bd0ce08c7c2
"

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

<<<<<<< HEAD
setlocal indentexpr=GetVerilog_SystemVerilogIndent()
=======
setlocal indentexpr=GetSystemVerilogIndent()
>>>>>>> 3e1a07b35122d6d8d8d5efc4a6e32bd0ce08c7c2
setlocal indentkeys=!^F,o,O,0),0},=begin,=end,=join,=endcase,=join_any,=join_none
setlocal indentkeys+==endmodule,=endfunction,=endtask,=endspecify
setlocal indentkeys+==endclass,=endpackage,=endsequence,=endclocking
setlocal indentkeys+==endinterface,=endgroup,=endprogram,=endproperty
setlocal indentkeys+==`else,=`endif

" Only define the function once.
<<<<<<< HEAD
if exists("*GetVerilog_SystemVerilogIndent")
=======
if exists("*GetSystemVerilogIndent")
>>>>>>> 3e1a07b35122d6d8d8d5efc4a6e32bd0ce08c7c2
  finish
endif

set cpo-=C

<<<<<<< HEAD
function GetVerilog_SystemVerilogIndent()

  if exists('b:verilog_indent_width')
    let offset = b:verilog_indent_width
  else
    let offset = &sw
  endif
  if exists('b:verilog_indent_modules')
=======
" Check if the column is a comment
function s:IsSVColComment(lnum, cnum)
  let rc = synIDattr(synID(a:lnum, a:cnum, 0), "name") =~? 'comment\|string'
  return rc
endfunction

" Check if the line is a fully comment, or part of comment
function s:IsSVLineComment(lnum)
  let line = getline(a:lnum)
  let rc = (line =~ '^\s*\/\/' ||
   \        ( s:IsSVColComment(a:lnum, match(line,'\S')+1) && 
   \         ((line !~ '\*\/\s*\S') ||
   \          (line =~ '\*\/\s*\S' && s:IsSVColComment(a:lnum, matchend(line,'\*\/\s*\S'))) 
   \         ) 
   \        )) ? 1: 0
  return rc
endfunction

function s:PrevNonBlankNonComment(lnum)
  let lnum = prevnonblank(a:lnum)
  while lnum > 0
    if 0 == s:IsSVLineComment(lnum)
      break
    endif
    let lnum = prevnonblank(lnum - 1)
  endwhile
  return lnum
endfunction

function s:RemoveSVComment(line)
  let myline = substitute(a:line,'\%(\/\/.*\|\/\*.*\*\/\s*\)',"","g")
  let myline = substitute(myline,'\%(^.*\*\/\|\/\*.*$\)',"","g")
  let myline = substitute(myline,'^\s*',"","")
  "let myline = substitute(myline,'\s*\/\s*$',"","") "remove \
  return myline
endfunction

function s:GetSVBlockStart(keyword, curr_lnum, mode)
  let lnum  = a:curr_lnum
  let pmid = ''
  if a:keyword =~ '\<end\>'
    let pend   = '\<end\>'
    let pstart = '\<begin\>'
  elseif a:keyword =~ '`\@<!\<else\>'
    let pend   = '\<else\>'
    let pstart = '\<if\>'
  elseif a:keyword =~ 'join'
    let pend   = '\<\%(join\|join_any\|join_none\)\>'
    let pstart = '\%(disable\s\+\)\@<!\<fork\>'
  elseif a:keyword =~ ')'
    let pend   = ')'
    let pstart = '('
  elseif a:keyword =~ '}'
    let pend   = '}'
    let pstart = '{'
  elseif a:keyword =~ '\<endcase\>'
    let pend   = '\<endcase\>'
    let pstart = '\<\%(case\%[zx]\|randcase\)\>'
  elseif a:keyword =~ '\<endgroup\>'
    let pend   = '\<endgroup\>'
    let pstart = '\<covergroup\>'
  elseif a:keyword =~ '\<endsequence\>'
    let pend   = '\<endsequence\>'
    let pstart = '\<randsequence\>'
  elseif a:keyword =~ '`else'
    let pend   = '`else'
    let pstart = '`if\%[n]def'
  elseif a:keyword =~ '`endif'
    let pend   = '`endif'
    let pstart = '`if\%[n]def'
    let pmid   = '`else'
  else
    let pend = '\<' . a:keyword . '\>'
    "let pstart = '\<' . substitute(a:keyword,'^end','','') . '\>'
    let pstart = '\<' . strpart(a:keyword,3) . '\>'
  endif
  let skip = "s:IsSVColComment(line('.'),col('.'))"
  call cursor(lnum, 1)
  let m_lnum = searchpair(pstart, pmid, pend, 'bW', skip)
  let ind = m_lnum > 0 && m_lnum < lnum ?
           \ indent(m_lnum) : indent(lnum)
  let result = a:mode=='line'   ?  m_lnum :
             \ a:mode=='indent' ?  ind : 0
  if exists('b:sv_indent_verbose')
    echo pend . ' ' . pstart . ' m:' . m_lnum . ' c:' . lnum . ' i:' . ind . "\n"
  endif
  return result
endfunction

function GetSystemVerilogIndent()

  if exists('b:sv_indent_width')
    let offset = b:sv_indent_width
  else
    let offset = &sw
  endif
  if exists('b:sv_indent_modules')
>>>>>>> 3e1a07b35122d6d8d8d5efc4a6e32bd0ce08c7c2
    let indent_modules = offset
  else
    let indent_modules = 0
  endif

<<<<<<< HEAD
  " Find a non-blank line above the current line.
  let lnum = prevnonblank(v:lnum - 1)
=======
  " Find a non-blank, non-comment line above the current line.
  let lnum = s:PrevNonBlankNonComment(v:lnum - 1)
>>>>>>> 3e1a07b35122d6d8d8d5efc4a6e32bd0ce08c7c2

  " At the start of the file use zero indent.
  if lnum == 0
    return 0
  endif

<<<<<<< HEAD
  let lnum2 = prevnonblank(lnum - 1)
  let curr_line  = getline(v:lnum)
  let last_line  = getline(lnum)
  let last_line2 = getline(lnum2)
  let ind  = indent(lnum)
  let ind2 = indent(lnum - 1)
  let offset_comment1 = 1
  " Define the condition of an open statement
  "   Exclude the match of //, /* or */
  let vlog_openstat = '\(\<or\>\|\([*/]\)\@<![*(,{><+-/%^&|!=?:]\([*/]\)\@!\)'
  " Define the condition when the statement ends with a one-line comment
  let vlog_comment = '\(//.*\|/\*.*\*/\s*\)'
  if exists('b:verilog_indent_verbose')
=======
  let lnum2 = s:PrevNonBlankNonComment(lnum - 1)
  let curr_line  = s:RemoveSVComment(getline(v:lnum))
  let last_line  = s:RemoveSVComment(getline(lnum))
  let last_line2 = s:RemoveSVComment(getline(lnum2))
  let ind  = indent(lnum)
  let offset_comment1 = 1
  " Define the condition of an open statement
  "   Exclude the match of //, /* or */
  let sv_openstat = '\%(\<or\>\|\%([*/]\)\@<![*(,{><+-/%^&|!=?:]\%([*/]\)\@!\)'
  " Define the condition when the statement ends with a one-line comment
  let sv_comment = '\%(\/\/.*\|\/\*.*\*\/\s*\)'
  let sv_block1_statement = '\%(`\@<!\<\%(if\|else\)\>\)\|' .
        \ '\%(^\s*\<\%(for\|case\%[zx]\|do\|foreach\|randcase\|randsequence' .
        \ '\|initial\|forever\|fork\|final\|specify' .
        \ '\|always\|always_comb\|always_ff\|always_latch\)\>\)'
  let sv_block2_statement = '^\s*\%(' .
        \ '\%(\<\%(clocking\|interface\|package' .
        \ '\|property\|program\|sequence\)\>\)\|' .
        \ '\%(\%(\<virtual\>\s*\)\=\<class\>\)\|' .
        \ '\%(\%(\<\S\+\s\+\)*\<\%(function\|task\)\>\)\|' .
        \ '\%(\%(\w\+\s*:\)\=\s*\<covergroup\>\)' .
        \ '\)'
  let sv_oneline_statement = '\<\%(' .
        \ '`\@<!if\|`\@<!else\|for\|always\|initial\|do\|foreach\|final' .
        \ '\)\>'
  let sv_end_statement = '\%(\<\%(' . 
        \ 'endclocking\|endinterface\|endpackage\|' .
        \ 'endproperty\|endprogram\|endsequence\|' .
        \ 'endclass\|endfunction\|endtask\|endgroup' .
        \ '\)\>\)'
  let sv_end_match = '\<\%(' .
        \ 'end\|else\|' . 
        \ 'end\%(case\|task\|function\|clocking\|interface\|program\|' .
        \ 'module\|class\|specify\|package\|sequence\|group\|property\)\|' . 
        \ 'join\|join_any\|join_none\)\>\|' .
        \ '[})]\|' .
        \ '`\<\%(else\|endif\)\>'

  if exists('b:sv_indent_verbose')
>>>>>>> 3e1a07b35122d6d8d8d5efc4a6e32bd0ce08c7c2
    let vverb_str = 'INDENT VERBOSE:'
    let vverb = 1
  else
    let vverb = 0
  endif

<<<<<<< HEAD
  " Indent accoding to last line
  " End of multiple-line comment
  if last_line =~ '\*/\s*$' && last_line !~ '/\*.\{-}\*/'
    let ind = ind - offset_comment1
    if vverb
      echo vverb_str "De-indent after a multiple-line comment."
    endif

  " Indent after if/else/for/case/always/initial/specify/fork blocks
  elseif last_line =~ '`\@<!\<\(if\|else\)\>' ||
    \ last_line =~ '^\s*\<\(for\|case\%[[zx]]\|do\|foreach\|randcase\)\>' ||
    \ last_line =~ '^\s*\<\(always\|always_comb\|always_ff\|always_latch\)\>' ||
    \ last_line =~ '^\s*\<\(initial\|specify\|fork\|final\)\>'
    if last_line !~ '\(;\|\<end\>\)\s*' . vlog_comment . '*$' ||
      \ last_line =~ '\(//\|/\*\).*\(;\|\<end\>\)\s*' . vlog_comment . '*$'
      let ind = ind + offset
      if vverb | echo vverb_str "Indent after a block statement." | endif
    endif
  " Indent after function/task/class/package/sequence/clocking/
  " interface/covergroup/property/program blocks
  elseif last_line =~ '^\s*\<\(function\|task\|class\|package\)\>' ||
    \ last_line =~ '^\s*\<\(sequence\|clocking\|interface\)\>' ||
    \ last_line =~ '^\s*\(\w\+\s*:\)\=\s*\<covergroup\>' ||
    \ last_line =~ '^\s*\<\(property\|program\)\>'
    if last_line !~ '\<end\>\s*' . vlog_comment . '*$' ||
      \ last_line =~ '\(//\|/\*\).*\(;\|\<end\>\)\s*' . vlog_comment . '*$'
      let ind = ind + offset
      if vverb
	echo vverb_str "Indent after function/task/class block statement."
      endif
    endif

  " Indent after module/function/task/specify/fork blocks
  elseif last_line =~ '^\s*\(\<extern\>\s*\)\=\<module\>'
    let ind = ind + indent_modules
    if vverb && indent_modules
      echo vverb_str "Indent after module statement."
    endif
    if last_line =~ '[(,]\s*' . vlog_comment . '*$' &&
      \ last_line !~ '\(//\|/\*\).*[(,]\s*' . vlog_comment . '*$'
      let ind = ind + offset
      if vverb
	echo vverb_str "Indent after a multiple-line module statement."
=======
  if last_line2 =~ sv_openstat . '\s*' . sv_comment . '*$'
    if vverb
      echo "last_line2 is open statement!\n"
    endif
  endif

  " Indent comment accoding to last line
  " End of multiple-line comment TODO
  if last_line =~ '\*/\s*$' && last_line !~ '/\*.\{-}\*/'
    let ind = ind - offset_comment1
    if vverb
      echo vverb_str "De-indent after a multiple-line comment.\n"
    endif

  " bypass single comment
  elseif last_line =~ '^\s*' . sv_comment
      if vverb | echo vverb_str "Skip Indent after a comment.\n" | endif

  endif

  " Indent accoding to last line
  " Indent after if/else/for/case/always/initial/specify/fork blocks
  if last_line =~ sv_block1_statement
    if last_line !~ '\%([;}]\|\<\%(end\|endcase\|endspecify\)\>\)\s*$'
      let ind = ind + offset
      if vverb | echo vverb_str "Indent after a if/else/for block statement.\n" | endif
    else
      if vverb | echo vverb_str "Fail Indent after a if/else/for block statement.\n" | endif
    endif
    
  " Indent after function/task/class/package/sequence/clocking/
  " interface/covergroup/property/program blocks
  elseif last_line =~ sv_block2_statement
    if last_line !~ sv_end_statement . '\s*$' &&
     \ last_line !~ '^\s*\<extern\>.*;\s*$'
      let ind = ind + offset
      if vverb
        echo vverb_str "Indent after function/task/class block statement.\n"
      endif
    else
      if vverb | echo vverb_str "Fail Indent after a function/task/class block statement.\n" | endif
    endif

  " Indent after multiple-line function/task stand-alone ');'
  elseif last_line =~ '^\s*)\s*;\s*$'
    let m_lnum  = s:GetSVBlockStart(')', lnum, 'line')
    if s:RemoveSVComment(getline(m_lnum)) =~ '\%(\%(\<\S\+\s\+\)*\<\%(function\|task\)\>\)' &&
     \ s:RemoveSVComment(getline(m_lnum)) !~ '^\s*\<\%(extern\|import\)\>'
      let ind = ind + offset
      if vverb
        echo vverb_str "Indent after a multiple-line function/task\n"
      endif
    endif

  " Indent after module blocks
  elseif last_line =~ '^\s*\%(\<extern\>\s*\)\=\<module\>'
    let ind = ind + indent_modules
    if vverb && indent_modules
      echo vverb_str "Indent after module statement.\n"
    endif
    if last_line =~ '[(,]\s*$'
      let ind = ind + offset
      if vverb
        echo vverb_str "Indent after a multiple-line module statement.\n"
>>>>>>> 3e1a07b35122d6d8d8d5efc4a6e32bd0ce08c7c2
      endif
    endif

  " Indent after a 'begin' statement
<<<<<<< HEAD
  elseif last_line =~ '\(\<begin\>\)\(\s*:\s*\w\+\)*' . vlog_comment . '*$' &&
    \ last_line !~ '\(//\|/\*\).*\(\<begin\>\)' &&
    \ ( last_line2 !~ vlog_openstat . '\s*' . vlog_comment . '*$' ||
    \ last_line2 =~ '^\s*[^=!]\+\s*:\s*' . vlog_comment . '*$' )
    let ind = ind + offset
    if vverb | echo vverb_str "Indent after begin statement." | endif

  " Indent after a '{' or a '('
  elseif last_line =~ '[{(]' . vlog_comment . '*$' &&
    \ last_line !~ '\(//\|/\*\).*[{(]' &&
    \ ( last_line2 !~ vlog_openstat . '\s*' . vlog_comment . '*$' ||
    \ last_line2 =~ '^\s*[^=!]\+\s*:\s*' . vlog_comment . '*$' )
    let ind = ind + offset
    if vverb | echo vverb_str "Indent after begin statement." | endif

  " De-indent for the end of one-line block
  elseif ( last_line !~ '\<begin\>' ||
    \ last_line =~ '\(//\|/\*\).*\<begin\>' ) &&
    \ last_line2 =~ '\<\(`\@<!if\|`\@<!else\|for\|always\|initial\|do\|foreach\|final\)\>.*' .
      \ vlog_comment . '*$' &&
    \ last_line2 !~
      \
    '\(//\|/\*\).*\<\(`\@<!if\|`\@<!else\|for\|always\|initial\|do\|foreach\|final\)\>' &&
    \ last_line2 !~ vlog_openstat . '\s*' . vlog_comment . '*$' &&
    \ ( last_line2 !~ '\<begin\>' ||
    \ last_line2 =~ '\(//\|/\*\).*\<begin\>' )
    let ind = ind - offset
    if vverb
      echo vverb_str "De-indent after the end of one-line statement."
    endif

    " Multiple-line statement (including case statement)
    " Open statement
    "   Ident the first open line
    elseif  last_line =~ vlog_openstat . '\s*' . vlog_comment . '*$' &&
      \ last_line !~ '\(//\|/\*\).*' . vlog_openstat . '\s*$' &&
      \ last_line2 !~ vlog_openstat . '\s*' . vlog_comment . '*$'
      let ind = ind + offset
      if vverb | echo vverb_str "Indent after an open statement." | endif

    " Close statement
    "   De-indent for an optional close parenthesis and a semicolon, and only
    "   if there exists precedent non-whitespace char
    elseif last_line =~ ')*\s*;\s*' . vlog_comment . '*$' &&
      \ last_line !~ '^\s*)*\s*;\s*' . vlog_comment . '*$' &&
      \ last_line !~ '\(//\|/\*\).*\S)*\s*;\s*' . vlog_comment . '*$' &&
      \ ( last_line2 =~ vlog_openstat . '\s*' . vlog_comment . '*$' &&
      \ last_line2 !~ ';\s*//.*$') &&
      \ last_line2 !~ '^\s*' . vlog_comment . '$'
      let ind = ind - offset
      if vverb | echo vverb_str "De-indent after a close statement." | endif

  " `ifdef and `else
  elseif last_line =~ '^\s*`\<\(ifdef\|else\)\>'
    let ind = ind + offset
    if vverb
      echo vverb_str "Indent after a `ifdef or `else statement."
=======
  elseif last_line =~ '\%(\<begin\>\)\%(\s*:\s*\S\+\)*\s*$' &&
    \ ( last_line2 !~ sv_openstat . '\s*$' ||
    \   last_line2 =~ '^\s*[^=!]\+\s*:\s*$' )
    let ind = ind + offset
    if vverb | echo vverb_str "Indent after begin statement.\n" | endif

  " Indent after a '{' or a '('
  elseif last_line =~ '[{(]\s*$' &&
    \ ( last_line2 !~ sv_openstat . '\s*$' ||
    \   last_line2 =~ '^\s*[^=!]\+\s*:\s*$' )
    let ind = ind + offset
    if vverb | echo vverb_str "Indent after {( statement.\n" | endif

  " De-indent for the end of one-line block
  elseif ( last_line !~ '\<\%(begin\|else\)\>' &&
    \ last_line =~ ';\s*$' ) &&
    \ ( last_line2 =~ sv_oneline_statement . '.*$' &&
    \ last_line2 !~ sv_openstat . '\s*$' &&
    \ last_line2 !~  ';\s*$' &&
    \ last_line2 !~ '\<begin\>' ) 
    let ind = ind - offset
    if vverb
      echo vverb_str "De-indent after the end of one-line statement.\n"
    endif

  " Multiple-line statement (including case statement)
  " Open statement
  "   Ident the first open line
  elseif last_line =~ sv_openstat . '\s*$' &&
    \ last_line2 !~ sv_openstat . '\s*$'
    let ind = ind + offset
    if vverb | echo vverb_str "Indent after an open statement.\n" | endif

  " Indent for `ifdef `else block
  elseif last_line =~ '^\s*`\<\%(ifdef\|else\)\>'
    let ind = ind + offset
    if vverb
      echo vverb_str "Indent after a `ifdef or `else statement.\n"
>>>>>>> 3e1a07b35122d6d8d8d5efc4a6e32bd0ce08c7c2
    endif

  endif

  " Re-indent current line

<<<<<<< HEAD
  " De-indent on the end of the block
  " join/end/endcase/endfunction/endtask/endspecify
  if curr_line =~ '^\s*\<\(join\|join_any\|join_none\|\|end\|endcase\|while\)\>' ||
      \ curr_line =~ '^\s*\<\(endfunction\|endtask\|endspecify\|endclass\)\>' ||
      \ curr_line =~ '^\s*\<\(endpackage\|endsequence\|endclocking\|endinterface\)\>' ||
      \ curr_line =~ '^\s*\<\(endgroup\|endproperty\|endprogram\)\>' ||
      \ curr_line =~ '^\s*}'
    let ind = ind - offset
    if vverb | echo vverb_str "De-indent the end of a block." | endif
  elseif curr_line =~ '^\s*\<endmodule\>'
    let ind = ind - indent_modules
    if vverb && indent_modules
      echo vverb_str "De-indent the end of a module."
    endif

  " De-indent on a stand-alone 'begin'
  elseif curr_line =~ '^\s*\<begin\>'
    if last_line !~ '^\s*\<\(function\|task\|specify\|module\|class\|package\)\>' ||
      \ last_line !~ '^\s*\<\(sequence\|clocking\|interface\|covergroup\)\>' ||
      \ last_line !~ '^\s*\<\(property\|program\)\>' &&
      \ last_line !~ '^\s*\()*\s*;\|)\+\)\s*' . vlog_comment . '*$' &&
      \ ( last_line =~
      \ '\<\(`\@<!if\|`\@<!else\|for\|case\%[[zx]]\|always\|initial\|do\|foreach\|randcase\|final\)\>' ||
      \ last_line =~ ')\s*' . vlog_comment . '*$' ||
      \ last_line =~ vlog_openstat . '\s*' . vlog_comment . '*$' )
      let ind = ind - offset
      if vverb
	echo vverb_str "De-indent a stand alone begin statement."
      endif
    endif

  " De-indent after the end of multiple-line statement
  elseif curr_line =~ '^\s*)' &&
    \ ( last_line =~ vlog_openstat . '\s*' . vlog_comment . '*$' ||
    \ last_line !~ vlog_openstat . '\s*' . vlog_comment . '*$' &&
    \ last_line2 =~ vlog_openstat . '\s*' . vlog_comment . '*$' )
    let ind = ind - offset
    if vverb
      echo vverb_str "De-indent the end of a multiple statement."
    endif

  " De-indent `else and `endif
  elseif curr_line =~ '^\s*`\<\(else\|endif\)\>'
    let ind = ind - offset
    if vverb | echo vverb_str "De-indent `else and `endif statement." | endif
=======
  " bypass single comment
  if s:IsSVLineComment(v:lnum)
      if getline(v:lnum) =~ '^\s*' . sv_comment &&
        \ last_line !~ sv_openstat . '\s*$' && last_line =~ ';\s*$' &&
        \ last_line2 =~ sv_openstat . '\s*$' && last_line2 !~ '[{]\s*$'
        let ind = ind - offset
        if vverb | echo vverb_str "De-indent Comment the end of a multiple statement.\n" | endif
      else
        if vverb | echo vverb_str "Skip De-Indent comment line.\n" | endif
      endif

  " De-indent on the end of the block
  " join/end/endcase/endfunction/endtask/endspecify
  elseif curr_line =~ '^\s*\%(' . sv_end_match . '\)' &&
      \ ( curr_line !~ '^\s*\<else\>' || last_line !~ '^\s*\%(\<end\>\|}[^;]\)' )
    let block_end = matchstr(curr_line, sv_end_match)
    let ind = s:GetSVBlockStart(block_end, v:lnum, 'indent')
    let m_lnum  = s:GetSVBlockStart(block_end, v:lnum, 'line')
    let m_lnum2 = s:PrevNonBlankNonComment(m_lnum-1)
    if s:RemoveSVComment(getline(m_lnum2)) =~ sv_openstat . '\s*$' &&
      \ s:RemoveSVComment(getline(m_lnum2)) !~ '[:{]\s*$'
      let ind = ind - offset
      if vverb | echo vverb_str "De-indent the end of a block(multiple statement).\n" | endif
    else
      if vverb | echo vverb_str "De-indent the end of a block.\n" | endif
    endif

  elseif curr_line =~ '^\s*\<endmodule\>'
    let ind = ind - indent_modules
    if vverb && indent_modules
      echo vverb_str "De-indent the end of a module.\n"
    endif

  " De-indent on a stand-alone 'begin'
  elseif curr_line =~ '^\s*\<begin\>' &&
       \ last_line !~ '\<begin\>'
    call cursor(v:lnum,1)
    let m_lnum = search('^\s*\%(\<\%(end\|if\|else\|for\|foreach\|' .
       \ 'always\|initial\|final\|fork\|repeat\|while\>\)\|'.
       \ '\%(\S\+::\)\=\%(\S\+\):\)' , 'bnW')
    let sb_lnum = search('\%(' . sv_block2_statement . '\)'
       \ , 'bnW', m_lnum)
    let ind = m_lnum>0 && m_lnum<v:lnum && sb_lnum==0 ? indent(m_lnum) : indent(lnum)
    if vverb
      echo vverb_str "De-indent a stand alone begin statement.\n" 'l:' lnum ',m:' m_lnum ',m2:' sb_lnum
    endif
 
  " De-indent on a stand-alone '{'
  elseif curr_line =~ '^\s*[{]' &&
       \ last_line !~ '[{]'
    call cursor(v:lnum,1)
    let m_lnum = search('^\s*\%(\<\%(if\|else\|foreach' .
       \ '\>\)' , 'bnW')
    let ind = m_lnum>0 && m_lnum<v:lnum ? indent(m_lnum) : indent(lnum)
    if vverb
      echo vverb_str "De-indent a stand alone { statement.\n" 'l:' lnum ',m:' m_lnum ',m2:' sb_lnum
    endif

  " ? TODO
  elseif curr_line =~ '^\s*`\<if\%[n]def\>'
    let ind  = indent(lnum)
    if vverb
      echo vverb_str "Indent after a `ifdef or `else statement.\n"
    endif

  " De-indent after the end of multiple-line statement
  "   excluding function/task/expression =
  elseif curr_line =~ '\S\+\s*$'
    if last_line !~ sv_openstat . '\s*$' && last_line =~ ';\s*$' &&
     \ last_line2 =~ sv_openstat . '\s*$' && last_line2 !~ '[{]\s*$'
      if last_line !~ ')\s*;\s*$'
        let ind = ind - offset
        if vverb | echo vverb_str "De-indent the end of a multiple statement.\n" | endif
      else
        let m_lnum  = s:GetSVBlockStart(')', lnum, 'line')
        if s:RemoveSVComment(getline(m_lnum)) !~ '\%(\%(\<\S\+\s\+\)*\<\%(function\|task\)\>\)\|' .
           \ '\%(\".\{-}\)\@<!\%([=]\)'
          let ind = ind - offset
          if vverb | echo vverb_str "De-indent the end of a multiple statement. with );\n" | endif
        else
          if vverb | echo vverb_str "Not De-indent the end of a multiple statement.\n" | endif
        endif
      endif
    endif
>>>>>>> 3e1a07b35122d6d8d8d5efc4a6e32bd0ce08c7c2

  endif

  " Return the indention
  return ind
endfunction

" vim:sw=2
