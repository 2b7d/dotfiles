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
