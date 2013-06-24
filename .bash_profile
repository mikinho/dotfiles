# .bash_profile

# set the number of open files to be 1024
ulimit -S -n 1024

# Source .profile, containing login, non-bash related initializations.
if [ -f ~/.profile ]; then
    source ~/.profile
fi

# Source .bashrc, containing non-login related bash initializations.
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
