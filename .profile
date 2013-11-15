# .profile

# if running bash
if [ -n "$BASH_VERSION" ]
then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]
    then
        source "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private and local bin if it exists
for each in "$HOME/bin" "/usr/local/bin" "/usr/local/sbin"
do
    if [ -d "$each" ] ; then
        PATH="$each:$PATH"
    fi
done

if [ -d $HOME/android ]
then
    # Android
    export ANDROID_SDK=$HOME/android/sdk
    export ANDROID_NDK=$HOME/android/ndk
    export ANDROID_VER=17.0.0

    PATH=$PATH:${ANDROID_SDK}/tools:${ANDROID_SDK}/platform-tools:${ANDROID_SDK}/build-tools/${ANDROID_VER}:${ANDROID_NDK}
fi

export PATH
