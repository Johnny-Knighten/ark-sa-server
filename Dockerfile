FROM steamcmd/steamcmd:ubuntu-22

LABEL maintainer="https://github.com/Johnny-Knighten"

ARG PGID=0 \
    PUID=0 \
    PROTON_GE_VAR=wine-lutris \
    PROTON_GE_VER=GE-Proton8-21 \
    PROTON_GE_ARCH=x86_64

ENV DEBUG=False \
    DRY_RUN=False \
    TZ=America/New_York \
    SKIP_FILE_VALIDATION=False \
    SERVER_DIR="/ark-server/server" \
    BACKUPS_DIR="/ark-server/backups" \
    LOGS_DIR="/ark-server/logs" \
    MAP="TheIsland_WP" \
    GAME_PORT=7777 \
    QUERY_PORT=27015 \
    EXTRA_LAUNCH_OPTIONS= \
    SERVER_PASSWORD= \
    ADMIN_PASSWORD=adminpassword \
    ENABLE_RCON=True \
    RCON_PORT=27020 \
    MAX_PLAYERS=70  \
    SERVER_NAME="Ark Server" \
    UPDATE_ON_BOOT=True \
    MOD_LIST= \
    NO_BATTLEYE=True \
    EPIC_PUBLIC_IP= \
    MULTI_HOME= \
    ENABLE_PVE=False \
    SCHEDULED_RESTART=False \
    BACKUP_ON_SCHEDULED_RESTART=False \
    RESTART_CRON="0 4 * * *" \
    SCHEDULED_UPDATE=False \
    BACKUP_BEFORE_UPDATE=False \
    UPDATE_CRON="0 5 * * 0" \
    BACKUP_ON_STOP=True \
    SCHEDULED_BACKUP=False \
    BACKUP_CRON="0 6 * * *" \
    ZIP_BACKUPS=False \
    RETAIN_BACKUPS=

RUN set -x && \
    apt-get update && \
    apt-get install --no-install-recommends -y  \
                        wget=1.21.2-2ubuntu1 \
                        xz-utils=5.2.5-2ubuntu1 \
                        xvfb=2:21.1.4-2ubuntu1.7~22.04.2 \
                        supervisor=4.2.1-1ubuntu1 \
                        cron=3.0pl1-137ubuntu3 \
                        tzdata=2023c-0ubuntu0.22.04.2 \
                        zip=3.0-12build2 \
                        unzip=6.0-26ubuntu3.1 \
                        python3=3.10.6-1~22.04 && \
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
COPY config_from_env_vars/ /usr/local/bin/config_from_env_vars
COPY supervisord.conf /usr/local/etc/supervisord.conf
RUN ["chmod", "-R", "+x", "/usr/local/bin"]


VOLUME [ "${SERVER_DIR}" ]
VOLUME [ "${BACKUPS_DIR}" ]
VOLUME [ "${LOGS_DIR}" ]

WORKDIR ${SERVER_DIR}

EXPOSE 7777/udp
EXPOSE 7778/udp
EXPOSE 27015/udp
EXPOSE 27020/tcp

ENTRYPOINT ["/usr/local/bin/system-bootstrap.sh"]
CMD []
