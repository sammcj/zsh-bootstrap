# Plan: Migrate to Chezmoi + Brewfile (New Repo)

## Context

The current `sammcj/zsh-bootstrap` repo manages macOS dotfiles via a monolithic `bootstrap_shell.sh` that creates symlinks from an iCloud Drive path (`~/Library/Mobile Documents/com~apple~CloudDocs/Dropbox Import/dotfiles/shell_config/`) to home directory targets. Numbered `.rc` files (0-16) are sourced by zshrc via glob from that iCloud path. Private files (`*private*.rc`, `.gitconfig.private`) are gitignored.

**Problems**: iCloud dependency, fragile symlink scripts, no templating for machine-specific config, no encryption for secrets, hard to reproduce on a fresh machine.

**Goal**: Create a **new repo** (e.g. `sammcj/dotfiles`) using Chezmoi for dotfile management + a tracked Brewfile + run scripts for non-brew installs. Use **age encryption** for secrets. Eliminate the iCloud Drive dependency. Keep the modular `.rc` file pattern. No asdf — use pyenv, uv, fnm, rustup directly.

---

## New Repository Structure

```
sammcj/dotfiles/                  # New repo, cloned by chezmoi to ~/.local/share/chezmoi
├── .chezmoi.toml.tmpl            # Config template (prompts for machine-specific values)
├── .chezmoiignore                # Ignore CI files, README, etc. from being applied
├── .chezmoiexternal.toml         # External git repos (zgen, tpm, git-fuzzy)
│
├── dot_zshrc.tmpl                # → ~/.zshrc
├── dot_zprofile.tmpl             # → ~/.zprofile
├── dot_gitconfig                 # → ~/.gitconfig
├── dot_gitignoreglobal           # → ~/.gitignoreglobal
├── dot_gitconfig-no_push         # → ~/.gitconfig-no_push
├── encrypted_dot_gitconfig.private.asc  # → ~/.gitconfig.private (age-encrypted)
├── dot_vimrc                     # → ~/.vimrc
├── dot_tmux.conf                 # → ~/.tmux.conf
├── dot_dircolors                 # → ~/.dircolors
├── dot_cspell.json               # → ~/.cspell.json
├── dot_cspell-custom-words.txt   # → ~/.cspell-custom-words.txt
├── dot_rsyncd.conf               # → ~/.rsyncd.conf
├── dot_editorconfig              # → ~/.editorconfig
│
├── private_dot_config/
│   ├── bat/
│   │   └── config                # → ~/.config/bat/config
│   ├── ghostty/
│   │   └── config                # → ~/.config/ghostty/config
│   └── htop/
│       └── htoprc                # → ~/.config/htop/htoprc
│
├── dot_zsh.d/                    # → ~/.zsh.d/ (all numbered rc files)
│   ├── 0-paths.rc.tmpl
│   ├── 1-zgen.rc
│   ├── 3-location_specifics.rc.tmpl
│   ├── 4-aliases.rc.tmpl
│   ├── 5-exports.rc.tmpl
│   ├── 6-zsh_options.rc
│   ├── 7-history.rc
│   ├── 9-functions.rc.tmpl
│   ├── 10-prompt.rc
│   ├── 14-source-files.rc
│   ├── 15-events.rc
│   ├── 16-ai.rc.tmpl
│   └── encrypted_private.rc.asc  # age-encrypted (replaces *private*.rc)
│
├── Brewfile                      # Tracked Brewfile for brew bundle
│
├── .github/                      # CI workflows (carried over from zsh-bootstrap)
│
└── run_scripts/                  # Chezmoi run_ scripts (replace bootstrap_shell.sh)
    ├── run_once_before_01-install-homebrew.sh.tmpl
    ├── run_onchange_02-brew-bundle.sh.tmpl
    ├── run_once_03-install-uv-python.sh
    ├── run_once_04-install-rust-cargo.sh
    ├── run_once_05-install-npm-packages.sh
    ├── run_once_06-install-go-packages.sh
    ├── run_once_07-setup-zsh-shell.sh
    ├── run_once_08-macos-defaults.sh.tmpl
    ├── run_once_09-configure-amazon-q.sh
    └── run_once_10-docker-compose.sh
```

---

## Key Design Decisions

### 1. Chezmoi Config (`.chezmoi.toml.tmpl`)

Prompts on first `chezmoi init` for machine-specific values. These replace the hostname `case` statement in `3-location_specifics.rc`.

