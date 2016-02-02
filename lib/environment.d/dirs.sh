#!/bin/bash

################################################################################
#   DIRECTORIES                                                                #
################################################################################

# PROJECT_DIR controls virtualenv and git behavior, among other things
# set this to your main programming projects dir
export PROJECT_DIR="$HOME/Projects"

export DOTFILES_REPO="$PROJECT_DIR/dotfiles"        # git repository where dotfiles are kept (can be same as $DOTFILES_DIR)
export DOTFILES_DIR="$HOME/.dotfiles"               # dotfiles directory
export DOTFILES_BACKUP_DIR="$HOME/.dotfiles.bak"    # old dotfiles backup directory
