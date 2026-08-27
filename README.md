dotfiles
========

Shell, git, and editor configuration for macOS and Linux.

Supports both **bash** and **zsh** with a shared config architecture that sources global, platform-specific, and host-specific settings automatically.

## Setup

```bash
git clone https://github.com/mikinho/dotfiles.git && cd dotfiles
./setupenv          # symlink dotfiles to $HOME
```

Use `./setupenv -f` to skip the confirmation prompt.

On macOS, Ghostty and Starship workstation setup are explicit, review-first
components. The generic bootstrap prints their plan commands but does not
install software or migrate configuration automatically. See the focused
[`mac/ghostty/README.md`](mac/ghostty/README.md) and
[`mac/starship/README.md`](mac/starship/README.md) workflows before applying.

## Structure

| Path | Purpose |
|------|---------|
| `setupenv` | Symlinks dotfiles to `$HOME`, copies SSH config, runs platform setup |
| `mac/` | macOS-specific aliases and setup (Sublime Text CLI, DNS flush, etc.) |
| `mac/ghostty/` | Ghostty, Nerd Font, and conflict-safe config setup for macOS |
| `mac/starship/` | Starship, minimal prompt overrides, and conflict-safe setup for macOS |
| `linux/` | Linux-specific config |
| `.profile` | Silent shared environment setup (PATH, JAVA_HOME, SSH agent socket) |
| `.zshenv` / `.zprofile` | Always-loaded zsh environment and login-only Homebrew setup |
| `.bashrc` / `.zshrc` | Interactive shell config with prompts, aliases, completion, and history |
| `.bash_aliases` | Functions and aliases shared between bash and zsh |
| `.prompt` | Bash-specific PS1 with git branch, dirty, and ahead indicators |
| `.gitconfig` | Git aliases, color settings, and workflow defaults |
| `.vimrc` | Vim defaults (4-space tabs, syntax, line numbers, key mappings) |
| `.editorconfig` | Editor-agnostic formatting rules |

## Project Scaffolding

Starter configs for new projects. Copy what you need:

```bash
cp -r ~/dotfiles/web/. . && cp ~/dotfiles/git/.gitignore-web .gitignore
```

| Path | Purpose |
|------|---------|
| `web/` | Web app configs (eslint, prettier, stylelint, htmlhint, editorconfig) |
| `node/` | npm library configs (eslint, prettier, npmignore, editorconfig) |
| `git/` | Gitignore templates (`.gitignore-web`, `.gitignore-node`, `.gitignore-python`) |
| `py/` | Python project configs (ruff via pyproject.toml, editorconfig) |

## Validation

Run the focused workstation and shell-startup tests after changing these components:

```bash
shellcheck mac/ghostty/install mac/ghostty/setup \
    mac/starship/install mac/starship/setup \
    tests/ghostty-workstation tests/starship-workstation \
    tests/dotfiles-startup mac/setupenv setupenv
tests/ghostty-workstation
tests/starship-workstation
tests/dotfiles-startup
```

## Customization

Machine-specific config that shouldn't be tracked by git goes in:

- `~/.bashrc.local` (bash)
- `~/.zshrc.local` (zsh)

These are sourced automatically if they exist. You can also create `~/.<hostname>` for host-specific config that applies to both shells.

## Git Aliases

Some highlights from `.gitconfig`:

| Alias | Command |
|-------|---------|
| `git lg` | Pretty graph log with author and signature status |
| `git staged` / `git unstage` | Inspect staged changes or unstage selected paths |
| `git undo` | Soft reset last commit |
| `git cleanup` | Delete branches already merged into the remote's default branch |
| `git amend` | Amend with previous commit message |
| `git compare` | Show commits ahead of the remote's default branch |
| `git alias` | List all git aliases |

## Note on Git Email

The `.gitconfig` email is intentionally invalid to force per-repo configuration:

```bash
cd your-repo
git config user.email "you@example.com"
```
