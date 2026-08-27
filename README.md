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
    tests/dotfiles-startup tests/git-identity mac/setupenv setupenv
tests/ghostty-workstation
tests/starship-workstation
tests/dotfiles-startup
tests/git-identity
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
| `git amend` | Amend with previous commit message |
| `git alias` | List all git aliases |

## Git Identity

The global `.gitconfig` intentionally sets `user.name` but does not set
`user.email`. With `user.useConfigOnly = true`, Git refuses to create a commit
unless an email is supplied explicitly. Configure each repository after cloning:

```bash
git config --local user.email "you@example.com"
git config --show-origin --get user.email
```

For groups of repositories that share an identity, keep the existing
`~/.gitconfig.local` include and add a conditional include there. A trailing
slash on the `gitdir` pattern applies the identity to repositories beneath that
directory:

```gitconfig
[includeIf "gitdir:~/dev/work/"]
    path = ~/.gitconfig-work
```

Then define the identity in the referenced file:

```gitconfig
[user]
    email = "you@work.example"
```

Run `tests/git-identity` to validate the policy safely. It uses an isolated
temporary home and two temporary repositories: an unconfigured commit must
fail, while a repository with a local email must commit successfully. It does
not read or modify the real global Git configuration. Environment variables or
command-level Git configuration can still supply an identity explicitly.
