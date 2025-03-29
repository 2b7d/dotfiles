vim9script

export def CWDFiles(): void
    botright new
    Term ++curwin fd -t f -E .git -E node_modules

    set bufhidden=delete
enddef

export def WordGrep(): void
    var word = expand("<cword>")

    if mode() == "v"
        var cursor_start = charcol("v")
        var cursor_end = charcol(".")

        if cursor_end < cursor_start
            [cursor_start, cursor_end] = [cursor_end, cursor_start]
        endif
        word = slice(getline("."), cursor_start - 1, cursor_end)
    endif

    # " ' < > \t \n < > ( ) [ ] { } ? * + | $ . ^ ` \
    word = escape(word, '\$#')
    word = escape(word, '()[]{}?*+|$^.#`\"')

    botright new
    execute $"Term ++curwin rg -i -w -g=!.git -g=!node_modules -- \"{word}\""
enddef

export def BufferGrep(): void
    var val = input("Buffer Grep> ")

    if trim(val) == ""
        return
    endif

    var bufname = expand("%")

    botright new
    execute $"Term ++curwin rg -i {val} {bufname}"
enddef

export def CWDGrep(): void
    var val = input("CWD Grep> ")

    if trim(val) == ""
        return
    endif

    botright new
    execute $"Term ++curwin rg -i -g=!.git -g=!node_modules {val}"
enddef
