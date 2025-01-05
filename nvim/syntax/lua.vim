if exists("b:current_syntax")
    finish
endif

syn sync fromstart

syn match lua_comment "--.*"
syn region lua_comment start="--\[\z(=*\)\[" end="\]\z1\]"

syn region lua_string start=+\z(['"]\)+ end=+\z1+ skip=+\\\\\|\\\z1+
syn region lua_string start="\[\z(=*\)\[" end="\]\z1\]"

hi def link lua_comment Comment
hi def link lua_string String

let b:current_syntax = "lua"
