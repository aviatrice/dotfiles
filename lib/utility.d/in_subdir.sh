#!/bin/bash

# takes a path to a dir $1 as argument
# returns true if in a subdirectory of $1
# returns false if directly inside $1 or outside $1
function in_subdir () {
  # strip out the last dir from working directory and compare
  if [[ "${PWD%/*}" == "$1"* ]]; then
    return 0
  else
    return 1
  fi
}
export -f in_subdir
