#!/bin/bash
# Default values
g_dst_save_path=$HOME/.klei/DoNotStarveTogether
param_cluster_serial="0"
param_tmux_session_name="dst-0"
m_send_command=""

# Get the directory path of the script
m_script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Function to display help message
display_help() {
    echo "Usage: $0 [OPTIONS] <command>"
    echo "Options:"
    echo "  -C <cluster_serial_number>  Specify XX of folder 'Cluster_XX'"
    echo "  -s <session_name>           New tmux session name"
    echo "  -h --help                   Show this help message."
}

# Parse command line options and arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      # Display help message
      display_help
      exit;;
    -C)
      # cluster_serial_number
      shift
      param_cluster_serial=$1
      param_tmux_session_name="dst-${1}"
      if [[ ! $param_cluster_serial =~ ^[0-9]+$ ]]; then
        echo "Paramater of "-C" should number, please check."
        exit 1
      fi
      if (( ! $param_cluster_serial>=1 && $param_cluster_serial<100 )); then
        echo "Maybe the cluster serial num range 1~100, please check."
        exit 1
      fi
      ;;
    -s)
      # session_name
      shift
      param_tmux_session_name=$1
      ;;
    *)
      # Capture the command and argument
      m_command=$1
      break;;
  esac
  shift
done

# echo command: $m_command
# echo argu: $m_argument
# Check if command argument is provided
if [ -z "$m_command" ]; then
  echo "Error: Command argument is required."
  display_help
  exit 1
fi

# Check if albin/tmux_send.al exist.
if [ ! -f "${m_script_dir}/albin/tmux_send.al" ]; then
        echo "${m_script_dir}/albin/tmux_send.al not found, please check."
        exit 1
fi

# Perform actions based on the specified command

# Perform actions based on the options
${m_script_dir}/albin/tmux_send.al ${param_tmux_session_name}:0 "$m_command"

# Additional code or actions can be added here

exit 0