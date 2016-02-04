#!/bin/bash

################################################################################
#   UTILITY FUNCTIONS                                                          #
################################################################################

# source all files in ./utility.d
parent_path=$( cd "$(dirname "${BASH_SOURCE}")" ; pwd -P )
for f in $parent_path/utility.d/*; do
    if [[ -f $f ]]; then
        source $f
    fi
done
