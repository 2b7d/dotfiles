if vim.b.did_ftplugin then
    return
end
vim.b.did_ftplugin = true

vim.opt_local.expandtab = false
vim.opt_local.colorcolumn = "120"

local id = vim.api.nvim_create_augroup("GoBuffer", {})
vim.api.nvim_create_autocmd("BufWritePost", {
    group = id,
    pattern = "*.go",
    command = "silent !~/.local/lib/go/bin/goimports -w %"
})
