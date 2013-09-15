# .bash_profile

# set the number of open files to be 1024
ulimit -S -n 1024

# Source .profile, containing login, non-bash related initializations.
# Source .bashrc, containing non-login related bash initializations.
# Source .$HOSTNAME, containing host specific bash initializations.

for file in ~/.profile ~/.bashrc ~/.bashrc ~/.$(hostname -s) ;  do
    if [ -f $file ]; then
        source $file
    fi
done

# Source platform specific profile
UNAME=$(uname)

case $UNAME in
	"")
		;;
    "Darwin")
  		PLATFORM_PROFILE=.osx
		;;
    "CYGWIN"*)
  		PLATFORM_PROFILE=.windows
		;;
    "MINGW"*)
  		PLATFORM_PROFILE=.windows
		;;
	*)
  		PLATFORM_PROFILE=."$(tr [A-Z] [a-z] <<< "$UNAME")"
		;;
esac

if [ -f "$PLATFORM_PROFILE" ]; then
    source $PLATFORM_PROFILE
fi