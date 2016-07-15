#!/bin/zsh
function () {
	local p
	for p in "$@"; do
		[[ -e "$p" ]] || continue
		source "$p"
		break
	done
} ${commands[virtualenvwrapper.sh]:-"/usr/share/virtualenvwrapper/virtualenvwrapper.sh"}
