vim9script

hi clear

if exists("g:syntax_on")
    syn reset
endif

g:colors_name = "art"

#   black 0      lblack 8
#     red 1     llblack 9
#   green 2      lgreen 10
#  orange 3      yellow 11
#    blue 4       lblue 12
# magenta 5    lmagenta 13
#    cyan 6       lcyan 14
#   white 7      lwhite 15

hi HiDebug       cterm=NONE      ctermfg=1    ctermbg=6
hi Normal        cterm=NONE      ctermfg=7    ctermbg=0
hi SpecialKey    cterm=NONE      ctermfg=6    ctermbg=NONE
hi NonText       cterm=NONE      ctermfg=9    ctermbg=NONE
hi Directory     cterm=NONE      ctermfg=4    ctermbg=NONE
hi ErrorMsg      cterm=NONE      ctermfg=NONE ctermbg=1
hi IncSearch     cterm=NONE      ctermfg=bg   ctermbg=3
hi Search        cterm=NONE      ctermfg=bg   ctermbg=4
hi MoreMsg       cterm=NONE      ctermfg=2    ctermbg=NONE
hi LineNr        cterm=NONE      ctermfg=9    ctermbg=NONE
hi Question      cterm=NONE      ctermfg=2    ctermbg=NONE
hi StatusLine    cterm=NONE      ctermfg=NONE ctermbg=8
hi StatusLineNC  cterm=NONE      ctermfg=9    ctermbg=8
hi VertSplit     cterm=NONE      ctermfg=bg   ctermbg=8
hi Title         cterm=NONE      ctermfg=5    ctermbg=NONE
hi Visual        cterm=NONE      ctermfg=bg   ctermbg=fg
hi WarningMsg    cterm=NONE      ctermfg=3    ctermbg=NONE
hi Folded        cterm=NONE      ctermfg=6    ctermbg=NONE
hi SignColumn    cterm=NONE      ctermfg=8    ctermbg=NONE
hi Pmenu         cterm=NONE      ctermfg=NONE ctermbg=9
hi PmenuSel      cterm=NONE      ctermfg=bg   ctermbg=5
hi PmenuSbar     cterm=NONE      ctermfg=NONE ctermbg=8
hi PmenuThumb    cterm=NONE      ctermfg=NONE ctermbg=5
hi TabLine       cterm=NONE      ctermfg=9    ctermbg=8
hi TabLineSel    cterm=NONE      ctermfg=NONE ctermbg=8
hi ColorColumn   cterm=NONE      ctermfg=NONE ctermbg=8
hi Cursor        cterm=NONE      ctermfg=bg   ctermbg=1
hi MessageWindow cterm=NONE      ctermfg=3    ctermbg=9
hi Comment       cterm=NONE      ctermfg=2    ctermbg=NONE
hi Underlined    cterm=underline ctermfg=NONE ctermbg=NONE

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

if str2nr(&t_Co) == 8
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
