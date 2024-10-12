if exists("b:current_syntax")
    finish
endif

syn sync fromstart

syn region json_string start=+"+ end=+"+ skip=+\\\\\|\\"+

hi def link json_string String

let b:current_syntax = "json"
