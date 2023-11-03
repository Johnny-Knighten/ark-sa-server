# Docker Run Inside A Systemd Service

This section is written in terms of using Systemd in an Ubuntu 22.04 VM. It should be easily adaptable to other Linux distros that use Systemd.

## Create File To Hold All Environment Variables

Start by creating a file to hold all of your variables. Consider the permissions of this file if it will contain secrets. 

Create a service config file [`/etc/sysconfig/ark-sa-server.env`](deployment-examples/docker-run-with-systemd/ark-sa-server.env)):

```
ARK_SERVER_NAME="Simple ARK SA Server"
ARK_GAME_PORT=8888
ARK_QUERY_PORT=27016
ARK_MAX_PLAYERS=20
ARK_SERVER_PASSWORD=password2
ARK_SERVER_ADMIN_PASSWORD=adminpassword2
ARK_ENABLE_PVE=True
STEAMCMD_SKIP_VALIDATION=True
ARK_PREVENT_AUTO_UPDATE=True
ARK_RCON_ENABLED=True
ARK_RCON_PORT=27021
ARK_MOD_LIST="927131, 893657"
```

## Create Systemd Service Unit File

Next create a systemd service unit file, that specifies dependencies, startup and shutdown behavior, and other properties of the service.

Create a systemd service until file [`/etc/systemd/system/ark-sa-server.service`](deployment-examples/docker-run-with-systemd/ark-sa-server.service)):

```
[Unit]
Description=ARK Survival Ascended Server
After=docker.service
Requires=docker.service
ConditionPathExists=/etc/sysconfig/ark-sa-server.env

[Service]
TimeoutStartSec=0
ExecStartPre=-/usr/bin/docker stop %n
ExecStartPre=-/usr/bin/docker rm %n
ExecStart=/usr/bin/docker run \
          --name %n \
          --pull=always \ # may want to remove if using locally built image
          --rm \
          -v /opt/ark-sa-server:/ark-server\
          -p 8888:8888/udp \
          -p 8889:8889/udp \
          -p 27016:27016/udp \
          -p 27021:27021/tcp \
          --env-file /etc/sysconfig/ark-sa-server.env \
          ark-sa-server:1.0.0
ExecStop=/usr/bin/docker stop %n
Restart=always
RestartSec=10s

[Install]
WantedBy=multi-user.target
```

Note 
* Make sure you make your ports and volumes match your desired configuration.
* %n will be the same of the service which is ark-sa-server.service in this case.

## Enable and Start Service

Now enable the service and start it:

```bash
$ sudo mkdir -p  /opt/ark-sa-server # Where ark server files will be stored, check the -v above
$ sudo systemctl daemon-reload
$ sudo systemctl enable ark-sa-server.service
$ sudo systemctl start ark-sa-server.service
```

## Admin Tasks

### Check Service Status
```bash
$ sudo systemctl status ark-sa-server.service
```

### Check Service Logs
```bash
$ sudo journalctl -u ark-sa-server.service
```

### Start Service
```bash
$ sudo systemctl start ark-sa-server.service
```

### Stop Service
```bash
$ sudo systemctl stop ark-sa-server.service
```

### Disable Service - Prevents Service From Starting On Boot
```bash
$ sudo systemctl disable ark-sa-server.service
```
### Enable Service - Allows Service To Start On Boot
```bash
$ sudo systemctl enable ark-sa-server.service
```

### Reload Service Unit File

If you modify the service unit file then you will need to reload the daemon:
```bash
$ sudo systemctl daemon-reload
```

### Update Configs

To update the configs, you will need to stop the service, update the configs, then start the service again for the server to pick up on the changes. Change environment variables via modifying `/etc/sysconfig/ark-sa-server.env` and change the actual config files as documented in the primary [README](README.md).
