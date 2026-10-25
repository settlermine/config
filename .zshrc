export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
# vim mode settings
KEYTIMEOUT=1

plugins=(git vi-mode)

source $ZSH/oh-my-zsh.sh

alias dc="docker compose"
alias dcr="docker compose run --rm"
alias dcu="docker compose up -d"
alias dcd="docker compose down"

alias dcn="devcontainer"

alias lmake="make -f local.Makefile"

HISTSIZE=10000000
SAVEHIST=10000000

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.devcontainers/bin:$PATH"

export EDITOR=nvim
