#!/bin/bash

# Function to display help message
display_help() {
    echo "Usage: $0 <session_name>:<window_serial_num> <command>"
    echo "e.g.: tmux_send.al dst-3:0 'c_save()'"
}

# Check the number of arguments
if [ $# -eq 0 ]; then
    echo "No parameters provided."
    display_help
    exit 1
fi

tmux_session_name="$1"
tmux_command="$2"

tmux send-keys -t $tmux_session_name $tmux_command C-m
