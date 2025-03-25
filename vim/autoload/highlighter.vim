vim9script

var hi_state = false

export def Strings(): void
    hi_state = !hi_state
    if hi_state
        hi String guifg=art_red ctermfg=1
    else
        hi String guifg=fg ctermfg=fg
    endif
enddef
