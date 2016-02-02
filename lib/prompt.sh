#!/bin/bash

################################################################################
#   CUSTOM PROMPT                                                              #
################################################################################

# escaped color codes
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
    B_STATE="${PROMPT_GREEN}"
  elif [[ ${git_status} =~ .*"Changes to be committed".* ]]; then
    B_STATE="${PROMPT_YELLOW}"
    git_dirty="*"
  else
    B_STATE="${PROMPT_RED}"
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
    export PS1="${PROMPT_LIGHTGRAY}${TITLEBAR}[\D{%I}:\D{%M}:\D{%S}] ${PROMPT_MAGENTA}\u@\h ${PROMPT_BLUE}\w${venv}${branch}\n${PROMPT_LIGHTGRAY}\$ ${PROMPT_EC}"
}

PROMPT_COMMAND=prompt_cmd
