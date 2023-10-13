#!/bin/bash
# Default values
param_cluster_serial="1"
param_tmux_session_name="dst-1"

# Function to display help message
display_help() {
    echo "Usage: ./dst_start.sh [OPTIONS]"
    echo "Options:"
    echo "  -C <cluster_serial_number>  Specify XX of folder 'Cluster_XX'"
    echo "  -s                          New tmux session name"
    echo "  -h | --help                 Show this help message."
}

# Check the number of arguments
if [ $# -eq 0 ]; then
    echo "No parameters provided."
    display_help
    exit 1
fi

# Parse the parameters
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -C)
            shift
            # param_C_value="$1"
            param_cluster_serial="$1"
            param_tmux_session_name="dst-${1}"
            # echo "Performing action for -C parameter."
            # Add your desired action for -C parameter here
            ;;
        -s)
            shift
            param_tmux_session_name="$1"
            ;;
        -h | --help)
            display_help
            exit 0
            ;;
        *)
            echo "Unknown parameter: $key"
            display_help
            exit 1
            ;;
    esac

    shift
done

# Perform actions based on the options

# Additional code or actions can be added here
# check if cluster_token.txt exist
echo "--------------------------------------------------------------------------------------"
echo "If Cluster is NEWLY UPLOADED, make sure you CHECKED cluster.ini and server.ini files manually."
echo "--------------------------------------------------------------------------------------"
echo Checking cluster_token.txt...
if [ -nf "$HOME/.klei/DoNotStarveTogether/Cluster_${param_cluster_serial}/cluster_token.txt" ]; then
    echo File "$HOME/.klei/DoNotStarveTogether/Cluster_${param_cluster_serial}/cluster_token.txt" does not exist
    if [ -nf "$HOME/.klei/DoNotStarveTogether/cluster_token.txt" ]; then
        echo There is no cluster_token.txt on server. Please generate one on local and upload then try again.
        exit 1
    else
        echo File "$HOME/.klei/DoNotStarveTogether/cluster_token.txt" exist
        echo Copying to "Cluster_${param_cluster_serial}"
        cp $HOME/.klei/DoNotStarveTogether/cluster_token.txt $HOME/.klei/DoNotStarveTogether/Cluster_${param_cluster_serial}/cluster_token.txt
        echo Done.
    fi
else
    echo "$HOME/.klei/DoNotStarveTogether/Cluster_${param_cluster_serial}/cluster_token.txt" exist.
fi

echo "SessionInfo---------------------------------------------------------------------------"
echo tmux session name: ${param_tmux_session_name}
echo cluster serial number: ${param_cluster_serial}
echo "--------------------------------------------------------------------------------------"
# update modlist and mods
$HOME/dst_update_modlist.sh ${param_cluster_serial}
$HOME/dst_update.sh

# start server in tmux
tmux new-session -s ${param_tmux_session_name} -d
tmux send-keys -t ${param_tmux_session_name}:0 "tmux set mouse on" C-m
tmux send-keys -t ${param_tmux_session_name}:0 "$HOME/dst_start_cluster.sh -C ${param_cluster_serial} -m" C-m
tmux new-window -t ${param_tmux_session_name}
tmux send-keys -t ${param_tmux_session_name}:1 "$HOME/dst_start_cluster.sh -C ${param_cluster_serial} -c" C-m
echo "--------------------------------------------------------------------------------------"
echo run "\"tmux attach -t $param_tmux_session_name\"" to interact with dst server.


exit 0