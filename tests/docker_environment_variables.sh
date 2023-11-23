#!/bin/bash

source ./tests/test_helper_functions.sh

######################
# Command Args Tests #
######################

perform_test "ARK_PREVENT_AUTO_UPDATE=True - Update Is Skipped" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              -e ARK_PREVENT_AUTO_UPDATE=True \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -q 'Skipping Auto-Update of Ark SA Server'"

perform_test "ARK_MAP=Not_TheIsland_WP - Map Is Not_TheIsland_WP" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              -e ARK_MAP='Not_TheIsland_WP' \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -q 'Not_TheIsland_WP'"

perform_test "ARK_MAP Not Set - Defaults To TheIsland_WP" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -q 'TheIsland_WP'"

perform_test "ARK_GAME_PORT=12345 - Game Port Is Set To 12345" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              -e ARK_GAME_PORT=12345 \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -q '\?Port=12345'"

perform_test "ARK_GAME_PORT Not Set - Defaults To 7777" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -q '\?Port=7777'"

perform_test "ARK_QUERY_PORT=12345 - Query Port Is Set To 12345" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              -e ARK_QUERY_PORT=12345 \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -q 'QueryPort=12345'"

perform_test "ARK_QUERY_PORT Not Set - Defaults To 27015" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -q 'QueryPort=27015'"

perform_test "ARK_EXTRA_LAUNCH_OPTIONS='-ExtraFlag' - '-ExtraFlag' Appears In Launch Command" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              -e ARK_EXTRA_LAUNCH_OPTIONS='-ExtraFlag' \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -q '\-ExtraFlag'"

perform_test "ARK_MULTI_HOME='192.168.1.2' - MultiHome Value Is 192.168.1.2" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              -e ARK_MULTI_HOME=192.168.1.2 \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -q '?MultiHome=192.168.1.2'"

perform_test "ARK_MULTI_HOME Not Set - No MultiHome Param" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -qv '?MultiHome='"

perform_test "ARK_NO_BATTLEYE=False - Battleye Flag Is Not Present" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              -e ARK_NO_BATTLEYE=False \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -qv '\-NoBattlEye'"

perform_test "ARK_NO_BATTLEYE Not Set - Battleye Flag Is Present" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -q '\-NoBattlEye'"

perform_test "ARK_EPIC_PUBLIC_IP=192.168.1.2 - --PublicIPforEpic Set to 192.168.1.2" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              -e ARK_EPIC_PUBLIC_IP=192.168.1.2 \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -q '\--PublicIPforEpic 192.168.1.2'"

perform_test "ARK_EPIC_PUBLIC_IP Not Set - --PublicIPforEpic Flag Is Not Present" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -qv '\--PublicIPforEpic'"

perform_test "ARK_MOD_LIST=\"1234,5678\" - -automanagedmods Flag Present With -mods=1234,5678" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              -e ARK_MOD_LIST='1234,5678' \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -q '\-automanagedmods \-mods=1234,5678'"

perform_test "ARK_MOD_LIST=\"    1234   ,    5678\" - -automanagedmods Flag Present With -mods=1234,5678 (Spaces Removed)" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              -e ARK_MOD_LIST='1234,5678' \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -q '\-automanagedmods \-mods=1234,5678'"

 perform_test "ARK_MOD_LIST Not Set - Not Mod Flags Present" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -qv '\-automanagedmods' &&\
             echo \$OUTPUT | grep -qv '\-mods='"

perform_test "ARK_MAX_PLAYERS=25 - Player Count Is 25" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              -e ARK_MAX_PLAYERS=25 \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -q '\-WinLiveMaxPlayers=25'"

perform_test "ARK_MAX_PLAYERS Not Set - Default Player Count Is 70" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -q '\-WinLiveMaxPlayers=70'"

#####################
# Config File Tests #
#####################

GAME_SETTINGS_PATH="/ark-server/server/ShooterGame/Saved/Config/WindowsServer/GameUserSettings.ini"
CONFIG_BOOTSTRAP_PATH="/opt/ark-sa-container/bin/ark-sa/config-templating/bootstrap-configs.sh"

perform_test "ARK_SERVER_NAME='Test Server' - SessionName='Test Server' In GameUserSettings.ini" \
             "docker run --rm \
              -e ARK_SERVER_NAME='Test Server' \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e CONFIG_BOOTSTRAP_PATH=${CONFIG_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c \"$CONFIG_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q 'SessionName=Test Server' $GAME_SETTINGS_PATH\""

