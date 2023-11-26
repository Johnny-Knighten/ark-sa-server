#!/bin/bash

container_termination_handler() {
  trigger_backup
  exit 0
}

trigger_backup() {
  if [[ "$ARK_BACKUP_ON_STOP" = "True" ]]; then
    supervisorctl start ark-sa-backup
  fi
}

trap container_termination_handler SIGTERM

echo "Starting ark-sa-cleanup.sh"

while true; do
  sleep 10
done
