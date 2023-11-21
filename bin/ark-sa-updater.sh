#!/usr/bin/env bash

echo "Starting Ark Server Updater..."

main() {
  if [ "$(find $ARK_SERVER_DIR/server -mindepth 1 -maxdepth 1 | wc -l)" -eq 0 ]; then
    echo "No Server Files Found, Downloading..."
    echo "Downloading Ark SA Server to $ARK_SERVER_DIR/server"
    download_ark_sa_server
  else

    echo "Server Files Found, Skipping Download..."
    if [ "$ARK_PREVENT_AUTO_UPDATE" != "True" ]; then
      echo "Updating Ark SA Server"
      download_ark_sa_server
    else
      echo "Skipping Auto-Update of Ark SA Server"
    fi

  fi
  exit 0
}

download_ark_sa_server() {
  if [ "$STEAMCMD_SKIP_VALIDATION" = "True" ]; then
    echo "SteamCMD Will Not Validate Ark SA Server Files"
    local app_update="+app_update 2430930"
  else
    local app_update="+app_update 2430930 validate"
  fi

  local install_dir="+force_install_dir $ARK_SERVER_DIR/server"
  steamcmd +login anonymous "$install_dir" "$app_update" +quit
}

main
