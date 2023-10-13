#!/bin/bash

tmux_session_name="$1"
tmux_command="$2"

tmux send-keys -t $tmux_session_name $tmux_command C-m
