vim9script

if exists("b:did_ftplugin")
    finish
endif
b:did_ftplugin = 1

setlocal comments=:;
setlocal commentstring=;%s
