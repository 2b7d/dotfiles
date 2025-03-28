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

    var snippath = $"{SNIPPETS_DIR}/{&filetype}/{trigger}"

    if !filereadable(snippath)
        snippath = ""
        if has_key(shared_filetypes, &filetype)
            for ft in shared_filetypes[&filetype]
                var path = $"{SNIPPETS_DIR}/{ft}/{trigger}"

                if filereadable(path)
                    snippath = path
                    break
                endif
            endfor
        endif

        if snippath == ""
            snippath = $"{SNIPPETS_DIR}/{trigger}"
            if !filereadable(snippath)
                return false
            endif
        endif
    endif

    snippet.filepath = snippath
    snippet.content_before_trigger = before_trigger
    snippet.content_after_trigger = after_trigger

    return true
enddef

export def Expand(): void
    var content = readfile(snippet.filepath)

    if len(content) == 0
        stopinsert
        timer_start(0, (_) => {
            echohl ErrorMsg
            echom $"snippet: empty snippet file {snippet.filepath}"
            echohl None
        })
        return
    endif

    for [i, line] in items(content)
        var [cmd, cmd_start, cmd_end] = matchstrpos(line, '${.*}') # anything between ${}
        if cmd_start < 0
            continue
        endif
        cmd = slice(cmd, 2, -1) # trim ${}
        var result = trim(execute(cmd))
        content[i] = slice(line, 0, cmd_start) .. result .. slice(line, cmd_end)
    endfor

    if &expandtab
        var indent_multiplier = shiftwidth()
        for [i, line] in items(content)
            var [_, _, indent_len] = matchstrpos(line, '^\t\+') # one or more \t from the start
            if indent_len < 0
                continue
            endif
            var space_indent = repeat(" ", indent_multiplier * indent_len)
            content[i] = space_indent .. slice(line, indent_len)
        endfor
    endif

    content[0] = snippet.content_before_trigger .. content[0]

    var row = line(".")
    var col = len(content[-1]) + 1

    content[-1] = content[-1] .. snippet.content_after_trigger

    &g:undolevels = &g:undolevels # close undo block :h undo-break

    setline(row, content[0])
    append(row, content[1 :])
    cursor(row + len(content) - 1, col)
enddef

export def ListAvailable(): void
    var dirents = readdirex(SNIPPETS_DIR)
    var snip_global: list<string> = []
    var snip_local: list<string> = []
    var filetypes = [&filetype]

    if has_key(shared_filetypes, &filetype)
        filetypes += shared_filetypes[&filetype]
    endif

    for dirent in dirents
        if dirent.type == "file"
            add(snip_global, dirent.name)
        elseif dirent.type == "dir"
            for ft in filetypes
                if dirent.name == ft
                    snip_local += readdir($"{SNIPPETS_DIR}/{dirent.name}")
                endif
            endfor
        endif
    endfor

    if len(snip_global) == 0 && len(snip_local) == 0
        echom "No snippets available"
    else
        if len(snip_global) > 0
            echom "Global:"
            for s in snip_global
                echom $"    {s}"
            endfor
        endif
        if len(snip_local) > 0
            echom "Local:"
            for s in snip_local
                echom $"    {s}"
            endfor
        endif
    endif
enddef

class SnippetState
    public var filepath = ""
    public var content_before_trigger = ""
    public var content_after_trigger = ""
endclass

const SNIPPETS_DIR = expand("$MYVIMDIR/snippets")

var snippet = SnippetState.new()

# TODO(art): where to put it? vimrc, plugin?
var shared_filetypes = {
    vue: ["html"],
    php: ["html"]
}
