#!/bin/bash

################################################################################
#   ENVIRONMENT VARIABLES                                                      #
################################################################################
#

# source all files in ./environment.d
parent_path=$( cd "$(dirname "${BASH_SOURCE:-$0}")" ; pwd -P )
for f in $parent_path/environment.d/*; do
    if [[ -f $f ]]; then
        source $f
    fi
done
