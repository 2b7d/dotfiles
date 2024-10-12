if exists("b:current_syntax")
    finish
endif

syn sync fromstart

syn match asm_comment ";.*"

syn region asm_string start=+\z(['"]\)+ end=+\z1+ skip=+\\\\\|\\\z1+

hi def link asm_comment Comment
hi def link asm_string String

let b:current_syntax = "yasm"
