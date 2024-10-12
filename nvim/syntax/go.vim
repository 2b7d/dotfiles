if exists("b:current_syntax")
    finish
endif

syn sync fromstart

syn match go_comment "\/\/.*"
syn region go_comment start="/\*" end="\*/"

syn region go_string start=+\z(['"`]\)+ end=+\z1+ skip=+\\\\\|\\\z1+

hi def link go_comment Comment
hi def link go_string String

let b:current_syntax = "go"
