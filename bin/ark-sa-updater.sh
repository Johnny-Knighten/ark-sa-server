#!/usr/bin/env bash

echo "Starting Ark Server Updater"

main() {
 download_and_update_ark_sa_server
 launch_ark_sa_server
}

launch_ark_sa_server() {
  echo " Updater - Launching Ark SA Server"
  supervisorctl start ark-sa-server
}

download_and_update_ark_sa_server() {
  if [ "$STEAMCMD_SKIP_VALIDATION" = "True" ]; then
    echo "Updater - Skipping SteamCMD Validation of Server Files"
    local app_update="+app_update 2430930"
  else
    local app_update="+app_update 2430930 validate"
  fi

  local install_dir="+force_install_dir $ARK_SERVER_DIR/server"
  steamcmd +login anonymous "$install_dir" "$app_update" +quit
}

main
