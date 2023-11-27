#!/usr/bin/env bash

set -e

[[ -z "${DEBUG}" ]] || [[ "${DEBUG,,}" = "false" ]] || [[ "${DEBUG,,}" = "0" ]] || set -x

config_template="/usr/local/bin/ark-sa/config-templating/GameUserSettings.template.ini"
config_file="${SERVER_DIR}/ShooterGame/Saved/Config/WindowsServer/GameUserSettings.ini"

if [[ ! -f "$config_file" ]] || [[ "$REBUILD_CONFIG" = "True" ]]; then

  if [ "$REBUILD_CONFIG" = "True" ]; then
    echo "REBUILD_CONFIG is set to True, rebuilding existing GameUserSettings.ini..."
  else
    echo "GameUserSettings.ini not found, creating from template..."
  fi

  if [ -f "$config_template" ]; then
    mkdir -p "${SERVER_DIR}/ShooterGame/Saved/Config/WindowsServer"
    cp "$config_template" "$config_file"
    sed -i "s/SessionName=<<SERVER_NAME>>/SessionName=$SERVER_NAME/" "$config_file"
    sed -i "s/RCONEnabled=<<ENABLE_RCON>>/RCONEnabled=$ENABLE_RCON/" "$config_file"
    sed -i "s/RCONPort=<<RCON_PORT>>/RCONPort=$RCON_PORT/" "$config_file"
    sed -i "s/MaxPlayers=<<MAX_PLAYERS>>/MaxPlayers=$MAX_PLAYERS/" "$config_file"
    sed -i "s/ServerPassword=<<SERVER_PASSWORD>>/ServerPassword=$SERVER_PASSWORD/" "$config_file"
    sed -i "s/ServerAdminPassword=<<ADMIN_PASSWORD>>/ServerAdminPassword=$ADMIN_PASSWORD/" "$config_file"
    sed -i "s/ServerPVE=<<ENABLE_PVE>>/ServerPVE=$ENABLE_PVE/" "$config_file"
  else
    echo "GameUserSettings template not found at $config_template"
    exit 1
  fi
else
    echo "GameUserSettings.ini found, skipping creation from template..."
fi
