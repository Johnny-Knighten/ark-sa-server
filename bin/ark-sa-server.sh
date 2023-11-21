#!/usr/bin/env bash

trap cleanup SIGTERM SIGINT

echo "Starting Ark Server Launcher..."

main() {
  wait_for_update
  start_server
}

wait_for_update() {
  local start_time=$(date +%s)
  echo "Start Time For wait_for_update: $start_time"

  echo "Waiting for ark-sa-updater to finish (timeout: ${UPDATE_TIMEOUT} seconds)..."

  while true; do
    local status=$(supervisorctl status ark-sa-updater)
    
    if [[ $status = *"EXITED"* ]]; then
      local status_file="/ark-server/logs/ark-sa-updater.status"

      if [ -f "$status_file" ]; then
        local lower_bound=$((start_time - 2*UPDATE_TIMEOUT))
        local upper_bound=$((start_time + 2*UPDATE_TIMEOUT))
        local mod_time=$(date -r "$status_file" +%s)

        if [ "$mod_time" -ge "$lower_bound" ] && [ "$mod_time" -le "$upper_bound" ]; then
          read exit_status < "$status_file"

          if [ "$exit_status" = "0" ]; then
              echo "Updater finished successfully. Launching Ark Server..."
              break
          else
              echo "Updater failed with exit status $exit_status. Not launching Ark Server."
              exit 10
          fi

        else
          echo "Updater status file is older than start time. Not launching Ark Server."
          exit 30

        fi
      else
          echo "Updater status file not found. Not launching Ark Server."
          exit 20
          
      fi
    fi

    local current_time=$(date +%s)
    local elapsed=$((current_time - start_time))
    if [ "$elapsed" -ge "${UPDATE_TIMEOUT:-300}" ]; then
      echo "Timeout exceeded while waiting for ark-sa-updater."
      exit 40
    fi

    sleep 10
  done
}

start_server() {
  echo "Starting Ark Server..."

  CMD_ARGS="$ARK_MAP?listen"
  CMD_ARGS+="?Port=$ARK_GAME_PORT"
  CMD_ARGS+="?QueryPort=$ARK_QUERY_PORT"

  if [[ -n "$ARK_MULTI_HOME" ]]; then
    CMD_ARGS+="?MultiHome=$ARK_MULTI_HOME"
  fi

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

  PLAYER_COUNT_FLAG="-WinLiveMaxPlayers=$ARK_MAX_PLAYERS"

  # remove all whitespace from ARK_MOD_LIST
  ARK_MOD_LIST="$(echo -e "$ARK_MOD_LIST" | tr -d '[:space:]')"

  if [[ -n "$ARK_MOD_LIST" ]]; then
    MOD_ARGS="-automanagedmods -mods=$ARK_MOD_LIST"
  else
    MOD_ARGS=""
  fi

  xvfb-run /opt/glorious_eggroll/proton/bin/wine ./server/ShooterGame/Binaries/Win64/ArkAscendedServer.exe "$CMD_ARGS" -log $BATTLE_EYE_FLAG $EPIC_IP_FLAG $PLAYER_COUNT_FLAG $MOD_ARGS $ARK_EXTRA_LAUNCH_OPTIONS &> /ark-server/logs/proton-wine.log &

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

}

cleanup() {
    echo "Cleaning up before stopping..."
    /opt/glorious_eggroll/proton/bin/wineserver -k
    echo "Cleanup complete."
}

main
