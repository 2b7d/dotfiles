vim.env.BASH_ENV = "~/.bash_aliases"

vim.g.mapleader = " "

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.tabpagemax = 5
vim.opt.errorbells = false
vim.opt.hlsearch = false
vim.opt.hidden = true
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"
vim.opt.scrolloff = 20
vim.opt.list = true
vim.opt.listchars = {trail = "·", tab = "  "}
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.cmd.colorscheme("art")

-- Telescope
require("telescope").setup({
    defaults = {
        sorting_strategy = "ascending",
        layout_strategy = "vertical",
        layout_config = {
            preview_cutoff = 1,
            prompt_position = "top",
            height = 100,
            width = function(_, max_columns, _)
                return math.min(max_columns, 90)
            end
        },
        buffer_previewer_maker = function(a, b, c)
            c.use_ft_detect = false
            require("telescope.previewers").buffer_previewer_maker(a, b, c)
        end
    }
})

local telescope_builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files)
vim.keymap.set("n", "<leader>fb", telescope_builtin.buffers)
vim.keymap.set("n", "<leader>fc", telescope_builtin.current_buffer_fuzzy_find)
vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep)
vim.keymap.set("n", "<leader>fs", telescope_builtin.grep_string)

-- LuaSnip
local luasnip = require("luasnip")
require("luasnip-snippets")

luasnip.config.set_config({
    history = false,
    updateevents = "TextChangedI"
})

vim.keymap.set("n", "<leader>ss", luasnip.unlink_current)

vim.keymap.set("i", "<tab>", function()
    if luasnip.expand_or_jumpable() then
        return "<plug>luasnip-expand-or-jump"
    end
    return "<tab>"
end, {remap = true, expr = true})
