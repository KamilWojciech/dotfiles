# default oh my zsh stuff
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell_custom"
export UPDATE_ZSH_DAYS=14
plugins=(git)
source $ZSH/oh-my-zsh.sh

# aliases
alias l="ls -la"
alias ll="ls -l"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

alias up="vagrant up --no-provision"

# vim keybinding in zsh
set -o vi
bindkey -v

# incremental search with '?'
bindkey -M vicmd '?' history-incremental-search-backward

# marks
# http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html
export MARKPATH=$HOME/.marks
function jump { 
    cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}
function mark { 
    mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}
function unmark { 
    rm -i "$MARKPATH/$1"
}
function marks {
    \ls -l "$MARKPATH" | tail -n +2 | sed 's/  / /g' | cut -d' ' -f9- | awk -F ' -> ' '{printf "%-10s -> %s\n", $1, $2}'
}

function _completemarks {
  reply=($(ls $MARKPATH))
}

compctl -K _completemarks jump
compctl -K _completemarks unmark

export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
