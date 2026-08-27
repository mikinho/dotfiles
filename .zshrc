# .zshrc

# Persist and share history across interactive zsh sessions.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt APPEND_HISTORY
setopt SHARE_HISTORY

# Load shared aliases, then increasingly specific overrides.
[[ -f "$HOME/.bash_aliases" ]] && source "$HOME/.bash_aliases"

case "$OSTYPE" in
    darwin*) [[ -f "$HOME/.mac" ]] && source "$HOME/.mac" ;;
    linux*) [[ -f "$HOME/.linux" ]] && source "$HOME/.linux" ;;
esac

HOST_CONFIG="$HOME/.${HOST%%.*}"
[[ -f "$HOST_CONFIG" ]] && source "$HOST_CONFIG"
unset HOST_CONFIG

[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# Enable zsh completion.
autoload -Uz compinit && compinit

# Use Starship when installed and retain zsh's default prompt otherwise.
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi
