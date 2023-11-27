#!/bin/bash

source ./tests/test_helper_functions.sh

GAME_SETTINGS_PATH="/ark-server/server/ShooterGame/Saved/Config/WindowsServer/GameUserSettings.ini"
CONFIG_BOOTSTRAP_PATH="/usr/local/bin/ark-sa/config-templating/bootstrap-configs.sh"

perform_test "SERVER_NAME='Test Server' - SessionName='Test Server' In GameUserSettings.ini" \
             "docker run --rm \
              -e SERVER_NAME='Test Server' \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e CONFIG_BOOTSTRAP_PATH=${CONFIG_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c \"$CONFIG_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q 'SessionName=Test Server' $GAME_SETTINGS_PATH\""

perform_test "SERVER_NAME Not Set - Defaults To SessionName='Ark Server' In GameUserSettings.ini" \
             "docker run --rm \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e CONFIG_BOOTSTRAP_PATH=${CONFIG_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c \"$CONFIG_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q 'SessionName=Ark Server' $GAME_SETTINGS_PATH\""

perform_test "ENABLE_PVE=True - ServerPVE=True In GameUserSettings.ini" \
             "docker run --rm \
              -e ENABLE_PVE=True \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e CONFIG_BOOTSTRAP_PATH=${CONFIG_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c \"$CONFIG_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q 'ServerPVE=True' $GAME_SETTINGS_PATH\""

perform_test "ENABLE_PVE Not Set - ServerPVE=False In GameUserSettings.ini" \
             "docker run --rm \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e CONFIG_BOOTSTRAP_PATH=${CONFIG_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c \"$CONFIG_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q 'ServerPVE=False' $GAME_SETTINGS_PATH\""

perform_test "ENABLE_RCON Not Set, RCON_PORT Not Set - RCONEnabled=True and RCONPort=27020 In GameUserSettings.ini" \
             "docker run --rm \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e CONFIG_BOOTSTRAP_PATH=${CONFIG_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c \"$CONFIG_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q 'RCONEnabled=True' $GAME_SETTINGS_PATH &&
                grep -q 'RCONPort=27020' $GAME_SETTINGS_PATH\""

perform_test "ENABLE_RCON Not Set, RCON_PORT=12345 - RCONEnabled=True and RCONPort=12345 In GameUserSettings.ini" \
             "docker run --rm \
              -e RCON_PORT=12345 \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e CONFIG_BOOTSTRAP_PATH=${CONFIG_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c \"$CONFIG_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q 'RCONEnabled=True' $GAME_SETTINGS_PATH &&
                grep -q 'RCONPort=12345' $GAME_SETTINGS_PATH\""

perform_test "ENABLE_RCON=False RCON_PORT Not Set - RCONEnabled=False and RCONPort=27020 In GameUserSettings.ini" \
             "docker run --rm \
              -e ENABLE_RCON=False \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e CONFIG_BOOTSTRAP_PATH=${CONFIG_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c \"$CONFIG_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q 'RCONEnabled=False' $GAME_SETTINGS_PATH &&
                grep -q 'RCONPort=27020' $GAME_SETTINGS_PATH\""

perform_test "SERVER_PASSWORD=password123 - ServerPassword=password123 In GameUserSettings.ini" \
             "docker run --rm \
              -e SERVER_PASSWORD=password123 \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e CONFIG_BOOTSTRAP_PATH=${CONFIG_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c \"$CONFIG_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q 'ServerPassword=password123' $GAME_SETTINGS_PATH\""

perform_test "SERVER_PASSWORD Not Set - ServerPassword is Blank In GameUserSettings.ini" \
             "docker run --rm \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e CONFIG_BOOTSTRAP_PATH=${CONFIG_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c \"$CONFIG_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q '^ServerPassword=\s*$' $GAME_SETTINGS_PATH\""

perform_test "ADMIN_PASSWORD=password123 - ServerAdminPassword=password123 In GameUserSettings.ini" \
             "docker run --rm \
              -e ADMIN_PASSWORD=password123 \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e CONFIG_BOOTSTRAP_PATH=${CONFIG_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c \"$CONFIG_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q 'ServerAdminPassword=password123' $GAME_SETTINGS_PATH\""

perform_test "ADMIN_PASSWORD Not Set - ServerAdminPassword=adminpassword In GameUserSettings.ini" \
             "docker run --rm \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e CONFIG_BOOTSTRAP_PATH=${CONFIG_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c \"$CONFIG_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q 'ServerAdminPassword=adminpassword' $GAME_SETTINGS_PATH\""

perform_test "MAX_PLAYERS=25 - MaxPlayers=25 In GameUserSettings.ini" \
             "docker run --rm \
              -e MAX_PLAYERS=25 \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e CONFIG_BOOTSTRAP_PATH=${CONFIG_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c \"$CONFIG_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q 'MaxPlayers=25' $GAME_SETTINGS_PATH\""

perform_test "MAX_PLAYERS Not Set - MaxPlayers=70 In GameUserSettings.ini" \
             "docker run --rm \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e CONFIG_BOOTSTRAP_PATH=${CONFIG_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c \"$CONFIG_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q 'MaxPlayers=70' $GAME_SETTINGS_PATH\""

log_failed_tests
