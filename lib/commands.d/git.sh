#!/bin/bash

################################################################################
#   RUN GIT FROM ANYWHERE                                                      #
################################################################################

function git () {

    repo_name=""

    # check for existence of repo flag
    shopt -s extglob
    IFS=" "
    if [[ "$*" == *"-repo"* ]]; then
        [[ "$*" =~ -repo[[:space:]]([[:alnum:][:punct:]]+) ]] && repo_name=${BASH_REMATCH[1]}
        if [ "$repo_name" == "" ]; then
            echo "-repo flag requires a repository name as argument." >&2
            exit 1
        elif ! [ -d "$PROJECT_DIR/$repo_name/.git" ]; then
            echo "Repository name passed with -repo must be a valid git repository inside \"$PROJECT_DIR\"." >&2
            exit 1
        fi
    fi
    IFS=""
    shopt -u extglob

    if [ "$repo_name" == "" ]; then
        # if no repo name was pushed, just use the existing git command and exit
        command git $@
    else
        # if a repo was set, run the existing git command with that repo
        # first strip the -repo option out of args
        args=( "$@" )
        for i in ${!args[@]}; do
            if [[ "${args[$i]}" == "-repo" || "${args[$i]}" == "$repo_name" ]]; then
                args[${i}]=""
            fi
        done
        command git --git-dir "$PROJECT_DIR/$repo_name/.git" --work-tree "$PROJECT_DIR/$repo_name" ${args[@]}
    fi
}

export -f git
