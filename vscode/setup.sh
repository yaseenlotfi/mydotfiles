#!/bin/sh

DIR=$(dirname $0)
cd "$DIR"

source ../utils/file_utils.sh

SOURCE="$(realpath .)"
DESTINATION="$HOME/Library/Application Support/Code/User"

info "Configuring VS Code..."

# Pull VS Code Keybindings and Settings
find . -type f -name "*.json" | while read filename; do
    fn=$(basename $filename)
    substep_success "Dotfile: $fn"
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
    substep_success ""
done

# Install extensions
while read -r line; do
    substep_info "Installing or Updating $line"
    code --install-extension "$line"
done < "$SOURCE/.vscode-extensions.txt"
substep_success "Finished Installing Extensions"

success "Ready to Code!"
