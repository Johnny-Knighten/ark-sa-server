#!/usr/bin/env bash

set -e

[[ -z "${DEBUG}" ]] || [[ "${DEBUG,,}" = "false" ]] || [[ "${DEBUG,,}" = "0" ]] || set -x

config_template="${CONTAINER_BIN_DIR}/ark-sa/config-templating/GameUserSettings.template.ini"
config_file="${ARK_SERVER_DIR}/server/ShooterGame/Saved/Config/WindowsServer/GameUserSettings.ini"

if [[ ! -f "$config_file" ]] || [[ "$ARK_REBUILD_CONFIG" = "True" ]]; then

  if [ "$ARK_REBUILD_CONFIG" = "True" ]; then
    echo "ARK_REBUILD_CONFIG is set to True, rebuilding existing GameUserSettings.ini..."
  else
    echo "GameUserSettings.ini not found, creating from template..."
  fi

  if [ -f "$config_template" ]; then
    mkdir -p "${ARK_SERVER_DIR}/server/ShooterGame/Saved/Config/WindowsServer"
    cp "$config_template" "$config_file"
    sed -i "s/SessionName=<<ARK_SERVER_NAME>>/SessionName=$ARK_SERVER_NAME/" "$config_file"
    sed -i "s/RCONEnabled=<<ARK_ENABLE_RCON>>/RCONEnabled=$ARK_ENABLE_RCON/" "$config_file"
    sed -i "s/RCONPort=<<ARK_RCON_PORT>>/RCONPort=$ARK_RCON_PORT/" "$config_file"
    sed -i "s/MaxPlayers=<<ARK_MAX_PLAYERS>>/MaxPlayers=$ARK_MAX_PLAYERS/" "$config_file"
    sed -i "s/ServerPassword=<<ARK_SERVER_PASSWORD>>/ServerPassword=$ARK_SERVER_PASSWORD/" "$config_file"
    sed -i "s/ServerAdminPassword=<<ARK_SERVER_ADMIN_PASSWORD>>/ServerAdminPassword=$ARK_SERVER_ADMIN_PASSWORD/" "$config_file"
    sed -i "s/ServerPVE=<<ARK_ENABLE_PVE>>/ServerPVE=$ARK_ENABLE_PVE/" "$config_file"
  else
    echo "GameUserSettings template not found at $config_template"
    exit 1
  fi
else
    echo "GameUserSettings.ini found, skipping creation from template..."
fi
