#!/bin/sh

set -eu

PROGRAM_NAME=${0##*/}
SCRIPT_DIRECTORY=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
REPOSITORY_ROOT=$(CDPATH='' cd -- "$SCRIPT_DIRECTORY/.." && pwd)
GHOSTTY_INSTALL=$REPOSITORY_ROOT/mac/ghostty/install
GHOSTTY_SETUP=$REPOSITORY_ROOT/mac/ghostty/setup
CONFIG_SOURCE=$REPOSITORY_ROOT/mac/ghostty/config.ghostty
TEST_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-ghostty.XXXXXX")
FAKE_BIN=$TEST_ROOT/fake-bin
FAKE_BREW_STATE=$TEST_ROOT/brew-state
TEST_HOME=$TEST_ROOT/home

cleanup() {
    if [ -d "$TEST_ROOT" ]; then
        rm -rf -- "$TEST_ROOT"
    fi
}

fail() {
    printf '%s: %s\n' "$PROGRAM_NAME" "$*" >&2
    exit 1
}

expect_failure() {
    expected_message=$1
    shift
    if "$@" >"$TEST_ROOT/command.stdout" 2>"$TEST_ROOT/command.stderr"; then
        fail "command unexpectedly succeeded: $*"
    fi
    grep -F -- "$expected_message" "$TEST_ROOT/command.stderr" >/dev/null \
        || fail "command failed without expected message: $expected_message"
}

run_with_fixture() {
    env \
        "FAKE_BREW_STATE=$FAKE_BREW_STATE" \
        "HOME=$TEST_HOME" \
        "XDG_CONFIG_HOME=$TEST_HOME/.config" \
        "PATH=$FAKE_BIN:$PATH" \
        "$@"
}

trap cleanup EXIT HUP INT TERM

[ -x "$GHOSTTY_INSTALL" ] || fail "Ghostty installer is not executable"
[ -x "$GHOSTTY_SETUP" ] || fail "Ghostty setup is not executable"
[ -f "$CONFIG_SOURCE" ] && [ ! -L "$CONFIG_SOURCE" ] \
    || fail "Ghostty configuration source is not a regular file"

mkdir -p \
    "$FAKE_BIN" \
    "$FAKE_BREW_STATE" \
    "$TEST_HOME/Library/Fonts"

cat > "$FAKE_BIN/uname" <<'EOF'
#!/bin/sh

[ "$#" -eq 1 ] && [ "$1" = -s ] || exit 1
printf 'Darwin\n'
EOF

cat > "$FAKE_BIN/brew" <<'EOF'
#!/bin/sh

set -eu

case "${1:-}" in
    list)
        [ "$#" -eq 4 ] \
            && [ "$2" = --cask ] \
            && [ "$3" = --versions ] \
            || exit 1
        if [ -f "$FAKE_BREW_STATE/$4" ]; then
            printf '%s 1.0.0\n' "$4"
            exit 0
        fi
        exit 1
        ;;
    install)
        [ "$#" -eq 3 ] && [ "$2" = --cask ] || exit 1
        [ ! -f "$FAKE_BREW_STATE/$3" ] \
            || { printf 'duplicate cask install: %s\n' "$3" >&2; exit 1; }
        : > "$FAKE_BREW_STATE/$3"
        ;;
    *)
        printf 'unexpected fake brew invocation: %s\n' "$*" >&2
        exit 1
        ;;
esac
EOF

cat > "$FAKE_BIN/ghostty" <<'EOF'
#!/bin/sh

set -eu

case "${1:-}" in
    +validate-config)
        [ "$#" -eq 2 ] || exit 1
        config_path=${2#--config-file=}
        [ "$config_path" != "$2" ] && [ -f "$config_path" ] || exit 1
        grep -F 'theme = Catppuccin Mocha' "$config_path" >/dev/null
        grep -F 'font-family = "JetBrainsMono Nerd Font"' "$config_path" >/dev/null
        if [ "${FAKE_GHOSTTY_REJECT_TARGET:-no}" = yes ] \
            && [ "$config_path" = "$HOME/.config/ghostty/config.ghostty" ]; then
            exit 1
        fi
        ;;
    +list-themes)
        printf 'Catppuccin Mocha (resources)\n'
        ;;
    *)
        printf 'unexpected fake Ghostty invocation: %s\n' "$*" >&2
        exit 1
        ;;
esac
EOF

chmod 0755 "$FAKE_BIN/uname" "$FAKE_BIN/brew" "$FAKE_BIN/ghostty"
: > "$TEST_HOME/Library/Fonts/JetBrainsMonoNerdFont-Regular.ttf"

"$GHOSTTY_INSTALL" --help >/dev/null
"$GHOSTTY_SETUP" --help >/dev/null
run_with_fixture "$GHOSTTY_INSTALL" --check >/dev/null
run_with_fixture "$GHOSTTY_SETUP" --check >/dev/null

run_with_fixture "$GHOSTTY_INSTALL" --plan > "$TEST_ROOT/install.plan"
grep -F 'install --cask ghostty' "$TEST_ROOT/install.plan" >/dev/null \
    || fail "install plan omitted the Ghostty cask"
grep -F 'install --cask font-jetbrains-mono-nerd-font' \
    "$TEST_ROOT/install.plan" >/dev/null \
    || fail "install plan omitted the Nerd Font cask"

