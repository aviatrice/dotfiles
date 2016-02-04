#!/bin/bash

# set virtual environment if one exists w/same name as $current_dir
# if not, and in subdir of $PROJECT_DIR, create virtualenv
# deactivate when moving back to or out of $PROJECT_DIR
function set_venv () {
  current_dir="$(basename "$PWD")"
  if [ -d "$WORKON_HOME/${current_dir}" ]; then
      workon "${current_dir}" > /dev/null
  elif ! in_subdir "${PROJECT_DIR}"; then
      deactivate &> /dev/null
  elif [ "$(dirname $PWD)" == "${PROJECT_DIR}" ]; then
      printf "Creating virtual environment \"${current_dir}\"..."
      (mkvirtualenv "${current_dir}" &> /dev/null) & disown # disown hides output
      spinner $! # pass last pid to spinner()
      prompt_cmd # updates prompt with newly created virtualenv
  fi
}
export -f set_venv
