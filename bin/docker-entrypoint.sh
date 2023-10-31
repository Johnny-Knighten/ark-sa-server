#!/usr/bin/env bash

set -e

[[ -z "${DEBUG}" ]] || [[ "${DEBUG,,}" = "false" ]] || [[ "${DEBUG,,}" = "0" ]] || set -x

required_sub_dirs=("server")

for sub_dir in "${required_sub_dirs[@]}"; do
    if [[ ! -d "${ARK_SERVER_DIR}/${sub_dir}" ]]; then
        mkdir -p "${ARK_SERVER_DIR}/${sub_dir}" || echo "Failed to create directory: ${ARK_SERVER_DIR}/${sub_dir}"
    fi
    chown "${CONTAINER_USER}". "${ARK_SERVER_DIR}/${sub_dir}" || echo "Failed setting rights on ${ARK_SERVER_DIR}/${sub_dir}, continuing startup..."
done

"$CONTAINER_BIN_DIR/steam-cmd-install.sh"
