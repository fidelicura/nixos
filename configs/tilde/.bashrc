# {{ INTERACTIVE }}
[[ $- != *i* ]] && return
# {{ INTERACTIVE }}



# {{ PROMPT }}
PS1="\n[#] \w [>] "
# {{ PROMPT }}



# {{ VARIABLES }}
source ~/.bash_profile
# {{ VARIABLES }}



# {{ ALIASES }}
alias h="hx"
alias cc="clang"
alias ll="ls -lA"
alias py="python3"
alias ls="ls --color"
alias xdg-open="handlr open"
alias xclip="xclip -selection c"
# {{ ALIASES }}



# {{ FUNCTIONS }}
function cd() { command cd "$@"; ls; }
function clear() { command clear; bunnyfetch; echo; ls; }

function bashclear() {
    history -c && history -w;
    clear;
    printf "\n[$] > Bash history cleared.\n";
}

function screenrec() {
    ffmpeg -f x11grab -i :0.0 $HOME/documents/videos/$(date "+%Y-%m-%d_%H-%M-%S").mkv
}

function sus() {
    local args="$@";
    su -c "$args"
}

function nsync() {
    local stamp="$(date +'%Y-%m-%d')"

    pushd $HOME/documents/notes

    git add . &&
    git commit -m "[script] $stamp" &&
    git push

    popd
}

function nedit() {
  local filepath=$(find $HOME/documents/notes/content/ -not -path '*/.*' | fzf)
  hx "$filepath"
}
# {{ FUNCTIONS }}



# {{ ON STARTUP }}
clear
. "/home/fidelicura/.own/rust/cargo/env"
# {{ ON STARTUP }}
