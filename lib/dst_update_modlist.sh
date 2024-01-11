#!/bin/bash

# check paras
if [[ "$1" == "" ]]; then
  echo "Please set cluster serial number."
  echo "Usage: $0 <cluster serial number>"
  echo "    E.g: "
  echo "        If the save directory is Cluster_5, run"
  echo "        "$0 5""
  exit 1
fi


cluster_modlist_path=$HOME/.klei/DoNotStarveTogether/Cluster_$1/Master/modoverrides.lua
server_modlist_path=$HOME/steamapps/DST/mods/dedicated_server_mods_setup.lua


while read -r number; do
  echo "ServerModSetup(\"$number\")"
done <<< "$(grep -oE 'workshop-[0-9]+' $cluster_modlist_path | cut -d'-' -f2)" >> $server_modlist_path 

cat "$server_modlist_path" | sort | uniq > temp_file && mv temp_file "$server_modlist_path"

echo Done.