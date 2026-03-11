dotfiles
========

Shell, git, and editor configuration for macOS and Linux.

Supports both **bash** and **zsh** with a shared config architecture that sources global, platform-specific, and host-specific settings automatically.

## Setup

```bash
git clone https://github.com/mikinho/dotfiles.git && cd dotfiles
./install_deps      # install system dependencies (homebrew, vim, git, etc.)
./setupenv          # symlink dotfiles to $HOME
```

Use `./setupenv -f` to skip the confirmation prompt.

## Structure

| Path | Purpose |
|------|---------|
| `setupenv` | Symlinks dotfiles to `$HOME`, copies SSH config, runs platform setup |
| `install_deps` | Installs packages via Homebrew (macOS) or apt/dnf (Linux) |
| `mac/` | macOS-specific aliases and setup (Sublime Text CLI, DNS flush, etc.) |
| `linux/` | Linux-specific config |
| `.profile` | Shared login shell config (PATH setup, JAVA_HOME) |
| `.bashrc` / `.zshrc` | Interactive shell config with git prompt, aliases, history |
| `.bash_aliases` | Functions and aliases shared between bash and zsh |
| `.prompt` | Bash-specific PS1 with git branch, dirty, and ahead indicators |
| `.gitconfig` | Git aliases, color settings, and workflow defaults |
| `.vimrc` | Vim defaults (4-space tabs, syntax, line numbers, key mappings) |
| `.editorconfig` | Editor-agnostic formatting rules |

## Customization

Machine-specific config that shouldn't be tracked by git goes in:

- `~/.bashrc.local` (bash)
- `~/.zshrc.local` (zsh)

These are sourced automatically if they exist. You can also create `~/.<hostname>` for host-specific config that applies to both shells.

## Git Aliases

Some highlights from `.gitconfig`:

| Alias | Command |
|-------|---------|
| `git lg` | Pretty graph log with colors |
| `git lsd` | Decorated log with all branches |
| `git staged` / `git unstaged` | Diff shortcuts for staged/unstaged changes |
| `git undo` | Soft reset last commit |
| `git ff` | Fast-forward only merge |
| `git cleanup` | Delete branches already merged into main |
| `git amend` | Amend with previous commit message |
| `git compare` | Show commits ahead of origin/main |
| `git this` | Init a new repo with README.md and .gitignore |
| `git alias` | List all git aliases |

## Note on Git Email

The `.gitconfig` email is intentionally invalid to force per-repo configuration:

```bash
cd your-repo
git config user.email "you@example.com"
```
