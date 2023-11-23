#!/usr/bin/env bash

set -e

[[ -z "${DEBUG}" ]] || [[ "${DEBUG,,}" = "false" ]] || [[ "${DEBUG,,}" = "0" ]] || set -x

echo "ARK SA Bootstrap - Starting"

main() {
  create_config_from_template
  check_if_server_files_exist
  auto_update_server
  launch_ark_sa_server
}

launch_ark_sa_server() {
  echo "ARK SA Bootstrap - Launching Ark SA Server"
  supervisorctl start ark-sa-server
}

launch_update_service() {
  echo "ARK SA Bootstrap - Launching Updater Service"
  supervisorctl start ark-sa-updater
}

create_config_from_template() {
  /usr/local/bin/ark-sa/config-templating/bootstrap-configs.sh
}

check_if_server_files_exist() {
  if [ "$(find "$ARK_SERVER_DIR"/server -mindepth 1 -maxdepth 1 | wc -l)" -eq 0 ]; then
    echo "ARK SA Bootstrap - No Server Files Found, Downloading Server"
    launch_update_service
    exit 0
  fi
}

auto_update_server() {
  if [ "$ARK_UPDATE_ON_BOOT" = "True" ]; then
    echo "ARK SA Bootstrap - Update On Boot Enabled"
    launch_update_service
    exit 0
  else
    echo "ARK SA Bootstrap - Update On Boot Disabled, Skipping"
  fi
}

main
