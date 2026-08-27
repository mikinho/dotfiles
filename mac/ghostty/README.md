# Ghostty workstation setup

This component reproduces Michael's Ghostty setup on macOS without embedding
machine-specific paths or state in the repository. It installs the current
Homebrew Ghostty cask and JetBrains Mono Nerd Font cask, then installs one
authoritative configuration with:

- the built-in Catppuccin Mocha theme;
- 16-pixel horizontal and vertical window padding;
- the macOS tab-style titlebar;
- 14-point JetBrainsMono Nerd Font.

Homebrew is an explicit prerequisite. The installer does not bootstrap
Homebrew by executing a remote shell script, and it does not silently upgrade
an already-installed cask. Install Homebrew from its
[official site](https://brew.sh/) first when it is not already present.

## Install and configure

Review the package plan, install any missing casks, then review and apply the
configuration migration:

```sh
mac/ghostty/install --plan
mac/ghostty/install
mac/ghostty/setup --plan
mac/ghostty/setup
```

The setup writes the current Ghostty filename at
`~/.config/ghostty/config.ghostty` with mode `0600`. It uses the XDG location
because it is portable and easy to manage from a checkout. Ghostty 1.3 searches
the macOS `config.ghostty` location before the XDG location and still accepts
legacy `config` filenames. Keeping more than one file makes the effective
configuration depend on load order and compatibility behavior. Setup therefore
retires only alternate files that are empty or byte-for-byte identical to the
repository config.

If any existing file differs, setup stops without changing it. Review the
replacement plan and opt in explicitly:

```sh
mac/ghostty/setup --plan --replace-existing
mac/ghostty/setup --replace-existing
```

Before replacement, every existing Ghostty config is copied into a private,
randomly named directory under `~/.config/ghostty/backups/`. Installation is
rollback-protected: if the installed file fails ownership, mode, content, or
Ghostty's own config validation, the prior files are restored.

## Shell and SSH integration

The config leaves Ghostty 1.3's shell integration defaults unchanged: local
shell detection is automatic, while `ssh-env` and `ssh-terminfo` are disabled.
`ssh-env` can improve compatibility by using `xterm-256color` on remote hosts
and offering Ghostty-related environment variables to SSH, but the remote SSH
server decides whether to accept those variables. `ssh-terminfo` preserves the
full `xterm-ghostty` capability set, but it runs `tic` to install a terminfo
entry in the remote user's account and maintains a client-side install cache.

Those features remain off so workstation bootstrap does not inject extra SSH
behavior or implicitly change a remote user's state. Enabling either feature
later is a client-side choice that belongs in this config; server-side support
should remain generic terminal and terminfo readiness rather than a
Ghostty-branded server component.

Verify the package and configuration state at any time:

```sh
mac/ghostty/install --verify
mac/ghostty/setup --verify
```

After changing an already-running Ghostty instance, press `Cmd+Shift+,` to
reload the configuration or quit and reopen the app. Ghostty's
[configuration documentation](https://ghostty.org/docs/config) describes the
load order and runtime reload behavior; its
[binary installation documentation](https://ghostty.org/docs/install/binary)
documents the Homebrew cask.

## Deliberate boundaries

The component manages Ghostty and the font required by this config. It does not
manage shell prompts, shell startup files, tmux, SSH identities, secrets, or
macOS preferences outside Ghostty. Those have different lifecycles and should
remain separate components rather than becoming hidden side effects of a
terminal-emulator install.
