#!/bin/bash

source ./tests/test_helper_functions.sh

perform_test "STEAMCMD_SKIP_VALIDATION=True - Skips Steam Validation" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              -e STEAMCMD_SKIP_VALIDATION=True \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -q 'SteamCMD Will Not Validate Ark SA Server Files'"

perform_test "STEAMCMD_SKIP_VALIDATION=False - Steam Validation Is Performed" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              -e STEAMCMD_SKIP_VALIDATION=False \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -q 'SteamCMD Will Validate Ark SA Server Files'"

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

perform_test "ARK_SERVER_NAME='Test Server' - Server Name Is 'Test Server'" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              -e ARK_SERVER_NAME='Test Server' \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -q 'SessionName=Test Server'"

perform_test "ARK_SERVER_NAME Not Set - Defaults To 'Ark Server'" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -q 'SessionName=Ark Server'"

perform_test "ARK_ENABLE_PVE=True - PVE Mode Enabled'" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              -e ARK_ENABLE_PVE=True \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -q 'ServerPVE=True'"

perform_test "ARK_ENABLE_PVE Not Set - Defaults To False" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -q 'ServerPVE=False'"

perform_test "ARK_ENABLE_RCON Not Set, RCONPort Not Set - Default RCON True With Default RCON Port'" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -q '?RCONEnabled=True?RCONPort=27020'"

perform_test "ARK_ENABLE_RCON Not Set, RCONPort=12345 - Default RCON True With RCON Port 12345'" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              -e ARK_RCON_PORT=12345 \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -q '?RCONEnabled=True?RCONPort=12345'"

perform_test "ARK_ENABLE_RCON=False - RCON Off With No RCON Port'" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              -e ARK_ENABLE_RCON=False \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -q '?RCONEnabled=False' &&  \
             echo \$OUTPUT | grep -qv '?RCONPort'"

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

perform_test "ARK_SERVER_PASSWORD=password123 - Server Password Is password123" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              -e ARK_SERVER_PASSWORD=password123 \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -q 'ServerPassword=password123'"

perform_test "ARK_SERVER_PASSWORD Not Set - No Server Password" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -qv '?ServerPassword='"

perform_test "ARK_SERVER_ADMIN_PASSWORD=password123 - Server Admin Password Is password123" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              -e ARK_SERVER_ADMIN_PASSWORD=password123 \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -q 'ServerAdminPassword=password123'"

perform_test "ARK_SERVER_ADMIN_PASSWORD Not Set - Default Server Admin Password adminpassword" \
             "OUTPUT=\$(docker run --rm \
              -e TEST_DRY_RUN=True \
              johnnyknighten/ark-sa-server:latest);
             echo \$OUTPUT | grep -q 'ServerAdminPassword=adminpassword'"

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

log_failed_tests
