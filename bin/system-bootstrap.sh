#!/usr/bin/env bash

set -e

[[ -z "${DEBUG}" ]] || [[ "${DEBUG,,}" = "false" ]] || [[ "${DEBUG,,}" = "0" ]] || set -x

echo "System Bootstrap - Starting"

main() {
  setup_cron_jobs
  exec /usr/bin/supervisord -c /usr/local/etc/supervisord.conf
}

create_required_sub_dirs() {
  local required_sub_dirs=("server" "logs")
  for sub_dir in "${required_sub_dirs[@]}"; do
      if [[ ! -d "${ARK_SERVER_DIR}/${sub_dir}" ]]; then
          mkdir -p "${ARK_SERVER_DIR}/${sub_dir}" || echo "System Bootstrap - Failed to create directory: ${ARK_SERVER_DIR}/${sub_dir}"
      fi
      chown ark-sa. "${ARK_SERVER_DIR}/${sub_dir}" || echo "System Bootstrap - Failed setting rights on ${ARK_SERVER_DIR}/${sub_dir}, continuing startup..."
  done
}

setup_cron_jobs() {
  if [[ "$ARK_SCHEDULED_RESTART" = "True" ]]; then
    echo "System Bootstrap - Setting Up Scheduled Restart"
    setup_cron_scheduled_restart
  fi

  if [[ "$ARK_SCHEDULED_UPDATE" = "True" ]]; then
    echo "System Bootstrap - Setting Up Scheduled Update"
    setp_cron_scheduled_update
  fi
}

setup_cron_scheduled_restart() {
  echo "$(date) - Server Restart RCON Scheduled For: $ARK_RESTART_CRON" >> /ark-server/logs/cron.log
  echo "$ARK_RESTART_CRON supervisorctl restart ark-sa-server && \
    echo \"\$(date) - CRON Restart - ark-sa-server\" >> /ark-server/logs/cron.log" \
    > /usr/local/bin/ark-sa-restart-crontab
  crontab /usr/local/bin/ark-sa-restart-crontab
  rm /usr/local/bin/ark-sa-restart-crontab
}

setp_cron_scheduled_update() {
  echo "$(date) - Server Update Scheduled For: $ARK_UPDATE_CRON" >> /ark-server/logs/cron.log
  echo "$ARK_UPDATE_CRON supervisorctl stop ark-sa-server && supervisorctl start ark-sa-updater && \
    echo \"\$(date) - CRON Update - ark-sa-updater\" >> /ark-server/logs/cron.log" \
    > /usr/local/bin/ark-sa-update-crontab
  crontab /usr/local/bin/ark-sa-update-crontab
  rm /usr/local/bin/ark-sa-update-crontab
}

main
