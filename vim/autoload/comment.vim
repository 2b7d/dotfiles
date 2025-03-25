vim9script

export def Toggle(): void
    var comment = ParseCommentString()
    var range = GetSelectedLineRange()
    var lines = getline(range.start, range.end)
    var lowest_indent = GetLowestIndentLevel(lines)
    var mode = GetToggleMode(lines, comment)
    var output: list<string> = []

    if mode == ToggleMode.COMMENT
        for line in lines
            if line->trim() == ""
                output->add(line)
                continue
            endif
            output->add(
                line->slice(0, lowest_indent) .. comment.prefix ..
                line->slice(lowest_indent) .. comment.suffix
            )
        endfor
    else # UNCOMMENT
        for line in lines
            if line->trim() == ""
                output->add(line)
                continue
            endif

            var prefi = line->stridx(comment.prefix)
            var suffi = line->strridx(comment.suffix)

            output->add(
                line->slice(0, prefi) ..
                line->slice(prefi + comment.prefix->len(), suffi)
            )
        endfor
    endif

    setline(range.start, output)
enddef

class Comment
    public var prefix: string
    public var suffix: string
endclass

class LineRange
    public var start: number
    public var end: number
endclass

enum ToggleMode
    COMMENT,
    UNCOMMENT
endenum

def ParseCommentString(): Comment
    var parts = &commentstring->split("%s")

    if parts->len() < 1
        throw "should never happen, commentstring is set by vim by default"
    endif

    var comment = Comment.new()

    comment.prefix = parts[0]->trim()
    comment.suffix = ""

    if parts->len() > 1
        comment.suffix = parts[1]->trim()
    endif

    return comment
enddef

def GetSelectedLineRange(): LineRange
    var range = LineRange.new()

    range.start = line("v")
    range.end = line(".")

    if range.start > range.end # selecting from bottom to top
        var tmp = range.start

        range.start = range.end
        range.end = tmp
    endif

    return range
enddef

def GetLowestIndentLevel(lines: list<string>): number
    var lowest_indent = 255

    for line in lines
        if line->trim() == ""
            continue
        endif

        var count = 0

        for ch in line
            if ch != " " && ch != "\t"
                break
            endif
            ++count
        endfor
        if count < lowest_indent
            lowest_indent = count
            if lowest_indent == 0
                break
            endif
        endif
    endfor

    return lowest_indent
enddef

def GetToggleMode(lines: list<string>, comment: Comment): ToggleMode
    var mode = ToggleMode.UNCOMMENT
    var i = 0
    var j = lines->len() - 1

    while i <= j
        var first = lines[i]->trim()
        var last = lines[j]->trim()

        if first != "" && !StrStarts(first, comment.prefix) ||
                last != "" && !StrStarts(last, comment.prefix)
            mode = ToggleMode.COMMENT
            break
        endif

        ++i
        --j
    endwhile

    return mode
enddef

def StrStarts(s: string, with: string): bool
    return s->slice(0, with->len()) == with
enddef
