#!/usr/bin/env bash

set -e

[[ -z "${DEBUG}" ]] || [[ "${DEBUG,,}" = "false" ]] || [[ "${DEBUG,,}" = "0" ]] || set -x

if [ "$STEAMCMD_VALIDATION_SKIP" = "True" ]; then
   APP_UPDATE_LINE="+app_update $STEAMCMD_ARK_SA_APP_ID"
else
    APP_UPDATE_LINE="+app_update $STEAMCMD_ARK_SA_APP_ID validate"
fi

steamcmd +login anonymous +force_install_dir "$ARK_SERVER_DIR/server" $APP_UPDATE_LINE +quit

"$CONTAINER_BIN_DIR/launch-ark-sa.sh"
