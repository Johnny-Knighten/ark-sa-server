#!/usr/bin/env bash

set -e

[[ -z "${DEBUG}" ]] || [[ "${DEBUG,,}" = "false" ]] || [[ "${DEBUG,,}" = "0" ]] || set -x

echo "Updater - Starting"

main() {
 download_and_update_ark_sa_server
 launch_ark_sa_server
}

launch_ark_sa_server() {
  echo " Updater - Launching Ark SA Server"
  if [[ "$DRY_RUN" = "True" ]]; then
    echo "DRY_RUN - supervisorctl start ark-sa-server."
  else
    supervisorctl start ark-sa-server
  fi
}

download_and_update_ark_sa_server() {
  if [ "$STEAMCMD_SKIP_VALIDATION" = "True" ]; then
    echo "Updater - Skipping SteamCMD Validation of Server Files"
    local app_update="+app_update 2430930"
  else
    local app_update="+app_update 2430930 validate"
  fi

  local install_dir="+force_install_dir $ARK_SERVER_DIR/server"

  if [[ "$DRY_RUN" = "True" ]]; then
    echo "$DRY_RUN_MSG steamcmd +login anonymous \"$install_dir\" \"$app_update\" +quit"
  else
    steamcmd +login anonymous "$install_dir" "$app_update" +quit
  fi
}

main
