### aviatrice - dotfiles
>A bunch of stuff to make life easier and better looking.

#### Installation
1. Set your main projects directory in `lib/**/dirs.sh / $PROJECT_DIR`
2. Clone anywhere, set any variables with undesired defaults in `lib/environment.d`:
    - `dirs.sh / $DOTFILES_REPO` - default `$PROJECT_DIR/dotfiles`
    - `dirs.sh / $DOTFILES_DIR` - default `$HOME/.dotfiles` (if different from `$DOTFILES_REPO`, symlinked during install)
    - `dirs.sh / $DOTFILES_BACKUP_DIR` - default `$HOME/.dotfiles.bak`
    - `install.sh / $SYMLINKS` - maps paths from `$DOTFILES_REPO` to desired symlinks in `$HOME`; for files such as `.bashrc` and `.vimrc`

Then run `bin/install_dotfiles.sh` to install.
