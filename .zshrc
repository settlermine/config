export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

alias dc="docker compose"
alias dcr="docker compose run --rm"
alias dcu="docker compose up -d"
alias dcd="docker compose down"

alias dcn="devcontainer"

alias vim=nvim

alias lmake="make -f local.Makefile"

HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.zshhistory

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt APPEND_HISTORY

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.devcontainers/bin:$PATH"

export EDITOR=vim
