# per virtualenvwrapper
source /usr/local/bin/virtualenvwrapper.sh > /dev/null

################################################################################
#   GLOBAL VARIABLES                                                           #
################################################################################

# project_dir controls virtualenv behavior
# virtualenvs will always be created in immediate subdirectories
# existing virtualenvs by the same name as an immediate subdirectory will be automatically switched to
# changing to this directory deactivates all virtualenvs
# to disable functionality, set this to an empty string or "none"
project_dir="/Users/rae/Projects"

# script to copy dotfiles to git repo and push them up
# must be in ~ with the rest of the dotfiles
git_script=".push_dotfiles"

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
#   SHELL COMMANDS                                                             #
################################################################################

# quicker basic commands
alias c='clear'
alias e='echo'

# ls shenanigans
alias ls='ls -FGhLl' # decorators + colorized + size units + resolve symlinks + list format
alias lsa='ls -a' # all files
alias lsc='ls -C' # force multi-column output
alias lst='lsa -t' # sorted by time
alias ls.='ls -d .*' # only hidden files
alias ls@='ls -H' # show symbolic links

# easier to move up dirs
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .4='cd ../../..'
alias .5='cd ../../../..'

# quick history of last 10 commands
alias h='history | tail -11 | head -10'

# easy-to-read path
alias path='echo -e ${PATH//:/\\n}'

# reboot / halt / poweroff
alias reboot='sudo /sbin/reboot'
alias poweroff='sudo /sbin/poweroff'
alias halt='sudo /sbin/halt'
alias shutdown='sudo /sbin/shutdown'

# assume auto-resume wget
alias wget='wget -c'

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

# colorize grep
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

################################################################################
#   UTILITY                                                                    #
################################################################################

function push_dotfiles () {
  wd=$(pwd)
  cd ~
  source ${git_script}
  cd ${wd}
  # test
}

# adds a loading spinner to the end of the previous line
# thanks to William Pursell
# https://stackoverflow.com/questions/12498304/using-bash-to-display-a-progress-working-indicator
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

# takes a path to a dir $1 as argument
# returns true if in a subdirectory of $1
# returns false if directly inside $1 or not inside $1
function in_subdirectory_of () {
  IFS='/'
  read -ra dirarray <<< "${PWD}"
  for i in "${dirarray[@]}"; do
      if [ "$i" == "$(basename $1)" ]; then
        IFS=''
        return 1
      fi
  done
  IFS='' # reset IFS or virtualenvwrapper has a fit
  return 0
}

# set virtual environment if one exists w/same name as dir
# if not, and in subdir of project_dir, create virtualenv
# deactivate when moving back to project_dir
function set_venv () {
  # allow unsetting project_dir to cancel functionality
  if [[ "${project_dir}" == "" || "${project_dir}" == "none" ]]; then
    return
  fi
  current_dir="$(basename "$PWD")"
  if [ -d "$WORKON_HOME/${current_dir}" ]; then
      workon ${current_dir} > /dev/null
  # elif [ "$PWD" == "${project_dir}" ]; then
  elif ! in_subdirectory_of "${project_dir}"; then
      deactivate &> /dev/null
      # TODO: deactivate if moving to any directory not inside the project_dir
  elif [ "$(dirname $PWD)" == "${project_dir}" ]; then
      printf "Creating virtual environment \"${current_dir}\"..."
      (mkvirtualenv ${current_dir} &> /dev/null) & disown # disown hides output
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
	      branch=" ${LIGHTGRAY}${B_STATE}[$git_branch$git_dirty]"
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

# Use bash-completion, if available
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
