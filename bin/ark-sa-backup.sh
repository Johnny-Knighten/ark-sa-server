#!/usr/bin/env bash

set -e

[[ -z "${DEBUG}" ]] || [[ "${DEBUG,,}" = "false" ]] || [[ "${DEBUG,,}" = "0" ]] || set -x

echo "Backup Process - Starting"

main() {
  backup_ark_sa_server
}

backup_ark_sa_server() {
  echo "Backup Process - Backing Up Ark SA Server"
  if [[ "$DRY_RUN" = "True" ]]; then
    echo "DRY_RUN - tar -czf ${ARK_BACKUPS_DIR}/server-backup-$(date +%Y%m%d%H%M%S).tar.gz ${ARK_SERVER_DIR}/ShooterGame/Saved"
  else
    tar -czf "${ARK_BACKUPS_DIR}"/ark-sa-server-$(date +%Y%m%d%H%M%S).tar.gz "${ARK_SERVER_DIR}"/ShooterGame/Saved
  fi
  echo "Backup Process - Backup Finished"
}

main
