if vim.g.loaded_syntax then
    return
end
vim.g.loaded_syntax = true

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.treesitter.stop()
        vim.cmd([[
            syn match global_shebang "#!.*"
            hi def link global_shebang Comment
        ]])
    end
})
