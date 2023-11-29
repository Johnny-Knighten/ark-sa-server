#!/bin/bash

source ./tests/test_helper_functions.sh

###################################
# Core Environment Variable Tests #
###################################

GAME_SETTINGS_PATH="/ark-server/server/ShooterGame/Saved/Config/WindowsServer/GameUserSettings.ini"
ARK_SA_BOOTSTRAP_PATH="/usr/local/bin/ark-sa-bootstrap.sh"

perform_test "Default Values In GameUserSettings.ini" \
             'docker run --rm \
              -e DRY_RUN=True \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e ARK_SA_BOOTSTRAP_PATH=${ARK_SA_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "$ARK_SA_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                  grep -q \"SessionName=Ark Server\" $GAME_SETTINGS_PATH && \
                  grep -q \"RCONEnabled=True\" $GAME_SETTINGS_PATH && \
                  grep -q \"RCONPort=27020\" $GAME_SETTINGS_PATH && \
                  grep -q \"MaxPlayers=70\" $GAME_SETTINGS_PATH && \
                  grep -q \"ServerPassword=$\" $GAME_SETTINGS_PATH && \
                  grep -q \"ServerAdminPassword=adminpassword\" $GAME_SETTINGS_PATH && \
                  grep -q \"ServerPVE=False\" $GAME_SETTINGS_PATH"'

perform_test "ENABLE_PVE=True - ServerPVE=True In GameUserSettings.ini" \
             'docker run --rm \
              -e DRY_RUN=True \
              -e ENABLE_PVE=True \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e ARK_SA_BOOTSTRAP_PATH=${ARK_SA_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "$ARK_SA_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q \"ServerPVE=True\" $GAME_SETTINGS_PATH"'

perform_test "RCON_PORT=12345 - RCONPort=12345 In GameUserSettings.ini" \
             'docker run --rm \
              -e DRY_RUN=True \
              -e RCON_PORT=12345 \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e ARK_SA_BOOTSTRAP_PATH=${ARK_SA_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "$ARK_SA_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q \"RCONPort=12345\" $GAME_SETTINGS_PATH"'

perform_test "ENABLE_RCON=False - RCONEnabled=False In GameUserSettings.ini" \
             'docker run --rm \
              -e DRY_RUN=True \
              -e ENABLE_RCON=False \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e ARK_SA_BOOTSTRAP_PATH=${ARK_SA_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "$ARK_SA_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q 'RCONEnabled=False' $GAME_SETTINGS_PATH &&
                grep -q 'RCONPort=27020' $GAME_SETTINGS_PATH"'

perform_test "SERVER_PASSWORD=password123 - ServerPassword=password123 In GameUserSettings.ini" \
             'docker run --rm \
              -e DRY_RUN=True \
              -e SERVER_PASSWORD=password123 \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e ARK_SA_BOOTSTRAP_PATH=${ARK_SA_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "$ARK_SA_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q \"ServerPassword=password123\" $GAME_SETTINGS_PATH"'

perform_test "ADMIN_PASSWORD=password123 - ServerAdminPassword=password123 In GameUserSettings.ini" \
             'docker run --rm \
              -e DRY_RUN=True \
              -e ADMIN_PASSWORD=password123 \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e ARK_SA_BOOTSTRAP_PATH=${ARK_SA_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "$ARK_SA_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q \"ServerAdminPassword=password123\" $GAME_SETTINGS_PATH"'

perform_test "MAX_PLAYERS=25 - MaxPlayers=25 In GameUserSettings.ini" \
             'docker run --rm \
              -e DRY_RUN=True \
              -e MAX_PLAYERS=25 \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e ARK_SA_BOOTSTRAP_PATH=${ARK_SA_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "$ARK_SA_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q \"MaxPlayers=25\" $GAME_SETTINGS_PATH"'

perform_test "SERVER_NAME=Test_Server - SessionName=Test_Server In GameUserSettings.ini" \
             'docker run --rm \
              -e DRY_RUN=True \
              -e SERVER_NAME=Test_Server \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e ARK_SA_BOOTSTRAP_PATH=${ARK_SA_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "$ARK_SA_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q \"SessionName=Test_Server\" $GAME_SETTINGS_PATH"'

log_failed_tests
