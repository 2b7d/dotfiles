if exists("b:current_syntax")
    finish
endif

runtime! syntax/json.vim

syn match json_comment "\/\/.*"
syn region json_comment start="/\*" end="\*/"

hi def link json_comment Comment

let b:current_syntax = "jsonc"