perform_test "ARK_SERVER_NAME Not Set - Defaults To SessionName='Ark Server' In GameUserSettings.ini" \
             "docker run --rm \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e CONFIG_BOOTSTRAP_PATH=${CONFIG_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c \"$CONFIG_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q 'SessionName=Ark Server' $GAME_SETTINGS_PATH\""

perform_test "ARK_ENABLE_PVE=True - ServerPVE=True In GameUserSettings.ini" \
             "docker run --rm \
              -e ARK_ENABLE_PVE=True \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e CONFIG_BOOTSTRAP_PATH=${CONFIG_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c \"$CONFIG_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q 'ServerPVE=True' $GAME_SETTINGS_PATH\""

perform_test "ARK_ENABLE_PVE Not Set - ServerPVE=False In GameUserSettings.ini" \
             "docker run --rm \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e CONFIG_BOOTSTRAP_PATH=${CONFIG_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c \"$CONFIG_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q 'ServerPVE=False' $GAME_SETTINGS_PATH\""

perform_test "ARK_ENABLE_RCON Not Set, ARK_RCON_PORT Not Set - RCONEnabled=True and RCONPort=27020 In GameUserSettings.ini" \
             "docker run --rm \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e CONFIG_BOOTSTRAP_PATH=${CONFIG_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c \"$CONFIG_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q 'RCONEnabled=True' $GAME_SETTINGS_PATH &&
                grep -q 'RCONPort=27020' $GAME_SETTINGS_PATH\""

perform_test "ARK_ENABLE_RCON Not Set, ARK_RCON_PORT=12345 - RCONEnabled=True and RCONPort=12345 In GameUserSettings.ini" \
             "docker run --rm \
              -e ARK_RCON_PORT=12345 \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e CONFIG_BOOTSTRAP_PATH=${CONFIG_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c \"$CONFIG_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q 'RCONEnabled=True' $GAME_SETTINGS_PATH &&
                grep -q 'RCONPort=12345' $GAME_SETTINGS_PATH\""

perform_test "ARK_ENABLE_RCON=False ARK_RCON_PORT Not Set - RCONEnabled=False and RCONPort=27020 In GameUserSettings.ini" \
             "docker run --rm \
              -e ARK_ENABLE_RCON=False \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e CONFIG_BOOTSTRAP_PATH=${CONFIG_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c \"$CONFIG_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q 'RCONEnabled=False' $GAME_SETTINGS_PATH &&
                grep -q 'RCONPort=27020' $GAME_SETTINGS_PATH\""

perform_test "ARK_SERVER_PASSWORD=password123 - ServerPassword=password123 In GameUserSettings.ini" \
             "docker run --rm \
              -e ARK_SERVER_PASSWORD=password123 \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e CONFIG_BOOTSTRAP_PATH=${CONFIG_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c \"$CONFIG_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q 'ServerPassword=password123' $GAME_SETTINGS_PATH\""

perform_test "ARK_SERVER_PASSWORD Not Set - ServerPassword is Blank In GameUserSettings.ini" \
             "docker run --rm \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e CONFIG_BOOTSTRAP_PATH=${CONFIG_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c \"$CONFIG_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q '^ServerPassword=\s*$' $GAME_SETTINGS_PATH\""

perform_test "ARK_SERVER_ADMIN_PASSWORD=password123 - ServerAdminPassword=password123 In GameUserSettings.ini" \
             "docker run --rm \
              -e ARK_SERVER_ADMIN_PASSWORD=password123 \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e CONFIG_BOOTSTRAP_PATH=${CONFIG_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c \"$CONFIG_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q 'ServerAdminPassword=password123' $GAME_SETTINGS_PATH\""

perform_test "ARK_SERVER_ADMIN_PASSWORD Not Set - ServerAdminPassword=adminpassword In GameUserSettings.ini" \
             "docker run --rm \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e CONFIG_BOOTSTRAP_PATH=${CONFIG_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c \"$CONFIG_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q 'ServerAdminPassword=adminpassword' $GAME_SETTINGS_PATH\""

perform_test "ARK_MAX_PLAYERS=25 - MaxPlayers=25 In GameUserSettings.ini" \
             "docker run --rm \
              -e ARK_MAX_PLAYERS=25 \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e CONFIG_BOOTSTRAP_PATH=${CONFIG_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c \"$CONFIG_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q 'MaxPlayers=25' $GAME_SETTINGS_PATH\""

perform_test "ARK_MAX_PLAYERS Not Set - MaxPlayers=70 In GameUserSettings.ini" \
             "docker run --rm \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e CONFIG_BOOTSTRAP_PATH=${CONFIG_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c \"$CONFIG_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                grep -q 'MaxPlayers=70' $GAME_SETTINGS_PATH\""

log_failed_tests
