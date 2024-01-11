#!/bin/bash
# Default values
g_dst_save_path=~/.klei/DoNotStarveTogether
param_cluster_serial="1"

# Function to display help message
display_help() {
    echo "Usage: ./dst_backup_cluster.sh [OPTIONS]"
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
echo "--------------------------------------------------------------------------------------"
echo cluster serial number: ${param_cluster_serial}
echo "--------------------------------------------------------------------------------------"
tar czvf ${g_dst_save_path}/Cluster_${param_cluster_serial}_$(date +%Y-%-m-%-d-%-H-%-M-%-S).tar.gz ${g_dst_save_path}/Cluster_${param_cluster_serial}
echo "--------------------------------------------------------------------------------------"
echo "Done."

exit 0
