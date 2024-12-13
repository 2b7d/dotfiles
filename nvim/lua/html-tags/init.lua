local M = {}

local CMD_IDENT = "ht:"

local SINGLE_TAGS = {
    "input", "img", "br", "hr", "meta", "link", "area", "base", "wbr", "col",
    "embed", "param", "source", "track"
}

local function tobytes(s)
    local b = {}
    for i = 1, #s do
        b[i] = string.byte(s, i)
    end
    return b
end

local function cursor_position()
    local pos = vim.api.nvim_win_get_cursor(0)
    return pos[1] - 1, pos[2]
end

local function is_uppercase(ch)
    return ch >= string.byte("A") and ch <= string.byte("Z")
end

local function is_single(tag)
    for i = 1, #SINGLE_TAGS do
        if tag == SINGLE_TAGS[i] then
            return true
        end
    end
    return false
end

local function Parser(line, offset)
    return {
        line = line,
        offset = offset,
        indent = 0,
        parents = {},
        output = {}
    }
end

local function parser_error(parser, msg)
    local fmt = string.format("%d : %s", parser.offset, msg)
    error(fmt, 0)
end

local function peek(parser)
    return parser.line[parser.offset]
end

local function end_of_line(parser)
    return peek(parser) == nil
end

local function match(parser, char)
    return peek(parser) == string.byte(char)
end

local function advance(parser)
    if end_of_line(parser) then
        return 0
    end

    local ch = peek(parser)
    parser.offset = parser.offset + 1
    return ch
end

local function add_indent(parser, output)
    local indent = string.rep("\t", parser.indent)
    return indent .. output
end

local function parse_tag(parser)
    local tag_bytes = {}
    while not end_of_line(parser) and
          not match(parser, ",") and
          not match(parser, ">") and
          not match(parser, "<")
    do
        table.insert(tag_bytes, advance(parser))
    end

    local tag = string.char(unpack(tag_bytes))
    if tag == "" then
        parser_error(parser, "no tag")
    end

    local output = "<" .. tag

    if match(parser, ">") then
        table.insert(parser.parents, tag)
        output = output .. ">"
    else
        if is_uppercase(tag_bytes[1]) then
            output = output .. " />"
        elseif is_single(tag) then
            output = output .. ">"
        else
            output = output .. "></" .. tag .. ">"
        end
    end

    if #parser.output > 0 then
        output = add_indent(parser, output)
    end

    table.insert(parser.output, output)
end

local function parse_seq(parser)
    parse_tag(parser)
    while match(parser, ",") do
        advance(parser)
        parse_tag(parser)
    end
end

local function parse_nest(parser)
    advance(parser)
    parser.indent = parser.indent + 1
    parse_seq(parser)
end

local function parse_unnest(parser)
    while match(parser, "<") do
        advance(parser)

        local tag = table.remove(parser.parents)
        if tag == nil then
            parser_error(parser, "nest underflow")
        end

        parser.indent = parser.indent - 1

        local output = add_indent(parser, "</" .. tag .. ">")
        table.insert(parser.output, output)
    end

    parse_seq(parser)
end

local function parse_cmd(parser)
    parse_seq(parser)

    while not end_of_line(parser) do
        if match(parser, ">") then
            parse_nest(parser)
        elseif match(parser, "<") then
            parse_unnest(parser)
        else
            parser_error(parser, "unexpected character")
            break
        end
    end

    while #parser.parents > 0 do
        local tag = table.remove(parser.parents)
        if tag == nil then
            parser_error(parser, "nest underflow")
        end

        parser.indent = parser.indent - 1

        local output = add_indent(parser, "</" .. tag .. ">")
        table.insert(parser.output, output)
    end
end

--grammar:
--  tag = any char except ',><'
--  seq = tag (',' tag)+?
--  nest = '>' seq
--  unnest = '<'+ seq
--  cmd = seq (nest | unnest)+?

function M.run()
    local line = vim.api.nvim_get_current_line()
    local cmd_start, cmd_end = string.find(line, CMD_IDENT, 1, true)

    if cmd_start == nil then
        return false
    end

    if cmd_start > 1 then
        local ch = string.byte(line, cmd_start - 1)
        if ch ~= string.byte(" ") and ch ~= string.byte("\t") then
            return false
        end
    end

    local parser = Parser(tobytes(line), cmd_end + 1)

    local ok, err = pcall(parse_cmd, parser)
    if not ok then
        vim.api.nvim_err_writeln(string.format("plugin/html-tags: %s", err))
        return false
    end

    cursor_row = cursor_position()
    vim.api.nvim_buf_set_text(0, cursor_row, cmd_start - 1, cursor_row, #line, parser.output)

    return true
end

--ht:html>head>meta,title<body>header>nav>List>ListItem<<<main>h1,input,section<script

return M
