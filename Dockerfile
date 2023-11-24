FROM steamcmd/steamcmd:ubuntu-22

LABEL maintainer="https://github.com/Johnny-Knighten"

ARG PGID=0 \
    PUID=0

ENV DEBUG=false \
    DRY_RUN=False \
    TZ=America/New_York \
    STEAMCMD_SKIP_VALIDATION=False \
    PROTON_GE_VAR=wine-lutris \
    PROTON_GE_VER=GE-Proton8-21 \
    PROTON_GE_ARCH=x86_64 \
    ARK_SERVER_DIR="/ark-server" \
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
    ARK_UPDATE_ON_BOOT=True \
    ARK_MOD_LIST= \
    ARK_NO_BATTLEYE=True \
    ARK_EPIC_PUBLIC_IP= \
    ARK_MULTI_HOME= \
    ARK_ENABLE_PVE=False \
    ARK_REBUILD_CONFIG=False \
    ARK_SCHEDULED_RESTART=False \
    ARK_RESTART_CRON="0 4 * * *" \
    ARK_SCHEDULED_UPDATE=False \
    ARK_UPDATE_CRON="0 5 * * 0"

RUN set -x && \
    apt-get update && \
    apt-get install --no-install-recommends -y  \
                        wget=1.21.2-2ubuntu1 \
                        xz-utils=5.2.5-2ubuntu1 \
                        xvfb=2:21.1.4-2ubuntu1.7~22.04.2 \
                        supervisor=4.2.1-1ubuntu1 \
                        cron=3.0pl1-137ubuntu3 \
                        tzdata=2023c-0ubuntu0.22.04.2 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/glorious_eggroll
RUN PROTON_GE_FILE="$PROTON_GE_VAR-$PROTON_GE_VER-$PROTON_GE_ARCH" && \
    wget -q "https://github.com/GloriousEggroll/wine-ge-custom/releases/download/$PROTON_GE_VER/$PROTON_GE_FILE.tar.xz" && \
    tar -xvf "$PROTON_GE_FILE.tar.xz" && \
    mkdir -p ~/.proton && \
    mv "lutris-$PROTON_GE_VER-$PROTON_GE_ARCH" ./proton && \
    rm -r "$PROTON_GE_FILE.tar.xz"

RUN groupadd -g "$PGID" -o ark-sa && \
    useradd -l -g "$PGID" -u "$PUID" -o --create-home ark-sa && \
    usermod -a -G crontab ark-sa

COPY bin/ /usr/local/bin
COPY supervisord.conf /usr/local/etc/supervisord.conf
RUN ["chmod", "-R", "+x", "/usr/local/bin"]

VOLUME [ "${ARK_SERVER_DIR}" ]
WORKDIR ${ARK_SERVER_DIR}

EXPOSE 7777/udp
EXPOSE 7778/udp
EXPOSE 27015/udp
EXPOSE 27020/tcp

ENTRYPOINT ["/usr/local/bin/system-bootstrap.sh"]
CMD []
