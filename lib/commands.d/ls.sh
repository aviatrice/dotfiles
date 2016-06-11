#!/bin/bash

################################################################################
#   EASY LS SHORTCUTS                                                          #
################################################################################

# aliases
alias ls='ls -FGhLl'            # decorators + colorized + size units + resolve symlinks + list format
alias lsa='ls -a'               # all files
alias lst='lsa -t'              # sorted by time
alias lsh='lst | HEAD -10'      # 10 most recently modified files
alias lsc='ls -C'               # force multi-column output
alias lsg='ls | grep -i'        # grep directory for a filename

# functions, as parameters can't be aliased
# list subdirectories (removes decorators)
function lsd () {
    [ "$1" ] && dir="${1%/}/"
    \ls -dGhLl ${dir}*/
    dir="" # TODO: why (if absent, var does not get reassigned)
}

# list hidden files
function ls. () {
    [ "$1" ] && dir="${1%/}/"
    ls -d ${dir}.*
    dir=""
}

# grep for symlinks and list them w/ symlinks and targets highlighted
function ls@ () {
    [ "$1" ] && dir="${1%/}/"
    ls -aH $dir | GREP_COLOR="1;34" \grep -E --color=always "\s\w+@" \
                | GREP_COLOR="1;35" \grep -E --color=always "\s\S+$" \
                || echo "No symlinks."
    dir=""
}

export -f lsd ls. ls@
