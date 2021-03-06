#!/bin/bash

################################################################################
#   DOTFILES GIT SHORTCUTS                                                     #
################################################################################

# TODO: run this in subshell so cd has no effect
function dotfiles_git () {
    # special case: 1st argument is "push"
    # asks for commit message or generates generic one before pushing
    if [ "$1" == "push" ]; then
        commit_msg=$2
        if [ "${commit_msg}" == "" ]; then
            printf "Do you want a custom commit message? (y/n) "
            read custom
            if [ "${custom}" == "y" ]; then
                printf "Enter commit message: "
                read commit_msg
            fi
            if [[ "${custom}" != "y" || "${commit_msg}" == "" ]]; then
                commit_msg="dotfiles update $(date +"%Y-%m-%d %T")"
            fi
        fi

        # temporary: save working dir and return after script runs
        wd="$PWD"
        cd "${DOTFILES_REPO}"
        git add . && git commit -m "${commit_msg}" && git push && return 0 || return 1
        cd "$wd"
    fi

    # if the first arg can be ran as a git command,
    # runs it automatically w/$HOME as the working tree.
    # ex "dotfiles_git diff" "dotfiles_git status"
    git --git-dir "${DOTFILES_REPO}/.git" --work-tree "${DOTFILES_DIR}" $@
}

export -f dotfiles_git
