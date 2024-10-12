if vim.b.did_ftplugin == 1 then
    return
end
vim.b.did_ftplugin = 1

vim.opt_local.expandtab = false
vim.opt_local.colorcolumn = "120"

local id = vim.api.nvim_create_augroup("GoBuffer", {clear = true})
vim.api.nvim_create_autocmd("BufWritePost", {
    group = id,
    pattern = "*.go",
    command = "!~/.local/lib/go/bin/goimports -w %"
})
