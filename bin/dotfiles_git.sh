#!/bin/bash

# ask for sudo privileges
if [ $EUID != 0 ]; then
    chmod +x $HOME/bin/dotfiles_git.sh
    sudo "$0" "$@"
    exit $?
fi

repo="$HOME/Projects/dotfiles/"

declare -a files_to_copy=(
    ".bash_profile"
    ".vimrc"
    "bin"
)


# special case: 1st argument is "push"
# asks for commit message and copies files before pushing
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

    echo "Copying dotfiles from $HOME to ${repo}"
    for path in "${files_to_copy[@]}"; do
        if [[ -d $HOME/$path ]]; then
            # $path is a directory
            if ! [[ -d "${repo}/$path" ]]; then
                mkdir "${repo}/$path"
            fi
            cp -R "$HOME/$path/." "${repo}/$path/"
        elif [[ -f $HOME/$path ]]; then
            # $path is a file
            cp "$HOME/$path" "${repo}/$path"
        else
            echo "$HOME/$path does not exist, skipping..."
        fi
    done

    cd ${repo}
    git add .
    git commit -m "${commit_msg}"
    git push -u origin master

    exit 0
fi

# if the first arg can be ran as a git command,
# runs it automatically w/~ as the working tree.
# ex "dotfiles_git diff" "dotfiles_git status"
git --git-dir ${repo}/.git --work-tree ~ $1
    && exit 0
    || exit "Failed to run git command"
