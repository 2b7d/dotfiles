vim9script noclear

if exists("b:current_syntax")
    finish
endif

syn include @syntax_css syntax/css.vim
unlet b:current_syntax
syn include @syntax_js syntax/javascript.vim
unlet b:current_syntax

syn case ignore
syn sync fromstart

syn region html_tag start="<[^/]" end=">" contains=html_string

syn region html_comment start="<!--" end="--\s*>"
syn region html_comment start="<!DOCTYPE" end=">" keepend

syn region html_string start=+\z(['"]\)+ end=+\z1+ skip=+\\\\\|\\\z1+ contained

syn region html_tag_css start="<style\>\_[^>]*>" end="</style>" contains=@syntax_css keepend
syn region html_tag_script start="<script\>\_[^>]*>" end="</script\_[^>]*>" contains=@syntax_js keepend

hi def link html_comment Comment
hi def link html_string String

b:current_syntax = "html"
