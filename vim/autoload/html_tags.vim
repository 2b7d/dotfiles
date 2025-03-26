vim9script

# grammar:
#   primary = tag (sequence | increase_nesting | decrease_nesting)?

#   sequence = "," primary
#   increase_nesting = ">" primary
#   decrease_nesting = "<"+ primary

#   tag = any char except "," ">" "<"

export def LineHasTrigger(): bool
    var input = slice(getline("."), 0, charcol(".") - 1)

    if slice(input, -len(CMD_TRIGGER)) != CMD_TRIGGER
        return false
    endif

    b:html_tags_input = slice(input, 0, strcharlen(input) - len(CMD_TRIGGER))
    return true
enddef

export def CompileLine(): void
    var state = State.new(b:html_tags_input)

    SetIndentLevel(state)
    CompilePrimary(state)

    var row = line(".")

    if state.has_error
        stopinsert
        timer_start(0, (id) => {
            setcursorcharpos(row, state.cursor + 1)
            ReportError(state.error)
        })
        return
    endif

    &g:undolevels = &g:undolevels # close undo block :h undo-break

    setline(row, state.output[0])
    append(row, state.output[1 :])
    cursor(row + len(state.output) - 1, len(state.output[-1]) + 1)
enddef

const CMD_TRIGGER = ":ht"

const SINGLE_TAGS = {
    input: 1, img: 1, br: 1, hr: 1, meta: 1, link: 1, area: 1, base: 1, wbr: 1,
    col: 1, embed: 1, param: 1, source: 1, track: 1
}

class State
    public var input: string
    public var cursor = 0
    public var indent_level: number
    public var indent_symbol: string
    public var indent_multiplier: number
    public var error = ""
    public var has_error = false
    public var parents: list<string> = []
    public var output: list<string> = []

    def new(input: string)
        this.input = input
    enddef
endclass

def CompilePrimary(state: State): void
    if state.has_error
        return
    endif

    CompileTag(state)

    if IsEndOfInput(state)
        return
    elseif Match(state, ",")
        CompileSequence(state)
    elseif Match(state, ">")
        CompileIncreaseNesting(state)
    elseif Match(state, "<")
        CompileDecreaseNesting(state)
    else
        throw $"unknown symbol {Peek(state)}"
    endif
enddef

def CompileTag(state: State): void
    if state.has_error
        return
    endif

    var tag = ParseTag(state)
    var output = ""

    if tag == ""
        SetError(state, $"expected tag but got '{Peek(state)}'")
        return
    endif

    if Match(state, ">")
        add(state.parents, tag)
        output = "<" .. tag .. ">"
    else
        if IsSingleTag(tag)
            output = "<" .. tag .. ">"
        elseif IsCustomTag(tag)
            output = "<" .. tag .. " />"
        else
            output = "<" .. tag .. "></" .. tag .. ">"
        endif
    endif

    InsertOutput(state, output)
enddef

def CompileSequence(state: State): void
    if state.has_error
        return
    endif

    Advance(state)
    CompilePrimary(state)
enddef

def CompileIncreaseNesting(state: State): void
    if state.has_error
        return
    endif

    Advance(state)
    ++state.indent_level

    CompilePrimary(state)

    if len(state.parents) > 0
        --state.indent_level
        InsertOutput(state, "</" .. remove(state.parents, -1) .. ">")
    endif
enddef

def CompileDecreaseNesting(state: State): void
    if state.has_error
        return
    endif

    while Match(state, "<")
        if len(state.parents) == 0
            SetError(state, "not enough parents to decrease nesting")
            return
        endif

        Advance(state)

        --state.indent_level
        InsertOutput(state, "</" .. remove(state.parents, -1) .. ">")
    endwhile

    CompilePrimary(state)
enddef

def SetIndentLevel(state: State): void
    # art: we are assuming that indentation is not a mix of tabs and spaces
    var sym = "\t"
    var mult = 1

    if &expandtab
        sym = " "
        mult = &shiftwidth
    endif

    state.indent_level = indent(line(".")) / mult
    state.indent_symbol = sym
    state.indent_multiplier = mult
enddef

def ParseTag(state: State): string
    SkipWhitespace(state)

    var tag = ""

    while !IsEndOfInput(state)
        var ch = Peek(state)

        if ch == "," || ch == "<" || ch == ">"
            break
        endif

        tag ..= ch
        Advance(state)
    endwhile

    return tag
enddef

def SkipWhitespace(state: State): void
    while true
        var ch = Peek(state)

        if ch != " " && ch != "\t"
            break
        endif

        Advance(state)
    endwhile
enddef

def Advance(state: State): string
    if IsEndOfInput(state)
        throw "tried to advance after the end of input"
    endif

    var ch = Peek(state)

    ++state.cursor
    return ch
enddef

def IsEndOfInput(state: State): bool
    return state.cursor >= strcharlen(state.input)
enddef

def Peek(state: State): string
    if IsEndOfInput(state)
        return ""
    endif
    return nr2char(strgetchar(state.input, state.cursor))
enddef

def Match(state: State, ch: string): bool
    return Peek(state) == ch
enddef

def IsSingleTag(tag: string): bool
    return get(SINGLE_TAGS, tag) == 1
enddef

def IsCustomTag(tag: string): bool
    var ch = nr2char(strgetchar(tag, 0))
    return ch == toupper(ch)
enddef

def InsertOutput(state: State, tag: string): void
    var indent_len = state.indent_level * state.indent_multiplier
    add(state.output, repeat(state.indent_symbol, indent_len) .. tag)
enddef

def SetError(state: State, msg: string): void
    state.error = $"{state.cursor + 1}: {msg}"
    state.has_error = true
enddef

def ReportError(msg: string): void
    echohl ErrorMsg
    echom $"html_tags:{msg}"
    echohl None
enddef
