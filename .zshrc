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

    case $(uname) in
        "Darwin")
            PLATFORM=.mac
            ;;
        *)
            PLATFORM=."$(tr '[:upper:]' '[:lower:]' <<< "$(uname)")"
            ;;
    esac

    __source "$HOME/$PLATFORM"
}

function __source_local
{
    __source "$HOME/.$(hostname -s 2>/dev/null || hostname | sed -e 's/\..*$//')"
}

# Source .profile for login shell config
__source "$HOME/.profile"

export EDITOR=vim

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt APPEND_HISTORY
setopt SHARE_HISTORY

# Case-insensitive globbing
setopt NO_CASE_GLOB

# Autocorrect typos in path names when using `cd`
setopt CORRECT

# Navigation
setopt AUTO_CD              # type a directory name to cd into it
setopt AUTO_PUSHD           # cd pushes onto dir stack (cd -2, cd -3, etc.)
setopt PUSHD_SILENT         # don't print dir stack on every cd

# Key bindings
bindkey '\eb' backward-word             # Alt+Left  (Alt+b)
bindkey '\ef' forward-word              # Alt+Right (Alt+f)
bindkey '\e[1;3D' backward-word         # Alt+Left  (escape sequence)
bindkey '\e[1;3C' forward-word          # Alt+Right (escape sequence)

# Prefix-based history search (type partial command, then up/down)
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '\e[A' up-line-or-beginning-search      # Up
bindkey '\e[B' down-line-or-beginning-search    # Down

# Edit current command in vim with Ctrl+x Ctrl+e
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# Source .bash_aliases (compatible with zsh)
__source "$HOME/.bash_aliases"

# Git prompt for zsh
if command -v git &>/dev/null; then
    function __git_prompt
    {
        local status_output
        status_output=$(git status --branch --porcelain --ignore-submodules --untracked-files=normal 2>/dev/null)
        if [ -z "$status_output" ]; then
            return
        fi

        local header
        header=$(head -1 <<< "$status_output")

        # Extract branch name (strip "## " prefix and any tracking info)
        local branch
        branch=$(sed -e 's/^## //' -e 's/\.\.\..*//' <<< "$header")

        local dirty=""
        if [ "$(wc -l <<< "$status_output")" -gt 1 ]; then
            dirty="*"
        fi

        local ahead=""
        if grep -q '\[ahead [0-9]*\]' <<< "$header"; then
            ahead="+"
        fi

        echo " (${branch}${dirty}${ahead})"
    }

    setopt PROMPT_SUBST
    PROMPT='%F{magenta}%n@%m%f%F{yellow} %~%f$(__git_prompt) %F{white}$%f: '
else
    PROMPT='%F{magenta}%n@%m%f%F{yellow} %~%f %F{white}$%f: '
fi

# Set terminal window/tab title
precmd () {
    echo -ne "\033]0;${HOST}: ${PWD/$HOME/~}\007"
}

# Source platform and host specific config
__source_platform
__source_local

# Source .zshrc.local for machine-specific config not tracked by git
__source "$HOME/.zshrc.local"

# Enable completion
autoload -Uz compinit && compinit

unset -f __source
unset -f __source_platform
unset -f __source_local
