local M = {}

local hi_strings = false

function M.strings()
    hi_strings = not hi_strings

    local fg = "fg"
    if hi_strings then
        fg = "red"
    end

    vim.cmd("hi String guifg=" .. fg)
end

return M
