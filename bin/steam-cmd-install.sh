#!/usr/bin/env bash

set -e

[[ -z "${DEBUG}" ]] || [[ "${DEBUG,,}" = "false" ]] || [[ "${DEBUG,,}" = "0" ]] || set -x

steamcmd +login anonymous +force_install_dir $ARK_SERVER_DIR/server +app_update $STEAMCMD_ARK_SA_APP_ID validate +quit

"$CONTAINER_BIN_DIR/launch-ark-sa.sh"
