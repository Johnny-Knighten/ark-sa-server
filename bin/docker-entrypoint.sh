#!/usr/bin/env bash

set -e

handle_steam_cmd_install_error() {
    echo "An error occurred in steam-cmd-install.sh"
    exit 1
}

handle_ark_sa_config_bootstrap_error() {
    echo "An error occurred in ark-sa/config-templating/bootstrap-configs.sh"
    exit 1
}

handle_launch_ark_sa_error() {
    echo "An error occurred in launch-ark-sa.sh"
    exit 1
}

[[ -z "${DEBUG}" ]] || [[ "${DEBUG,,}" = "false" ]] || [[ "${DEBUG,,}" = "0" ]] || set -x

required_sub_dirs=("server")

for sub_dir in "${required_sub_dirs[@]}"; do
    if [[ ! -d "${ARK_SERVER_DIR}/${sub_dir}" ]]; then
        mkdir -p "${ARK_SERVER_DIR}/${sub_dir}" || echo "Failed to create directory: ${ARK_SERVER_DIR}/${sub_dir}"
    fi
    chown "${CONTAINER_USER}". "${ARK_SERVER_DIR}/${sub_dir}" || echo "Failed setting rights on ${ARK_SERVER_DIR}/${sub_dir}, continuing startup..."
done

trap 'handle_steam_cmd_install_error' ERR
"$CONTAINER_BIN_DIR/steam-cmd-install.sh"
trap - ERR

trap 'handle_ark_sa_config_bootstrap_error' ERR
"$CONTAINER_BIN_DIR/ark-sa/config-templating/bootstrap-configs.sh"
trap - ERR

trap 'handle_launch_ark_sa_error' ERR
"$CONTAINER_BIN_DIR/launch-ark-sa.sh"
trap - ERR
