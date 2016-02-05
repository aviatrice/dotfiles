#!/bin/bash

################################################################################
#   COMMAND MODS/BINDINGS                                                      #
################################################################################

# bash bindings
if [ ${BASH_VERSION} ]; then
    bind "TAB":menu-complete                ## TAB:         autocomplete
    bind '"\e[Z":complete'                  ## SHIFT+TAB:   show autocomplete options
    bind '"\e[A":history-search-backward'   ## arrow-up:    history search
    bind '"\e[B":history-search-forward'    ## arrow-down:  history search
fi
