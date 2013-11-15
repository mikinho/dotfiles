# .profile

# Export PATH
export PATH=/usr/local/bin:/usr/local/sbin:$HOME/bin:$PATH

if [ -d $HOME/android ]
then
    # Android
    export ANDROID_SDK=$HOME/android/sdk
    export ANDROID_NDK=$HOME/android/ndk
    export ANDROID_VER=17.0.0

    export PATH=$PATH:${ANDROID_SDK}/tools:${ANDROID_SDK}/platform-tools:${ANDROID_SDK}/build-tools/${ANDROID_VER}:${ANDROID_NDK}
fi
