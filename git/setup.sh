#!/bin/sh

DIR=$(dirname $0)
cd "$DIR"

source ../utils/file_utils.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"

info "Configuring git..."

find . -type f -name ".git*" | while read filename; do
    fn=$(basename $filename)
    substep_success "Dotfile: $fn"
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
    substep_success ""
done

read -p "Git Username (Enter to skip): " username
read -p "Git Email (Enter to skip): " useremail
exclude="$HOME/.gitignore_global"

git config --global user.name $username
git config --global user.email $useremail
git config --global core.excludesfiles $exclude

substep_success "Git Username: $(git config user.name)"
substep_success "Git Email: $(git config user.email)"

success "Ready to Git!"
success
