export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

alias dc="docker compose"
alias dcr="docker compose run --rm"
alias dcu="docker compose up -d"
alias dcd="docker compose down"

alias nv=nvim

alias chat='cursor-agent --workspace "$HOME/chat" --model auto --resume=00000000-0000-0000-0000-000000000000'


#if [ -z "$TMUX" ]; then
# tmux
#fi

HISTSIZE=10000000      # Сколько команд хранить в текущей сессии (в памяти)
SAVEHIST=10000000      # Сколько команд хранить в файле истории на диске
HISTFILE=~/.zshhistory # Путь к файлу истории (убедись, что он такой)

setopt HIST_IGNORE_DUPS     # Не сохранять дубликаты, если команда введена подряд
setopt HIST_IGNORE_ALL_DUPS # Удалять старую копию команды, если ввел её снова
setopt HIST_REDUCE_BLANKS   # Удалять лишние пробелы в командах
setopt SHARE_HISTORY        # Делиться историей между всеми открытыми окнами терминала
setopt APPEND_HISTORY       # Дописывать историю, а не перезаписывать её

export PATH="$HOME/.local/bin:$PATH"
export EDITOR=vim
