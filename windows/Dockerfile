FROM steamcmd/steamcmd:windows-core-2019

LABEL maintainer="https://github.com/Johnny-Knighten"

ENV DEBUG=false \
    CONTAINER_BIN_DIR="C:\\Program Files\\ark-sa-container\\bin" \
    TEST_DRY_RUN=False \
    STEAMCMD_ARK_SA_APP_ID=2430930 \
    STEAMCMD_SKIP_VALIDATION=False \
    ARK_SERVER_DIR="C:\\Program Files\\ark-sa-container\\server" \
    ARK_MAP="TheIsland_WP" \
    ARK_GAME_PORT=7777 \
    ARK_QUERY_PORT=27015 \
    ARK_EXTRA_LAUNCH_OPTIONS= \
    ARK_SERVER_PASSWORD= \
    ARK_SERVER_ADMIN_PASSWORD=adminpassword \
    ARK_ENABLE_RCON=True \
    ARK_RCON_PORT=27020 \
    ARK_MAX_PLAYERS=70  \
    ARK_SERVER_NAME="Ark Server" \
    ARK_PREVENT_AUTO_UPDATE=False \
    ARK_MOD_LIST= \
    ARK_NO_BATTLEYE=True \
    ARK_EPIC_PUBLIC_IP= \
    ARK_MULTI_HOME= \
    ARK_ENABLE_PVE=False
    
COPY bin/ ${CONTAINER_BIN_DIR}

VOLUME [ "${ARK_SERVER_DIR}" ]
WORKDIR ${ARK_SERVER_DIR}

EXPOSE 7777/udp
EXPOSE 7778/udp
EXPOSE 27015/udp
EXPOSE 27020/tcp

ENTRYPOINT ["powershell.exe", "-Command", "& \"C:\\Program Files\\ark-sa-container\\bin\\docker-entrypoint.ps1\""]
CMD []
