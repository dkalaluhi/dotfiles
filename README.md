# Dotfiles

This repository contains the managed configuration for my Platform Engineering workstation. It is the executable definition of the workstation and is intended to produce a reporducible engineering environment.

## Repository Structure

```text
dotfiles
├── Brewfile
├── CHANGELOG.md
├── ghostty
│   └── config
├── gitconfig
├── README.md
├── scripts
│   └── bootstrap.sh
├── vscode
│   └── settings.json
├── zprofile
├── zsh
│   ├── 00-history.zsh
│   ├── 10-aliases.zsh
│   ├── 20-functions.zsh
│   ├── 30-mise.zsh
│   ├── 40-fzf.zsh
│   ├── 80-prompt.zsh
│   └── 90-experimental.zsh
└── zshrc
```

## Prerequisites

Before restoring these dotfiles, ensure you have:

- A macOS workstation
- Git installed
- Working GitHub SSH authentication
- Access to the private `dkalaluhi/dotfiles` repository

The broader workstation recovery procedure is documented separately in my Commonplace.

---

## Bootstrap Workstation

### 1. Clone the repository

```zsh
mkdir -p ~/Projects
git clone git@github.com:dkalaluhi/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
```
### 2. Run the bootstrap

```zsh
./scripts/bootstrap.sh
```

The bootstrap script will:

- Verify the Xcode Command Line tools are installed.
- Install Homebrew if necessary.
- Install applications and command-line tools from the `Brewfile`.
- Preserve existing unmanaged configuration.
- Create the managed symbolic links.
- Verify the managed configuration.

The script is safe to execute multiple times.

## Verification

Open a new terminal and verify:

- the native two-line prompt appears.
- `reload` completes successfully
- `mkcd` displays its usage message when called without an argument
- `Ctrl-R` opens fuzzy history search.
- Running `false` causes the next prompt to display the failure indicator.

Confirm the managed configuration:

```zsh
type reload
type mkcd
type fzf

ls -ld ~/.config/zsh
readlink ~/.config/zsh

ls -l ~/.config/ghostty/config
readlink ~/.config/ghostty/config
```

Expected results include:

```text
reload is a shell function
mkcd is a shell function
fzf is /opt/homebrew/bin/fzf
```

The symbolic links should resolve to the managed configuration under:

```text
~/Projects/dotfiles
```

---

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

## Design Principles

This repository follows a few simple rules:

- Keep the workstation reproducible.
- Prefer native tooling over large frameworks.
- Install software only when it enables work.
- Track intentional configuration, not machine state.
- Never commit secrets.

---

## Security

see: [SECURITY.md](SECURITY.md)

---

## License

This repository is released under the MIT [License](LICENSE).

The configuration is intended to serve as a reference implementation for a reproducible engineering workstation. Feel free to adapt it to your own environment.
