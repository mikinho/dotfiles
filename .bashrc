# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	source /etc/bashrc
fi

# Enable programmable completion features.
if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
fi

# Everyone need some color in their life
export LS_OPTIONS="--color -l"
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export TERM=xterm-color 

alias git-branch='git branch --no-color 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/\1/"'
alias git-isdirty='[[ $(git status --porcelain 2> /dev/null | grep "^??") ]] && echo "*"'

# Better prompt w/ git integration
export PS1="\[\033[0;35m\]\u@\h\[\033[0;33m\] \w\[\033[00m\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \" \"\(\$(git-branch)\$(git-isdirty)\)) \[\033[37m\]$\[\033[00m\]: "

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
