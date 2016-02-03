#!/bin/bash

################################################################################
#   DOTFILES GIT SHORTCUTS                                                     #
################################################################################

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

        cd "${DOTFILES_REPO}"
        git add . && git commit -m "${commit_msg}" && git push && exit 0 || exit 1
    fi

    # if the first arg can be ran as a git command,
    # runs it automatically w/$HOME as the working tree.
    # ex "dotfiles_git diff" "dotfiles_git status"
    git --git-dir "${DOTFILES_REPO}/.git" --work-tree $HOME $@
}

export -f dotfiles_git
