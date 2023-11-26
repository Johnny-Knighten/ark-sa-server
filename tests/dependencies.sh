#!/bin/bash

source ./tests/test_helper_functions.sh

perform_test "Verify SteamCMD is Installed" \
            "docker run --rm \
              --entrypoint steamcmd \
              johnnyknighten/ark-sa-server:latest \
              +quit > /dev/null 2>&1"

perform_test "Verify xvfb is Installed" \
             "docker run --rm \
                --entrypoint xvfb-run \
                johnnyknighten/ark-sa-server:latest \
                -h > /dev/null 2>&1"

perform_test "Verify Supervisor is Installed" \
             "docker run --rm \
                --entrypoint supervisord \
                johnnyknighten/ark-sa-server:latest \
                -v > /dev/null 2>&1"

perform_test "Verify CRON is Installed" \
             'docker run --rm \
                --entrypoint bash \
                johnnyknighten/ark-sa-server:latest \
                -c "echo \"* * * * * test\" > crontab.txt && crontab crontab.txt && crontab -l" > /dev/null 2>&1'

perform_test "Verify tzdata is Installed" \
             'docker run --rm \
                --entrypoint bash \
                johnnyknighten/ark-sa-server:latest \
                -c "cat /usr/share/zoneinfo/tzdata.zi | head -n 1 | grep \"# version 2023c\"" > /dev/null 2>&1'

perform_test "Verify tar is Installed" \
             'docker run --rm \
                --entrypoint tar \
                johnnyknighten/ark-sa-server:latest \
                --version > /dev/null 2>&1'

perform_test "Verify zip is Installed" \
             'docker run --rm \
                --entrypoint zip \
                johnnyknighten/ark-sa-server:latest \
                -v > /dev/null 2>&1'

perform_test "Verify GE's Wine Proton Fork's Directory Exists" \
            "docker run --rm \
              --entrypoint test \
              johnnyknighten/ark-sa-server:latest \
              -d /opt/glorious_eggroll/proton"

perform_test "Verify GE's Wine Proton Fork's Wine Executable Exists" \
             "docker run --rm \
                --entrypoint test \
                johnnyknighten/ark-sa-server:latest \
                -f /opt/glorious_eggroll/proton/bin/wine"

perform_test "Verify ark-sa-container/bin Content is Present" \
            "docker run --rm \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c \"test -f /usr/local/bin/system-bootstrap.sh && \
                  test -f /usr/local/bin/ark-sa-bootstrap.sh && \
                  test -f /usr/local/bin/ark-sa-server.sh && \
                  test -f /usr/local/bin/ark-sa-updater.sh && \
                  test -f /usr/local/bin/ark-sa/config-templating/bootstrap-configs.sh && \
                  test -f /usr/local/bin/ark-sa/config-templating/GameUserSettings.template.ini \""

log_failed_tests