```toml
encryption = "age"

[age]
  identity = "~/.config/chezmoi/key.txt"
  recipient = "age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

[data]
  name = "Sam McLeod"
  email = "{{ promptStringOnce . "email" "Git email address" }}"
  hostname = "{{ .chezmoi.hostname }}"
  is_personal = {{ promptBoolOnce . "is_personal" "Is this a personal machine" }}
  username = "{{ .chezmoi.username }}"
```

### 2. Dotfile Sourcing — Eliminate iCloud Path

**This is the most important change.** The current `zshrc` (line 49-52) sources from iCloud:
```zsh
# CURRENT (zshrc:49-52)
for file in "$HOME"/Library/Mobile\ Documents/com\~apple\~CloudDocs/Dropbox\ Import/dotfiles/shell_config/*.rc; do
```

In the new setup, chezmoi places rc files at `~/.zsh.d/`, and `dot_zshrc.tmpl` sources from there:
```zsh
# NEW
for file in "$HOME"/.zsh.d/*.rc; do
    source "$file"
done
```

All hardcoded iCloud/Dropbox paths throughout the codebase must be updated:

| File | Lines | What to change |
|------|-------|----------------|
| `zshrc` | 49-52 | RC sourcing path → `~/.zsh.d/` |
| `0-paths.rc` | 7 | iCloud bin dir → `$HOME/.local/bin` or remove |
| `4-aliases.rc` | 4, 7, 11 | `THIS_DIRECTORY`, icloud_drive alias |
| `4-aliases.rc` | 202-205 | Backup paths referencing iCloud |
| `5-exports.rc` | various | `PNPM_HOME` hardcoded to `/Users/samm/` |
| `9-functions.rc` | 927, 992, 1455, 1725 | Backup destinations, scripts paths |
| `16-ai.rc` | 7-8 | Cline rules path |
| `bootstrap_shell.sh` | 14 | `THIS_REPO` path (script removed entirely) |

For paths that genuinely reference iCloud (like backup destinations, Cline rules), use chezmoi template with `{{ .chezmoi.homeDir }}` to avoid hardcoding `/Users/samm`.

### 3. Brewfile (Starter Template)

A curated Brewfile based on tools referenced across the rc files, bootstrap script, and aliases. You'll refine this with `brew bundle dump --describe` on your machine.

```ruby
# Taps
tap "homebrew/bundle"

# Core CLI
brew "bat"
brew "coreutils"
brew "delta"          # git diff pager
brew "difftastic"     # structural diff
brew "fd"
brew "fnm"            # fast node manager
brew "fzf"
brew "gh"
brew "git"
brew "git-lfs"
brew "glow"           # markdown renderer
brew "htop"
brew "jq"
brew "mas"            # Mac App Store CLI
brew "mtr"
brew "pyenv"
brew "ripgrep"
brew "tmux"
brew "vim"
brew "vivid"          # LS_COLORS generator
brew "zoxide"
brew "zsh"

# Development
brew "go"
brew "node"           # base node for fnm
brew "pnpm"
brew "docker-compose"

# Networking / cloud
brew "awscli"
brew "saml2aws"

# Media
brew "ffmpeg"
brew "imagemagick"

# Casks
cask "ghostty"
cask "visual-studio-code"
# cask "firefox"
# cask "docker"
# ... add your casks

# Mac App Store (uncomment and add IDs)
# mas "App Name", id: 123456
```

### 4. Run Scripts (Replace `bootstrap_shell.sh`)

Each script is **idempotent** — safe to re-run. Chezmoi tracks execution state so `run_once_*` scripts only run on first apply.

| Script | Chezmoi Type | Replaces |
|--------|-------------|----------|
| `run_once_before_01-install-homebrew.sh.tmpl` | `run_once_before` | `installHomebrew()` (brew install only) |
| `run_onchange_02-brew-bundle.sh.tmpl` | `run_onchange` | `brew bundle` — reruns when Brewfile hash changes |
| `run_once_03-install-uv-python.sh` | `run_once` | `installPythonPackages()` — uv, venv, mu-repo, oterm, yt-dlp |
| `run_once_04-install-rust-cargo.sh` | `run_once` | `installCargoPackages()` — rustup + cai, code2prompt, gitu, lazycli |
| `run_once_05-install-npm-packages.sh` | `run_once` | `installNpmPackages()` — pnpm, eslint, prettier, cspell + 16 dicts |
| `run_once_06-install-go-packages.sh` | `run_once` | `installGoPackages()` — actionlint, gup, lazydocker, dnstrace |
| `run_once_07-setup-zsh-shell.sh` | `run_once` | `installZshZgen()` — add zsh to /etc/shells |
| `run_once_08-macos-defaults.sh.tmpl` | `run_once` | `macOSConfig()` — gh completion, NSStatusItemSelectionPadding, touchID |
| `run_once_09-configure-amazon-q.sh` | `run_once` | `configureAmazonQ()` — all `q settings` calls |
| `run_once_10-docker-compose.sh` | `run_once` | `installDockerCompose()` — cli-plugins symlink |

