vim9script

setlocal noexpandtab
setlocal colorcolumn=120
setlocal listchars=tab:\ \ ,trail:·,lead:·

augroup ftplugin_go
    au!
    au BufWritePost *.go {
        silent !~/.local/lib/go/bin/goimports -w %
        redraw!
    }
augroup END

command! -buffer -nargs=* GoKeywordPrg {
    var prev_isk = &l:iskeyword

    setlocal iskeyword+=.

    var word = expand("<cword>")

    &l:iskeyword = prev_isk
    execute $"term go doc {word}"
}
