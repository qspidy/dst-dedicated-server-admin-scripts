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
    echo "  -C <cluster_serial_number>  Specify XX of folder 'Cluster_XX'"
    echo "  -h --help                   Show this help message."
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
            if [[ "$1" == "0" ]]; then
                echo "Please set cluster serial number."
                exit 1
            fi
            param_cluster_serial="$1"
            # echo "Performing action for -C parameter."
            # Add your desired action for -C parameter here
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
# cat custer.ini
cat ${g_dst_save_path}/Cluster_${param_cluster_serial}/cluster.ini

exit 0