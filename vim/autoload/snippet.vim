vim9script

export def LineHasTrigger(): bool
    var line = getline(".")
    var col = charcol(".")
    var input = slice(line, 0, col - 1)
    var [trigger, trigger_start, _] = matchstrpos(input, '\S\+$') # one or more non-whitespace from the end
    var before_trigger = slice(input, 0, trigger_start)
    var after_trigger = slice(line, col - 1)

    if trigger == ""
        return false
    endif

    var snippath = glob($"$MYVIMDIR/snippets/{&filetype}/{trigger}")

    if snippath == ""
        snippath = glob($"$MYVIMDIR/snippets/{trigger}")
        if snippath == ""
            return false
        endif
    endif

    if getftype(snippath) != "file"
        return false
    endif

    snippet.path = snippath
    snippet.content_before_trigger = before_trigger
    snippet.content_after_trigger = after_trigger

    return true
enddef

export def Expand(): void
    var content = readfile(snippet.path)

    content[0] = snippet.content_before_trigger .. content[0]

    var row = line(".")
    var col = len(content[-1]) + 1

    content[-1] = content[-1] .. snippet.content_after_trigger

    &g:undolevels = &g:undolevels # close undo block :h undo-break

    setline(row, content[0])
    append(row, content[1 :])
    cursor(row + len(content) - 1, col)
enddef

var snippet = {
    path: "",
    content_before_trigger: "",
    content_after_trigger: "",
}
