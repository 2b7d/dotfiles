vim9script noclear

if exists("b:current_syntax")
    finish
endif

runtime! syntax/html.vim

syn sync fromstart

syn region php_region start="<?\(php\|=\)" end="?>" contains=php_comment,php_string keepend

syn match php_comment "\/\/.*" contained
syn match php_comment "#.*" contained
syn region php_comment start="/\*" end="\*/" contained

syn region php_string start=+\z(['"`]\)+ end=+\z1+ skip=+\\\\\|\\\z1+
syn region php_string start="\(<<<\)\@<=\(\"\=\)\z(\I\i*\)\2$" end="^\s*\z1\>" contained
syn region php_string start="\(<<<\)\@<='\z(\I\i*\)'$" end="^\s*\z1\>" contained

hi def link php_comment Comment
hi def link php_string String

b:current_syntax = "php"
