# per virtualenvwrapper
source /usr/local/bin/virtualenvwrapper.sh > /dev/null

# allow running scripts from $HOME/bin
chmod +x "$HOME/bin/."

################################################################################
#   GLOBAL VARIABLES                                                           #
################################################################################

# project_dir controls virtualenv behavior, among other things
# set this to your main programming projects dir
project_dir="$HOME/Projects"

# script to copy dotfiles to git repo and push them up
# must be in ~ with the rest of the dotfiles
git_script="dotfiles_git.sh"

# a few colors
RED='\[\e[0;31m\]'
ORANGE='\[\e[1;31m\]'
GREEN='\[\e[0;32m\]'
YELLOW='\[\e[0;33m\]'
BLUE='\[\e[0;34m\]'
MAGENTA='\[\e[0;35m\]'
CYAN='\[\e[0;36m\]'
LIGHTGRAY='\[\e[0;37m\]'
WHITE='\[\e[1;37m\]'
ENDCOLOR='\[\e[0m\]'

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

alias p='cd ${project_dir}'
alias dotfiles_git='bash dotfiles_git.sh'

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

# When this "cd" function gets more than one argument it ignores the "cd" and re-arranges the args
# so that second arg becomes the command.
# e.g.
# "cd log/project/20120330/some.log.gz zless"  ->  "zless log/project/20120330/some.log.gz"
# "cd lib/Foo/Bar/Baz.pm vi +100"  ->  "vi +100 lib/Foo/Bar/Baz.pm"
function cd {
    if [ $# -lt 1 ]; then
        builtin cd
    elif [ $# -eq 1 ]; then
        builtin cd "$1"
    else
        cd_arg_1="$1"
        shift
        "$@" "$cd_arg_1"
    fi
}

# dotfiles management
conf() {
        case "$1" in
                bash)       vim ~/.bash_profile && bash ;;
                vim)        vim ~/.vimrc ;;
                crawl)	    cd /Applications/Dungeon\ Crawl\ Stone\ Soup\ -\ Tiles.app/Contents/Resources/settings && subl . ;;
                zsh)        vim ~/.zshrc && source ~/.zshrc ;;
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

# check if an array contains a specific string
function contains () {
  local e
  for e in "${@:2}"
  do
    [[ "$e" == "$1" ]] && return 0
  done
  return 1
}

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

# set virtual environment if one exists w/same name as $current_dir
# if not, and in subdir of $project_dir, create virtualenv
# deactivate when moving back to or out of $project_dir
function set_venv () {
  current_dir="$(basename "$PWD")"
  if [ -d "$WORKON_HOME/${current_dir}" ]; then
      workon "${current_dir}" > /dev/null
  elif ! in_subdir "${project_dir}"; then
      deactivate &> /dev/null
  elif [ "$(dirname $PWD)" == "${project_dir}" ]; then
      printf "Creating virtual environment \"${current_dir}\"..."
      (mkvirtualenv "${current_dir}" &> /dev/null) & disown # disown hides output
      spinner $! # pass last pid to spinner()
      prompt_cmd # updates prompt with newly created virtualenv
  fi
}

################################################################################
#   CUSTOM PROMPT                                                              #
################################################################################

# get virtual env
function get_venv () {
  if [[ $VIRTUAL_ENV != "" ]]
      then
        # strip out the path and just leave the env name
        venv=" (${VIRTUAL_ENV##*/})"
  else
        # In case you don't have one activated
        venv=''
  fi
}

# build git section
# thanks https://gist.github.com/maumercado for some of the below functions!

# capture the output of the "git status" and "git branch" commands
# if the repo name doesn't match the dir name, prepend the repo name to the branch name
function parse_git_branch () {
  git_branch="$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"
  git_repo="$(git config --local remote.origin.url|sed -n 's#.*/\([^.]*\)\.git#\1#p')"
  if [[ "${git_branch}" != "" && "$(basename $PWD)" != "${git_repo}" ]]; then
    if [ "${git_repo}" == "" ]; then
      git_repo="?" # if the branch is defined but not the repo, display a ? as the repo name
    fi
    git_branch="${git_repo}/${git_branch}"
  fi
}
parse_git_branch

# indicate status of working copy
function set_git_branch () {
  git_status="$(git status 2> /dev/null)"
  git_dirty=""
  # set color based on clean/staged/dirty
  if [[ ${git_status} =~ .*"working directory clean".* ]]; then
    B_STATE="${GREEN}"
  elif [[ ${git_status} =~ .*"Changes to be committed".* ]]; then
    B_STATE="${YELLOW}"
    git_dirty="*"
  else
    B_STATE="${RED}"
    git_dirty="*"
  fi
}
set_git_branch

# build prompt
function build_branch() {
	if [[ $git_branch != "" ]]
	    then
	      branch=" ${B_STATE}[$git_branch$git_dirty]"
	else
		  branch=""
	fi
}

# example prompt:
# [11:10:58] user@hostname ~/current/dir (virtualenv) [gitrepo/gitbranch*]
# $
prompt_cmd() {
    set_venv
    get_venv
    parse_git_branch
    set_git_branch
    build_branch
    export PS1="${LIGHTGRAY}${TITLEBAR}[\D{%I}:\D{%M}:\D{%S}] ${MAGENTA}\u@\h ${BLUE}\w${venv}${branch}\n${LIGHTGRAY}\$ ${ENDCOLOR}"
}

PROMPT_COMMAND=prompt_cmd

################################################################################
#   INIT                                                                       #
################################################################################

# add $HOME/.bin if it's not already in the path
if [[ ":$PATH:" != *":$HOME/.bin:"* ]]; then
  export PATH="$HOME/.bin:$PATH"
fi
# add $HOME/bin if it's not already in the path
if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
  export PATH="$HOME/bin:$PATH"
fi

# Use bash-completion, if available
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
