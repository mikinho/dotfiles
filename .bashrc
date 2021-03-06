# .bashrc

function __source
{
    while (( "$#" )); do
        if [ -f "$1" ]; then
            source "$1"
        fi
        shift
    done
}

function __source_platform
{
    local UNAME
    local PLATFORM

    # Source platform specific profile
    UNAME=$(uname)

    case $UNAME in
      "")
        ;;
      "Darwin")
          PLATFORM=.osx
        ;;
      "CYGWIN"*)
          PLATFORM=.windows
        ;;
      "MINGW"*)
          PLATFORM=.windows
        ;;
      *)
          PLATFORM=."$(tr [A-Z] [a-z] <<< "$UNAME")"
        ;;
    esac

    __source "$HOME/$PLATFORM"
}

function __source_local
{
	local HOSTNAME

	if hostname --help 2>&1 | grep --no-messages --quiet "\-\-short"
	then
		HOSTNAME=$(hostname --short)
	else
		HOSTNAME=$(hostname | sed -e "s/\..*$//")
	fi

    __source "$HOME/.$HOSTNAME"
}

# Source global definitions
__source /etc/bashrc

# Source .profile, containing login, non-bash related initializations.
__source "$HOME/.profile" 

# Enable programmable completion features.
__source /etc/bash_completion

# Sensible Bash
__source ~/dotfiles/bash-sensible/sensible.bash

export EDITOR=vim

# Avoid succesive duplicates in the bash command history.
export HISTCONTROL=ignoredups

 # Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# set the number of open files to be 1024
ulimit -S -n 1024

# Source .bash_aliases and .prompt
__source "$HOME/.bash_aliases" "$HOME/.prompt"

# Source .$PLATFORM, containing os\platform specific bash initializations.
__source_platform

# Source .$HOSTNAME, containing host specific bash initializations.
__source_local

unset __source
unset __source_platform
unset __source_local
