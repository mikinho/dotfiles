# .profile

function __add_to_path
{
    while (( "$#" )); do
        if [ -d "$1" ] && [[ "$PATH" != "$1":* ]]; then
            PATH="$1:$PATH"
        fi
        shift
    done
}

# Homebrew (Apple Silicon and Intel)
__add_to_path "/opt/homebrew/bin" "/opt/homebrew/sbin"
__add_to_path "$HOME/bin" "/usr/local/bin" "/usr/local/sbin"

# Add JAVA_HOME
if [ -x /usr/libexec/java_home ] && /usr/libexec/java_home &>/dev/null; then
    export JAVA_HOME=$(/usr/libexec/java_home)
fi

unset __add_to_path

export PATH
