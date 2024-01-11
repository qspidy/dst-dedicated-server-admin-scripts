#!/bin/bash
# Default values
g_dst_save_path=$HOME/.klei/DoNotStarveTogether
param_cluster_serial="0"

# Get the directory path of the script
m_script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Function to display help message
display_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -h --help                   Show this help message."
}

display_basic_info() {
    echo --------------------------------------
    echo Cluster_$1:
    cat ${g_dst_save_path}/Cluster_$1/cluster.ini | grep -E "cluster_name|cluster_description"
}

# Parse the parameters
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
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
for param_cluster_serial in $(ls -d ${g_dst_save_path}/*/ | grep -oE "/Cluster_[1-9]+/"|cut -d'_' -f2|grep -oE "[1-9]*"); do
    display_basic_info $param_cluster_serial
done


exit 0