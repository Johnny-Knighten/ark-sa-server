#!/usr/bin/env bash

set -e

[[ -z "${DEBUG}" ]] || [[ "${DEBUG,,}" = "false" ]] || [[ "${DEBUG,,}" = "0" ]] || set -x

echo "System Bootstrap - Starting"

cleanup() {
    supervisorctl stop all
    supervisorctl exit
    echo "System Bootstrap - Stopping" >> /ark-server/logs/system-bootstrap.log
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
  if [[ "$ARK_SCHEDULED_RESTART" = "True" ]]; then
    echo "System Bootstrap - Setting Up Scheduled Restart"
    setup_cron_scheduled_restart >> /usr/local/bin/ark-sa-cron-jobs
  fi

  if [[ "$ARK_SCHEDULED_UPDATE" = "True" ]]; then
    echo "System Bootstrap - Setting Up Scheduled Update"
     setup_cron_scheduled_update >> /usr/local/bin/ark-sa-cron-jobs
  fi

  if [[ -f /usr/local/bin/ark-sa-cron-jobs ]]; then
    echo "System Bootstrap - Updating Crontab"
    crontab /usr/local/bin/ark-sa-cron-jobs
    rm /usr/local/bin/ark-sa-cron-jobs
  fi
}
  
setup_cron_scheduled_restart() {
  echo "$(date) - Server Restart RCON Scheduled For: $ARK_RESTART_CRON" >> /ark-server/logs/cron.log
  echo "$ARK_RESTART_CRON supervisorctl restart ark-sa-server && \
    echo \"\$(date) - CRON Restart - ark-sa-server\" >> /ark-server/logs/cron.log"
}

setup_cron_scheduled_update() {
  echo "$(date) - Server Update Scheduled For: $ARK_UPDATE_CRON" >> /ark-server/logs/cron.log
  echo "$ARK_UPDATE_CRON supervisorctl stop ark-sa-server && supervisorctl start ark-sa-updater && \
    echo \"\$(date) - CRON Update - ark-sa-updater\" >> /ark-server/logs/cron.log"
}

main