run_with_fixture "$GHOSTTY_INSTALL" >/dev/null
[ -f "$FAKE_BREW_STATE/ghostty" ] \
    || fail "installer did not install the Ghostty cask"
[ -f "$FAKE_BREW_STATE/font-jetbrains-mono-nerd-font" ] \
    || fail "installer did not install the Nerd Font cask"
run_with_fixture "$GHOSTTY_INSTALL" --verify >/dev/null
run_with_fixture "$GHOSTTY_INSTALL" >/dev/null

run_with_fixture "$GHOSTTY_SETUP" --plan > "$TEST_ROOT/setup.plan"
grep -F "$TEST_HOME/.config/ghostty/config.ghostty" \
    "$TEST_ROOT/setup.plan" >/dev/null \
    || fail "setup plan omitted the canonical config target"
run_with_fixture "$GHOSTTY_SETUP" >/dev/null
cmp -s "$CONFIG_SOURCE" "$TEST_HOME/.config/ghostty/config.ghostty" \
    || fail "setup did not install the repository config"
if stat -f '%Lp' "$TEST_HOME/.config/ghostty/config.ghostty" >/dev/null 2>&1; then
    installed_mode=$(stat -f '%Lp' "$TEST_HOME/.config/ghostty/config.ghostty")
else
    installed_mode=$(stat -c '%a' "$TEST_HOME/.config/ghostty/config.ghostty")
fi
[ "$installed_mode" = 600 ] \
    || fail "installed config does not have mode 0600"
run_with_fixture "$GHOSTTY_SETUP" --verify >/dev/null
run_with_fixture "$GHOSTTY_SETUP" >/dev/null

cp "$CONFIG_SOURCE" "$TEST_HOME/.config/ghostty/config"
mkdir -p "$TEST_HOME/Library/Application Support/com.mitchellh.ghostty"
: > "$TEST_HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
run_with_fixture "$GHOSTTY_SETUP" >/dev/null
[ ! -e "$TEST_HOME/.config/ghostty/config" ] \
    || fail "setup retained a matching legacy XDG config"
[ ! -e "$TEST_HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty" ] \
    || fail "setup retained an empty macOS override"

printf 'local workstation drift\n' \
    > "$TEST_HOME/.config/ghostty/config.ghostty"
printf 'macOS workstation drift\n' \
    > "$TEST_HOME/Library/Application Support/com.mitchellh.ghostty/config"
expect_failure \
    'a differing Ghostty config exists' \
    run_with_fixture "$GHOSTTY_SETUP" --plan
[ "$(cat "$TEST_HOME/.config/ghostty/config.ghostty")" = \
    'local workstation drift' ] \
    || fail "failed plan changed the canonical config"
run_with_fixture "$GHOSTTY_SETUP" --plan --replace-existing \
    > "$TEST_ROOT/replace.plan"
grep -F 'preserve existing configs' "$TEST_ROOT/replace.plan" >/dev/null \
    || fail "replacement plan omitted persistent backup"
[ "$(cat "$TEST_HOME/Library/Application Support/com.mitchellh.ghostty/config")" = \
    'macOS workstation drift' ] \
    || fail "replacement plan changed an alternate config"

expect_failure \
    'Ghostty rejected the configuration' \
    run_with_fixture env FAKE_GHOSTTY_REJECT_TARGET=yes \
        "$GHOSTTY_SETUP" --replace-existing
[ "$(cat "$TEST_HOME/.config/ghostty/config.ghostty")" = \
    'local workstation drift' ] \
    || fail "failed replacement did not restore the canonical config"
[ "$(cat "$TEST_HOME/Library/Application Support/com.mitchellh.ghostty/config")" = \
    'macOS workstation drift' ] \
    || fail "failed replacement did not restore an alternate config"

run_with_fixture "$GHOSTTY_SETUP" --replace-existing >/dev/null
backup_file=$(find "$TEST_HOME/.config/ghostty/backups" \
    -type f -name canonical -print | head -n 1)
[ -n "$backup_file" ] \
    || fail "replacement did not preserve the prior canonical config"
grep -F 'local workstation drift' "$backup_file" >/dev/null \
    || fail "persistent backup does not contain the prior config"
alternate_backup=$(find "$TEST_HOME/.config/ghostty/backups" \
    -type f -name macos-legacy -print | head -n 1)
[ -n "$alternate_backup" ] \
    || fail "replacement did not preserve the prior macOS config"
grep -F 'macOS workstation drift' "$alternate_backup" >/dev/null \
    || fail "persistent backup does not contain the prior macOS config"
run_with_fixture "$GHOSTTY_SETUP" --verify >/dev/null

ln -s /etc/passwd "$TEST_HOME/.config/ghostty/config"
expect_failure \
    'configuration target must be a regular file' \
    run_with_fixture "$GHOSTTY_SETUP" --plan
rm -f -- "$TEST_HOME/.config/ghostty/config"

fixture_root=$TEST_ROOT/repository
mkdir -p "$fixture_root/mac/ghostty"
cp "$GHOSTTY_SETUP" "$fixture_root/mac/ghostty/setup"
chmod 0755 "$fixture_root/mac/ghostty/setup"
ln -s /etc/passwd "$fixture_root/mac/ghostty/config.ghostty"
expect_failure \
    'repository config must be a regular file' \
    run_with_fixture "$fixture_root/mac/ghostty/setup" --check

printf 'Validated Ghostty workstation installation and migration boundaries.\n'
