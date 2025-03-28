vim9script noclear

if exists("b:current_syntax")
    finish
endif

syn sync fromstart

syn match yasm_comment ";.*"

syn region yasm_string start=+\z(['"]\)+ end=+\z1+ skip=+\\\\\|\\\z1+

hi def link yasm_comment Comment
hi def link yasm_string String

b:current_syntax = "yasm"
