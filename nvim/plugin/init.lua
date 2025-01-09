if vim.g.loaded_init then
    return
end
vim.g.loaded_init = true

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.treesitter.stop()
        vim.cmd.syn("match global_shebang '#!.*'")
        vim.cmd.hi("def link global_shebang Comment")
    end
})
