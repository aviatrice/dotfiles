#!/bin/bash

################################################################################
#   CUSTOM PROMPT                                                              #
################################################################################

# escaped color codes
if ! [ "${BASH_VERSION}" == "" ]; then
  PROMPT_RED="\[${RED}\]"
  PROMPT_ORANGE="\[${ORANGE}\]"
  PROMPT_GREEN="\[${GREEN}\]"
  PROMPT_YELLOW="\[${YELLOW}\]"
  PROMPT_BLUE="\[${BLUE}\]"
  PROMPT_MAGENTA="\[${MAGENTA}\]"
  PROMPT_CYAN="\[${CYAN}\]"
  PROMPT_LIGHTGRAY="\[${LIGHTGRAY}\]"
  PROMPT_WHITE="\[${WHITE}\]"
  PROMPT_EC="\[${ENDCOLOR}\]"
else
  PROMPT_RED="${RED}"
  PROMPT_ORANGE="${ORANGE}"
  PROMPT_GREEN="${GREEN}"
  PROMPT_YELLOW="${YELLOW}"
  PROMPT_BLUE="${BLUE}"
  PROMPT_MAGENTA="${MAGENTA}"
  PROMPT_CYAN="${CYAN}"
  PROMPT_LIGHTGRAY="${LIGHTGRAY}"
  PROMPT_WHITE="${WHITE}"
  PROMPT_EC="${ENDCOLOR}"
fi

# get virtual env
function _get_venv () {
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
function _parse_git_branch () {
  git_branch="$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"
  git_repo="$(git config --local remote.origin.url|sed -n 's/.*\/\(.*\)\.git/\1/p')"
  if [[ "${git_branch}" != "" && "$(basename $PWD)" != "${git_repo}" ]]; then
    if [ "${git_repo}" == "" ]; then
      git_repo="?" # if the branch is defined but not the repo, display a ? as the repo name
    fi
    git_branch="${git_repo}/${git_branch}"
  fi
}
_parse_git_branch

# indicate status of working copy
function _set_git_branch () {
  git_status="$(git status 2> /dev/null)"
  git_dirty=""
  # set color based on clean/staged/dirty
  if [[ ${git_status} =~ .*"working directory clean".* ]]; then
    B_STATE="${PROMPT_GREEN}"
  elif [[ ${git_status} =~ .*"Changes to be committed".* ]]; then
    B_STATE="${PROMPT_YELLOW}"
    git_dirty="*"
  else
    B_STATE="${PROMPT_RED}"
    git_dirty="*"
  fi
}
_set_git_branch

# build prompt
function _build_branch() {
    if [[ $git_branch != "" ]]
        then
          branch=" ${B_STATE}[$git_branch$git_dirty]"
    else
          branch=""
    fi
}

function _log_history() {
  if [ "$(id -u)" -ne 0 ]; then
    echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history 1)" >> ~/.logs/bash/bash-history-$(date "+%Y-%m-%d").log;
  fi
}

# example prompt:
# [11:10:58] user@hostname ~/current/dir (virtualenv) [gitrepo/gitbranch*]
# $
prompt_cmd() {
    # log last command every time prompt is rebuilt
    # _log_history
    # build prompt
    # set_venv - currently broken
    _get_venv
    _parse_git_branch
    _set_git_branch
    _build_branch
    export PS1="${PROMPT_LIGHTGRAY}${TITLEBAR}[\D{%I}:\D{%M}:\D{%S}] ${PROMPT_MAGENTA}\u@\h ${PROMPT_BLUE}\w${venv}${branch}\n${PROMPT_LIGHTGRAY}\$ ${PROMPT_EC}"
}

PROMPT_COMMAND=prompt_cmd
