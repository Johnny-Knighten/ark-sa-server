This section is written in terms of using Systemd in an Ubuntu 22.04 VM. It should be easily adaptable to other Linux distros that use Systemd.

Start by creating a file to hold all of your variables. Consider the permissions of this file if it will contain secrets. 

Create a service config file `/etc/sysconfig/ark-sa-server.env`:
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

Next create a systemd service unit file, that specifies dependencies, startup and shutdown behavior, and other properties of the service.

Create a systemd service until file `/etc/systemd/system/ark-sa-server.service`:
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

Now enable the service and start it:
```bash
$ sudo mkdir -p  /opt/ark-sa-server # Where ark server files will be stored, check the -v above
$ sudo systemctl daemon-reload
$ sudo systemctl enable ark-sa-server.service
$ sudo systemctl start ark-sa-server.service
```

To check the status of the service:
```bash
$ sudo systemctl status ark-sa-server.service
```

To check the logs of the service:
```bash
$ sudo journalctl -u ark-sa-server.service
```

To stop the service:
```bash
$ sudo systemctl stop ark-sa-server.service
```

To prevent the service from starting on boot:
```bash
$ sudo systemctl disable ark-sa-server.service
```

To enable the service to start on boot again:
```bash
$ sudo systemctl enable ark-sa-server.service
```

To start the service if its stopped:
```bash
$ sudo systemctl start ark-sa-server.service
```

If you modify the service unit file then you will need to reload the daemon:
```bash
$ sudo systemctl daemon-reload
```
