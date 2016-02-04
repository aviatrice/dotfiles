#!/bin/bash

################################################################################
#   SYSTEM SHORTCUTS                                                           #
################################################################################

alias p='cd ${PROJECT_DIR}'

################################################################################
#   SHELL COMMANDS                                                             #
################################################################################

# fast prefs reload
# .bashrc and .bash_profile must be symlinked
alias b='bash'

# reload prefs without leaving the current shell
alias sb='source ~/.bash_profile'

# quicker basic commands
alias c='clear'
alias e='echo'

# ls shenanigans
alias ls='ls -FGhLl'        # decorators + colorized + size units + resolve symlinks + list format
alias lsa='ls -a'           # all files
alias lsd='\ls -dGhLl */'   # list subdirectories (removes decorators)
alias ls.='ls -d .*'        # list hidden files
alias lst='lsa -t'          # sorted by time
alias lsc='ls -C'           # force multi-column output
alias ls@='ls -H'           # show symbolic links
alias lsg='ls | grep -i'    # grep directory for a filename

# copy working directory path to clipboard
alias cwd='printf "%q\n" "$(pwd)" | pbcopy'

# easier to move up dirs
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .4='cd ../../..'
alias .5='cd ../../../..'

# quick history of last 20 commands
alias h='history | tail -21 | head -20'
# fast history grep
alias hs='history | grep'
# timestamps in history
export HISTTIMEFORMAT="[%F %T] "

# grep your processes
alias psg='ps | grep'

# easy-to-read path
alias path='echo -e ${PATH//:/\\n}'

# reboot / shutdown
alias reboot='sudo /sbin/reboot'
alias shutdown='sudo /sbin/shutdown'

# assume auto-resume wget
alias wget='wget -c'

# please thank you
alias please='eval "sudo $(fc -ln -1)"' # run last command w/sudo

# check internet connection
alias pong='ping -c 4 8.8.8.8'

# output external IP
alias whatsmyip='dig +short myip.opendns.com @resolver1.opendns.com'

# git
alias push='git push -u origin'

# hurr
alias wow='git status'
alias such='git'
alias very='git'
alias so='git'
alias much='git'

# docker aliases
alias dockereval='eval $(docker-machine env dev)'
alias dockerstart='docker-machine start dev'
alias dockerstop='docker-machine stop dev'
alias dockerup='dockereval; docker-compose up'
alias dockerall='dockerstart; dockereval; dockerup'

################################################################################
#   APPS                                                                       #
################################################################################

alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
alias mplayer='/Applications/MPlayer\ OSX\ Extended.app/Contents/Resources/Binaries/mpextended.mpBinaries/Contents/MacOS/mplayer'
alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'

################################################################################
#   COLORS                                                                     #
################################################################################

# highlight pattern in output of grep, fgrep and egrep
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
