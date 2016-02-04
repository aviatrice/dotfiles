#!/bin/bash

# adds a loading spinner to the end of the previous line
# thanks to William Pursell for some of the logic
# https://stackoverflow.com/questions/12498304/using-bash-to-display-a-progress-working-indicator
# requires the pid of a running background process
function spinner() {
  pid=$1 # pid of the previous running command
  spin='-\|/'
  i=0
  printf "  " # 2 spaces, one for spacing, one for padding against first \b
  while kill -0 $pid 2>/dev/null
  do
    i=$(( (i+1) %4 ))
    printf "\b${spin:$i:1}"
    sleep .1
  done
  printf "\bDone.\n"
}
export -f spinner
