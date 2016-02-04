#!/bin/bash

# takes a path to a dir $1 as argument
# returns true if in a subdirectory of $1 or directly inside $1
# returns false if outside $1
function in_dir () {
  if [[ "${PWD}" == "$1" ]]; then
    return 0
  else
    return 1
  fi
}
export -f in_dir
