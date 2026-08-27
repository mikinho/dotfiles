# .zprofile

# Configure the login-shell environment after .zshenv loads shared settings.
if command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv)"
fi
