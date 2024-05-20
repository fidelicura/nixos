# {{ INTERACTIVE }}
[[ $- != *i* ]] && return

case $- in
    *i*) ;;
    *) return;;
esac

complete -cf sudo
complete -cf man

shopt -s checkwinsize
# {{ INTERACTIVE }}



# {{ GARBAGE }}
LESSHISTFILE=-
# {{ GARBAGE }}



# {{ PROMPT }}
PS1="\n[#] \w [>] "
# {{ PROMPT }}



# {{ VARIABLES }}
source ~/.bash_profile
source ~/.bash_aliases
# {{ VARIABLES }}



# {{ FUNCTIONS }}
cd() { command cd "$@"; ls; }
clear() { command clear; ls; }

bashclear() {
    history -c && history -w
    clear
    printf "\n[$] > Bash history cleared.\n"
}

nsync() {
    local stamp="$(date +'%Y-%m-%d')"

    pushd $HOME/Documents/personal

    git add . &&
    git commit -m "[script] $stamp" &&
    git push

    popd
}

nedit() {
    local filepath=$(find $HOME/Documents/personal -not -path '*/.*' | fzf)
    hx "$filepath"
}

gco() {
    git checkout $(git branch | fzf)
}
# {{ FUNCTIONS }}



# {{ ON STARTUP }}
clear
# {{ ON STARTUP }}
