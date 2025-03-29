vim9script noclear

if exists("b:current_syntax")
    finish
endif

syn sync fromstart

syn match dart_comment "//.*"
syn match dart_comment "^[ \t]*\*\($\|[ \t]\+\)"
syn region dart_comment start="/\*" end="\*/"

syn region dart_string start=+\z(['"]\)+ end=+\z1+ skip=+\\\\\|\\\z1+

hi def link dart_comment Comment
hi def link dart_string String

b:current_syntax = "dart"
