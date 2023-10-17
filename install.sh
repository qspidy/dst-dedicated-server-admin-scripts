#!/bin/bash

# Get the directory path of the script
m_script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# grant exec rights
chmod +x ${m_script_dir}/*.sh
chmod +x ${m_script_dir}/albin/*

# add albin to PATH
albin_directory=${m_script_dir}/albin

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
      echo "set PATH \"$albin_directory\":\$PATH" >> ~/.config/fish/config.fish
      echo "albin directory added to PATH for Fish."
      # and auto completion
      # complete -c al_dstserver -d "discription like 'start server'" -f -a 'start' -x

      echo "complete -c al_dstserver -f -a 'start shutdown info update upgrate backup status list' -x" >> ~/.config/fish/config.fish
      echo "completion added"
      ;;
    *)
      echo "Unsupported shell: $albin_directory. Please manually add the directory to the appropriate shell configuration file."
      ;;
  esac
else
  echo "albin directory does not exist."
fi
