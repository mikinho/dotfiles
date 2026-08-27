# .profile

function __add_to_path
{
    while (( "$#" )); do
        if [ -d "$1" ]; then
            case ":$PATH:" in
                *:"$1":*)
                    ;;
                *)
                    PATH="$1:$PATH"
                    ;;
            esac
        fi
        shift
    done
}

# Homebrew (Apple Silicon and Intel)
__add_to_path "/opt/homebrew/bin" "/opt/homebrew/sbin"
__add_to_path "$HOME/bin" "/usr/local/bin" "/usr/local/sbin"
__add_to_path "$HOME/.luarocks/bin"

# Add JAVA_HOME
if [ -x /usr/libexec/java_home ] && /usr/libexec/java_home &>/dev/null; then
    JAVA_HOME=$(/usr/libexec/java_home)
    export JAVA_HOME
fi

# Use the stable forwarded-agent socket maintained by ~/.ssh/rc when present.
__SSH_AUTH_SOCK_LINK="$HOME/.ssh/ssh_auth_sock"
if [ -S "$__SSH_AUTH_SOCK_LINK" ]; then
    export SSH_AUTH_SOCK="$__SSH_AUTH_SOCK_LINK"
fi
unset __SSH_AUTH_SOCK_LINK

unset -f __add_to_path

export PATH
