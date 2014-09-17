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

# set PATH so it includes user's private and local bin if it exists
__add_to_path "$HOME/bin" "/usr/local/git/bin" "/usr/local/bin" "/usr/local/sbin"

unset __add_to_path

if [ -d $HOME/android ]
then
    # Android
    export ANDROID_SDK=$HOME/android/sdk
    export ANDROID_NDK=$HOME/android/ndk
    export ANDROID_VER=17.0.0

    PATH=$PATH:${ANDROID_SDK}/tools:${ANDROID_SDK}/platform-tools:${ANDROID_SDK}/build-tools/${ANDROID_VER}:${ANDROID_NDK}
fi

export PATH
