# Marks from:
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
        ls -l "$MARKPATH" | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
}

_completemarks() {
      local curw=${COMP_WORDS[COMP_CWORD]}
        local wordlist=$(find $MARKPATH -type l -printf "%f\n")
              COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
                return 0
}

complete -F _completemarks jump unmark
# end of marks

# vim mode
set -o vi

# prompt
export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \$\[\033[00m\] '

# aliases
alias l="ls -la"
alias ll="ls -l"
