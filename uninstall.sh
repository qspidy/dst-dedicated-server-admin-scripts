#!/bin/bash


# Get the directory path of the script
m_script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# revoke exec rights
chmod -x ${m_script_dir}/*.sh
chmod -x ${m_script_dir}/albin/*
echo Exection rights revoked.

# Directory to be removed from PATH
# albin_directory=${m_script_dir}/albin

# Get the user's default shell
default_shell=$(basename "$SHELL")

# Function to remove directory from Bash PATH
remove_from_bash() {
  sed -i -e "s#export PATH=.*$1##g" ~/.bashrc
}

# Function to remove directory from Zsh PATH
remove_from_zsh() {
  sed -i -e "s#export PATH=.*$1##g" ~/.zshrc
}

# Function to remove directory from Fish PATH
remove_from_fish() {
  echo removing .. from fish
  # sed -i -e "s#set PATH.*$1##g" ~/.config/fish/config.fish
  # sed -i "/set PATH \"$albin_directory\":\\\$PATH/d" ~/.config/fish/config.fish
  # sed -i '\|set PATH "'"$albin_directory"':\$PATH"|d' ~/.config/fish/config.fish
  sed -i '/set PATH ".*\/albin":\$PATH/d' ~/.config/fish/config.fish
  sed -i '/complete -c al_dstserver/d' ~/.config/fish/config.fish
}

# Check the default shell and remove the directory from the appropriate shell configuration file
case $default_shell in
  bash)
    # remove_from_bash 
    echo "Directory removed from PATH for Bash."
    ;;
  zsh)
    #remove_from_zsh
    echo "Directory removed from PATH for Zsh."
    ;;
  fish)
    # remove_from_fish "$albin_directory"
    remove_from_fish 
    echo "Directory removed from PATH for Fish."
    ;;
  *)
    echo "Unsupported shell: $default_shell. Please manually remove the directory from the appropriate shell configuration file."
    ;;
esac