**Key detail for `run_onchange` Brewfile script:**
```bash
#!/bin/bash
# run_onchange_02-brew-bundle.sh.tmpl
# Brewfile hash: {{ include "Brewfile" | sha256sum }}
brew bundle --file={{ joinPath .chezmoi.sourceDir "Brewfile" }} --no-lock
```
The hash comment triggers re-execution whenever Brewfile content changes.

### 5. External Dependencies (`.chezmoiexternal.toml`)

Replaces `clone_repo()` calls in bootstrap_shell.sh:

```toml
[".zgen"]
  type = "git-repo"
  url = "https://github.com/tarjoilija/zgen.git"
  refreshPeriod = "168h"

[".tmux/plugins/tpm"]
  type = "git-repo"
  url = "https://github.com/tmux-plugins/tpm.git"
  refreshPeriod = "168h"

[".git-fuzzy"]
  type = "git-repo"
  url = "https://github.com/bigH/git-fuzzy.git"
  refreshPeriod = "168h"
```

### 6. Secrets — age Encryption

**Setup (one-time on your machine):**
```bash
chezmoi age keygen -o ~/.config/chezmoi/key.txt
# Copy the public key (age1...) into .chezmoi.toml.tmpl [age] recipient
# Back up the key file securely (e.g. password manager, USB key)
```

**Adding encrypted files:**
```bash
chezmoi add --encrypt ~/.gitconfig.private
chezmoi add --encrypt ~/.zsh.d/private.rc   # your *private*.rc content
```

Files are stored age-encrypted in the repo. On `chezmoi apply`, they're decrypted using the local key.

### 7. Git Config

The current `gitConfig()` function in bootstrap_shell.sh runs `git config --global` commands. Most of these settings already exist in `.gitconfig` — the function is redundant. Keep the declarative `.gitconfig` file and drop the function. The only thing that needs a run script is `git maintenance start/register` (already idempotent).

### 8. The `ba()` Update Function

This runtime function in `9-functions.rc` continues to work as-is. Only hardcoded `/Users/samm/` paths need `$HOME` substitution. Add chezmoi convenience aliases:

```zsh
alias dotfiles='chezmoi cd'
alias dotedit='chezmoi edit'
alias dotupdate='chezmoi update'
alias dotdiff='chezmoi diff'
```

### 9. `.chezmoiignore`

Prevents non-dotfile repo files from being applied to home:

```
README.md
LICENSE
.github/
.pre-commit-config.yaml
.eslintrc.js
.prettierrc.js
commitlint.config.js
.editorconfig
.gitignore
Brewfile
```

---

## Migration Steps

### Phase 1: Prepare (on your machine)
1. `brew install chezmoi age`
2. `chezmoi init` — creates `~/.local/share/chezmoi`
3. `chezmoi age keygen -o ~/.config/chezmoi/key.txt`
4. Create `.chezmoi.toml.tmpl` in source dir with age config + data prompts
5. Create the new `sammcj/dotfiles` repo on GitHub

### Phase 2: Move Dotfiles
6. For each managed file, use `chezmoi add`:
   - `chezmoi add ~/.zshrc` → creates `dot_zshrc` in source
   - `chezmoi add ~/.gitconfig` → `dot_gitconfig`
   - `chezmoi add --encrypt ~/.gitconfig.private` → encrypted
   - `chezmoi add ~/.config/bat/config` → `private_dot_config/bat/config`
   - etc. for all files in the `configureDotfiles()` function
7. Create `dot_zsh.d/` and copy all numbered `.rc` files with chezmoi naming
8. `chezmoi add --encrypt` for private.rc files
9. Add `.tmpl` suffix to files needing path updates, convert hardcoded paths

### Phase 3: Brewfile + Run Scripts
10. Run `brew bundle dump --describe --force` on your machine, refine it
11. Create all `run_once_*` / `run_onchange_*` scripts from bootstrap_shell.sh
12. Create `.chezmoiexternal.toml` for zgen, tpm, git-fuzzy
13. Create `.chezmoiignore`

### Phase 4: Test
14. `chezmoi diff` — review what would change
15. `chezmoi apply -v -n` (dry run)
16. `chezmoi apply -v` — apply for real
17. Open new shell, verify prompt, aliases, completions, functions
18. Run `ba` to verify update function works
19. `chezmoi verify` — ensure source matches target

