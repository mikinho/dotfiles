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

# Amazon EC2 CLI tools read the EC2_HOME environment variable
export EC2_HOME=$HOME/ec2/ec2-api-tools-1.7.2.4
export AWS_RDS_HOME=$HOME/aws/RDSCli-1.18.001

# Add JAVA_HOME
export JAVA_HOME=$(/usr/libexec/java_home)

# set PATH so it includes user's private and local bin if it exists
__add_to_path "$HOME/bin" "/usr/local/git/bin" "/usr/local/bin" "/usr/local/sbin" "$EC2_HOME/bin" "$AWS_RDS_HOME/bin"

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

