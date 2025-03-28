vim9script noclear

if exists("g:did_load_filetypes")
    finish
endif

augroup filetypedetect
    au! BufRead,BufNewFile *.yasm setfiletype yasm
augroup END
