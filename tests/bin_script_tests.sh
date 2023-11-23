#!/bin/bash

source ./tests/test_helper_functions.sh

###########################
# ark-sa-updater.sh Tests #
###########################

BIN_PATH="/usr/local/bin"

perform_test "STEAMCMD_SKIP_VALIDATION=True - Skips Steam Validation" \
             "OUTPUT=\$(docker run --rm \
              -e DRY_RUN=True \
              -e STEAMCMD_SKIP_VALIDATION=True \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/ark-sa-updater.sh");
             echo \$OUTPUT | grep -qv 'validate'"

perform_test "STEAMCMD_SKIP_VALIDATION=False - Steam Validation Is Performed"  \
             "OUTPUT=\$(docker run --rm \
              -e DRY_RUN=True \
              -e STEAMCMD_SKIP_VALIDATION=False \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/ark-sa-updater.sh");
             echo \$OUTPUT | grep -q 'validate'"

log_failed_tests
