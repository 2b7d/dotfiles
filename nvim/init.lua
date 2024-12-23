vim.env.BASH_ENV = "~/.bash_aliases"

vim.g.mapleader = " "

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.hlsearch = false
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"
vim.opt.scrolloff = 20
vim.opt.list = true
vim.opt.listchars = {trail = "·", tab = "  "}
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.cmd.filetype("indent off")
vim.cmd.colorscheme("art")

-- Highlighter
vim.keymap.set("n", "<leader>hs", require("highlighter").strings)

-- Comment Toggler
vim.keymap.set({"n", "v"}, "<leader>/", require("comment-toggler").toggle, {expr = true})

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

luasnip.add_snippets("all", {
	luasnip.snippet("note", {luasnip.text_node("NOTE(art), " .. os.date("!%d.%m.%y") .. ": ")}),
	luasnip.snippet("todo", {luasnip.text_node("TODO(art), " .. os.date("!%d.%m.%y") .. ": ")}),
})

luasnip.add_snippets("vue", {
    luasnip.snippet("vue", {
        luasnip.text_node({
            "<script setup>",
            'import * as Vue from "vue";',
            "</script>",
            "",
            "<template>",
            "</template>",
            "",
            "<style scoped>",
            "</style>",
        }),
    })
})

luasnip.add_snippets("php", {
    luasnip.snippet("php", {
        luasnip.text_node({
            "<?php",
            "declare(strict_types = 1);",
            "",
            "?>"
        }),
    })
})

for _, lang in pairs({"html", "vue", "php"}) do
    luasnip.add_snippets(lang, {
        luasnip.snippet("tag", {
            luasnip.text_node("<"), luasnip.insert_node(1), luasnip.text_node(">"),
            luasnip.insert_node(0),
            luasnip.text_node("</"), require("luasnip.extras").rep(1), luasnip.text_node(">")
        }),
        luasnip.snippet("html", {
            luasnip.text_node({
                "<!DOCTYPE html>",
                "<html>",
                "<head>",
                    '\t<meta charset="utf-8">',
                    '\t<meta name="viewport" content="width=device-width, initial-scale=1.0">',
                    "\t<title>Title</title>",
                "</head>",
                "<body>",
                "</body>",
                "</html>"
            })
        })
    })
end
