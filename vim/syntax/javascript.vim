vim9script noclear

if exists("b:current_syntax")
    finish
endif

syn sync fromstart

syn match js_comment "\/\/.*"
syn region js_comment start="/\*" end="\*/"

syn region js_string start=+\z(['"`]\)+ end=+\z1+ skip=+\\\\\|\\\z1+
syn region js_regexp start=+/[^/*]+ end=+/[gimuys]*+ skip=+\\\\\|\\/+ oneline

hi def link js_comment Comment
hi def link js_string String
hi def link js_regexp String

b:current_syntax = "javascript"
