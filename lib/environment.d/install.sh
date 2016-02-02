#!/bin/bash

################################################################################
#   INSTALL SCRIPT                                                             #
################################################################################

# list of paths to symlink in $HOME (can be longer path)
# target can be a space-separated list of directories
export -A SYMLINKS=(
    [".bash_profile"]=".bash_profile .bashrc"
    [".vimrc"]=".vimrc"
    ["bin"]="bin"
    ["lib"]="lib"
)
