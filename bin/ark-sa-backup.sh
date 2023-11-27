#!/usr/bin/env bash

set -e

[[ -z "${DEBUG}" ]] || [[ "${DEBUG,,}" = "false" ]] || [[ "${DEBUG,,}" = "0" ]] || set -x

echo "Backup Process - Starting"

SCRIPT_PARAM="$1"

main() {
  clean_up_backups_dir
  backup_ark_sa_server
  start_ark_sa_server
  start_ark_sa_update
}

start_ark_sa_server() {
  if [[ "$SCRIPT_PARAM" = "restart" ]]; then
     echo "Backup Process - Starting Ark SA Server After Backup"
    if [[ "$DRY_RUN" = "True" ]]; then
      echo "DRY_RUN - supervisorctl start ark-sa-server"
    else
      supervisorctl start ark-sa-server
    fi
  fi
}

start_ark_sa_update() {
  if [[ "$SCRIPT_PARAM" = "update" ]]; then
    echo "Backup Process - Starting Ark SA Update After Backup"
    if [[ "$DRY_RUN" = "True" ]]; then
      echo "DRY_RUN - supervisorctl start ark-sa-updater"
    else
      supervisorctl start ark-sa-updater
    fi
  fi
}

zip_backup() {
if [[ "$DRY_RUN" = "True" ]]; then
    echo "DRY_RUN - zip -r \"${ARK_BACKUPS_DIR}/ark-sa-server-$(date +%Y%m%d%H%M%S).zip\" \"${ARK_SERVER_DIR}/ShooterGame/Saved\""
  else
    zip -r "${ARK_BACKUPS_DIR}/ark-sa-server-$(date +%Y%m%d%H%M%S).zip" "${ARK_SERVER_DIR}/ShooterGame/Saved"
  fi
}

tar_gz_backup() {
  if [[ "$DRY_RUN" = "True" ]]; then
    echo "DRY_RUN - tar -czf \"${ARK_BACKUPS_DIR}/server-backup-$(date +%Y%m%d%H%M%S).tar.gz\" \"${ARK_SERVER_DIR}/ShooterGame/Saved\""
  else
    tar -czf "${ARK_BACKUPS_DIR}"/ark-sa-server-$(date +%Y%m%d%H%M%S).tar.gz "${ARK_SERVER_DIR}"/ShooterGame/Saved
  fi
}

backup_ark_sa_server() {
  echo "Backup Process - Backing Up Ark SA Server"
  if [[ "$ARK_ZIP_BACKUPS" = "True" ]]; then
    zip_backup
  else
    tar_gz_backup
  fi
  echo "Backup Process - Backup Finished"
}

clean_up_backups_dir() {
  if [[ -n "$ARK_NUMBER_OF_BACKUPS" ]]; then
    echo "Backup Process - Cleaning Up Backup Directory"
    count_files() {
      find "$ARK_BACKUPS_DIR" -type f | wc -l
    }

    delete_oldest_file() {
        find "$ARK_BACKUPS_DIR" -type f -print0 | xargs -0 ls -tr | head -n 1 | xargs rm -f
    }

    current_file_count=$(count_files)

    while [ "$current_file_count" -gt "$((ARK_NUMBER_OF_BACKUPS - 1))" ]; do
        echo "Backup Process - File Limit Exceded: ($current_file_count),  Deleting Oldest"
        delete_oldest_file
        current_file_count=$(count_files)
    done

    echo "Backup Process - File Count Post Cleanup: $(count_files)"
  fi
}

main
