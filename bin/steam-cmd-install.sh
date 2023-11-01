#!/usr/bin/env bash

set -e

[[ -z "${DEBUG}" ]] || [[ "${DEBUG,,}" = "false" ]] || [[ "${DEBUG,,}" = "0" ]] || set -x

if [ "$STEAMCMD_SKIP_VALIDATION" = "True" ]; then
    echo "SteamCMD Will Not Validate Ark SA Server Files"
    APP_UPDATE_LINE="+app_update $STEAMCMD_ARK_SA_APP_ID"
else
    echo "SteamCMD Will Validate Ark SA Server Files"
    APP_UPDATE_LINE="+app_update $STEAMCMD_ARK_SA_APP_ID validate"
fi

# run steamcmd if ARK_PREVENT_AUTO_UPDATE is not "True" OR if install directory is empty
if [[ "$ARK_PREVENT_AUTO_UPDATE" != "True" ]] || [[ -z "$(ls -A "$ARK_SERVER_DIR/server")" ]]; then
    steamcmd +login anonymous +force_install_dir "$ARK_SERVER_DIR/server" $APP_UPDATE_LINE +quit
else
    echo "Skipping Auto-Update of Ark SA Server"
fi

"$CONTAINER_BIN_DIR/launch-ark-sa.sh"
