#!/bin/bash

source ./tests/test_helper_functions.sh

perform_test "Verify Required Directories Are Created" \
             'docker run --rm \
              -e DRY_RUN=True \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/system-bootstrap.sh > /dev/null 2>&1 && \
                  test -d /ark-server/server && \
                  test -d /ark-server/logs"'

perform_test "Verify Default Scheduled Restart CRON Job" \
             'docker run --rm \
              -e DRY_RUN=True \
              -e ARK_SCHEDULED_RESTART=True \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/system-bootstrap.sh > /dev/null 2>&1 &&
               crontab -l | grep -q \"0 4 \* \* \*\""'

perform_test "Verify No Scheduled CRON If ARK_SCHEDULED_RESTART=False" \
             'docker run --rm \
              -e DRY_RUN=True \
              -e ARK_SCHEDULED_RESTART=False \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/system-bootstrap.sh > /dev/null 2>&1 &&
               ! crontab -l"'

perform_test "Verify Restart CRON Job Scheduled Correctly" \
             'docker run --rm \
              -e DRY_RUN=True \
              -e ARK_SCHEDULED_RESTART=True \
              -e ARK_RESTART_CRON="10 * * * *" \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/system-bootstrap.sh > /dev/null 2>&1 &&
               crontab -l | grep -q \"10 \* \* \* \*\""'

perform_test "Verify Default Scheduled Update CRON Job" \
             'docker run --rm \
              -e DRY_RUN=True \
              -e ARK_SCHEDULED_UPDATE=True \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/system-bootstrap.sh > /dev/null 2>&1 && 
              crontab -l | grep -q \"0 5 \* \* 0\""'

perform_test "Verify No Scheduled CRON If ARK_SCHEDULED_UPDATE=False" \
             'docker run --rm \
              -e DRY_RUN=True \
              -e ARK_SCHEDULED_UPDATE=False \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/system-bootstrap.sh > /dev/null 2>&1 &&
               ! crontab -l"'

perform_test "Verify Update CRON Job Scheduled Correctly" \
             'docker run --rm \
              -e DRY_RUN=True \
              -e ARK_SCHEDULED_UPDATE=True \
              -e ARK_UPDATE_CRON="10 * * * *" \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/system-bootstrap.sh > /dev/null 2>&1 &&
               crontab -l | grep -q \"10 \* \* \* \*\""'

perform_test "Verify Both Update and Restart Van Be Scheduled Together" \
             'docker run --rm \
              -e DRY_RUN=True \
              -e ARK_SCHEDULED_RESTART=True \
              -e ARK_SCHEDULED_UPDATE=True \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/system-bootstrap.sh > /dev/null 2>&1 && 
              crontab -l | grep -q \"0 5 \* \* 0\" && \
              crontab -l | grep -q \"0 4 \* \* \*\""'

perform_test "Verify Command To Launch Supervisord Would Have Been Called" \
             'OUTPUT=$(docker run --rm \
              -e DRY_RUN=True \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/system-bootstrap.sh");
             echo $OUTPUT | grep -q "exec /usr/bin/supervisord -c /usr/local/etc/supervisord.conf"'

log_failed_tests
