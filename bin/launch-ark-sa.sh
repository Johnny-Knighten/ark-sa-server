#!/usr/bin/env bash

set -e

[[ -z "${DEBUG}" ]] || [[ "${DEBUG,,}" = "false" ]] || [[ "${DEBUG,,}" = "0" ]] || set -x

CMD_ARGS="$ARK_MAP?listen"
CMD_ARGS+="?SessionName=$ARK_SERVER_NAME"
CMD_ARGS+="?Port=$ARK_GAME_PORT"
CMD_ARGS+="?QueryPort=$ARK_QUERY_PORT"
CMD_ARGS+="?RCONEnabled=$ARK_ENABLE_RCON"
CMD_ARGS+="?RCONPort=$ARK_RCON_PORT"
CMD_ARGS+="?ServerPVE=$ARK_ENABLE_PVE"
CMD_ARGS+="?MaxPlayers=$ARK_MAX_PLAYERS"

if [[ "$ARK_PUBLIC_SERVER" != "True" ]]; then
  CMD_ARGS+="?ServerPassword=$ARK_SERVER_PASSWORD"
fi

CMD_ARGS+="?ServerAdminPassword=$ARK_SERVER_ADMIN_PASSWORD"

# remove all whitespace from ARK_MOD_LIST
ARK_MOD_LIST="$(echo -e "$ARK_MOD_LIST" | tr -d '[:space:]')"

if [[ -z "$ARK_MOD_LIST" ]]; then
  MOD_ARGS=""
else
  MOD_ARGS="-automanagedmods -mods=$ARK_MOD_LIST"
fi

xvfb-run /opt/glorious_eggroll/proton/bin/wine ./server/ShooterGame/Binaries/Win64/ArkAscendedServer.exe $CMD_ARGS -log $MOD_ARGS $ARK_LAUNCH_OPTIONS &> proton-wine.log &

log_file="${ARK_SERVER_DIR}/server/ShooterGame/Saved/Logs/ShooterGame.log"
timeout=300 

while [ ! -f "$log_file" ] && [ $timeout -gt 0 ]; do
  echo "Waiting for file $log_file to exist..."
  sleep 1
  ((timeout--))
done

if [ -f "$log_file" ]; then
  tail -f "$log_file"
else
  echo "File $log_file did not appear within the timeout period"
  exit 1
fi