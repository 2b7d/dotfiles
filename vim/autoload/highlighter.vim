vim9script

var hi_strings = false

export def Strings(): void
    hi_strings = !hi_strings
    if hi_strings
        hi String ctermfg=1
    else
        hi String ctermfg=fg
    endif
enddef
