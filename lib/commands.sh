#!/bin/bash

################################################################################
#   ENHANCED COMMANDS                                                          #
################################################################################

# source all files in ./commands.d
parent_path=$( cd "$(dirname "${BASH_SOURCE}")" ; pwd -P )
for f in $parent_path/commands.d/*; do
    if [[ -f $f ]]; then
        source $f
    fi
done
