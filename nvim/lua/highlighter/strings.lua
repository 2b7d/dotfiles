local M = {}

local hi_state = false

function M.highlight()
    hi_state = not hi_state

    local fg = "fg"
    if hi_state then
        fg = "red"
    end

    vim.cmd.hi("String guifg="..fg)
end

return M
