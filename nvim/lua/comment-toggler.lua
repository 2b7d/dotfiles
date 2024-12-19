local M = {}

local function create_comment(prefix, suffix)
    return {prefix = prefix, suffix = suffix or ""}
end

local slash = create_comment("//")
local hash = create_comment([[\\#]])

local filetype_comment = {
    javascript = slash,
    typescript = slash,
    go         = slash,
    c          = slash,
    cpp        = slash,
    php        = slash,
    scss       = slash,
    vue        = slash,
    dart       = slash,
    jsonc      = slash,
    sh         = hash,
    python     = hash,
    yaml       = hash,
    asm        = hash,
    html       = create_comment([[\<\!--]], [[--\>]]),
    css        = create_comment([[/\*]], [[\*/]]),
    lua        = create_comment("--"),
    vim        = create_comment([[\"]]),
    yasm       = create_comment([[\;]])
}

function M.toggle()
    local ft = vim.bo.filetype
    local comment = filetype_comment[ft]

    if comment == nil then
        vim.schedule(function()
            vim.api.nvim_err_writeln(string.format("comment-toggler: filetype '%s' is not supported", ft))
        end)
        return "<esc>"
    end

    local range_start = vim.fn.line('v')
    local range_end = vim.fn.line('.')

    if range_start > range_end then
        range_start, range_end = range_end, range_start
    end

    return string.format("<cmd>%d,%d!~/.local/lib/vim-filter-toggle-comment %s %s<cr><esc>", range_start, range_end, comment.prefix, comment.suffix)
end

return M
