#!/usr/bin/env bash

echo "Starting Ark Server Bootstrap..."


main() {
  create_config_from_template
  supervisorctl start ark-sa-server
  exit 0
}

create_config_from_template() {
  /usr/local/bin/ark-sa/config-templating/bootstrap-configs.sh
}

main
