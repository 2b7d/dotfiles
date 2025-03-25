vim9script

hi clear

if exists("g:syntax_on")
    syn reset
endif

g:colors_name = "art"

const black   = "#1a1a1a"
const red     = "#9f6060"
const green   = "#8ba375"
const orange  = "#d9b38c"
const blue    = "#7a9eb8"
const magenta = "#c69fc3"
const cyan    = "#88ddb3"
const white   = "#cccccc"

const lblack   = "#333333"
const llblack  = "#504e49"
const lgreen   = "#b3c2a3"
const yellow   = "#d9d98c"
const lblue    = "#9cbac9"
const lmagenta = "#d7bfd9"
const lcyan    = "#b0e8df"
const lwhite   = "#f2f2f2"

g:terminal_ansi_colors = [
    black, red, green, orange, blue, magenta, cyan, white,
    lblack, llblack, lgreen, yellow, lblue, lmagenta, lcyan, lwhite
]

v:colornames.art_black   = black
v:colornames.art_red     = red
v:colornames.art_green   = green
v:colornames.art_orange  = orange
v:colornames.art_blue    = blue
v:colornames.art_magenta = magenta
v:colornames.art_cyan    = cyan
v:colornames.art_white   = white

v:colornames.art_lblack   = lblack
v:colornames.art_llblack  = llblack
v:colornames.art_lgreen   = lgreen
v:colornames.art_yellow   = yellow
v:colornames.art_lblue    = lblue
v:colornames.art_lmagenta = lmagenta
v:colornames.art_lcyan    = lcyan
v:colornames.art_lwhite   = lwhite

const gui2term = {
    NONE: "NONE",
    fg:   "fg",
    bg:   "bg",

    art_black:   "0",
    art_red:     "1",
    art_green:   "2",
    art_orange:  "3",
    art_blue:    "4",
    art_magenta: "5",
    art_cyan:    "6",
    art_white:   "7",

    art_lblack:   "8",
    art_llblack:  "9",
    art_lgreen:   "10",
    art_yellow:   "11",
    art_lblue:    "12",
    art_lmagenta: "13",
    art_lcyan:    "14",
    art_lwhite:   "15"
}

def Hi(group: string, mode: string, guifg: string, guibg: string): void
    var termfg = gui2term[guifg]
    var termbg = gui2term[guibg]
    execute printf("hi %s gui=%s guifg=%s guibg=%s cterm=%s ctermfg=%s ctermbg=%s", group, mode, guifg, guibg, mode, termfg, termbg)
enddef

Hi("HiDebug",       "NONE",      "art_red",     "art_cyan")
Hi("Normal",        "NONE",      "art_white",   "art_black")
Hi("SpecialKey",    "NONE",      "art_cyan",    "NONE")
Hi("NonText",       "NONE",      "art_llblack", "NONE")
Hi("Directory",     "NONE",      "art_blue",    "NONE")
Hi("ErrorMsg",      "NONE",      "NONE",        "art_red")
Hi("IncSearch",     "NONE",      "bg",          "art_orange")
Hi("Search",        "NONE",      "bg",          "art_blue")
Hi("MoreMsg",       "NONE",      "art_green",   "NONE")
Hi("LineNr",        "NONE",      "art_llblack", "NONE")
Hi("Question",      "NONE",      "art_green",   "NONE")
Hi("StatusLine",    "NONE",      "NONE",        "art_lblack")
Hi("StatusLineNC",  "NONE",      "art_llblack", "art_lblack")
Hi("VertSplit",     "NONE",      "bg",          "art_lblack")
Hi("Title",         "NONE",      "art_magenta", "NONE")
Hi("Visual",        "NONE",      "bg",          "fg")
Hi("WarningMsg",    "NONE",      "art_orange",  "NONE")
Hi("Folded",        "NONE",      "art_cyan",    "NONE")
Hi("SignColumn",    "NONE",      "art_lblack",  "NONE")
Hi("Pmenu",         "NONE",      "NONE",        "art_llblack")
Hi("PmenuSel",      "NONE",      "bg",          "art_orange")
Hi("PmenuSbar",     "NONE",      "NONE",        "art_lblack")
Hi("PmenuThumb",    "NONE",      "NONE",        "art_orange")
Hi("TabLine",       "NONE",      "art_llblack", "art_lblack")
Hi("TabLineSel",    "NONE",      "NONE",        "art_lblack")
Hi("ColorColumn",   "NONE",      "NONE",        "art_lblack")
Hi("Cursor",        "NONE",      "bg",          "art_red")
Hi("MessageWindow", "NONE",      "art_orange",  "art_llblack")
Hi("Comment",       "NONE",      "art_green",   "NONE")
Hi("Underlined",    "underline", "NONE",        "NONE")

hi! link Terminal          Normal
hi! link CurSearch         IncSearch
hi! link FoldColumn        Folded
hi! link TabLineFill       TabLine
hi! link QuickFixLine      PmenuSel
hi! link StatusLineTerm    StatusLine
hi! link StatusLineTermNC  StatusLineNC
hi! link PopupNotification MessageWindow
hi! link Error             ErrorMsg
hi! link Todo              Comment

hi clear ModeMsg
hi clear Constant
hi clear Identifier
hi clear Statement
hi clear PreProc
hi clear Type
hi clear Special
hi clear Ignore

if !has("gui_running") && str2nr(&t_Co) == 8
    hi IncSearch     ctermfg=bg ctermbg=5
    hi Search                   ctermbg=3
    hi StatusLine               ctermbg=4
    hi StatusLineNC  ctermfg=bg ctermbg=fg
    hi VertSplit                ctermbg=fg
    hi Pmenu         ctermfg=bg ctermbg=fg
    hi PmenuSbar                ctermbg=fg
    hi PmenuThumb               ctermbg=3
    hi TabLine       ctermfg=bg ctermbg=fg
    hi TabLineSel    ctermfg=fg ctermbg=4
    hi MessageWindow ctermfg=bg ctermbg=fg
    hi ColorColumn   ctermfg=bg ctermbg=fg

    hi! link NonText    SpecialKey
    hi! link SignColumn SpecialKey
    hi! link LineNr     SpecialKey
endif

# not used
hi! link CursorLineNr  HiDebug
hi! link VisualNOS     HiDebug
hi! link WildMenu      HiDebug
hi! link DiffAdd       HiDebug
hi! link DiffChange    HiDebug
hi! link DiffDelete    HiDebug
hi! link DiffText      HiDebug
hi! link Conceal       HiDebug
hi! link SpellBad      HiDebug
hi! link SpellCap      HiDebug
hi! link SpellRare     HiDebug
hi! link SpellLocal    HiDebug
hi! link CursorColumn  HiDebug
hi! link CursorLine    HiDebug
hi! link lCursor       HiDebug
hi! link MatchParen    HiDebug
hi! link ToolbarLine   HiDebug
hi! link ToolbarButton HiDebug
hi! link Added         HiDebug
hi! link Changed       HiDebug
hi! link Removed       HiDebug
