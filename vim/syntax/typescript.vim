vim9script noclear

if exists("b:current_syntax")
    finish
endif

runtime! syntax/javascript.vim
