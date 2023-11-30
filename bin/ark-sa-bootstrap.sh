#!/usr/bin/env bash

set -e

[[ -z "${DEBUG}" ]] || [[ "${DEBUG,,}" = "false" ]] || [[ "${DEBUG,,}" = "0" ]] || set -x

echo "ARK SA Bootstrap - Starting"

main() {
  generate_config_files
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

generate_config_files() {
  mkdir -p "${SERVER_DIR}/ShooterGame/Saved/Config/WindowsServer"

  if [[ ! -f "${SERVER_DIR}/ShooterGame/Saved/Config/WindowsServer/GameUserSettings.ini" || "$MANUAL_CONFIG" != "True" ]]; then
    echo "ARK SA Bootstrap - Generating GameUserSettings.ini"

    export CONFIG_GameUserSettings_SessionSettings_SessionName="${SERVER_NAME}"
    export CONFIG_GameUserSettings_ServerSettings_RCONEnabled="${ENABLE_RCON}"
    export CONFIG_GameUserSettings_ServerSettings_RCONPort="${RCON_PORT}"
    export CONFIG_GameUserSettings_SLASH_Script_SLASH_Engine_DOT_GameSession_MaxPlayers="${MAX_PLAYERS}"
    export CONFIG_GameUserSettings_ServerSettings_ServerPassword="${SERVER_PASSWORD}"
    export CONFIG_GameUserSettings_ServerSettings_ServerAdminPassword="${ADMIN_PASSWORD}"
    export CONFIG_GameUserSettings_ServerSettings_ServerPVE="${ENABLE_PVE}"

    python3 /usr/local/bin/config_from_env_vars/main.py --path "${SERVER_DIR}/ShooterGame/Saved/Config/WindowsServer"
  else
    echo "ARK SA Bootstrap - Skipping GameUserSettings.ini Generation MANAUL_CONFIG is True"
  fi
}

# -eq 1  below because we assume the single config file is generate at this point
check_if_server_files_exist() {
  if [ "$(find "$SERVER_DIR" -mindepth 1 -maxdepth 1 | wc -l)" -eq 1 ]; then
    echo "ARK SA Bootstrap - No Server Files Found, Downloading Server"
    launch_update_service
  fi
}

auto_update_server() {
  if [ "$UPDATE_ON_BOOT" = "True" ]; then
    echo "ARK SA Bootstrap - Update On Boot Enabled"
    launch_update_service
  else
    echo "ARK SA Bootstrap - Update On Boot Disabled, Skipping"
  fi
}

main
