#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="${HOME}/Projects/dotfiles"
BACKUP_DIR="${HOME}/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

info() {
    printf "ℹ️  %s\n" "$1"
}

success() {
    printf "✅ %s\n" "$1"
}

warn() {
    printf "⚠️  %s\n" "$1"
}

fail() {
    printf "❌ %s\n" "$1"
    exit 1
}

backup_target() {
    local target="$1"

    mkdir -p "$BACKUP_DIR"

    local relative="${target#$HOME/}"
    local destination="${BACKUP_DIR}/${relative}"

    mkdir -p "$(dirname "$destination")"
    mv "$target" "$destination"

    warn "Existing ${target} moved to ${destination}"
}

link_item() {
    local source="$1"
    local target="$2"

    mkdir -p "$(dirname "target")"

    if [[ -L "$target" ]]; then
        local current
        current="$(readlink "$target")"

        if [[ "$current" == "$source" ]]; then
            success "${target} already linked"
            return
        fi

        warn "${target} points somewhere else"
        rm "$target"

    elif [[ -e "$target" ]]; then
        backup_target "$target"
    fi

    ln -s "$source" "$target"
    success "Linked ${target} → ${source}"
}

printf "\n🚀 Bootstrapping workstation...\n\n"

#
# Xcode Command Line Tools
#

if xcode-select -p >/dev/null 2>&1; then
    success "Xcode Command Line Tools installed"
else
    info "Installing Xcode Command Line Tools..."
    xcode-select --install

    printf "\n"
    warn "Complete the Xcode Command Line Tools installation, then run this script again"
    exit 0
fi

#
# Homebrew
#

if command -v brew >/dev/null 2>&1; then
    success "Homebrew installed"
else
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

#
# Make Homebrew available in this shell
#

if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
else
    fail "Homebrew installed but brew executable could not be located"
fi

#
# Verify dotfiles repository
#

if [[ ! -d $DOTFILES_DIR ]]; then
    fail "Dotfiles repository not found at ${DOTFILES_DIR}"
fi

if [[ ! -f "${DOTFILES_DIR}/Brewfile" ]]; then
    fail "Brewfile not found"
fi

success "Dotfiles repository found"

#
# Homebrew Packages
#

info "Installing packages from Brewfile..."

brew bundle --file="${DOTFILES_DIR}/Brewfile"

success "Homebrew bundle commplete"

#
# Symlinks
#

info "Creating configuration links..."

link_item \
    "${DOTFILES_DIR}/zsh" \
    "${HOME}/.config/zsh"

link_item \
    "${DOTFILES_DIR}/ghostty/config" \
    "${HOME}/.config/ghostty/config"

#
# Verification
#

printf "\n📦 Managed configuration\n\n"

ls -ld "${HOME}/.config/zsh"
ls -l "${HOME}/.config/ghostty/config"

printf "\n✅ Workstation bootstrap complete.\n"
printf "\nOpen a new shell to begin using the workstation configuration.\n\n"
