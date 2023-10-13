#!/bin/bash

# revoke exec rights
chmod -x dst_*
chmod -x albin/*

# Directory to be removed from PATH
albin_directory=$(pwd)/albin

# Get the user's default shell
default_shell=$(basename "$SHELL")

# Function to remove directory from Bash PATH
remove_from_bash() {
  sed -i "/export PATH=.*$1:/d" ~/.bashrc
}

# Function to remove directory from Zsh PATH
remove_from_zsh() {
  sed -i "/export PATH=.*$1:/d" ~/.zshrc
}

# Function to remove directory from Fish PATH
remove_from_fish() {
  sed -i "/set PATH.*$1/d" ~/.config/fish/config.fish
}

# Check the default shell and remove the directory from the appropriate shell configuration file
case $default_shell in
  bash)
    remove_from_bash "$albin_directory"
    echo "Directory removed from PATH for Bash."
    ;;
  zsh)
    remove_from_zsh "$albin_directory"
    echo "Directory removed from PATH for Zsh."
    ;;
  fish)
    remove_from_fish "$albin_directory"
    echo "Directory removed from PATH for Fish."
    ;;
  *)
    echo "Unsupported shell: $default_shell. Please manually remove the directory from the appropriate shell configuration file."
    ;;
}