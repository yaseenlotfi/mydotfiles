#!/bin/sh

DIR=$(dirname $0)
cd "$DIR"

# source ../utils/pretty_echo.sh
source ../utils/file_utils.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"

info "Configuring vim..."

find . -type f -name ".vim*" | while read filename; do
    fn=$(basename $filename)
    substep_success "Dotfile: $fn"
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
    substep_success ""
done

success "Ready to vim!"
success
