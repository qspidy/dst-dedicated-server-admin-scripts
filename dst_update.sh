#!/bin/sh

/home/steam/steamcmd/steamcmd.sh +@ShutdownOnFailedCommand 1 +@NoPromptForPassword 1 +force_install_dir /home/steam/steamapps/DST +login anonymous  +app_update 343050 +quit
cd /home/steam/steamapps/DST/bin/ 
./dontstarve_dedicated_server_nullrenderer -only_update_server_mods
