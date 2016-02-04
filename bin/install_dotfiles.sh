#!/bin/bash

############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in $HOME/dotfiles
# Derived from https://github.com/michaeljsmalley/dotfiles/blob/master/makesymlinks.sh
############################

########## Variables

# shorthand for colored output
GRAY=$LIGHTGRAY
EC=$ENDCOLOR

# source environment variables if running in a subshell
if [[ ! ${SYMLINKS[@]} ]]; then
    printf "${GRAY}Sourcing environment variables...${ENDCOLOR}\n"
    source $HOME/lib/environment.sh
fi

##########

printf "${GRAY}Installing dotfiles...${EC}\n"

# runs command in a subshell & catches any output
# prints "done" or "failed" first, then prints the output
# useful after an echo -n
# ex:   $ echo -n "Performing task ..."; subsh_and_delay_output [task_that_will_fail];
#       $ Performing task ...failed
#       $ error is printed here
function subsh_and_delay_output () {
    output=$( ($@) 2>&1 ) && printf "${GREEN}done${EC}\n" || printf "${RED}failed${EC}\n"
    if [ "$output" ]; then printf "${GRAY}$output${EC}\n"; fi
}

# if needed, symlink source repository to $DOTFILES_DIR
# otherwise skip and don't spam the terminal w/unneccessary output
if [[ ! "${DOTFILES_REPO}" == "${DOTFILES_DIR}" && ! "$(readlink ${DOTFILES_DIR})" == "$DOTFILES_REPO" ]]; then
    printf "${GRAY}Linking ${WHITE}$DOTFILES_REPO ${GRAY}-> ${WHITE}$DOTFILES_DIR ${GRAY}..."
    subsh_and_delay_output ln -shf $DOTFILES_REPO $DOTFILES_DIR
fi

# if needed, create $DOTFILES_BACKUP_DIR in $HOME
# otherwise skip and don't spam the terminal w/unneccessary output
if [ ! -e $DOTFILES_BACKUP_DIR ]; then
    printf "${GRAY}Creating ${WHITE}$DOTFILES_BACKUP_DIR ${GRAY}for backup of any existing dotfiles in $HOME ..."
    subsh_and_delay_output mkdir -p $DOTFILES_BACKUP_DIR
fi

# move any existing dotfiles in $HOME to $DOTFILES_BACKUP_DIR
# create symlinks from $HOME to any files in $DOTFILES_DIR specified in $symlinks
for link_path in ${!SYMLINKS[@]}; do
    for target in ${SYMLINKS["$link_path"]}; do
        # backup existing dotfile if needed
        if [[ -e "$HOME/$target" && ! -L "$HOME/$target" ]]; then
            printf "${GRAY}Backing up ${WHITE}"$target" ${GRAY}..."
            subsh_and_delay_output mv "$HOME/$target" "$DOTFILES_BACKUP_DIR/"
        fi
        # symlink and print either "linking" or "re-linking" target -> link_path
        if [[ ! "$(readlink "${DOTFILES_DIR}/${link_path}")" == "$HOME/$target" ]]; then
            printf ${GRAY}
            if [ -L "$HOME/$target" ]; then
                printf "Re-l"
            else
                printf "L"
            fi
            printf "inking ${WHITE}$target ${GRAY}-> ${WHITE}${DOTFILES_DIR#$HOME/}/$link_path ${GRAY}in $HOME ..."
            subsh_and_delay_output ln -shf $DOTFILES_DIR/$link_path $HOME/$target
        fi
    done
done

printf "${GRAY}Done installing dotfiles.${EC}\n"
