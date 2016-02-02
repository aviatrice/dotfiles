### aviatrice - dotfiles
>A bunch of stuff to make life easier and better looking.

#### Installation
Clone anywhere, set any variables with undesired defaults in `bin/install_dotfiles.sh`:
- `$source_repo` - default `$HOME/Projects/dotfiles`
- `$dotfiles_dir` - default `$HOME/.dotfiles`
- `$backup_dir` - default `$HOME/.dotfiles.bak`
- `$symlinks` - maps paths from `$source_repo` -> desired symlinks in `$HOME`

Then run `bin/install_dotfiles.sh` to install. This will also symlink `$source_repo/bin` -> `$HOME/bin`.
