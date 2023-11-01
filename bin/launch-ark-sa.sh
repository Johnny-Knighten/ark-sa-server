#!/usr/bin/env bash

set -e

[[ -z "${DEBUG}" ]] || [[ "${DEBUG,,}" = "false" ]] || [[ "${DEBUG,,}" = "0" ]] || set -x

xvfb-run /opt/glorious_eggroll/proton/bin/wine ./server/ShooterGame/Binaries/Win64/ArkAscendedServer.exe TheIsland_WP?listen?Port=7777?QueryPort=27015 -log -NoBattlEye &> proton-wine.log &

while [ ! -f "${ARK_SERVER_DIR}/server/ShooterGame/Saved/Logs/ShooterGame.log" ]; do
  echo "Waiting for file ${ARK_SERVER_DIR}/server/ShooterGame/Saved/Logs/ShooterGame.log to exist..."
  sleep 1
done

tail -f "${ARK_SERVER_DIR}/server/ShooterGame/Saved/Logs/ShooterGame.log"
