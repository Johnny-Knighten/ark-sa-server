#!/usr/bin/env bash

echo "Starting Ark Server Bootstrap..."

main() {
  create_config_from_template
  check_if_server_files_exist
  auto_update_server
  launch_ark_sa_server
}

launch_ark_sa_server() {
  echo "Launching Ark SA Server"
  supervisorctl start ark-sa-server
}

launch_update_service() {
  echo "Launching Updater Service"
  supervisorctl start ark-sa-updater
}

create_config_from_template() {
  /usr/local/bin/ark-sa/config-templating/bootstrap-configs.sh
}

check_if_server_files_exist() {
  if [ "$(find "$ARK_SERVER_DIR"/server -mindepth 1 -maxdepth 1 | wc -l)" -eq 0 ]; then
    echo "No Server Files Found, Downloading Server"
    launch_update_service
    exit 0
  fi
}

auto_update_server() {
  if [ "$ARK_PREVENT_AUTO_UPDATE" != "True" ]; then
    echo "Checking Updating Ark SA Server"
    launch_update_service
    exit 0
  else
    echo "Skipping Update of Ark SA Server"
  fi
}

main
