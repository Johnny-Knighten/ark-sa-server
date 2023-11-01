FROM steamcmd/steamcmd:ubuntu-22

LABEL MAINTAINER="https://github.com/Johnny-Knighten"

ENV DEBUG=false \
    CONTAINER_BIN_DIR="/opt/ark-sa-container/bin" \
    STEAMCMD_ARK_SA_APP_ID=2430930 \
    STEAMCMD_SKIP_VALIDATION=False \
    PROTON_GE_VAR=wine-lutris \
    PROTON_GE_VER=GE-Proton8-21 \
    PROTON_GE_ARCH=x86_64 \
    ARK_SERVER_DIR="/ark-server" \
    ARK_MAP="TheIsland_WP" \
    ARK_GAME_PORT=7777 \
    ARK_QUERY_PORT=27015 \
    ARK_LAUNCH_OPTIONS="-log -NoBattlEye" \
    ARK_PUBLIC_SERVER=False \
    ARK_SERVER_PASSWORD=password \
    ARK_SERVER_ADMIN_PASSWORD=adminpassword \
    ARK_ENABLE_RCON=True \
    ARK_RCON_PORT=27020 \
    ARK_MAX_PLAYERS=70  \
    ARK_SERVER_NAME="Ark Server" \
    ARK_PREVENT_AUTO_UPDATE=False
    
RUN set -x && \
    apt-get update && \
    apt-get install -y  wget \
                        xz-utils \
                        xvfb && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/glorious_eggroll
RUN PROTON_GE_FILE="$PROTON_GE_VAR-$PROTON_GE_VER-$PROTON_GE_ARCH" && \
    wget "https://github.com/GloriousEggroll/wine-ge-custom/releases/download/$PROTON_GE_VER/$PROTON_GE_FILE.tar.xz" && \
    tar -xvf "$PROTON_GE_FILE.tar.xz" && \
    mkdir -p ~/.proton && \
    mv "lutris-$PROTON_GE_VER-$PROTON_GE_ARCH" ./proton && \
    rm -r "$PROTON_GE_FILE.tar.xz"
   
COPY bin/ ${CONTAINER_BIN_DIR}

VOLUME [ "${ARK_SERVER_DIR}" ]
WORKDIR ${ARK_SERVER_DIR}

EXPOSE 7777/udp
EXPOSE 7778/udp
EXPOSE 27015/udp
EXPOSE 27020/tcp

ENTRYPOINT "${CONTAINER_BIN_DIR}/docker-entrypoint.sh"
CMD []
