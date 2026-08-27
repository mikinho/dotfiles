# .bash_aliases

# Bash Functions

function git-root
{
    local NEXT_ROOT
    local ROOT

    ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || return
    while NEXT_ROOT=$(git -C "$ROOT/.." rev-parse --show-toplevel 2>/dev/null)
    do
        [ "$NEXT_ROOT" != "$ROOT" ] || break
        ROOT=$NEXT_ROOT
    done

    cd "$ROOT" || return
}

# Add some easy shortcuts for formatted directory listings
if ls --color=auto &>/dev/null; then
    alias ll='ls --color=auto -lF'
    alias la='ls --color=auto -alF'
    alias ls='ls --color=auto -F'
else
    alias ll='ls -lF'
    alias la='ls -alF'
    alias ls='ls -F'
fi

alias kp='ps auxwww'

# git helper aliases. they change the cwd so they need to be outside of .gitconfig
alias git-top='cd "$(git rev-parse --show-toplevel)"'
