--grammar:
--    primary = tag (sequence | increase_nesting | decrease_nesting)?

--    sequence = "," primary
--    increase_nesting = ">" primary
--    decrease_nesting = "<"+ primary

--    tag = any char except "," ">" "<"

local M = {}

local CMD_TRIGGER = ":ht"

local SINGLE_TAGS = {
    input  = 1, img   = 1, br  = 1, hr  = 1, meta  = 1, link  = 1,
	area   = 1, base  = 1, wbr = 1, col = 1, embed = 1, param = 1,
	source = 1, track = 1
}

local function get_utf8_char(str, i)
    local rune = vim.fn.strgetchar(str, i - 1)
    return vim.fn.nr2char(rune)
end

local function is_single_tag(tag)
    return SINGLE_TAGS[tag] ~= nil
end

local function is_custom_tag(tag)
    local ch = get_utf8_char(tag, 1)
    return ch == vim.fn.toupper(ch)
end

local function report_error(state, fmt, ...)
    local msg = string.format(fmt, ...)

    state.error = string.format("%d: %s", state.cursor, msg)
    state.has_error = true
end

local function is_end_of_input(state)
    return state.cursor > #state.input
end

local function peek(state)
    if is_end_of_input(state) then
        return ""
    end

    local current = string.sub(state.input, state.cursor)
    return get_utf8_char(current, 1)
end

local function match(state, ch)
    return peek(state) == ch
end

local function advance(state)
    if is_end_of_input(state) then
        error("tried to advance after the end of input", 2)
    end
    state.cursor = state.cursor + 1
end

local function insert_output(state, tag)
    local whitespace = "\t"
    local level = state.indent

    if vim.bo.expandtab then
        whitespace = " "
        level = level * vim.fn.shiftwidth()
    end

    table.insert(state.output, string.rep(whitespace, level)..tag)
end

local function parse_pattern(state, pattern)
    local start, _end = string.find(state.input, pattern, state.cursor)

    if start == nil then
        return false, ""
    end

    state.cursor = _end + 1
    return true, string.sub(state.input, start, _end)
end

local function parse_indent(state)
    local _, whitespace = parse_pattern(state, "^%s*") -- starts with 0 or more whitespaces

    -- NOTE(art), 25.12.24: we are assuming that indentation is not a mix of tabs and spaces
    local indent = string.len(whitespace)
    if vim.bo.expandtab then
        indent = math.floor(indent / vim.fn.shiftwidth())
    end

    state.indent = indent
end

local compile_primary

local function compile_decrease_nesting(state)
    if state.has_error then
        return
    end

    while match(state, "<") do
        local tag = table.remove(state.parents)
        if tag == nil then
            report_error(state, "not enough parents to decrease nesting")
            return
        end

        advance(state)

        state.indent = state.indent - 1
        insert_output(state, "</"..tag..">")
    end

    compile_primary(state)
end

local function compile_increase_nesting(state)
    if state.has_error then
        return
    end

    advance(state)
    state.indent = state.indent + 1

    compile_primary(state)

    local tag = table.remove(state.parents)
    if tag ~= nil then
        state.indent = state.indent - 1
        insert_output(state, "</"..tag..">")
    end
end

local function compile_sequence(state)
    if state.has_error then
        return
    end

    advance(state)
    compile_primary(state)
end

local function compile_tag(state)
    if state.has_error then
        return
    end

    local found, tag = parse_pattern(state, "^[^,><]+") -- starts with 1 or more of any, except ,><
    if not found then
        report_error(state, "expected tag, but got '%s'", peek(state))
        return
    end

    local output = ""

    if match(state, ">") then
        table.insert(state.parents, tag)
        output = "<"..tag..">"
    else
        if is_single_tag(tag) then
            output = "<"..tag..">"
        elseif is_custom_tag(tag) then
            output = "<"..tag.." />"
        else
            output = "<"..tag.."></"..tag..">"
        end
    end

    insert_output(state, output)
end

function compile_primary(state)
    if state.has_error then
        return
    end

    compile_tag(state)

    if is_end_of_input(state) then
        return
    elseif match(state, ",") then
        compile_sequence(state)
    elseif match(state, ">") then
        compile_increase_nesting(state)
    elseif match(state, "<") then
        compile_decrease_nesting(state)
    else
        report_error(state, "unknown symbol '%s'", peek(state))
        return
    end
end

function M.compile_line()
    local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
    local state = {
        input = vim.b.html_tags_input,
        cursor = 1,
        indent = 0,
        error = "",
        has_error = false,
        parents = {},
        output = {}
    }

    parse_indent(state)
    compile_primary(state)

    if state.has_error then
        vim.cmd.stopinsert()
        vim.schedule(function()
            vim.api.nvim_win_set_cursor(0, {cursor_row, state.cursor - 1})
            vim.api.nvim_err_writeln(string.format("html-tags:%s", state.error))
        end)
        return
    end

    local row = cursor_row - 1
    local output = state.output

    vim.api.nvim_buf_set_text(0, row, 0, row, cursor_col, output)
    vim.api.nvim_win_set_cursor(0, {row + #output, #output[#output]})
end

function M.line_has_trigger()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_get_current_line()
    local input = string.sub(line, 1, col)

    if string.sub(input, -#CMD_TRIGGER) ~= CMD_TRIGGER then
        return false
    end

    vim.b.html_tags_input = string.sub(input, 1, #input - #CMD_TRIGGER)
    return true
end

return M
