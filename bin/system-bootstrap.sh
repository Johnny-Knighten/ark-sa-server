#!/usr/bin/env bash

set -e

[[ -z "${DEBUG}" ]] || [[ "${DEBUG,,}" = "false" ]] || [[ "${DEBUG,,}" = "0" ]] || set -x

echo "System Bootstrap - Starting"

cleanup() {
    echo "System Bootstrap - Cleanup Starting"
    supervisorctl stop all
    supervisorctl start ark-sa-backup
    wait_for_backup_completion
    supervisorctl exit
    echo "System Bootstrap - Cleanup Stopping"
}

main() {
  setup_cron_jobs
  if [[ "$DRY_RUN" = "True" ]]; then
    echo "DRY_RUN - exec /usr/bin/supervisord -c /usr/local/etc/supervisord.conf"
  else
    trap 'cleanup' SIGTERM
    /usr/bin/supervisord -c /usr/local/etc/supervisord.conf &
    wait $!
  fi
}

setup_cron_jobs() {
  if [[ "$SCHEDULED_RESTART" = "True" ]]; then
    if [[ "$BACKUP_ON_SCHEDULED_RESTART" = "True" ]]; then
      echo "System Bootstrap - Setting Up Scheduled Restart With Backup"
      setup_cron_scheduled_restart_with_backup >> /usr/local/bin/ark-sa-cron-jobs
    else
      echo "System Bootstrap - Setting Up Scheduled Restart"
      setup_cron_scheduled_restart >> /usr/local/bin/ark-sa-cron-jobs
    fi
  fi

  if [[ "$SCHEDULED_UPDATE" = "True" ]]; then
    if [[ "$BACKUP_BEFORE_UPDATE" = "True" ]]; then
      echo "System Bootstrap - Setting Up Scheduled Update With Backup"
      setup_cron_scheduled_update_with_backup >> /usr/local/bin/ark-sa-cron-jobs
    else
      echo "System Bootstrap - Setting Up Scheduled Update"
      setup_cron_scheduled_update >> /usr/local/bin/ark-sa-cron-jobs
    fi
  fi

  if [[ "$SCHEDULED_BACKUP" = "True" ]]; then
    echo "System Bootstrap - Setting Up Scheduled Backup"
    setup_cron_scheduled_backup >> /usr/local/bin/ark-sa-cron-jobs
  fi

  if [[ -f /usr/local/bin/ark-sa-cron-jobs ]]; then
    echo "System Bootstrap - Updating Crontab"
    crontab /usr/local/bin/ark-sa-cron-jobs
    rm /usr/local/bin/ark-sa-cron-jobs
  fi
}
  
setup_cron_scheduled_restart() {
  echo "$(date) - Server Restart CRON Scheduled For: $RESTART_CRON" >> /ark-server/logs/cron.log
  echo "$RESTART_CRON supervisorctl restart ark-sa-server && \
    echo \"\$(date) - CRON Restart - ark-sa-server\" >> /ark-server/logs/cron.log"
}

setup_cron_scheduled_restart_with_backup() {
  echo "$(date) - Server Restart and Backup CRON Scheduled For: $RESTART_CRON" >> /ark-server/logs/cron.log
  echo "$RESTART_CRON supervisorctl stop ark-sa-server && supervisorctl start ark-sa-backup-and-restart &&\
    echo \"\$(date) - CRON Restart + Backup - ark-sa-server\" >> /ark-server/logs/cron.log"
}

setup_cron_scheduled_update() {
  echo "$(date) - Server Update Scheduled For: $UPDATE_CRON" >> /ark-server/logs/cron.log
  echo "$UPDATE_CRON supervisorctl stop ark-sa-server && supervisorctl start ark-sa-updater && \
    echo \"\$(date) - CRON Update - ark-sa-updater\" >> /ark-server/logs/cron.log"
}

setup_cron_scheduled_update_with_backup() {
  echo "$(date) - Server Update and Backup Scheduled For: $UPDATE_CRON" >> /ark-server/logs/cron.log
  echo "$UPDATE_CRON supervisorctl stop ark-sa-server && supervisorctl start ark-sa-backup-and-update && \
    echo \"\$(date) - CRON Update + Backup - ark-sa-updater\" >> /ark-server/logs/cron.log"
}

setup_cron_scheduled_backup() {
  echo "$(date) - Server Backup Scheduled For: $BACKUP_CRON" >> /ark-server/logs/cron.log
  echo "$BACKUP_CRON supervisorctl stop ark-sa-server && supervisorctl start ark-sa-backup-and-restart && \
    echo \"\$(date) - CRON Backup - ark-sa-backup\" >> /ark-server/logs/cron.log"
}

wait_for_backup_completion() {
  local counter=0
  local max_wait_time=600 

  while true; do
    local status
    status=$(supervisorctl status ark-sa-backup)
    if [[ "$status" == *"RUNNING"* ]] || [[ "$status" == *"STARTING"* ]]; then
      echo "System Bootstrap - Waiting For Backup Process To Finish."
    elif [[ "$status" == *"STOPPED"* ]] || [[ "$status" == *"EXITED"* ]] || [[ "$status" == *"FATAL"* ]]; then
      echo "System Bootstrap - Backup Process Has Finished"
    fi

    sleep 5
    ((counter += 5))

    if [[ "$counter" -ge "$max_wait_time" ]]; then
      echo "System Bootstrap - Timeout Duration Exceeded, Closing Supervisor Without Complete Backup"
      break
    fi
  done
}

main
