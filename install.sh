#!/bin/bash

# Get the directory path of the script
m_script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
m_complete_sub_prefix="complete -c al_dstserver -n '__fish_seen_subcommand_from al_dstserver send_preset' -f"

# uninstall old version
chmod +x ${m_script_dir}/uninstall.sh
if [ ! -f "${m_script_dir}/uninstall.sh" ]; then
  echo "${m_script_dir}/uninstall.sh not found, please check."
  exit 1
fi
${m_script_dir}/uninstall.sh

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

      echo "complete -c al_dstserver -f -a 'start shutdown info update upgrade backup status list send send_preset' -x" >> ~/.config/fish/config.fish
      # echo "complete -c al_dstserver -n '__fish_seen_subcommand_from al_dstserver_send_preset' -a 'save kick ban'" >> ~/.config/fish/config.fish
      echo "$m_complete_sub_prefix -a 'save' -d 'save'" >> ~/.config/fish/config.fish
      echo "$m_complete_sub_prefix -a 'shutdown' -d 'shutdown'" >> ~/.config/fish/config.fish
      echo "$m_complete_sub_prefix -a 'regenerateworld' -d 'regenerateworld'" >> ~/.config/fish/config.fish
      echo "$m_complete_sub_prefix -a 'listallplayers' -d 'listallplayers'" >> ~/.config/fish/config.fish
      echo "$m_complete_sub_prefix -a 'present_info' -d 'present_info'" >> ~/.config/fish/config.fish
      echo "$m_complete_sub_prefix -a 'kick' -d 'kick <username>|<userid>'" >> ~/.config/fish/config.fish
      echo "$m_complete_sub_prefix -a 'ban' -d 'ban <username>|<userid>'" >> ~/.config/fish/config.fish
      echo "$m_complete_sub_prefix -a 'announce' -d 'announce \"anything to say\"'" >> ~/.config/fish/config.fish
      echo "completion added"
      ;;
    *)
      echo "Unsupported shell: $albin_directory. Please manually add the directory to the appropriate shell configuration file."
      ;;
  esac
else
  echo "albin directory does not exist."
fi
