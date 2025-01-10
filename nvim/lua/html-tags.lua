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
    local indent_len = state.indent.level * state.indent.multiplier
    table.insert(state.output, string.rep(state.indent.symbol, indent_len)..tag)
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
    local indent = string.len(whitespace)

    state.indent.level = math.floor(indent / state.indent.multiplier)
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

        state.indent.level = state.indent.level - 1
        insert_output(state, "</"..tag..">")
    end

    compile_primary(state)
end

local function compile_increase_nesting(state)
    if state.has_error then
        return
    end

    advance(state)
    state.indent.level = state.indent.level + 1

    compile_primary(state)

    local tag = table.remove(state.parents)
    if tag ~= nil then
        state.indent.level = state.indent.level - 1
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

-- this function is forward declared as local above
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
        error("unknown symbol '"..peek(state).."'")
        return
    end
end

local function compile(state)
    parse_indent(state)
    compile_primary(state)
end

local function State(input)
    -- NOTE(art), 25.12.24: we are assuming that indentation is not a mix of tabs and spaces
    local indent_symbol, indent_multiplier = "\t", 1
    if vim.bo.expandtab then
        indent_symbol, indent_multiplier = " ", vim.fn.shiftwidth()
    end

    return {
        input = input,
        cursor = 1,
        indent = {
            level = 0,
            symbol = indent_symbol,
            multiplier = indent_multiplier
        },
        error = "",
        has_error = false,
        parents = {},
        output = {}
    }
end

function M.compile_line()
    local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
    local state = State(vim.b.html_tags_input)

    compile(state)

    if state.has_error then
        vim.cmd.stopinsert()
        vim.schedule(function()
            vim.api.nvim_win_set_cursor(0, {cursor_row, state.cursor - 1})
            vim.api.nvim_err_writeln("html-tags:"..state.error)
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
--[[

local function print_err(description, label, got, want, state)
    vim.print(description, "", "got "..label, got, "", "but want", want, "", state)
end

local function check_output(got, want)
    if #got ~= #want then
        return false
    end
    for i = 1, #got do
        if got[i] ~= want[i] then
            return false
        end
    end
    return true
end

local cases_success = {
    ["tag"] = {input = "div", want = {"<div></div>"}},
    ["tag utf-8"] = {input = "див", want = {"<див></див>"}},
    ["single tag"] = {input = "input", want = {"<input>"}},
    ["custom tag"] = {input = "List", want = {"<List />"}},
    ["custom tag utf-8"] = {input = "Лист", want = {"<Лист />"}},

    ["sequence"] = {input = "a,b", want = {"<a></a>", "<b></b>"}},
    ["sequence multiple"] = {input = "a,b,c", want = {"<a></a>", "<b></b>", "<c></c>"}},
    ["sequence different types of tags"] = {input = "a,br,C", want = {"<a></a>", "<br>", "<C />"}},

    ["increase nesting"] = {input = "a>b", want = {"<a>", "    <b></b>", "</a>"}},
    ["increase nesting multiple"] = {input = "a>b>c", want = {"<a>", "    <b>", "        <c></c>", "    </b>", "</a>"}},
    ["increase nesting single tag"] = {input = "meta>a", want = {"<meta>", "    <a></a>", "</meta>"}},
    ["increase nesting custom tag"] = {input = "List>ListItem", want = {"<List>", "    <ListItem />", "</List>"}},
    ["increase nesting sequence"] = {input = "a>b,c", want = {"<a>", "    <b></b>", "    <c></c>", "</a>"}},

    ["decrease nesting"] = {input = "a>b<c", want = {"<a>", "    <b></b>", "</a>", "<c></c>"}},
    ["decrease nesting sequence"] = {input = "a>b<c,d", want = {"<a>", "    <b></b>", "</a>", "<c></c>", "<d></d>"}},
    ["decrease nesting 2"] = {input = "a>b>c<d", want = {"<a>", "    <b>", "        <c></c>", "    </b>", "    <d></d>", "</a>"}},
    ["decrease nesting 3"] = {input = "a>b>c<<d", want = {"<a>", "    <b>", "        <c></c>", "    </b>", "</a>", "<d></d>"}},

    ["with indent"] = {input = "    div", want = {"    <div></div>"}},
    ["with indent 2"] = {input = "   div", want = {"<div></div>"}},
    ["with indent 3"] = {input = "  div", want = {"<div></div>"}},
    ["with indent 4"] = {input = " div", want = {"<div></div>"}},

    ["with tab indent"] = {input = "\tdiv", use_tab = true, want = {"\t<div></div>"}},
    ["with tab indent 2"] = {input = "\t\tdiv", use_tab = true, want = {"\t\t<div></div>"}},
    ["with tab indent 3"] = {input = "a>b>c<d", use_tab = true, want = {"<a>", "\t<b>", "\t\t<c></c>", "\t</b>", "\t<d></d>", "</a>"}},
}

for description, case in pairs(cases_success) do
    local state = State(case.input)
    if case.use_tab then
        state.indent.symbol = "\t"
        state.indent.multiplier = 1
    end

    compile(state)

    if state.has_error then
        print_err(description, "has_error", state.has_error, false, state)
        break
    end

    if not check_output(state.output, case.want) then
        print_err(description, "output", state.output, case.want, state)
        break
    end
end

local cases_fail = {
    ["no tag"] = {input = "", want = 1},
    ["no tag 2"] = {input = ",", want = 1},
    ["no tag 3"] = {input = ">", want = 1},
    ["no tag 4"] = {input = "<", want = 1},
    ["no tag 5"] = {input = "div>", want = 5},
    ["no tag 6"] = {input = "div,", want = 5},
    ["not enough parents"] = {input = "div<", want = 4},
    ["not enough parents 2"] = {input = "div>div<<", want = 9},
    ["not enough parents 3"] = {input = "a>b>c<d<e<", want = 10},
}

for description, case in pairs(cases_fail) do
    local state = State(case.input)
    compile(state)

    if not state.has_error then
        print_err(description, "has_error", state.has_error, true, state)
        break
    end

    if state.cursor ~= case.want then
        print_err(description, "cursor", state.cursor, case.want, state)
        break
    end
end

--]]
