# Dotfiles

This repository contains the managed configuration for my Zsh environment and the Homebrew bundle supporting it.

## Repository Structure

```text
dotfiles/
├── Brewfile
├── CHANGELOG.md
├── README.md
├── zprofile
├── zshrc
└── zsh/
    ├── 00-history.zsh
    ├── 10-aliases.zsh
    ├── 20-functions.zsh
    ├── 40-fzf.zsh
    ├── 80-prompt.zsh
    └── 90-experimental.zsh
```

## Prerequisites

Before restoring these dotfiles, the workstation must have:

- Git
- Homebrew
- Working GitHub SSH authentication
- Access to the private `dkalaluhi/dotfiles` repository

The broader workstation recovery procedure is documented separately.

## Restore the Dotfiles

### 1. Clone the repository

```zsh
mkdir -p ~/Projects
git clone git@github.com:dkalaluhi/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
```

### 2. Install repository dependencies

Install the applications and command-line tools defined in the Brewfile:

```zsh
brew bundle --file ~/Projects/dotfiles/Brewfile
```

### 3. Preserve existing Zsh configuration

Create timestamped backups of any existing configuration:

```zsh
backup_date=$(date +%Y%m%d-%H%M%S)

[[ -e ~/.config/zsh || -L ~/.config/zsh ]] &&
    mv ~/.config/zsh ~/.config/zsh.backup-"$backup_date"

[[ -e ~/.zshrc || -L ~/.zshrc ]] &&
    mv ~/.zshrc ~/.zshrc.backup-"$backup_date"

[[ -e ~/.zprofile || -L ~/.zprofile ]] &&
    mv ~/.zprofile ~/.zprofile.backup-"$backup_date"
```

Keep these backups until the managed configuration has been tested successfully.

### 4. Link the managed configuration

```zsh
mkdir -p ~/.config

ln -s ~/Projects/dotfiles/zsh ~/.config/zsh
ln -s ~/Projects/dotfiles/zshrc ~/.zshrc
ln -s ~/Projects/dotfiles/zprofile ~/.zprofile
```

### 5. Verify the links

```zsh
ls -ld ~/.config/zsh ~/.zshrc ~/.zprofile

readlink ~/.config/zsh
readlink ~/.zshrc
readlink ~/.zprofile
```

The links should resolve to files and directories under:

```text
/Users/dave.kalaluhi/Projects/dotfiles
```

### 6. Verify Zsh

Start a clean login shell and confirm that the managed functions and dependencies load:

```zsh
zsh -lic 'type mkcd; type reload; type fzf'
```

Expected results include:

```text
mkcd is a shell function
reload is a shell function
fzf is /opt/homebrew/bin/fzf
```

Open a new terminal and verify:

- The native two-line prompt appears.
- `reload` completes successfully.
- `mkcd` displays its usage message when called without an argument.
- Running `false` causes the next prompt to display its failure indicator.
- `Ctrl-R` opens fuzzy history search.

## Making Changes

Review configuration changes before committing them:

```zsh
cd ~/Projects/dotfiles
git status
git diff
```

Commit and publish intentional changes:

```zsh
git add .
git commit -m "Describe the change"
git push
```

## VS Code

VS Code user settings are stored in:

```text
vscode/settings.json
Link them on macOS with:
ln -sfn \
  "$HOME/Projects/dotfiles/vscode/settings.json" \
  "$HOME/Library/Application Support/Code/User/settings.json"
VS Code extensions are managed through the vscode entries in the Brewfile.

Never store credentials, private keys, tokens, or other secrets in this repository.