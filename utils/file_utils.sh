#!/bin/sh

#############################
### Pretty Echo functions ###
#############################
# Courtesy of https://github.com/rkalis/dotfiles
coloredEcho() {
    local exp="$1";
    local color="$2";
    local arrow="$3";
    if ! [[ $color =~ '^[0-9]$' ]] ; then
       case $(echo $color | tr '[:upper:]' '[:lower:]') in
        black) color=0 ;;
        red) color=1 ;;
        green) color=2 ;;
        yellow) color=3 ;;
        blue) color=4 ;;
        magenta) color=5 ;;
        cyan) color=6 ;;
        white|*) color=7 ;; # white or invalid color
       esac
    fi
    tput bold;
    tput setaf "$color";
    echo "$arrow $exp";
    tput sgr0;
}

info() {
    coloredEcho "$1" blue "========>"
}

success() {
    coloredEcho "$1" green "========>"
}

error() {
    coloredEcho "$1" red "========>"
}

substep_info() {
    coloredEcho "$1" magenta "===="
}

substep_success() {
    coloredEcho "$1" cyan "===="
}

substep_error() {
    coloredEcho "$1" red "===="
}

##############################
### File Utility functions ###
##############################
realpath() { # Not all systems give a "realpath" builtin function
    echo "$(cd "$(dirname "$1")"; pwd -P)/$(basename "$1")"
}

now() { # Fetch the current timestamp. Formatted.
    echo "$(date "+%Y%m%d_%H%M%S")"
}

backup() { # Backup given filepath in a specific directory
    # Only accept one argument: filepath
    if [[ "$#" -gt 1 || "$#" -lt 1 ]]; then
        error "Expecting only one argument!"
        return 1
    else
        local src_fp="$1"
    fi

    local src_fn=$(basename "$1")
    local bkproot="$HOME/.dotfiles_bkps"
    local bkpdir="$bkproot/${src_fn}_bkps"
    local bkp_fp="$bkpdir/${src_fn}.$(now)"

    # Check if backup directory exists as ~/.old_dotefiles/.dotfile_type
    if [[ ! -d "$bkpdir" ]]; then
        if [[ ! -d "$bkproot" ]]; then
            mkdir "$bkproot"
        fi
        mkdir "$bkpdir"
        substep_info "Backup directory created at $bkpdir"
    else
        substep_info "Backup directory exists:  $bkpdir"
    fi

    # Move target file to backup directory
    if [[ -e "$src_fp" ]]; then
        mv "$src_fp" "$bkp_fp"
        substep_info "Archived: $src_fn to $bkp_fp"
    else
        error "Can't find source file for backup!"
        return 1
    fi
}

symlink() {
    # Expect two args: SOURCE filepath and DESTINATION filepath
    local SRC="$1"
    local DST="$2"

    substep_info "Source: $SRC"

    # Check if file or symlink exists, move it to a backup dir
    if [ -e "$DST" ] || [ -h "$DST" ]; then
        backup "$DST"
    fi

    # Create symlink
    if ln -s "$SRC" "$DST"; then
        substep_success "Symlink: $DST to $SRC."
    else
        substep_error "Symlinking $DST to $SRC failed!"
    fi
}
