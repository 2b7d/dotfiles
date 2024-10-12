if exists("b:current_syntax")
    finish
endif

syn match js_comment "\/\/.*"
syn region js_comment start="/\*" end="\*/"

syn region js_string start=+\z(['"`]\)+ end=+\z1+ skip=+\\\\\|\\\z1+

hi def link js_comment Comment
hi def link js_string String

let b:current_syntax = "javascript"
