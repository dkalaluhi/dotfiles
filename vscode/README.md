# VSCode

VSCode user settings are stored in:

```text
vscode/settings.json
Link them on macOS with:
ln -sfn \
  "$HOME/Projects/dotfiles/vscode/settings.json" \
  "$HOME/Library/Application Support/Code/User/settings.json"
VS Code extensions are managed through the vscode entries in the Brewfile.

Never store credentials, private keys, tokens, or other secrets in this repository.
