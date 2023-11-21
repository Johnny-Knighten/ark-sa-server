#!/usr/bin/env bash

main() {
  create_required_sub_dirs
  exec /usr/bin/supervisord -c /usr/local/etc/supervisord.conf
}

create_required_sub_dirs() {
  local required_sub_dirs=("server")
  for sub_dir in "${required_sub_dirs[@]}"; do
      if [[ ! -d "${ARK_SERVER_DIR}/${sub_dir}" ]]; then
          mkdir -p "${ARK_SERVER_DIR}/${sub_dir}" || echo "Failed to create directory: ${ARK_SERVER_DIR}/${sub_dir}"
      fi
      chown ark-sa. "${ARK_SERVER_DIR}/${sub_dir}" || echo "Failed setting rights on ${ARK_SERVER_DIR}/${sub_dir}, continuing startup..."
  done
}

main
