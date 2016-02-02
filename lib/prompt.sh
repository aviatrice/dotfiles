################################################################################
#   CUSTOM PROMPT                                                              #
################################################################################

# escaped color codes
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
