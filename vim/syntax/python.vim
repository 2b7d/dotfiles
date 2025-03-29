vim9script noclear

if exists("b:current_syntax")
    finish
endif

syn sync fromstart

syn match python_comment "#.*"

syn region python_string start=+\z(['"]\)+ end=+\z1+ skip=+\\\\\|\\\z1+
syn region python_string start=+\z('''\|"""\)+ end="\z1" skip=+\\["']+

hi def link python_comment Comment
hi def link python_string String

b:current_syntax = "python"
