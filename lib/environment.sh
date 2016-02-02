#!/bin/bash

################################################################################
#   ENVIRONMENT VARIABLES                                                      #
################################################################################

# source all files in ./environment.d
parent_path=$( cd "$(dirname "${BASH_SOURCE}")" ; pwd -P )
for f in $parent_path/environment.d/*; do
    if [[ -f $f && -x $f ]]; then
        source $f
    fi
done
