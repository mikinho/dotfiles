# .zshrc

function __source
{
    while (( "$#" )); do
        if [ -f "$1" ]; then
            source "$1"
        fi
        shift
    done
}

function __source_platform
{
    local PLATFORM
    local SYSTEM_NAME

    SYSTEM_NAME=$(uname -s)
    case "$SYSTEM_NAME" in
        Darwin)
            PLATFORM=.mac
            ;;
        *)
            PLATFORM=."$(tr '[:upper:]' '[:lower:]' <<< "$SYSTEM_NAME")"
            ;;
    esac

    __source "$HOME/$PLATFORM"
}

function __source_local
{
    local HOST_NAME

    HOST_NAME=$(hostname -s 2>/dev/null || hostname | sed -e 's/\..*$//')
    __source "$HOME/.$HOST_NAME"
}

# Persist and share history across interactive zsh sessions.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt APPEND_HISTORY
setopt SHARE_HISTORY

# Load shared aliases, then increasingly specific overrides.
__source "$HOME/.bash_aliases"
__source_platform
__source_local
__source "$HOME/.zshrc.local"

# Enable zsh completion.
autoload -Uz compinit && compinit

# Use Starship when installed and retain zsh's default prompt otherwise.
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

unset -f __source
unset -f __source_platform
unset -f __source_local
