#!/bin/sh

DIR=$(dirname $0)
cd $DIR

source ../utils/file_utils.sh

info "Setting up Homebrew for you..."

if [[ -z $(command -v brew) ]]; then
  # Check if Xcode CLI dependency is installed
  if [[ -z $(command -v xcode-select) ]]; then
    substep_info "Installing XCode Dependency..."
    xcode-select --install
  fi
  substep_info "Installing Homebrew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  # Need to add location for brew installations to PATH variable
  echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bash_profile
  # Install applications in Brewfile
  brew doctor
else
  substep_info "Homebrew is installed here: $(command -v brew)"
  brew update
  brew upgrade
fi

info "Installing Brewfile packages..."
brew bundle

success "Ready to Brew!"
