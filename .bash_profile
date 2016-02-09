################################################################################
#   LIB/BIN                                                                    #
################################################################################

# allow running scripts from $HOME/bin
for f in $HOME/bin/*; do
  if [[ -f $f ]]; then
    chmod +x $f
  fi
done
# source all files in $HOME/lib
for f in $HOME/lib/*; do
  if [[ -f $f ]]; then
    source $f
  fi
done

################################################################################
#   INIT                                                                       #
################################################################################

# call attention to any errors in this section
printf "${RED}"

# virtualenvwrapper
source /usr/local/bin/virtualenvwrapper.sh > /dev/null

# add dirs if not already in the path:
# ~/.bin
# ~/bin
# ~/lib
path_addns=""
[[ ":$PATH:" != *":$HOME/.bin:"* ]] && path_addns+="$HOME/.bin:"
[[ ":$PATH:" != *":$HOME/bin:"* ]] && path_addns+="$HOME/bin:"
[[ ":$PATH:" != *":$HOME/lib:"* ]] && path_addns+="$HOME/lib:"
[[ $path_addns ]] && export PATH="$path_addns$PATH"

# Use bash-completion, if available
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

printf "${ENDCOLOR}"
