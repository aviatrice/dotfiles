#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in $HOME/dotfiles
# Derived from https://github.com/michaeljsmalley/dotfiles/blob/master/makesymlinks.sh
############################

########## Variables

source_repo="$HOME/Projects/dotfiles"   # git repository where dotfiles are kept (can be same as $dotfiles_dir)
dotfiles_dir="$HOME/.dotfiles"          # dotfiles directory
backup_dir="$HOME/.dotfiles.bak"        # old dotfiles backup directory

# list of paths to symlink in $HOME (can be longer path)
# target can be a space-separated list of directories
declare -A symlinks=(
    [".bash_profile"]=".bash_profile .bashrc"
    [".vimrc"]=".vimrc"
    ["bin"]="bin"
)

# for nice output
WHITE='\e[1;37m'
LIGHTGRAY='\e[0;37m'
GREEN='\e[0;32m'
RED='\e[0;31m'

##########

printf "${LIGHTGRAY}Installing dotfiles...${ENDCOLOR}\n"

# runs command in a subshell & catches any output
# prints "done" or "failed" first, then prints the output
# useful after an echo -n
# ex:   $ echo -n "Performing task ..."; subsh_and_delay_output task_that_will_fail;
#       $ Performing task ...failed
#       $ error is printed here
function subsh_and_delay_output () {
    output=$( ($@) 2>&1 ) && printf "${GREEN}done${ENDCOLOR}\n" || printf "${RED}failed${ENDCOLOR}\n"
    if [ "$output" ]; then printf "${LIGHTGRAY}$output${ENDCOLOR}\n"; fi
}

# if needed, symlink source repository to $dotfiles_dir
# otherwise skip and don't spam the terminal w/unneccessary output
if [[ ! "${source_repo}" == "${dotfiles_dir}" && ! "$(readlink ${dotfiles_dir})" == "$source_repo" ]]; then
    printf "${LIGHTGRAY}Linking ${WHITE}$source_repo ${LIGHTGRAY}-> ${WHITE}$dotfiles_dir ${LIGHTGRAY}..."
    subsh_and_delay_output ln -shf $source_repo $dotfiles_dir
fi

# if needed, create $backup_dir in $HOME
# otherwise skip and don't spam the terminal w/unneccessary output
if [ ! -e $backup_dir ]; then
    printf "${LIGHTGRAY}Creating ${WHITE}$backup_dir ${LIGHTGRAY}for backup of any existing dotfiles in $HOME ..."
    subsh_and_delay_output mkdir -p $backup_dir
fi

# move any existing dotfiles in $HOME to $backup_dir
# create symlinks from $HOME to any files in $dotfiles_dir specified in $symlinks
for path in ${!symlinks[@]}; do
    for target in ${symlinks["$path"]}; do
        if [[ -e "$HOME/$target" && ! -L "$HOME/$target" ]]; then
            printf "${LIGHTGRAY}Backing up ${WHITE}"$target" ${LIGHTGRAY}..."
            subsh_and_delay_output mv "$HOME/$target" "$backup_dir/"
        fi
        if [[ ! "$(readlink "${dotfiles_dir}/${path}")" == "$HOME/$target" ]]; then
            printf "${LIGHTGRAY}Linking ${WHITE}$target ${LIGHTGRAY}-> ${WHITE}${dotfiles_dir#$HOME/}/$path ${LIGHTGRAY}in $HOME ..."
            subsh_and_delay_output ln -shf $dotfiles_dir/$path $HOME/$target
        fi
    done
done

printf "${LIGHTGRAY}Done installing dotfiles.${ENDCOLOR}\n"
