# todo: break up into sections
# move functions to lib/

################################################################################
#   LIB/BIN                                                                    #
################################################################################

# allow running scripts from $HOME/bin
for f in $HOME/bin/*; do
  if [[ -f $f ]]; then
    chmod +x $f
  fi
done
# source all files directly in $HOME/lib
for f in $HOME/lib/*; do
  if [[ -f $f ]]; then
    source $f
  fi
done

################################################################################
#   INIT                                                                       #
################################################################################

# call attention to any errors in this section
printf "${RED}"

# virtualenvwrapper
source /usr/local/bin/virtualenvwrapper.sh > /dev/null

# add $HOME/.bin if it's not already in the path
if [[ ":$PATH:" != *":$HOME/.bin:"* ]]; then
  export PATH="$HOME/.bin:$PATH"
fi
# add $HOME/bin if it's not already in the path
if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
  export PATH="$HOME/bin:$PATH"
fi
# add $HOME/lib if it's not already in the path
if [[ ":$PATH:" != *":$HOME/lib:"* ]]; then
  export PATH="$HOME/lib:$PATH"
fi

# Use bash-completion, if available
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

printf "${ENDCOLOR}"

################################################################################
#   COMMAND MODS/BINDINGS                                                      #
################################################################################

bind "TAB":menu-complete                ## TAB:         autocomplete
bind '"\e[Z":complete'                  ## SHIFT+TAB:   show autocomplete options
bind '"\e[A":history-search-backward'   ## arrow-up:    history search
bind '"\e[B":history-search-forward'    ## arrow-down:  history search

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

# app aliases
alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
alias mplayer='/Applications/MPlayer\ OSX\ Extended.app/Contents/Resources/Binaries/mpextended.mpBinaries/Contents/MacOS/mplayer'
alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'

# hidden file toggle (Finder)
alias findershow='defaults write com.apple.finder ShowAllFiles TRUE'
alias finderhide='defaults write com.apple.finder ShowAllFiles FALSE'

# add separators to the dock
function add_dock_separator () {
    defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
    killall Dock
}

################################################################################
#   COLORS                                                                     #
################################################################################

# colorized man command
man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
            man "$@"
}

# highlight pattern in output of grep, fgrep and egrep
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

################################################################################
#   UTILITY                                                                    #
################################################################################

# returns the PID of a process
# process name must be an exact match
function psfind () {
  psg "$1" | grep -E ".*\W$1\W.*" | grep -Eo "^\d+"
}

# dotfiles management
conf() {
        case "$1" in
                bash)       vim $HOME/.bash_profile && bash ;;
                vim)        vim $HOME/.vimrc ;;
                crawl)	    cd /Applications/Dungeon\ Crawl\ Stone\ Soup\ -\ Tiles.app/Contents/Resources/settings && subl . ;;
                zsh)        vim $HOME/.zshrc && source ~/.zshrc ;;
                hosts)      vim /etc/hosts ;;
                *)          echo "Unknown application: $1" >&2 ;;
        esac
}

# adds a loading spinner to the end of the previous line
# thanks to William Pursell for some of the logic
# https://stackoverflow.com/questions/12498304/using-bash-to-display-a-progress-working-indicator
# requires the pid of a running background process
function spinner() {
  pid=$1 # pid of the previous running command
  spin='-\|/'
  i=0
  printf "  " # 2 spaces, one for spacing, one for padding against first \b
  while kill -0 $pid 2>/dev/null
  do
    i=$(( (i+1) %4 ))
    printf "\b${spin:$i:1}"
    sleep .1
  done
  printf "\bDone.\n"
}
export -f spinner

# check if an array contains a specific string
function contains () {
  local e
  for e in "${@:2}"
  do
    [[ "$e" == "$1" ]] && return 0
  done
  return 1
}
export -f contains

# takes a path to a dir $1 as argument
# returns true if in a subdirectory of $1
# returns false if directly inside $1 or outside $1
function in_subdir () {
  # strip out basename from working directory and compare
  if [[ "${PWD%/*}" =~ "$1" ]]; then
    return 0
  else
    return 1
  fi
}
export -f in_subdir

# takes a path to a dir $1 as argument
# returns true if in a subdirectory of $1 or directly inside $1
# returns false if outside $1
function in_dir () {
  if [[ "${PWD}" =~ "$1" ]]; then
    return 0
  else
    return 1
  fi
}
export -f in_dir

# set virtual environment if one exists w/same name as $current_dir
# if not, and in subdir of $PROJECT_DIR, create virtualenv
# deactivate when moving back to or out of $PROJECT_DIR
function set_venv () {
  current_dir="$(basename "$PWD")"
  if [ -d "$WORKON_HOME/${current_dir}" ]; then
      workon "${current_dir}" > /dev/null
  elif ! in_subdir "${PROJECT_DIR}"; then
      deactivate &> /dev/null
  elif [ "$(dirname $PWD)" == "${PROJECT_DIR}" ]; then
      printf "Creating virtual environment \"${current_dir}\"..."
      (mkvirtualenv "${current_dir}" &> /dev/null) & disown # disown hides output
      spinner $! # pass last pid to spinner()
      prompt_cmd # updates prompt with newly created virtualenv
  fi
}
export -f set_venv
