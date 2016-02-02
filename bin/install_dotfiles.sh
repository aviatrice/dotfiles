#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in $HOME/dotfiles
# Derived from https://github.com/michaeljsmalley/dotfiles/blob/master/makesymlinks.sh
############################

########## Variables

source_repo="$PROJECT_DIR/dotfiles"     # git repository where dotfiles are kept (can be same as $dotfiles_dir)
dotfiles_dir="$HOME/.dotfiles"          # dotfiles directory
backup_dir="$HOME/.dotfiles.bak"        # old dotfiles backup directory

# list of paths to symlink in $HOME (can be longer path)
# target can be a space-separated list of directories
declare -A symlinks=(
    [".bash_profile"]=".bash_profile .bashrc"
    [".vimrc"]=".vimrc"
    ["bin"]="bin"
    ["lib"]="lib"
)

# shorthand for colored output
GRAY=$LIGHTGRAY
EC=$ENDCOLOR

##########

printf "${GRAY}Installing dotfiles...${EC}\n"

# runs command in a subshell & catches any output
# prints "done" or "failed" first, then prints the output
# useful after an echo -n
# ex:   $ echo -n "Performing task ..."; subsh_and_delay_output task_that_will_fail;
#       $ Performing task ...failed
#       $ error is printed here
function subsh_and_delay_output () {
    output=$( ($@) 2>&1 ) && printf "${GREEN}done${EC}\n" || printf "${RED}failed${EC}\n"
    if [ "$output" ]; then printf "${GRAY}$output${EC}\n"; fi
}

# if needed, symlink source repository to $dotfiles_dir
# otherwise skip and don't spam the terminal w/unneccessary output
if [[ ! "${source_repo}" == "${dotfiles_dir}" && ! "$(readlink ${dotfiles_dir})" == "$source_repo" ]]; then
    printf "${GRAY}Linking ${WHITE}$source_repo ${GRAY}-> ${WHITE}$dotfiles_dir ${GRAY}..."
    subsh_and_delay_output ln -shf $source_repo $dotfiles_dir
fi

# if needed, create $backup_dir in $HOME
# otherwise skip and don't spam the terminal w/unneccessary output
if [ ! -e $backup_dir ]; then
    printf "${GRAY}Creating ${WHITE}$backup_dir ${GRAY}for backup of any existing dotfiles in $HOME ..."
    subsh_and_delay_output mkdir -p $backup_dir
fi

# move any existing dotfiles in $HOME to $backup_dir
# create symlinks from $HOME to any files in $dotfiles_dir specified in $symlinks
for path in ${!symlinks[@]}; do
    for target in ${symlinks["$path"]}; do
        if [[ -e "$HOME/$target" && ! -L "$HOME/$target" ]]; then
            printf "${GRAY}Backing up ${WHITE}"$target" ${GRAY}..."
            subsh_and_delay_output mv "$HOME/$target" "$backup_dir/"
        fi
        if [[ ! "$(readlink "${dotfiles_dir}/${path}")" == "$HOME/$target" ]]; then
            printf ${GRAY}
            if [ -L "$HOME/$target" ]; then
                printf "Re-l"
            else
                printf "L"
            fi
            printf "inking ${WHITE}$target ${GRAY}-> ${WHITE}${dotfiles_dir#$HOME/}/$path ${GRAY}in $HOME ..."
            subsh_and_delay_output ln -shf $dotfiles_dir/$path $HOME/$target
        fi
    done
done

printf "${GRAY}Done installing dotfiles.${EC}\n"
