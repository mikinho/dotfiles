# .profile

# Add some more custom software to PATH.
PATH=$PATH:/opt/local/bin:/usr/local/sbin:$HOME/bin

# Android
export ANDROID_SDK=$HOME/android/sdk
export ANDROID_NDK=$HOME/android/ndk
export ANDROID_VER=17.0.0
PATH=$PATH:${ANDROID_SDK}/tools:${ANDROID_SDK}/platform-tools:${ANDROID_SDK}/build-tools/${ANDROID_VER}:${ANDROID_NDK}

# Export PATH
export PATH
