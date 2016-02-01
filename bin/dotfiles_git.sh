#!/bin/bash

# get access to .bash_profile functions and variables
# suppress errors/warnings such as "bind: warning: line editing not enabled"
source $HOME/.bash_profile 2> /dev/null

# ask for sudo privileges
if [ $EUID != 0 ]; then
    chmod +x $HOME/bin/dotfiles_git.sh
    sudo "$0" "$@"
    exit $?
fi

# location of the git repository
repo="${project_dir}/dotfiles"

# filenames and directories to copy
copy_paths=(
    ".bash_profile"
    ".vimrc"
    "bin"
)

# will omit these files when cleaning the directory $repo during a push
ignore_paths=(
    ".git"
    "README.md"
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

    echo "Copying dotfiles from $HOME to ${repo}..."
    for path in "${copy_paths[@]}"; do
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
            echo "$HOME/$path does not exist, skipping"
        fi
    done

    ## loop through all files including subdirectories
    # shopt -s globstar
    # for f in ${repo}/**/{.,}*
    ## todo: loop through $HOME and find existing files in desired subdirs
    ## add these to keep_paths along with anything in copy_paths

    ## loop through repo and immediate subdirectories
    keep_paths=${copy_paths[@]}
    for f in ${repo}/{.,}*
    do
        path=${f#$repo/}
        # if $f is not in $keep_paths, prompt to remove file
        # exclude from removal: ., .., and anything in $ignore_paths
        omit_regex=$( IFS=$'|'; echo "${ignore_paths[*]}" )
        if ! [[ "$path" =~ .*(\.{1,2}|$omit_regex)$ ]]; then
            rootdir=${path%%/*}
            if ! contains "$rootdir" ${keep_paths[@]}; then
                printf "Do you want to remove $rootdir from $repo? (y/n) "
                read remove
                if [ "$remove" == "y" ]; then
                    rm -rf $repo/$path && echo "Removed $repo/$path" || echo "Failed to remove $repo/$path"
                fi
            fi
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
git --git-dir ${repo}/.git --work-tree $HOME $@
