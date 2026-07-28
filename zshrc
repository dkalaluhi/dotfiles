# Homebrew environment
eval "$(/opt/homebrew/bin/brew shellenv)"

# Load modular zsh configuration
for file in ~/.config/zsh/*.zsh; do
    [[ -r "$file" ]] && source "$file"
done
