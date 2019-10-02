#! /bin/sh

# Note, MacOS Mojave came installed with Python 2.7
# Homebrew handles this and will install the Python 3.x formulae
# The user will need to specify python3 and pip3 if they wish
# to use Python 3.x (unless otherwise aliased)

DIR=$(dirname $0)
cd $DIR

source ../utils/file_utils.sh

info "Configuring Python..."

# Install global Python packages
# Use virtualenv for project-level dependencies
pip3 install -U -r ./requirements.txt

success "Ready to Slither!"
