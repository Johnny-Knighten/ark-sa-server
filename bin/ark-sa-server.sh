#!/usr/bin/env bash

trap cleanup SIGTERM SIGINT

start_time=$(date +%s)
echo "Starting Ark Server Launcher At: $start_time"

main() {
  check_for_update
  start_server
}

check_for_update() {
  if [ "$(find "$ARK_SERVER_DIR"/server -mindepth 1 -maxdepth 1 | wc -l)" -eq 0 ]; then
    echo "No Server Files Found, Downloading Server"
    launch_update_service
  else
    if [ "$ARK_PREVENT_AUTO_UPDATE" != "True" ]; then
      echo "Checking Updating Ark SA Server"
      launch_update_service
    else
      echo "Skipping Update of Ark SA Server"
    fi
  fi
}

launch_update_service() {
  echo "Launching Updater Service"
  supervisorctl start ark-sa-updater
  wait_for_update
}

wait_for_update() {
  echo "Waiting For Updater Service to Finish (Update Timeout Limit: ${UPDATE_TIMEOUT} Seconds)"

  while true; do
    if [[ $(supervisorctl status ark-sa-updater) = *"EXITED"* ]]; then
      local status_file="/ark-server/logs/ark-sa-updater.status"

      if [ -f "$status_file" ]; then
        local mod_time
        mod_time=$(date -r "$status_file" +%s)

        if [ "$mod_time" -ge "$start_time" ]; then
          read -r exit_code < "$status_file"

          if [ "$exit_code" = "0" ]; then
              echo "Updater Finished Successfully"
              break
          else
              echo "Updater Failed (Exit Code: $exit_code)"
              exit 10
          fi
        else
          echo "Updater Failed - Status File is Older Than Start Time"
          exit 30
        fi
      else
          echo "Updater Failed - Status File Not Found"
          exit 20
      fi
    fi

    local current_time
    current_time=$(date +%s)
    local elapsed=$((current_time - start_time))
    if [ "$elapsed" -ge "${UPDATE_TIMEOUT:-300}" ]; then
      echo "Updater Failed - Did Not Finish Before Timeout"
      exit 40
    fi

    sleep 10
  done
}

start_server() {
  echo "Starting Ark Server"

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

  local proton_wine=/opt/glorious_eggroll/proton/bin/wine
  local proton_wine_log=/ark-server/logs/proton-wine.log
  local server_exe=/ark-server/server/ShooterGame/Binaries/Win64/ArkAscendedServer.exe
  local cmd_flags="-log $BATTLE_EYE_FLAG $EPIC_IP_FLAG $PLAYER_COUNT_FLAG $MOD_ARGS $ARK_EXTRA_LAUNCH_OPTIONS"

  xvfb-run "$proton_wine" "$server_exe" "$CMD_ARGS" "$cmd_flags" &> "$proton_wine_log" &

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
    rm /ark-server/logs/ark-sa-updater.status
    echo "Cleanup complete."
}

main
