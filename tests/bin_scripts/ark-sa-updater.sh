#!/bin/bash

source ./tests/test_helper_functions.sh

perform_test "SKIP_FILE_VALIDATION=True - Skips Steam Validation" \
             "OUTPUT=\$(docker run --rm \
              -e DRY_RUN=True \
              -e SKIP_FILE_VALIDATION=True \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/ark-sa-updater.sh");
             echo \$OUTPUT | grep -qv 'validate'"

perform_test "SKIP_FILE_VALIDATION=False - Steam Validation Is Performed"  \
             "OUTPUT=\$(docker run --rm \
              -e DRY_RUN=True \
              -e SKIP_FILE_VALIDATION=False \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/ark-sa-updater.sh");
             echo \$OUTPUT | grep -q 'validate'"

log_failed_tests
