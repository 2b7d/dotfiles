vim9script

export def LineHasTrigger(): bool
    var line = getline(".")
    var col = charcol(".")
    var input = slice(line, 0, col - 1)
    var parts = split(input, '\s', 1) # TODO(art): try to use index
    var word = remove(parts, -1) # NOTE(art): 'parts' was mutated

    if word == ""
        return false
    endif

    var snippath = glob($"./snippets/{&filetype}/{word}")

    if snippath == ""
        return false
    endif

    snippet.path = snippath
    snippet.content_before_trigger = join(parts)
    snippet.content_after_trigger = slice(line, col - 1)

    return true
enddef

export def Expand(): void
    var content = readfile(snippet.path)

    if snippet.content_before_trigger != ""
        content[0] = $"{snippet.content_before_trigger} {content[0]}"
    endif

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

