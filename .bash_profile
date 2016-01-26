#virtualenv
source /usr/local/bin/virtualenvwrapper.sh > /dev/null

################################################################################
#   SHELL COMMANDS                                                             #
################################################################################

# quicker basic commands
alias c='clear'
alias e='echo'

# ls shenanigans
alias ls='ls -FGhLl' # decorators + colorized + units + resolve links + list format
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

# shell aliases
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
#   CUSTOM PROMPT                                                              #
################################################################################

# help by The Bash Prompt Builder written by Giles Orr (http://www.gilesorr.com/Code/bpb/)

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

# set virtual environment if one exists w/same name as dir
# if not, and in subdir of project_dir, create virtualenv
# deactivate when moving back to project_dir
function set_venv () {
  project_dir="/Users/rae/Projects"
  current_dir="$(basename "$PWD")"
  if [ -d "$WORKON_HOME/${current_dir}" ]; then
      workon ${current_dir} > /dev/null
  elif [ "$PWD" == "${project_dir}" ]; then
      # deactivate command is not found if virtualenvwrapper is not active,
      # this is expected and ok.
      # send all output including errors to /dev/null.
      deactivate &> /dev/null
  elif [ "$(dirname $PWD)" == "${project_dir}" ]; then
      mkvirtualenv ${current_dir} > /dev/null
  fi
}

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
# thanks https://gist.github.com/maumercado for the below functions!
# capture the output of the "git status" and "git branch" commands
function parse_git_branch () {
  git_branch="$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"
}
parse_git_branch
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
# build prompt
set_git_branch
function build_branch() {
	if [[ $git_branch != "" ]]
	    then
	      branch=" ${LIGHTGRAY}${B_STATE}[$git_branch$git_dirty]"
	else
		  branch=""
	fi
}

# 1. git and venv
# [11:10:58] rae@meanmachine ~/Projects (virtualenv) ~ (gitbranch*)
# $
prompt_cmd() {
    set_venv
    get_venv
    parse_git_branch
    set_git_branch
    build_branch
    export PS1="${LIGHTGRAY}${TITLEBAR}[\D{%I}:\D{%M}:\D{%S}] ${MAGENTA}\u@\h${ENDCOLOR}${LIGHTGRAY} ${BLUE}\w${venv}${branch}\n\
${LIGHTGRAY}\$${ENDCOLOR} "
}

PROMPT_COMMAND=prompt_cmd

################################################################################
#   INIT                                                                       #
################################################################################

if [[ ":$PATH:" != *":$HOME/.bin:"* ]]; then
  # per trevor
  export PATH="$HOME/.bin:$PATH"
fi

# Use bash-completion, if available
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
