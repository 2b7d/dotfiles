vim.cmd("hi clear")

if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
end

vim.g.colors_name = "art"
vim.g.loaded_matchparen = 1

vim.opt.background = "dark"

local black   = "#2f2e2d"  -- 0
local red     = "#a36666"  -- 1
local green   = "#90a57d"  -- 2
local yellow  = "#d7af87"  -- 3
local blue    = "#7fa5bd"  -- 4
local magenta = "#c79ec4"  -- 5
local cyan    = "#8adbb4"  -- 6
local white   = "#d0d0d0"  -- 7

local lblack   = "#4a4845" -- 8
local lred     = "#d78787" -- 9
local lgreen   = "#afbea2" -- 10
local lyellow  = "#d7d787" -- 11
local lblue    = "#a1bdce" -- 12
local lmagenta = "#d7beda" -- 13
local lcyan    = "#b1e7dd" -- 14
local lwhite   = "#efefef" -- 15

local background = "#1c1c1c"
local foreground = white

-- TODO(art), 07.10.24: term support?
local hi = function(group, gui)
    local gui_fg, gui_bg, gui_mod = unpack(gui)
    gui_mod = gui_mod or "NONE"

    local args = {group, "cterm=NONE", "ctermfg=NONE", "ctermbg=NONE"}
    table.insert(args, "gui="..gui_mod)

    if gui_fg ~= nil then
        table.insert(args, "guifg="..gui_fg)
    end

    if gui_bg ~= nil then
        table.insert(args, "guibg="..gui_bg)
    end

    vim.cmd.highlight(args)
end

local link = function(from, to)
    vim.cmd.highlight({bang = true, "link", from, to})
end

-- UI
hi("Normal", {foreground, background})

hi("HiDebug", {"bg", white})

link("TermCursor", "HiDebug")
link("Cursor",     "HiDebug")
link("lCursor",    "HiDebug")

hi("SpecialKey",   {cyan})
hi("NonText",      {lblack})
hi("Directory",    {blue})
hi("ErrorMsg",     {"fg", red})
hi("Visual",       {"bg", "fg"})

hi("StatusLine",   {"fg", black})
hi("StatusLineNC", {lblack, black})

hi("ModeMsg",      {"fg"})
link("WildMenu", "HiDebug")

hi("LineNr",       {black, "bg"})
hi("SignColumn",   {black, "bg"})

hi("Pmenu",        {"fg", lblack})
hi("PmenuSel",     {"bg", magenta})
hi("PmenuSbar",    {_, black})
hi("PmenuThumb",   {_, "fg"})
hi("ColorColumn",  {_, black})
hi("WinSeparator", {"bg", black})

hi("IncSearch",    {"bg", magenta})
hi("Search",       {"bg", magenta})

hi("TabLine",      {lblack, black})
hi("TabLineSel",   {"fg", black})
link("TabLineFill", "TabLine")

hi("Title",        {magenta})
hi("MoreMsg",      {green})
hi("Question",     {green})
hi("WarningMsg",   {yellow})
hi("Folded",       {cyan, "bg"})

link("FoldColumn",   "Folded")

link("DiffAdd",    "HiDebug")
link("DiffChange", "HiDebug")
link("DiffDelete", "HiDebug")
link("DiffText",   "HiDebug")

link("SpellBad",   "HiDebug")
link("SpellCap",   "HiDebug")
link("SpellRare",  "HiDebug")
link("SpellLocal", "HiDebug")

-- Languages
hi("Comment", {green})

hi("Constant", {"fg"})
hi("String",   {"fg"})

link("Character", "Constant")
link("Number",    "Constant")
link("Boolean",   "Constant")
link("Float",     "Constant")

hi("Identifier", {"fg"})
link("Function", "Identifier")

hi("Statement", {"fg"})
link("Conditional", "Statement")
link("Repeat",      "Statement")
link("Label",       "Statement")
link("Operator",    "Statement")
link("Keyword",     "Statement")
link("Exception",   "Statement")

hi("PreProc", {"fg"})
link("Include",   "PreProc")
link("Define",    "PreProc")
link("Macro",     "PreProc")
link("PreCondit", "PreProc")

hi("Type", {"fg"})
link("StorageClass", "Type")
link("Structure",    "Type")
link("Typedef",      "Type")

hi("Special", {"fg"})
link("SpecialChar",    "Special")
link("Tag",            "Special")
link("Delimiter",      "Special")
link("SpecialComment", "Special")
link("Debug",          "Special")

hi("Underlined", {"fg", _, "underline"})

hi("Ignore", {"fg"})

link("Error", "ErrorMsg")

link("Todo", "Comment")

-- Telescope
link("TelescopeMatching", "IncSearch")
hi("TelescopeSelection", {"fg", lblack})
