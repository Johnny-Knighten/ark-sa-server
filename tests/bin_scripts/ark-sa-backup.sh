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
              -e ZIP_BACKUPS=True \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "mkdir -p /ark-server/server/ShooterGame/Saved && \
                echo "test" > /ark-server/server/ShooterGame/Saved/test.txt && \
                /usr/local/bin/ark-sa-backup.sh > /dev/null 2>&1 && \
                ls /ark-server/backups/*.zip > /dev/null 2>&1"'

perform_test "Test RETAIN_BACKUPS=2 When There Are Already 5 Backups (Delete Files)" \
             'docker run --rm \
              -e RETAIN_BACKUPS=2 \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "mkdir -p /ark-server/server/ShooterGame/Saved > /dev/null 2>&1 && \
                echo "test" > /ark-server/server/ShooterGame/Saved/test.txt > /dev/null 2>&1 && \
                for i in \$(seq 1 5); do touch /ark-server/backups/testfile\$i.txt; done; \
                /usr/local/bin/ark-sa-backup.sh > /dev/null 2>&1 && \
                test \$(ls /ark-server/backups | wc -l) -eq 2"'

perform_test "Test RETAIN_BACKUPS=6 When There Are Already 5 Backups (No Deletion)" \
             'docker run --rm \
              -e RETAIN_BACKUPS=6 \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "mkdir -p /ark-server/server/ShooterGame/Saved > /dev/null 2>&1 && \
                echo "test" > /ark-server/server/ShooterGame/Saved/test.txt > /dev/null 2>&1 && \
                for i in \$(seq 1 5); do touch /ark-server/backups/testfile\$i.txt; done; \
                /usr/local/bin/ark-sa-backup.sh > /dev/null 2>&1 && \
                test \$(ls /ark-server/backups | wc -l) -eq 6"'

perform_test "Test RETAIN_BACKUPS Is Empty When There Are Already 5 Backups (No Deletion)" \
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

perform_test "Verify .tar.gz Backup Contains Only Saved Contents (Not Full Path)" \
             'docker run --rm \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "mkdir -p /ark-server/server/ShooterGame/Saved/testdir && \
                echo \"test\" > /ark-server/server/ShooterGame/Saved/test.txt && \
                echo \"nested\" > /ark-server/server/ShooterGame/Saved/testdir/nested.txt && \
                /usr/local/bin/ark-sa-backup.sh > /dev/null 2>&1 && \
                BACKUP_FILE=\$(ls /ark-server/backups/*.tar.gz | head -n 1) && \
                tar -tzf \$BACKUP_FILE | head -n 5 | grep -v \"^ark-server\" && \
                tar -tzf \$BACKUP_FILE | grep -q \"^\\./test.txt\" && \
                tar -tzf \$BACKUP_FILE | grep -q \"^\\./testdir/nested.txt\""'

perform_test "Verify .zip Backup Contains Only Saved Contents (Not Full Path)" \
             'docker run --rm \
              -e ZIP_BACKUPS=True \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "mkdir -p /ark-server/server/ShooterGame/Saved/testdir && \
                echo \"test\" > /ark-server/server/ShooterGame/Saved/test.txt && \
                echo \"nested\" > /ark-server/server/ShooterGame/Saved/testdir/nested.txt && \
                /usr/local/bin/ark-sa-backup.sh > /dev/null 2>&1 && \
                BACKUP_FILE=\$(ls /ark-server/backups/*.zip | head -n 1) && \
                unzip -l \$BACKUP_FILE | grep -v \"ark-server\" | grep -q \"\\./test.txt\" && \
                unzip -l \$BACKUP_FILE | grep -q \"\\./testdir/nested.txt\""'

log_failed_tests
