#!/bin/bash

# quick access to configuration for various apps
conf() {
        case "$1" in
                bash)       vim $HOME/.bash_profile && bash ;;
                vim)        vim $HOME/.vimrc ;;
                crawl)      cd /Applications/Dungeon\ Crawl\ Stone\ Soup\ -\ Tiles.app/Contents/Resources/settings && subl . ;;
                zsh)        vim $HOME/.zshrc && source ~/.zshrc ;;
                hosts)      vim /etc/hosts ;;
                *)          echo "Unknown application: $1" >&2 ;;
        esac
}
