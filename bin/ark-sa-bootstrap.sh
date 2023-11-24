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
  if [[ "$DRY_RUN" = "True" ]]; then
    echo "DRY_RUN - supervisorctl start ark-sa-server"
  else
    supervisorctl start ark-sa-server
  fi
}

launch_update_service() {
  echo "ARK SA Bootstrap - Launching Updater Service"
  if [[ "$DRY_RUN" = "True" ]]; then
    echo "DRY_RUN - supervisorctl start ark-sa-updater"
  else
    supervisorctl start ark-sa-updater
  fi
  exit 0
}

create_config_from_template() {
  /usr/local/bin/ark-sa/config-templating/bootstrap-configs.sh
}

# -eq 1  below because we assume the single config file is generate at this point
check_if_server_files_exist() {
  if [ "$(find "$ARK_SERVER_DIR"/server -mindepth 1 -maxdepth 1 | wc -l)" -eq 1 ]; then
    echo "ARK SA Bootstrap - No Server Files Found, Downloading Server"
    launch_update_service
  fi
}

auto_update_server() {
  if [ "$ARK_UPDATE_ON_BOOT" = "True" ]; then
    echo "ARK SA Bootstrap - Update On Boot Enabled"
    launch_update_service
  else
    echo "ARK SA Bootstrap - Update On Boot Disabled, Skipping"
  fi
}

main
