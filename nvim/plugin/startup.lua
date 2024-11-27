if vim.g.loaded_startup == 1 then
    return
end
vim.g.loaded_startup = 1

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.treesitter.stop()

        vim.cmd.syntax({"match", "global_shebang", "/#!.*/"})
        vim.cmd.highlight({"def", "link", "global_shebang", "Comment"})
    end
})

local hi_state = false

vim.keymap.set("n", "<leader>hs", function()
    local val = "red"
    if hi_state then
        val = "fg"
    end
    vim.cmd("hi String guifg=" .. val)
    hi_state = not hi_state
end)
