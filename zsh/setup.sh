#!/bin/sh

DIR=$(dirname $0)
cd "$DIR"

source ../utils/file_utils.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"

info "Configuring Zsh..."

# Check Zsh already an authorizes shell
check_zsh=$(cat /etc/shells | grep /bin/zsh)
if [[ -z "$check_zsh" ]]; then
    error "Zsh is not an authorized shell!"
fi

# Make Zsh default shell
substep_info "Making Zsh the Default Shell..."
# chsh -s $(which zsh)
substep_success "Zsh is now the default!"

# Install Oh My Zsh
substep_info "Installing Oh My Zsh Manager..."
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
substep_success "Done installing Oh My Zsh"

substep_info "Enabling Zsh Syntax Highlighting..."
# Enable syntax highlighting
if [[ -d "~/.oh-my-zsh/zsh-syntax-highlighting" ]]; then
    cd ~/.oh-my-zsh && git clone git://github.com/zsh-users/zsh-syntax-highlighting.git
    echo "source ~/.oh-my-zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
    substep_success "Syntax Highlighting Enabled!"
else
    substep_success "Syntax Highlighting Already Enabled!"
fi
cd "$SOURCE"

# Linking Aliases and Exports
safe_append() {
    local zshrc_text=$(cat ~/.zshrc)
    local filename="$1"
    local import_file=$(source ~/$filename)
    local check_rc=$(cat ~/.zshrc | grep "$import_file")

    # If the file is not being imported, append to .zshrc
    if [[ -z "$check_rc" ]]; then
        echo "$import_file" >> ~/.zshrc
        substep_success "Appended $filename to .zshrc file!"
    else
        substep_success "$filename is already imported by .zshrc file."
    fi
}

substep_info "Importing Aliases and Exports"
safe_append ".aliases"
safe_append ".exports"

success "Ready to Zsh!"
