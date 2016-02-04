#!/bin/bash

# add separators to the dock
function add_dock_separator () {
    defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
    killall Dock
}

export -f add_dock_separator
