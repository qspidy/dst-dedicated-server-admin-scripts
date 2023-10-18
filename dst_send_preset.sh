#!/bin/bash
# Default values
g_dst_save_path=$HOME/.klei/DoNotStarveTogether
param_cluster_serial="0"
param_tmux_session_name="dst-0"
m_send_command=""
m_send_argument=""
m_userid=""

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
      m_argument=$2
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

# Check if dst_send.sh exist.
if [ ! -f "${m_script_dir}/dst_send.sh" ]; then
        echo "${m_script_dir}/dst_send.sh not found, please check."
        exit 1
fi

# Perform actions based on the specified command
case $m_command in
  save)
    echo sending "c_save()"
    echo -------------------------------------
    ${m_script_dir}/dst_send.sh -s $param_tmux_session_name "c_save()"
    echo -------------------------------------
    echo Done.
    ;;
  shutdown)
    echo sending "c_shutdown()"
    echo -------------------------------------
    ${m_script_dir}/dst_send.sh -s $param_tmux_session_name "c_shutdown()"
    echo -------------------------------------
    echo Done.
    ;;
  kill)
    m_userid=$( ${m_script_dir}/dst_send.sh -s $param_tmux_session_name "c_listallplayers()" \
    && tail ${g_dst_save_path}/Cluster_${param_cluster_serial}/Master/server_log.txt -n 30 \
    | grep -E "\[[0-9]{1}]" | grep $m_argument | grep -oE "KU_[a-zA-Z0-9]+" | uniq )
    echo sending "TheNet:Kick($m_userid)"
    echo -------------------------------------
    ${m_script_dir}/dst_send.sh -s $param_tmux_session_name "TheNet:Kick($m_userid)"
    echo -------------------------------------
    echo Done.
    ;;
  ban)
    m_userid=$( ${m_script_dir}/dst_send.sh -s $param_tmux_session_name "c_listallplayers()" \
    && tail ${g_dst_save_path}/Cluster_${param_cluster_serial}/Master/server_log.txt -n 30 \
    | grep -E "\[[0-9]{1}]" | grep $m_argument | grep -oE "KU_[a-zA-Z0-9]+" | uniq )
    echo sending "TheNet:Ban($m_userid)"
    echo -------------------------------------
    ${m_script_dir}/dst_send.sh -s $param_tmux_session_name "TheNet:Ban($m_userid)"
    echo -------------------------------------
    echo Done.
    ;;
  regenerateworld)
    echo sending "c_regenerateworld()"
    echo -------------------------------------
    ${m_script_dir}/dst_send.sh -s $param_tmux_session_name "c_regenerateworld()"
    echo -------------------------------------
    echo Done.
    ;;
  announce)
    echo sending "c_announce('$m_argument')"
    echo -------------------------------------
    ${m_script_dir}/dst_send.sh -s $param_tmux_session_name "c_announce('$m_argument')"
    echo -------------------------------------
    echo Done.
    ;;
  listallplayers)
    echo sending "c_listallplayers()"
    echo -------------------------------------
    ${m_script_dir}/dst_send.sh -s $param_tmux_session_name "c_listallplayers()" \
    && tail ${g_dst_save_path}/Cluster_${param_cluster_serial}/Master/server_log.txt -n 30 \
    | grep -oE "\[[0-9]{1}].*" | uniq
    echo -------------------------------------
    echo Done.
    ;;
  present_info)
    echo running present_info
    echo -------------------------------------
    ${m_script_dir}/dst_send.sh -s $param_tmux_session_name 'print("Game Mode: " .. TheNet:GetServerGameMode())' 
    ${m_script_dir}/dst_send.sh -s $param_tmux_session_name 'print("World Seed: " .. TheWorld.meta.seed)' 
    ${m_script_dir}/dst_send.sh -s $param_tmux_session_name 'print("Day/Night Status: " .. (TheWorld.state.isday and "Day" or "Night"))' 
    ${m_script_dir}/dst_send.sh -s $param_tmux_session_name 'print("Moon Cycle: " .. TheWorld.state.moonphase)' 
    ${m_script_dir}/dst_send.sh -s $param_tmux_session_name 'print("Current Weather: " .. (TheWorld.state.israining and "Rainy" or "Clear"))' 
    ${m_script_dir}/dst_send.sh -s $param_tmux_session_name 'print("Server Status: " .. TheWorld.state.season .. ", Day " .. TheWorld.state.cycles)' 
    ${m_script_dir}/dst_send.sh -s $param_tmux_session_name 'print("Time of Day: " .. TheWorld.state.time)' 
    ${m_script_dir}/dst_send.sh -s $param_tmux_session_name 'print("Current Temperature: " .. TheWorld.state.temperature .. " degrees")' 
    tail ${g_dst_save_path}/Cluster_${param_cluster_serial}/Master/server_log.txt -n 50 \
    | grep -E "^\[.+]" \
    | grep -E "Game Mode|World Seed|Time of Day|Day/Night Staus|Moon Cycle|Current Weather|Current Temperature|Server Status" \
    | grep -v "RemoteCommandInput" \
    | sed 's/\[[0-9][0-9]:[0-9][0-9]:[0-9][0-9]\]: //g' \
    | sort | uniq
    echo -------------------------------------
    echo Done.
    ;;
  *)
    echo "Error: Unknown command '$m_command'."
    exit 1;;
esac

# Perform actions based on the options

# Additional code or actions can be added here
# ${m_script_dir}/dst_send.sh -s $param_tmux_session_name $m_send_command $argument


exit 0