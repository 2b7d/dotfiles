if exists("b:current_syntax")
    finish
endif

syn case ignore
syn sync fromstart

syn region css_comment start="/\*" end="\*/"

syn region css_string start=+\z(['"]\)+ end=+\z1+ skip=+\\\\\|\\\z1+

hi def link css_comment Comment
hi def link css_string String

let b:current_syntax = "css"
