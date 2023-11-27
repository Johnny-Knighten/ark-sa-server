#!/bin/bash

source ./tests/test_helper_functions.sh

perform_test "Verify Backup Is Created With Defaults (.tar.gz)" \
             'docker run --rm \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "mkdir -p /ark-server/server/ShooterGame/Saved && \
                echo "test" > /ark-server/server/ShooterGame/Saved/test.txt && \
                /usr/local/bin/ark-sa-backup.sh > /dev/null 2>&1 && \
                ls /ark-server/backups/*.tar.gz > /dev/null 2>&1"'

perform_test "Verify Backup Is Created With Defaults (.zip)" \
             'docker run --rm \
              -e ARK_ZIP_BACKUPS=True \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "mkdir -p /ark-server/server/ShooterGame/Saved && \
                echo "test" > /ark-server/server/ShooterGame/Saved/test.txt && \
                /usr/local/bin/ark-sa-backup.sh > /dev/null 2>&1 && \
                ls /ark-server/backups/*.zip > /dev/null 2>&1"'

perform_test "Test ARK_NUMBER_OF_BACKUPS=2 When There Are Already 5 Backups (Delete Files)" \
             'docker run --rm \
              -e ARK_NUMBER_OF_BACKUPS=2 \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "mkdir -p /ark-server/server/ShooterGame/Saved > /dev/null 2>&1 && \
                echo "test" > /ark-server/server/ShooterGame/Saved/test.txt > /dev/null 2>&1 && \
                for i in \$(seq 1 5); do touch /ark-server/backups/testfile\$i.txt; done; \
                /usr/local/bin/ark-sa-backup.sh > /dev/null 2>&1 && \
                test \$(ls /ark-server/backups | wc -l) -eq 2"'

perform_test "Test ARK_NUMBER_OF_BACKUPS=6 When There Are Already 5 Backups (No Deletion)" \
             'docker run --rm \
              -e ARK_NUMBER_OF_BACKUPS=6 \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "mkdir -p /ark-server/server/ShooterGame/Saved > /dev/null 2>&1 && \
                echo "test" > /ark-server/server/ShooterGame/Saved/test.txt > /dev/null 2>&1 && \
                for i in \$(seq 1 5); do touch /ark-server/backups/testfile\$i.txt; done; \
                /usr/local/bin/ark-sa-backup.sh > /dev/null 2>&1 && \
                test \$(ls /ark-server/backups | wc -l) -eq 6"'

perform_test "Test ARK_NUMBER_OF_BACKUPS Is Empty When There Are Already 5 Backups (No Deletion)" \
             'docker run --rm \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "mkdir -p /ark-server/server/ShooterGame/Saved > /dev/null 2>&1 && \
                echo "test" > /ark-server/server/ShooterGame/Saved/test.txt > /dev/null 2>&1 && \
                for i in \$(seq 1 5); do touch /ark-server/backups/testfile\$i.txt; done; \
                /usr/local/bin/ark-sa-backup.sh > /dev/null 2>&1 && \
                test \$(ls /ark-server/backups | wc -l) -eq 6"'

perform_test "Verify ark-sa-server Is Launched When 'restart' Is Passed To The Script" \
             'OUTPUT=$(docker run --rm \
              -e DRY_RUN=True \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/ark-sa-backup.sh restart");
             echo $OUTPUT | grep -q "supervisorctl start ark-sa-server"'

perform_test "Verify ark-sa-updater Is Launched When 'update' Is Passed To The Script" \
             'OUTPUT=$(docker run --rm \
              -e DRY_RUN=True \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "/usr/local/bin/ark-sa-backup.sh update");
             echo $OUTPUT | grep -q "supervisorctl start ark-sa-updater"'

log_failed_tests
