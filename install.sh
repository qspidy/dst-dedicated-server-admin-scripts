#!/bin/bash

# grant exec rights
chmod +x dst_*
chmod +x albin/*

# add albin to PATH
albin_directory=$(pwd)/albin

# Check if the directory exists
if [ -d "$albin_directory" ]; then
  # Get the user's default shell
  default_shell=$(basename "$SHELL")

  # Add the directory to the appropriate shell configuration file
  case $default_shell in
    bash)
      echo "export PATH=\"$albin_directory:\$PATH\"" >> ~/.bashrc
      echo "albin directory added to PATH for Bash."
      ;;
    zsh)
      echo "export PATH=\"$albin_directory:\$PATH\"" >> ~/.zshrc
      echo "albin directory added to PATH for Zsh."
      ;;
    fish)
      echo "set PATH \"$albin_directory\" \$PATH" >> ~/.config/fish/config.fish
      echo "albin directory added to PATH for Fish."
      ;;
    *)
      echo "Unsupported shell: $albin_directory. Please manually add the directory to the appropriate shell configuration file."
      ;;
  esac
else
  echo "albin directory does not exist."
fi
