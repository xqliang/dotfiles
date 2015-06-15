Dotfiles
========

[![Join the chat at https://gitter.im/xqliang/dotfiles](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/xqliang/dotfiles?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

A bunch of configuration files for editors and other UNIX tools.

Installation
------------

Clone this repo into `~/.dotfiles`:

    $ git clone git@github.com:xqliang/dotfiles.git ~/.dotfiles

Then install the dotfiles:

    $ cd ~/.dotfiles
    $ make             # Or "make install" to create symblinks
    $ make deps        # Optional install system dependences like 'ctags' and 'pycscope', require root privilege
    $ make uninstall   # Restore backups and remove symblinks

It will backup existing files as `<file>.dotfiles.bak`.

The dotfiles will be symlinked, e.g. `~/.bashrc` symlinked to `~/.dotfiles/dotfiles/bashrc`.
