## Dotfiles
One-stop-shop for my MacOS setup to handle installations and configuration.

#### Project Structure
Everything is tied together with the `run.sh` script. In general, each *topic* that requires setup has it's own directory and set of scripts. These topics, however, depend on the `brew` and `cask` installations.

The core of what makes this system work is the concept of symlinking (think shortcuts) and backing up dotfiles. This means that the user:
1. Does not need to worry about where the project is located on their system - filepaths are relative to the home directory.
2. Can quickly change dotfiles without screwing up the system.

#### Install Packages and Applications
See Brewfile under `./brew` for a list of packages and applications. Note, Brew Cask is unable to handle cases when the app is already installed - it simply throws an error.

#### MacOS System Settings
Taken from a massive bash script - most seemed too niche. Mostly focused on developer friendly Finder settings.

#### Shell Configuration
Sets up files for:
- Bash profile/RC (including customized prompt)
- Aliases
- Environment variables

#### Text Editor Configuration
There is a basic `vimrc` file, including a helper function for Python.

Beyond Vim, there is a dedicated setup topic for Visual Studio Code. It uses:
- Extensions: Listed in a text file and installed by the VS Code CLI.
- Keybindings JSON file.
- Settings JSON file.