### Phase 5: Finalize
20. Push to `sammcj/dotfiles`
21. Test fresh bootstrap: `chezmoi init --apply sammcj/dotfiles` (on a test account or VM)
22. Update `sammcj/zsh-bootstrap` README to point to the new repo
23. Archive old repo

---

## Verification Checklist

- [ ] `chezmoi init --apply sammcj/dotfiles` succeeds on clean account
- [ ] `chezmoi diff` shows no drift after apply
- [ ] New shell loads: prompt renders, aliases work, completions work
- [ ] `chezmoi cat ~/.gitconfig.private` decrypts correctly
- [ ] `brew bundle check` passes
- [ ] `chezmoi managed` lists all expected files
- [ ] `ba` update function still works
- [ ] `chezmoi data` shows correct hostname/email/is_personal values
- [ ] No references to iCloud/Dropbox path remain in applied files
- [ ] zoxide, fzf, fnm, pyenv all initialize correctly
- [ ] Git prompt (10-prompt.rc async) works

---

## Files Summary

**Source files from `sammcj/zsh-bootstrap` → chezmoi mapping:**

| Current file | Chezmoi source name | Target |
|---|---|---|
| `zshrc` | `dot_zshrc.tmpl` | `~/.zshrc` |
| `zprofile` | `dot_zprofile.tmpl` | `~/.zprofile` |
| `.gitconfig` | `dot_gitconfig` | `~/.gitconfig` |
| `.gitignoreglobal` | `dot_gitignoreglobal` | `~/.gitignoreglobal` |
| `.gitconfig-no_push` | `dot_gitconfig-no_push` | `~/.gitconfig-no_push` |
| `.gitconfig.private` | `encrypted_dot_gitconfig.private.asc` | `~/.gitconfig.private` |
| `.vimrc` | `dot_vimrc` | `~/.vimrc` |
| `tmux.conf` | `dot_tmux.conf` | `~/.tmux.conf` |
| `.dircolors` | `dot_dircolors` | `~/.dircolors` |
| `.cspell.json` | `dot_cspell.json` | `~/.cspell.json` |
| `.cspell-custom-words.txt` | `dot_cspell-custom-words.txt` | `~/.cspell-custom-words.txt` |
| `bat-config` | `private_dot_config/bat/config` | `~/.config/bat/config` |
| `ghostty-config` | `private_dot_config/ghostty/config` | `~/.config/ghostty/config` |
| `htoprc` | `private_dot_config/htop/htoprc` | `~/.config/htop/htoprc` |
| `0-paths.rc` | `dot_zsh.d/0-paths.rc.tmpl` | `~/.zsh.d/0-paths.rc` |
| `1-zgen.rc` | `dot_zsh.d/1-zgen.rc` | `~/.zsh.d/1-zgen.rc` |
| `3-location_specifics.rc` | `dot_zsh.d/3-location_specifics.rc.tmpl` | `~/.zsh.d/3-location_specifics.rc` |
| `4-aliases.rc` | `dot_zsh.d/4-aliases.rc.tmpl` | `~/.zsh.d/4-aliases.rc` |
| `5-exports.rc` | `dot_zsh.d/5-exports.rc.tmpl` | `~/.zsh.d/5-exports.rc` |
| `6-zsh_options.rc` | `dot_zsh.d/6-zsh_options.rc` | `~/.zsh.d/6-zsh_options.rc` |
| `7-history.rc` | `dot_zsh.d/7-history.rc` | `~/.zsh.d/7-history.rc` |
| `9-functions.rc` | `dot_zsh.d/9-functions.rc.tmpl` | `~/.zsh.d/9-functions.rc` |
| `10-prompt.rc` | `dot_zsh.d/10-prompt.rc` | `~/.zsh.d/10-prompt.rc` |
| `14-source-files.rc` | `dot_zsh.d/14-source-files.rc` | `~/.zsh.d/14-source-files.rc` |
| `15-events.rc` | `dot_zsh.d/15-events.rc` | `~/.zsh.d/15-events.rc` |
| `16-ai.rc` | `dot_zsh.d/16-ai.rc.tmpl` | `~/.zsh.d/16-ai.rc` |
| `*private*.rc` | `dot_zsh.d/encrypted_private.rc.asc` | `~/.zsh.d/private.rc` |

**Files to NOT carry over** (replaced by chezmoi mechanisms):
- `bootstrap_shell.sh` → replaced by `run_once_*` scripts
- `.asdfrc` → not needed (no asdf)
- `rsyncd.conf` → only if still used

**New files to create:**
- `.chezmoi.toml.tmpl`
- `.chezmoiignore`
- `.chezmoiexternal.toml`
- `Brewfile`
- 10 run scripts in `run_scripts/`
- `README.md` with setup instructions
