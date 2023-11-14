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
              -c \"test -f /opt/ark-sa-container/bin/docker-entrypoint.sh && \
                  test -f /opt/ark-sa-container/bin/launch-ark-sa.sh && \
                  test -f /opt/ark-sa-container/bin/steam-cmd-install.sh\""
        
log_failed_tests
