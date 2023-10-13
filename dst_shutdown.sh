#!/bin/bash
# Default values
param_cluster_serial="1"
param_tmux_session_name="dst-1"

# Function to display help message
display_help() {
    echo "Usage: ./dst_shutdown.sh [OPTIONS]"
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
echo "--------------------------------------------------------------------------------------"
echo tmux session name: ${param_tmux_session_name}
echo cluster serial number: ${param_cluster_serial}
echo "--------------------------------------------------------------------------------------"

# shutdown server in tmux
tmux send-keys -t ${param_tmux_session_name}:1 "c_save()" C-m
tmux send-keys -t ${param_tmux_session_name}:1 "c_shutdown()" C-m
echo Closing Caves...
tmux send-keys -t ${param_tmux_session_name}:0 "c_save()" C-m
tmux send-keys -t ${param_tmux_session_name}:0 "c_shutdown()" C-m
echo Closing Master...
sleep 10
tmux kill-window -t ${param_tmux_session_name}:1
echo Caves windows closed.
tmux kill-window -t ${param_tmux_session_name}:0
echo Master windows closed.
echo "--------------------------------------------------------------------------------------"
echo Session ${param_tmux_session_name} killed.


exit 0