#!/bin/bash

source ./tests/test_helper_functions.sh

GAME_SETTINGS_PATH="/ark-server/server/ShooterGame/Saved/Config/WindowsServer/GameUserSettings.ini"
CONFIG_BOOTSTRAP_PATH="/opt/ark-sa-container/bin/ark-sa/config-templating/bootstrap-configs.sh"

perform_test "Ensure Config Templating Script Is Being Launched" \
             'docker run --rm \
              -e DRY_RUN=True \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/ark-sa-bootstrap.sh > /dev/null 2>&1 && \
                test -f $GAME_SETTINGS_PATH"'

perform_test "Server Files Not Present - Download ARK Server" \
             'OUTPUT=$(docker run --rm \
              -e DRY_RUN=True \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/ark-sa-bootstrap.sh");
                echo $OUTPUT | grep -q "No Server Files Found" && \
                echo $OUTPUT | grep -qv "Update On Boot Enabled" && \
                echo $OUTPUT | grep -q "supervisorctl start ark-sa-updater" && \
                echo $OUTPUT | grep -qv "supervisorctl start ark-sa-server"'

perform_test "Server Files Present With Default ARK_UPDATE_ON_BOOT (Default = True)" \
            'OUTPUT=$(docker run --rm \
            -e DRY_RUN=True \
            --entrypoint bash \
            johnnyknighten/ark-sa-server:latest \
            -c "/usr/local/bin/system-bootstrap.sh && \
                touch /ark-server/server/extra_file.txt && \
                /usr/local/bin/ark-sa-bootstrap.sh");
              echo $OUTPUT | grep -qv "No Server Files Found" && \
              echo $OUTPUT | grep -q "Update On Boot Enabled" && \
              echo $OUTPUT | grep -q "supervisorctl start ark-sa-updater" && \
              echo $OUTPUT | grep -qv "supervisorctl start ark-sa-server"'

perform_test "Server Files Present With ARK_UPDATE_ON_BOOT=False" \
            'OUTPUT=$(docker run --rm \
            -e DRY_RUN=True \
            -e ARK_UPDATE_ON_BOOT=False \
            --entrypoint bash \
            johnnyknighten/ark-sa-server:latest \
            -c "/usr/local/bin/system-bootstrap.sh && \
                touch /ark-server/server/extra_file.txt && \
                /usr/local/bin/ark-sa-bootstrap.sh");
              echo $OUTPUT | grep -qv "No Server Files Found" && \
              echo $OUTPUT | grep -q "Update On Boot Disabled" && \
              echo $OUTPUT | grep -qv "supervisorctl start ark-sa-updater" && \
              echo $OUTPUT | grep -q "supervisorctl start ark-sa-server"'

log_failed_tests
