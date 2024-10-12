# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source ~/.bash_aliases

PS1="\[\e[33m\]\[\e[m\]\[\e[33m\]\u\[\e[m\]\[\e[33m\] \[\e[m\]\[\e[34m\]\[\e[m\]\[\e[34m\]\w\[\e[m\]\[\e[34m\] \[\e[m\]\[\e[35m\]\\$\[\e[m\] "

~/.local/lib/random-terminal-art
