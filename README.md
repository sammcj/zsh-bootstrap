## zsh shell bootstrap

This git directory in my dropbox and can run the below install script to bootstrap my zsh configuration.

[![Issue Count](https://codeclimate.com/github/sammcj/zsh-bootstrap/badges/issue_count.svg)](https://codeclimate.com/github/sammcj/zsh-bootstrap)

## Install

`$HOME/Library/Mobile\ Documents/com\~apple\~CloudDocs/Dropbox\ Import/dotfiles/shell_config/bootstrap_shell.sh`

## Assumptions

- iCloud Drive or some sort of syncing tool like Dropbox etc...
- Internet access
- [Homebrew](http://brew.sh/) is installed
- Any private exports such as github API tokens etc... can be put in `11-tokens.rc` which is [ignored by git](.gitignore)

## Tests

- Install shellcheck `brew install shellcheck`
- `./run_tests.sh`

And there is travis [![Build Status](https://travis-ci.org/sammcj/zsh-bootstrap.svg?branch=master)](https://travis-ci.org/sammcj/zsh-bootstrap)
