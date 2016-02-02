### aviatrice - dotfiles
>A bunch of stuff to make life easier and better looking.

#### Installation
Clone anywhere, set any variables with undesired defaults in `bin/install_dotfiles.sh`:
- `$source_repo` - default `$HOME/Projects/dotfiles`
- `$dotfiles_dir` - default `$HOME/.dotfiles`
- `$backup_dir` - default `$HOME/.dotfiles.bak`
- `$symlinks` - an associative array of dotfile -> desired symlink in `$HOME`

Then run `bin/install_dotfiles.sh` to install. This will also symlink `bin` to `$HOME/bin`.
