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

# Everyone need some color in their life
export LS_OPTIONS="--color -l"
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export TERM=xterm-color

# Include these alias here since we are using it within out prompt
alias git-branch='git branch --no-color 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/\1/"'
alias git-isdirty='git status --porcelain 2> /dev/null | grep --no-messages --quiet " " && echo "*"'
alias git-isahead='git status -b --porcelain 2> /dev/null | grep --no-messages --quiet "\[ahead \d*\]" && echo "+"'

# Better prompt w/ git integration
if command -v git > /dev/null ; then
    export PS1="\[\033[0;35m\]\u@\h\[\033[0;33m\] \w\[\033[00m\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \" \"\(\$(git-branch)\$(git-isdirty)\$(git-isahead)\)) \[\033[37m\]$\[\033[00m\]: "
else
    export PS1="\[\033[0;35m\]\u@\h\[\033[0;33m\] \w\[\033[00m\] \[\033[37m\]$\[\033[00m\]: "
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

# Append commands to the history every time a prompt is shown,
# instead of after closing the session.
export PROMPT_COMMAND='history -a'

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
