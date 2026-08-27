# Starship workstation setup

This component reproduces Michael's Starship prompt on macOS without copying
Starship defaults into the repository. It installs the Homebrew Starship
formula and JetBrains Mono Nerd Font cask, then installs the current prompt
overrides:

- Nerd Font symbols for modules whose Starship defaults differ;
- a single-line prompt;
- green and red `$:` prompt characters for successful and failed commands.

The source was distilled from the active `~/.config/starship.toml`. The schema
metadata, battery symbols, and Node.js symbol in that generated preset already
matched Starship 1.26.0 defaults and were omitted. `setup --check` compares the
committed scalar settings with the installed Starship defaults. It fails when
an override is unknown, ineffective, or has become default-equivalent, making
default drift an explicit cleanup event instead of preserving stale defaults.

The committed symbols are values rather than a request to regenerate the Nerd
Font preset during bootstrap. This preserves the current prompt while allowing
new Starship settings and modules to inherit their current upstream defaults.

Homebrew is an explicit prerequisite. The installer does not bootstrap
Homebrew by executing a remote shell script, and it does not silently upgrade
an already-installed formula or cask. Install Homebrew from its
[official site](https://brew.sh/) first when it is not already present.

## Install and configure

Review the package plan, install any missing packages, then review and apply
the configuration migration:

```sh
mac/starship/install --plan
mac/starship/install
mac/starship/setup --plan
mac/starship/setup
```

By default, setup writes `~/.config/starship.toml` with mode `0644`. It follows
`XDG_CONFIG_HOME` and, when set, Starship's `STARSHIP_CONFIG` override. The
repository `.zshrc` already initializes Starship when the binary is available,
so the normal dotfiles bootstrap completes shell activation without another
startup-file mutation.

If an existing target differs, setup stops without changing it. Review the
replacement plan and opt in explicitly:

```sh
mac/starship/setup --plan --replace-existing
mac/starship/setup --replace-existing
```

Before replacement, the existing config is copied into a private, randomly
named directory under `${XDG_CONFIG_HOME:-~/.config}/starship/backups/`.
Installation is rollback-protected: if the installed file fails ownership,
mode, content, minimal-override, load-path, or Starship parsing checks, the
prior config is restored.

Verify package and configuration state at any time:

```sh
mac/starship/install --verify
mac/starship/setup --verify
```

Open a new zsh session after installation. Starship's
[installation guide](https://starship.rs/guide/) documents Homebrew and zsh
initialization, its [configuration guide](https://starship.rs/config/)
documents the config path and environment override, and the
[Nerd Font Symbols preset](https://starship.rs/presets/nerd-font) documents the
symbol set from which this minimal override file was derived.

## Deliberate boundaries

The component manages Starship, the font required by this config, and the
Starship TOML file. It does not modify the tracked shell startup files, change
terminal font selection, install a terminal emulator, manage shell plugins, or
alter machine-specific shell configuration. Those remain separate dotfiles or
workstation components.
