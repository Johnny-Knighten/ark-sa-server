#!/usr/bin/env bash

echo "Starting Ark Server Updater"

trap 'write_status $?' EXIT

write_status() {
  local exit_status=$1
  echo "$exit_status" > /ark-server/logs/ark-sa-updater.status
}

main() {
 download_and_update_ark_sa_server
}

download_and_update_ark_sa_server() {
  if [ "$STEAMCMD_SKIP_VALIDATION" = "True" ]; then
    echo "Skipping SteamCMD Validation of Server Files"
    local app_update="+app_update 2430930"
  else
    local app_update="+app_update 2430930 validate"
  fi

  local install_dir="+force_install_dir $ARK_SERVER_DIR/server"
  steamcmd +login anonymous "$install_dir" "$app_update" +quit

  local steamcmd_exit_status=$?
  exit $steamcmd_exit_status
}

main
