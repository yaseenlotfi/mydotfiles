#!/bin/sh

DIR=$(dirname $0)
cd $DIR

source utils/file_utils.sh

info "I. Am. Root! Prompting for password..."
if sudo -v; then
    # Keep-alive: update existing `sudo` time stamp until `setup.sh` has finished
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    success "Sudo credentials updated."
else
    error "Failed to obtain sudo credentials."
fi

# Set up logging - timestamped text file under ~/.dotfiles_logs/...
logdir="$HOME/.dotfiles_logs"
if [[ ! -d "$logdir" ]]; then
    mkdir "$logdir"
fi
logfp="$logdir/run_$(now).txt"
touch "$logfp"
info "Log output can be found here: $logfp"
info

# Install Homebrew before running anything else!
bash ./brew/setup.sh 2>&1 | tee -a "$logfp"

# Install Git next
bash ./git/setup.sh 2>&1 | tee -a "$logfp"

# Run all setup scripts (except brew)
find . -name "setup.sh" ! -path "*brew*" ! -path "*git*" | while read setup; do
    bash ./"$setup" 2>&1 | tee -a "$logfp"
done

success
success "Fin."
