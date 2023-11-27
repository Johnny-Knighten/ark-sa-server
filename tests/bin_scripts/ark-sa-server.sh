#!/bin/bash

source ./tests/test_helper_functions.sh

perform_test "MAP=Not_TheIsland_WP - Map Is Not_TheIsland_WP" \
             'OUTPUT=$(docker run --rm \
              -e DRY_RUN=True \
              -e MAP="Not_TheIsland_WP" \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/ark-sa-server.sh");
             echo $OUTPUT | grep -q "Not_TheIsland_WP"'

perform_test "MAP Not Set - Defaults To TheIsland_WP" \
             'OUTPUT=$(docker run --rm \
              -e DRY_RUN=True \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/ark-sa-server.sh");
             echo $OUTPUT | grep -q "TheIsland_WP"'

perform_test "GAME_PORT=12345 - Game Port Is Set To 12345" \
             'OUTPUT=$(docker run --rm \
              -e DRY_RUN=True \
              -e GAME_PORT=12345 \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/ark-sa-server.sh");
             echo $OUTPUT | grep -q "?Port=12345"'

perform_test "GAME_PORT Not Set - Defaults To 7777" \
             'OUTPUT=$(docker run --rm \
              -e DRY_RUN=True \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/ark-sa-server.sh");
             echo $OUTPUT | grep -q "?Port=7777"'

perform_test "QUERY_PORT=12345 - Query Port Is Set To 12345" \
             'OUTPUT=$(docker run --rm \
              -e DRY_RUN=True \
              -e QUERY_PORT=12345 \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/ark-sa-server.sh");
             echo $OUTPUT | grep -q "QueryPort=12345"'

perform_test "QUERY_PORT Not Set - Defaults To 27015" \
             'OUTPUT=$(docker run --rm \
              -e DRY_RUN=True \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/ark-sa-server.sh");
             echo $OUTPUT | grep -q "QueryPort=27015"'

perform_test "EXTRA_LAUNCH_OPTIONS='-ExtraFlag' - '-ExtraFlag' Appears In Launch Command" \
             'OUTPUT=$(docker run --rm \
              -e DRY_RUN=True \
              -e EXTRA_LAUNCH_OPTIONS="-ExtraFlag" \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/ark-sa-server.sh");
             echo $OUTPUT | grep -q "\-ExtraFlag"'

perform_test "MULTI_HOME='192.168.1.2' - MultiHome Value Is 192.168.1.2" \
             'OUTPUT=$(docker run --rm \
              -e DRY_RUN=True \
              -e MULTI_HOME=192.168.1.2 \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/ark-sa-server.sh");
             echo $OUTPUT | grep -q "?MultiHome=192.168.1.2"'

perform_test "MULTI_HOME Not Set - No MultiHome Param" \
             'OUTPUT=$(docker run --rm \
              -e DRY_RUN=True \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/ark-sa-server.sh");
             echo $OUTPUT | grep -qv "?MultiHome="'

perform_test "NO_BATTLEYE=False - Battleye Flag Is Not Present" \
             'OUTPUT=$(docker run --rm \
              -e DRY_RUN=True \
              -e NO_BATTLEYE=False \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/ark-sa-server.sh");
             echo $OUTPUT | grep -qv "\-NoBattlEye"'

perform_test "NO_BATTLEYE Not Set - Battleye Flag Is Present" \
             'OUTPUT=$(docker run --rm \
              -e DRY_RUN=True \
               --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/ark-sa-server.sh");
             echo $OUTPUT | grep -q "\-NoBattlEye"'

perform_test "EPIC_PUBLIC_IP=192.168.1.2 - --PublicIPforEpic Set to 192.168.1.2" \
             'OUTPUT=$(docker run --rm \
              -e DRY_RUN=True \
              -e EPIC_PUBLIC_IP=192.168.1.2 \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/ark-sa-server.sh");
             echo $OUTPUT | grep -q "\--PublicIPforEpic 192.168.1.2"'

perform_test "EPIC_PUBLIC_IP Not Set - --PublicIPforEpic Flag Is Not Present" \
             'OUTPUT=$(docker run --rm \
              -e DRY_RUN=True \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/ark-sa-server.sh");
             echo $OUTPUT | grep -qv "\--PublicIPforEpic"'

perform_test "MOD_LIST=\"1234,5678\" - -automanagedmods Flag Present With -mods=1234,5678" \
             'OUTPUT=$(docker run --rm \
              -e DRY_RUN=True \
              -e MOD_LIST='1234,5678' \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/ark-sa-server.sh");
             echo $OUTPUT | grep -q "\-automanagedmods \-mods=1234,5678"'

perform_test "MOD_LIST=\"    1234   ,    5678\" - -automanagedmods Flag Present With -mods=1234,5678 (Spaces Removed)" \
             'OUTPUT=$(docker run --rm \
              -e DRY_RUN=True \
              -e MOD_LIST='1234,5678' \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/ark-sa-server.sh");
             echo $OUTPUT | grep -q "\-automanagedmods \-mods=1234,5678"'

 perform_test "MOD_LIST Not Set - Not Mod Flags Present" \
             'OUTPUT=$(docker run --rm \
              -e DRY_RUN=True \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/ark-sa-server.sh");
             echo $OUTPUT | grep -qv "\-automanagedmods" &&\
             echo $OUTPUT | grep -qv "\-mods="'

perform_test "MAX_PLAYERS=25 - Player Count Is 25" \
             'OUTPUT=$(docker run --rm \
              -e DRY_RUN=True \
              -e MAX_PLAYERS=25 \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/ark-sa-server.sh");
             echo $OUTPUT | grep -q "\-WinLiveMaxPlayers=25"'

perform_test "MAX_PLAYERS Not Set - Default Player Count Is 70" \
             'OUTPUT=$(docker run --rm \
              -e DRY_RUN=True \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/ark-sa-server.sh");
             echo $OUTPUT | grep -q "\-WinLiveMaxPlayers=70"'

perform_test "Existing ShooterGame File Are Deleted To Avoid Premature Log Tail" \
            'docker run --rm \
            -e DRY_RUN=True \
            --entrypoint bash \
            johnnyknighten/ark-sa-server:latest \
            -c "mkdir -p /ark-server/server/ShooterGame/Saved/Logs && \
                touch /ark-server/server/ShooterGame/Saved/Logs/ShooterGame.log && \
                /usr/local/bin/ark-sa-server.sh | grep -q "Deleting Old Shooter Logs"  \
                test ! -f /ark-server/server/ShooterGame/Saved/Logs/ShooterGame.log"'

log_failed_tests
