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

# add $HOME/.bin if it's not already in the path
if [[ ":$PATH:" != *":$HOME/.bin:"* ]]; then
  export PATH="$HOME/.bin:$PATH"
fi
# add $HOME/bin if it's not already in the path
if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
  export PATH="$HOME/bin:$PATH"
fi
# add $HOME/lib if it's not already in the path
if [[ ":$PATH:" != *":$HOME/lib:"* ]]; then
  export PATH="$HOME/lib:$PATH"
fi

# Use bash-completion, if available
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

printf "${ENDCOLOR}"
