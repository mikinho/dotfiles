# .bash_aliases

# Bash Functions 

function git-root
{
	git rev-parse --is-inside-work-tree &> /dev/null || return

	while :
	do
		cd "$(git rev-parse --show-toplevel)"
		cd ..
		git rev-parse --is-inside-work-tree &> /dev/null || break
	done
	cd - &> /dev/null
}

# Add some easy shortcuts for formatted directory listings
alias ll='ls -lF'
alias la='ls -alF'
alias ls='ls -F'

alias kp='ps auxwww'

# Strip source control, useful for ensuring deployed code is production only
alias cleansvn='find . -name ".svn" -exec rm -rf {} \;'
alias cleangit='find . -name ".git" -exec rm -rf {} \;'
 
# git helper aliases. they change the cwd so they need to be outside of .gitconfig
alias git-top='cd "$(git rev-parse --show-toplevel)"'

# OS X has no `md5sum`, so use `md5` as a fallback
command -v md5sum > /dev/null || alias md5sum="md5"

# OS X has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum > /dev/null || alias sha1sum="shasum"
