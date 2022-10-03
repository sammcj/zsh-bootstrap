# zsh shell bootstrap and dotfiles

This repository bootstraps my zsh shell, brew packages and dotfiles.

[![Issue Count](https://codeclimate.com/github/sammcj/zsh-bootstrap/badges/issue_count.svg)](https://codeclimate.com/github/sammcj/zsh-bootstrap)

## Install

```shell
./bootstrap_shell.sh
```

## Update

```shell
# Make changes
pre-commit install
git add . && git commit -m "fix/feat/chore: commit message" && git push
```

## Assumptions

- Internet access.
- [Homebrew](https://brew.sh/) is installed.
- Any private exports such as github API tokens etc... can be put in `*private*.rc` which are [ignored by git](.gitignore) and checked for in CI.
- iCloud Drive setup (if you want to use the iCloud Drive dotfiles).
- Signed in to the Apple App Store if you want to use the [mas](https://github.com/mas-cli/mas) package manager.

## Files

- [`bootstrap_shell.sh`](bootstrap_shell.sh) - Installs homebrew packages, sets up zsh, and symlinks dotfiles
- [`Brewfile`](Brewfile) - Homebrew packages to install
- [`commitlint.config.js`](commitlint.config.js) - Commitlint config
