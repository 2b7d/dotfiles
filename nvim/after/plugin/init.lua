if vim.g.loaded_after_init then
    return
end
vim.g.loaded_after_init = true

vim.keymap.del("o", "%")
vim.keymap.del("x", "a%")
vim.keymap.del({"n", "o", "x"}, "[%")
vim.keymap.del({"n", "o", "x"}, "]%")
vim.keymap.del({"n", "o", "x"}, "g%")
vim.keymap.del({"n", "o", "x"}, "gc")
vim.keymap.del("n", "&")
vim.keymap.del("n", "[d")
vim.keymap.del("n", "]d")
vim.keymap.del("n", "gcc")
vim.keymap.del("n", "<C-W><C-D>")
vim.keymap.del("n", "<C-W>d")

vim.keymap.del("n", "<Plug>PlenaryTestFile")

vim.keymap.del({"n", "o", "v"}, "<Plug>luasnip-expand-repeat")
vim.keymap.del("n", "<Plug>luasnip-delete-check")

vim.keymap.del("n", "<Plug>(MatchitNormalMultiForward)")
vim.keymap.del("n", "<Plug>(MatchitNormalMultiBackward)")
vim.keymap.del("n", "<Plug>(MatchitNormalBackward)")
vim.keymap.del("n", "<Plug>(MatchitNormalForward)")
vim.keymap.del("o", "<Plug>(MatchitOperationMultiForward)")
vim.keymap.del("o", "<Plug>(MatchitOperationMultiBackward)")
vim.keymap.del("o", "<Plug>(MatchitOperationBackward)")
vim.keymap.del("o", "<Plug>(MatchitOperationForward)")

vim.keymap.del("x", "<Plug>(MatchitVisualTextObject)")
vim.keymap.del("v", "<Plug>(MatchitVisualMultiForward)")
vim.keymap.del("v", "<Plug>(MatchitVisualMultiBackward)")
vim.keymap.del("v", "<Plug>(MatchitVisualBackward)")
vim.keymap.del("v", "<Plug>(MatchitVisualForward)")

vim.keymap.del("x", "@")
vim.keymap.del("x", "Q")

vim.keymap.del("v", "<Plug>luasnip-jump-prev")
vim.keymap.del("v", "<Plug>luasnip-jump-next")
vim.keymap.del("v", "<Plug>luasnip-prev-choice")
vim.keymap.del("v", "<Plug>luasnip-next-choice")
vim.keymap.del("v", "<Plug>luasnip-expand-snippet")
vim.keymap.del("v", "<Plug>luasnip-expand-or-jump")
