local M = {}

local hi_ns = vim.api.nvim_create_namespace("")
vim.api.nvim_set_hl_ns(hi_ns)

vim.api.nvim_set_hl(hi_ns, "hl_0", {fg = "magenta"})
vim.api.nvim_set_hl(hi_ns, "hl_1", {fg = "yellow"})
vim.api.nvim_set_hl(hi_ns, "hl_2", {fg = "cyan"})
vim.api.nvim_set_hl(hi_ns, "hl_3", {fg = "green"})
vim.api.nvim_set_hl(hi_ns, "hl_4", {fg = "red"})

local SYM_OPEN = 0
local SYM_CLOSE = 1

local SYMS = {
    [string.byte("(")] = SYM_OPEN,
    [string.byte("[")] = SYM_OPEN,
    [string.byte("{")] = SYM_OPEN,
    [string.byte(")")] = SYM_CLOSE,
    [string.byte("]")] = SYM_CLOSE,
    [string.byte("}")] = SYM_CLOSE,
}

local skip_hlname = {
    ["Comment"] = 1,
    ["String"] = 1,
    ["Character"] = 1
}

function M.parens()
    local begin, end_ = vim.fn.line("w0") - 1, vim.fn.line("w$")
    local lines = vim.api.nvim_buf_get_lines(0, begin, end_, 1)
    local id = 1000
    local tt = {}

    vim.schedule(function()
        local level = 0
        for i, line in ipairs(lines) do
            for j = 1, #line do
                local ch = string.byte(line, j)
                local sym_kind = SYMS[ch]
                if sym_kind ~= nil then
                    local hlname = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.synID(begin + i, j, true)), "name")
                    if skip_hlname[hlname] == nil then
                        local group = "hl_"..level%5
                        if sym_kind == SYM_CLOSE then
                            if level > 0 then
                                level = level - 1
                            end
                            group = "hl_"..level%5
                        else -- SYM_OPEN
                            level = level + 1
                        end
                        table.insert(tt, {
                            group = group,
                            id = id,
                            pos1 = {begin + i, j, 1},
                            priority = 10,
                        })
                        id = id + 1
                    end
                end
            end
        end
        vim.fn.setmatches(tt)
    end)
end

local id = vim.api.nvim_create_augroup("plugin_highlighter", {})
--vim.api.nvim_create_autocmd({"WinScrolled", "TextChanged", "TextChangedI", "BufEnter"}, {
--    group = id,
--    pattern = "*",
--    callback = function()
--        M.parens()
--    end
--})

return M
