#!/bin/bash
# Default values
g_dst_save_path=$HOME/.klei/DoNotStarveTogether
# SERVER_PATH="./dontstarve_dedicated_server_nullrenderer"  # Replace with the actual path to your DST server executable
# SERVER_ARGS=" -console -cluster Cluster_$1 -shard Master"                     # Replace with any additional arguments or options for your server
# g_date=$(date +%Y_%-m_%-d_%-H_%-M)
# old_log_path=${g_dst_save_path}/Cluster_${param_cluster_serial}/${param_cluster_type}/server_log.txt
# new_log_path=~/.klei/DoNotStarveTogether/Cluster_$1/Master/server_log_$g_date.txt
# old_chat_log_path=~/.klei/DoNotStarveTogether/Cluster_$1/Master/server_chat_log.txt
# new_chat_log_path=~/.klei/DoNotStarveTogether/Cluster_$1/Master/server_chat_log_$g_date.txt
param_cluster_serial="1"
param_cluster_type="Master"
param_cluster_auto_restart=true
# Get the directory path of the script
m_script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Function to display help message
display_help() {
    echo "Usage: ./dst_start_cluster.sh [OPTIONS]"
    echo "Options:"
    echo "  -C <cluster_serial_number>  Specify XX of folder 'Cluster_XX'"
    echo "  -m                          Start Cluster Master"
    echo "  -c                          Start Cluster Caves"
    echo "  -n --no_auto_restart        Do not auto restart server when crashed or stopped"
    echo "  -h --help                   Show this help message."
}

server_run() {
    echo "-----------------------------------------------------------------------------------"
    echo "Starting DST server..."
    echo "Backup----------------------------------------------------------------------------"
    # backup
    if [ "$param_cluster_type" = "Master" ]; then
        if [ -f "${m_script_dir}/dst_backup_cluster.sh" ]; then
            ${m_script_dir}/dst_backup_cluster.sh -C $param_cluster_serial
        else
            echo "File ${m_script_dir}/dst_backup_cluster.sh does not exist."
        fi
        cp ${g_dst_save_path}/Cluster_${param_cluster_serial}/${param_cluster_type}/server_chat_log.txt ${g_dst_save_path}/Cluster_${param_cluster_serial}_$(date +%Y-%-m-%-d-%-H-%-M-%-S)_server_chat_log.txt
    fi

    echo "----------------------------------------------------------------------------------"
    # server start
    echo "ServerStart-----------------------------------------------------------------------"
    cd $HOME/steamapps/DST/bin
    ./dontstarve_dedicated_server_nullrenderer -console -cluster Cluster_${param_cluster_serial} -shard ${param_cluster_type}
    
    echo "----------------------------------------------------------------------------------"

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
            # echo "Performing action for -C parameter."
            # Add your desired action for -C parameter here
            ;;
        -c)
            param_cluster_type="Caves"
            ;;
        -m)
            param_cluster_type="Master"
            ;;
        -n | --no_auto_restart)
            param_cluster_auto_restart=false
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
if [ "$param_cluster_auto_restart" ]; then
    while true; do
        server_run
        # server down
        echo "----------------------------------------------------------------------------------"
        echo "Server crashed or stopped. Restart in 10 seconds..."
        ${m_script_dir}/dst_update.sh
        sleep 10  # Wait for 5 seconds before restarting
    done

else
    server_run

fi

exit 0