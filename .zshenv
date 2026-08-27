# .zshenv

# Keep this file silent: zsh loads it for interactive shells, scripts, and
# non-interactive SSH commands.
if [ -f "$HOME/.profile" ]; then
    source "$HOME/.profile"
fi
