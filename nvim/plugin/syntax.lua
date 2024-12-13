if vim.g.loaded_syntax then
    return
end
vim.g.loaded_syntax = true

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.treesitter.stop()

        vim.cmd.syntax({"match", "global_shebang", "/#!.*/"})
        vim.cmd.highlight({"def", "link", "global_shebang", "Comment"})
    end
})
