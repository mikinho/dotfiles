# .zprofile

# Source .profile for shared login shell config
if [ -f "$HOME/.profile" ]; then
    source "$HOME/.profile"
fi

if command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv)"
fi
