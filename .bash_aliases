# .bash_aliases

alias startvm='prlctl start'

# Flush the DNS cache
alias flushdns="sudo killall -HUP mDNSResponder"

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
alias git-root='f() { local dir=$PWD; while : ; do git rev-parse --is-inside-work-tree &> /dev/null || break; cd "$(git rev-parse --show-toplevel)"; local dir=$PWD; cd ..; done; cd "$dir"; }; f'

# Get OS X Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
alias updateall='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm update npm -g; npm update -g; sudo gem update'

# OS X has no `md5sum`, so use `md5` as a fallback
command -v md5sum > /dev/null || alias md5sum="md5"

# OS X has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum > /dev/null || alias sha1sum="shasum"
