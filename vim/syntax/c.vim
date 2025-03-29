vim9script noclear

if exists("b:current_syntax")
    finish
endif

syn sync fromstart

syn match c_comment "\/\/.*"
syn region c_comment start="/\*" end="\*/"

syn region c_string start=+\z(['"]\)+ end=+\z1+ skip=+\\\\\|\\\z1+
syn match c_string display contained "<[^>]*>"

syn match c_include display "^\s*\zs\%(%:\|#\)\s*include\>\s*<" contains=c_string

hi def link c_comment Comment
hi def link c_string String

b:current_syntax = "c"
