if vim.g.loaded_toggle_comment == 1 then
    return
end
vim.g.loaded_toggle_comment = 1

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

vim.keymap.set({"n", "v"}, "<leader>/", function()
    local ft = vim.bo.filetype
    local comment = filetype_comment[ft]

    if comment == nil then
        vim.schedule(function()
            vim.api.nvim_err_writeln(string.format("plugin/toggle-comment: filetype '%s' is not supported", ft))
        end)
        return "<esc>"
    end

    local line_start = vim.fn.line('v')
    local line_end = vim.fn.line('.')

    if line_start > line_end then
        line_start, line_end = line_end, line_start
    end

    return string.format("<cmd>%d,%d!~/.local/lib/vim-filter-toggle-comment %s %s<cr><esc>", line_start, line_end, comment.prefix, comment.suffix)
end, {expr = true})
