export PATH=$HOME/.local/bin:$PATH

export XINITRC=$HOME/.config/xorg/xinitrc
export XAUTHORITY=$HOME/.local/state/xorg/Xauthority
export NPM_CONFIG_USERCONFIG=$HOME/.config/npm/npmrc
export GOPATH=$HOME/.local/lib/go

export NODE_REPL_HISTORY=$HOME/.local/state/nodejs-history
export TS_NODE_HISTORY=$HOME/.local/state/ts-node-history
export MYSQL_HISTFILE=$HOME/.local/state/mysql-history

export LS_COLORS="rs=0:di=00;34:ln=00;36:mh=00:pi=00:so=00:do=00:bd=00:cd=00:or=00:mi=00:su=00:sg=00:ca=00:tw=00;34:ow=00;34:st=00;34:ex=00;32:"

[[ -f ~/.bashrc ]] && . ~/.bashrc
