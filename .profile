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

# Amazon EC2 CLI tools
if [ -d $HOME/ec2/ec2-api-tools-1.7.2.4 ]
then
    export EC2_HOME=$HOME/ec2/ec2-api-tools-1.7.2.4
    __add_to_path "$EC2_HOME/bin"
fi

# AWS RDS
if [ -d $HOME/aws/RDSCli-1.18.001 ]
then
    AWS_RDS_HOME=$HOME/aws/RDSCli-1.18.001
    __add_to_path "$AWS_RDS_HOME/bin"
fi

# Add JAVA_HOME
if command -v java_home > /dev/null; then
    export JAVA_HOME=$(/usr/libexec/java_home)
fi

unset __add_to_path

if [ -d $HOME/android ]
then
    # Android
    export ANDROID_SDK=$HOME/android/sdk
    export ANDROID_HOME=$ANDROID_SDK
    export ANDROID_NDK=$HOME/android/ndk
    export ANDROID_VER=17.0.0

    PATH=$PATH:${ANDROID_SDK}/tools:${ANDROID_SDK}/platform-tools:${ANDROID_SDK}/build-tools/${ANDROID_VER}:${ANDROID_NDK}
fi

export PATH