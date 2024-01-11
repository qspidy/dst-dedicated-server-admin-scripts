#!/bin/bash

SERVER_PATH="./dontstarve_dedicated_server_nullrenderer"  # Replace with the actual path to your DST server executable
SERVER_ARGS=" -console -cluster Cluster_$1 -shard Caves"                     # Replace with any additional arguments or options for your server
g_date=$(date +%Y_%-m_%-d_%-H_%-M)
old_log_path=~/.klei/DoNotStarveTogether/Cluster_$1/Caves/server_log.txt
new_log_path=~/.klei/DoNotStarveTogether/Cluster_$1/Caves/server_log_$g_date.txt
old_chat_log_path=~/.klei/DoNotStarveTogether/Cluster_$1/Caves/server_chat_log.txt
new_chat_log_path=~/.klei/DoNotStarveTogether/Cluster_$1/Caves/server_chat_log_$g_date.txt

while true; do
  echo "Starting DST server..."
  cd ~/steamapps/DST/bin
  cp $old_log_path $new_log_path
  cp $old_chat_log_path $new_chat_log_path
  $SERVER_PATH $SERVER_ARGS

  echo "Server crashed or stopped. Restarting..."
  ~/update_dst.sh
  sleep 10  # Wait for 5 seconds before restarting
done