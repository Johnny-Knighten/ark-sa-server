#!/usr/bin/env bash

set -e

[[ -z "${DEBUG}" ]] || [[ "${DEBUG,,}" = "false" ]] || [[ "${DEBUG,,}" = "0" ]] || set -x


trap cleanup SIGTERM SIGINT

start_time=$(date +%s)
echo "Ark Server - Starting at $start_time"

main() {
  handle_old_shooter_log
  start_server
}

handle_old_shooter_log() {
  local shooter_log="${ARK_SERVER_DIR}/ShooterGame/Saved/Logs/ShooterGame.log"
  if [[ -f "$shooter_log" ]]; then
    echo "Ark Server - Deleting Old Shooter Logs"
    rm "$shooter_log"
  fi
}

start_server() {
  local cmd_args="$ARK_MAP?listen"
  cmd_args+="?Port=$ARK_GAME_PORT"
  cmd_args+="?QueryPort=$ARK_QUERY_PORT"

  if [[ -n "$ARK_MULTI_HOME" ]]; then
    cmd_args+="?MultiHome=$ARK_MULTI_HOME"
  fi

  local launch_flags="-log"

  if [[ "$ARK_NO_BATTLEYE" = "True" ]]; then
    launch_flags+=" -NoBattlEye"
  fi

  if [[ -n "$ARK_EPIC_PUBLIC_IP" ]]; then
    launch_flags+=" --PublicIPforEpic $ARK_EPIC_PUBLIC_IP"
  fi
  
  launch_flags+=" -WinLiveMaxPlayers=$ARK_MAX_PLAYERS"

  ARK_MOD_LIST="$(echo -e "$ARK_MOD_LIST" | tr -d '[:space:]')"
  if [[ -n "$ARK_MOD_LIST" ]]; then
    launch_flags+=" -automanagedmods -mods=$ARK_MOD_LIST"
  fi

  launch_flags+=" $ARK_EXTRA_LAUNCH_OPTIONS"

  local proton_wine=/opt/glorious_eggroll/proton/bin/wine
  local proton_wine_log=/ark-server/logs/proton-wine.log
  local server_exe=/ark-server/server/ShooterGame/Binaries/Win64/ArkAscendedServer.exe

  if [[ "$DRY_RUN" = "True" ]]; then
    echo "DRY_RUN - $proton_wine $server_exe \"$cmd_args\" $launch_flags"
    return
  fi

  xvfb-run $proton_wine $server_exe "$cmd_args" $launch_flags &> $proton_wine_log &

  local log_file="${ARK_SERVER_DIR}/ShooterGame/Saved/Logs/ShooterGame.log"
  local timeout=300

  while [ ! -f "$log_file" ] && [ $timeout -gt 0 ]; do
    echo "Ark Server - Waiting for File $log_file to Exist"
    sleep 5
    ((timeout--))
  done

  if [ -f "$log_file" ]; then
    tail -f "$log_file"
  else
    echo "Ark Server - File $log_file Did Not Appear Within the Timeout Period"
    exit 1
  fi
}

cleanup() {
  echo "Ark Server - Cleaning up before stopping..."
  /opt/glorious_eggroll/proton/bin/wineserver -k
  echo "Ark Server - Cleanup complete."
}

main
