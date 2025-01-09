vim.cmd.hi("clear")

if vim.g.syntax_on ~= nil then
    vim.cmd.syn("reset")
end

vim.g.colors_name = "art"

local black   = "#333333"  -- 0
local red     = "#9f6060"  -- 1
local green   = "#8ba375"  -- 2
local yellow  = "#d9b38c"  -- 3
local blue    = "#7a9eb8"  -- 4
local magenta = "#c69fc3"  -- 5
local cyan    = "#88ddb3"  -- 6
local white   = "#cccccc"  -- 7

local lblack   = "#504e49" -- 8
local lred     = "#d98c8c" -- 9
local lgreen   = "#b3c2a3" -- 10
local lyellow  = "#d9d98c" -- 11
local lblue    = "#9cbac9" -- 12
local lmagenta = "#d7bfd9" -- 13
local lcyan    = "#b0e8df" -- 14
local lwhite   = "#f2f2f2" -- 15

local background = "#1a1a1a"
local foreground = white

-- TODO(art), 07.10.24: term support?
-- TODO(art), 19.12.24: try to use builtin nvim function
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

    vim.cmd.hi(args)
end

local link = function(from, to)
    vim.cmd.hi({bang = true, "link", from, to})
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
