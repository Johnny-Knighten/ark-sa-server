#!/usr/bin/env bash

set -e

[[ -z "${DEBUG}" ]] || [[ "${DEBUG,,}" = "false" ]] || [[ "${DEBUG,,}" = "0" ]] || set -x

CMD_ARGS="$ARK_MAP?listen"
CMD_ARGS+="?SessionName=$ARK_SERVER_NAME"
CMD_ARGS+="?Port=$ARK_GAME_PORT"
CMD_ARGS+="?QueryPort=$ARK_QUERY_PORT"
CMD_ARGS+="?ServerPVE=$ARK_ENABLE_PVE"
CMD_ARGS+="?MaxPlayers=$ARK_MAX_PLAYERS"

if [[ "$ARK_RCON_ENABLED" = "True" ]]; then
  CMD_ARGS+="?RCONEnabled=$ARK_RCON_ENABLED?RCONPort=$ARK_RCON_PORT"
else
  CMD_ARGS+="?RCONEnabled=False"
fi

if [[ -n "$ARK_MULTI_HOME" ]]; then
  CMD_ARGS+="?MultiHome=$ARK_MULTI_HOME"
fi

if [[ -n "$ARK_SERVER_PASSWORD" ]]; then
  CMD_ARGS+="?ServerPassword=$ARK_SERVER_PASSWORD"
fi

CMD_ARGS+="?ServerAdminPassword=$ARK_SERVER_ADMIN_PASSWORD"

if [[ "$ARK_NO_BATTLEYE" = "True" ]]; then
  BATTLE_EYE_FLAG="-NoBattlEye"
else
  BATTLE_EYE_FLAG=""
fi

if [[ -n "$ARK_EPIC_PUBLIC_IP" ]]; then
  EPIC_IP_FLAG="--PublicIPforEpic $ARK_EPIC_PUBLIC_IP"
else
  EPIC_IP_FLAG=""
fi

# remove all whitespace from ARK_MOD_LIST
ARK_MOD_LIST="$(echo -e "$ARK_MOD_LIST" | tr -d '[:space:]')"

if [[ -n "$ARK_MOD_LIST" ]]; then
  MOD_ARGS="-automanagedmods -mods=$ARK_MOD_LIST"
else
  MOD_ARGS=""
fi

xvfb-run /opt/glorious_eggroll/proton/bin/wine ./server/ShooterGame/Binaries/Win64/ArkAscendedServer.exe $CMD_ARGS -log $BATTLE_EYE_FLAG $EPIC_IP_FLAG $MOD_ARGS $ARK_EXTRA_LAUNCH_OPTIONS &> proton-wine.log &

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