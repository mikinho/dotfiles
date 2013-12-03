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

# Make grep more user friendly by highlighting matches and excluding source control folders.
if grep --help 2>&1 | grep --no-messages --quiet "\-\-color" ; then
    export GREP_OPTIONS="--color=auto"
fi

if echo "." | grep --no-messages --quiet --exclude-dir="" "." 2> /dev/null ; then
    export GREP_OPTIONS="$GREP_OPTIONS --exclude-dir=\.svn --exclude-dir=\.git"
fi

# Better prompt w/ git integration
if command -v git > /dev/null ; then
    export PS1='\[\033[0;35m\]\u@\h\[\033[0;33m\] \w\[\033[00m\]$(git status --branch --ignore-submodules --no-column --porcelain --untracked-files=no 2>/dev/null | sed -e '"'"'$!N;s/\\n[^#][^#].*/*/g'"'"' -e '"'"'s/\\.\\.\\..* \\[ahead [0-9]*\\]/+/'"'"' -e '"'"'s/^## \(.*\)/ (\1)/'"'"') \[\033[37m\]$\[\033[00m\]: '
else
    export PS1='\[\033[0;35m\]\u@\h\[\033[0;33m\] \w\[\033[00m\] \[\033[37m\]$\[\033[00m\]: '
fi

# Set the default editor to vim.
export EDITOR=vim

# Avoid succesive duplicates in the bash command history.
export HISTCONTROL=ignoredups

 # Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Export PROMPT_COMMAND only needed once
export PROMPT_COMMAND

# Append commands to the history every time a prompt is shown, instead of after closing the session.
# PROMPT_COMMAND='history -a'

# Set iTerm Window\Tab Title
PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME}: ${PWD/$HOME/~}\007"'

# Source .bash_aliases,
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# set the number of open files to be 1024
ulimit -S -n 1024

# Source .$PLATFORM, containing os\platform specific bash initializations.
__source_platform

# Source .$HOSTNAME, containing host specific bash initializations.
__source_local

unset __source
unset __source_platform
unset __source_local
