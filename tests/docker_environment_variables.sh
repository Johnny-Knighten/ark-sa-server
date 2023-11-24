#!/bin/bash

source ./tests/test_helper_functions.sh

######################
# Command Args Tests #
######################

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
