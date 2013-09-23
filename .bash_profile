# .bash_profile

# set the number of open files to be 1024
ulimit -S -n 1024

# Source .profile, containing login, non-bash related initializations.
# Source .bashrc, containing non-login related bash initializations.
# Source .$HOSTNAME, containing host specific bash initializations.
# Source .$PLATFORM, containing os\platform specific bash initializations.

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

    [ -f "$HOME/$PLATFORM" ] && . "$HOME/$PLATFORM"
}

__source ~/.profile ~/.bashrc ~/.$(hostname -s)
__source_platform

unset __source
unset __source_platform
