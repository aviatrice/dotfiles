#!/bin/bash

# When this "cd" function gets more than one argument it ignores the "cd" and re-arranges the args
# so that second arg becomes the command.
# e.g.
# "cd log/project/20120330/some.log.gz zless"  ->  "zless log/project/20120330/some.log.gz"
# "cd lib/Foo/Bar/Baz.pm vi +100"  ->  "vi +100 lib/Foo/Bar/Baz.pm"
function cd () {
    if [ $# -lt 1 ]; then
        builtin cd
    elif [ $# -eq 1 ]; then
        builtin cd "$1"
    else
        cd_arg_1="$1"
        shift
        "$@" "$cd_arg_1"
    fi
}
export -f cd
