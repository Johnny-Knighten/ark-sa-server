# ARK Survival Ascended Server - Docker Containers

[![GitHub (Pre-)Release Date](https://img.shields.io/github/release-date-pre/Johnny-Knighten/ark-sa-server?logo=github)](https://github.com/Johnny-Knighten/ark-sa-server/releases)
[![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/Johnny-Knighten/ark-sa-server/build-and-test.yml?logo=github&label=build%20and%20test%20-%20status)
](https://github.com/Johnny-Knighten/ark-sa-server/actions/workflows/build-and-test.yml)
[![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/Johnny-Knighten/ark-sa-server/release.yml?logo=github&label=release%20-%20status)
](https://github.com/Johnny-Knighten/ark-sa-server/actions/workflows/release.yml)
[![GitHub Repo stars](https://img.shields.io/github/stars/Johnny-Knighten/ark-sa-server?logo=github)
](https://github.com/Johnny-Knighten/ark-sa-server)
[![GitHub](https://img.shields.io/github/license/Johnny-Knighten/ark-sa-server?logo=github)](https://github.com/Johnny-Knighten/ark-sa-server/blob/main/LICENSE)

[![Docker Image Version (latest semver)](https://img.shields.io/docker/v/johnnyknighten/ark-sa-server?logo=docker)](https://hub.docker.com/r/johnnyknighten/ark-sa-server)
[![Docker Stars](https://img.shields.io/docker/stars/johnnyknighten/ark-sa-server?logo=docker)](https://hub.docker.com/r/johnnyknighten/ark-sa-server)
[![Docker Pulls](https://img.shields.io/docker/pulls/johnnyknighten/ark-sa-server?logo=docker)](https://hub.docker.com/r/johnnyknighten/ark-sa-server)

Docker Linux container image for running an ARK Survival Ascended dedicated server.

**Note - This container has not been tested with the Epic Game Store version of the game only the Steam version. If there are any problem please open an issue.**

**See the [wiki](https://github.com/Johnny-Knighten/ark-sa-server/wiki) for more detailed documentation.**

# Table of Contents

* [Features](#features)
* [Quick Start](#quick-start)
   - [Linux Host](#linux-host)
   - [Windows Host](#windows-host)
* [System Requirements](#system-requirements)
* [Game/Server Configs](#game/server-configs)
   - [Environment Variables](#environment-variables)
   - [Exposed Ports](#exposed-ports)
   - [Volumes](#volumes)
   - [Backups](#backups)
   - [Config Files](#config-files)
   - [Mods](#mods)
* [Deployment](#deployment)
* [Tags](#tags)
* [Shout Outs](#shout-outs)
* [Contributing](#contributing)

## Features

* Simple automated installation of ARK Survival Ascended (SA) dedicated server
* Configuration via environment variables and config files
* Scheduled server restarts and updates via Cron
  * Can be frozen to a specific version that is already downloaded
* Automated backups
* Automatic mod deployment, management, and updating
* Linux Container that runs the Windows version of the game server via wine/proton
    * Will switch to Linux game server if it is ever released

## Quick Start

It is assumed you already have Docker installed on your host machine. See [here](https://docs.docker.com/engine/install/) for instructions on how to install Docker.

The commands below will run the latest version of the ARK SA Server in a Linux container using `wine`. It will expose the default ports needed for the game server and RCON. It will also set the server name and admin password. 

**Note - Using `docker run` by itself isn't recommended to host a server in the long term. See the [Deployment Examples](https://github.com/Johnny-Knighten/ark-sa-server/wiki/Deployment-Examples) section of the wiki for more deployment options.**

### Linux Host

The ark server data in this example will be stored in your home directory (`/home/USERNAME/ark-data`). 

```bash
# written for bash, but should work in other shells
# may require Sudo depending on your docker setup
$ docker run -d \
  --name ark-sa-server \
  -p 7777:7777/udp \
  -p 7778:7778/udp \
  -p 27015:27015/udp \
  -p 27020:27020/tcp \
  -e SERVER_NAME="\"Simple ARK SA Server\"" \
  -e ADMIN_PASSWORD=secretpassword \
  -v $HOME/ark-data/server:/ark-server/server \
  -v $HOME/ark-data/logs:/ark-server/logs \
  -v $HOME/ark-data/backups:/ark-server/backups \
  johnnyknighten/ark-sa-server:latest
```

To view the container logs:

```bash
$ docker logs ark-sa-server -f
```

Press `CTRL+C` to exit the logs output.

To stop the container:
  
```bash
$ docker stop ark-sa-server
```

### Windows Host

See the [Windows Host](https://github.com/Johnny-Knighten/ark-sa-server/wiki/Quick-Start#windows-host) section in the Quick Starts page of the wiki for details.

## System Requirements

You should consider running this on another device besides your gaming PC, unless you have RAM to spare.

General Minimum Spec Recommendation (For Server Only):
* 16GB of RAM
* 4 Cores Modern CPU
* 20GB of Storage (SSD Recommended)

Note - Treat these as suggestions rather than hard rules. These recommendations are based on informal performance testing with some metrics collected over time. See the [Performance Testing](https://github.com/Johnny-Knighten/ark-sa-server/wiki/Performance-Testing) section in the wiki for more details.

## Server/Game Configs

### Environment Variables

Environment variables are the primary way to configure the server itself. For game configurations such as XP/Gathering/Taming rates and player stats, you will need to use config files. See the [Config Files](https://github.com/Johnny-Knighten/ark-sa-server/wiki/Config-Files) section in the wiki for more details.

The table below shows all the available environment variables and their default values.

| Variable | Description | Default |
| --- | --- | :---: |
| `SKIP_FILE_VALIDATION` | Skips SteamCMD validation of the server files. Can speed up server start time, but could risk not detecting corrupted files. | `False` |
| `TZ` | Sets the timezone of the container. See the table [here](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) and look in the TZ identifier column. Highly recommend to set this if you will be using any of the CRON variables. | `America/New_York` |
| `MANUAL_CONFIG` | If set to `True` then the container will not generate any config files. This is useful if you want to manage the config files yourself. | `False` |
| `SCHEDULED_RESTART` | Enable scheduled restarts of the server. | `False` |
| `BACKUP_ON_SCHEDULED_RESTART` | Determines if the server should backup itself before restarting. | `False` |
| `RESTART_CRON` | Cron expression for scheduled restarts. Default is everyday at 4am. | `0 4 * * *` |
| `SCHEDULED_UPDATE` | Enable scheduled updates of the server. | `False` |
| `UPDATE_CRON` | Cron expression for scheduled updates. Default is every Sunday at 5am. | `0 5 * * 0` |
| `BACKUP_BEFORE_UPDATE` | Determines if the server should backup itself before updating. | `False` |
| `UPDATE_ON_BOOT` | Determines if the server should update itself when it starts. If this is set to `False` then the server will only update if `SCHEDULED_UPDATE=True`, then it will update on the schedule specified by `UPDATE_CRON`.  | `True` |
| `SCHEDULED_BACKUP` | Enable scheduled backups of the server. | `False` |
| `BACKUP_CRON` | Cron expression for scheduled backups. Default is every day at 6am. | `0 6 * * *` |
| `BACKUP_ON_STOP` | Determines if the server should backup itself when the container stops. | `True` |
| `ZIP_BACKUPS` | If this is set to `True` then it will zip your backups instead of the default tar and gzip. | `False` |
| `RETAIN_BACKUPS` | Number of backups to keep. If not set, then an unlimited number of backs will be kept. | EMPTY |
| `SERVER_NAME` | Name of the server that appears in the server list. If the name contains a space wrap the name in quotes, depending on your system you may need to add escaped quotes `\"`. | `"ARK SA Server"` |
| `SERVER_PASSWORD` | Password to login to the server. Defaults to no password aka a public server. **Do not put spaces in your password.** | EMPTY |
| `ADMIN_PASSWORD `| Password for the server admin. Also used for RCON access. **Do not put spaces in your password.** | `adminpassword` |
| `GAME_PORT` | Primary game port. This port +1 will also be used. | `7777` |
| `QUERY_PORT` | Steam query port. | `27015` |
| `ENABLE_RCON` | Enable RCON on the server. | `True` |
| `RCON_PORT`| RCON port for the server. | `27020` |
| `MAP` | Map launched on the server. | `TheIsland_WP` |
| `MAX_PLAYERS`| Maximum number of players allowed on the server. | `70` |
| `ENABLE_PVE`| Enable PvE mode, otherwise it is a PvPvE. |`False`|
| `NO_BATTLEYE` | Disables BattlEye on the server. | `True` |
| `EXTRA_LAUNCH_OPTIONS`  | Extra launch options for the server. Allows additional flags that do not have an environment variable provided yet. | EMPTY |
| `MOD_LIST` | Comma separated list of mod ids to install. Needs to be wrapped in quotes and whitespace can appear before or after commas. | EMPTY |
| `EPIC_PUBLIC_IP` | Public IP address of the server, used by Epic game clients. | EMPTY |
| `MULTI_HOME_SERVER` | Provide your public IP address when hosting multiple servers on the same machine. | EMPTY |
| `CLUSTER_ID` | Unique identifier for the cluster. If set, the server will join a cluster with this ID. If you are attempting to make a cluster, make sure all your containers use the same ID. | EMPTY |
| `CLUSTER_DIR` | Directory where the cluster data is stored. If set, the server will use this directory to store cluster data. If not set, it will use the default `/ark-server/cluster` directory. Note - this is only used if `CLUSTER_ID` is set. | `/ark-server/cluster` |
| `NO_TRANSFER_FROM_FILTERING` | If set to `True`, the server will not filter transfers from other servers in the cluster. This allows players to transfer items and creatures from any server in the cluster without restrictions. | `False` |

**Note - If you are new to CRON, check here to get help understanding the syntax: [crontab guru](https://crontab.guru/).**

### Exposed Ports

The table below shows the default ports that are exposed by the container. These can be changed by setting the environment variables `GAME_PORT`, `QUERY_PORT`, and `RCON_PORT`.

| Port | Protocol | Description |
| :---: | :---: | --- |
| 7777 | UDP | Main game port |
| 7778 | UDP | Additional game port that is always one port above the main game port|
| 27015 | UDP | Steam query port |
| 27020 | TCP | RCON Port |

Make sure you have Port Forwarding configured otherwise the server will not be accessible from the internet. See the [Port Forwarding](https://github.com/Johnny-Knighten/ark-sa-server/wiki/Deployment-Examples#port-forwarding) section int he wiki for more details.

Note - Always ensure that your `-p` port mappings if using docker run and the `ports` section of your docker compose match up to the ports specified via the environment variables. If they do not match up, the server will not be accessible.

### Volumes

There are thee volumes used by the container

| Volume | Description |
| --- | --- |
| /ark-server/server | Contains server and mods files |
| /ark-server/logs | Contains all log files generated by the container |
| /ark-server/backups | Contains all automated backups |
| /ark-server/cluster | This is only used if `CLUSTER_ID` is set. This directory is where the cluster data is stored. It can be configured via the `CLUSTER_DIR` environment variable. |

### Backups

Backups can be performed automatically if configured. Backups are performed by making a copy the `/ark-server/server/ShooterGame/Saved` directory to the `/ark-server/backups` volume. The backups are named using the following format: `server-backup-{datetime}`. They are compressed as `tar.gz` files by default(can be set to zip via `ZIP_BACKUPS=True`) and are stored in the `/ark-server/backups` volume. You can configure the number of backups to keep using `RETAIN_BACKUPS`, otherwise you will need to manually delete old backups.

Backup Automation Options
* `BACKUP_ON_SCHEDULED_RESTART` - Backup the server before a scheduled restart
* `BACKUP_BEFORE_UPDATE` - Backup the server before an update
* `BACKUP_ON_STOP` - Backup the server when the container stops
* `SCHEDULED_BACKUP` - Backup the server on a schedule

**If you are using `BACKUP_ON_STOP=True`, it is highly recommended you adjust the timeout settings of your `docker run/stop/compose` command to allow the backup process enough time to complete its backup. Without doing this, it is likely your backup will be unfinished and corrupt. See the [Backup On Container Stop - Docker Timeout Considerations](https://github.com/Johnny-Knighten/ark-sa-server/wiki/Backups#backup-on-container-stop---docker-timeout-considerations) section of the wiki for more details.**

If desired, you can also manually trigger a backup. See the [Manual Backup](https://github.com/Johnny-Knighten/ark-sa-server/wiki/Backups#manual-backup) section of the wiki.

#### Restoring Backups

See the [Restoring Backups](https://github.com/Johnny-Knighten/ark-sa-server/wiki/Backups#restoring-backups) section of the wiki for details.

#### Tip For Using `BACKUP_ON_STOP=True`

If you are planning on using `BACKUP_ON_STOP=True`, it is highly recommended you adjust the timeout settings of your `docker stop/compose down` command to allow the backup process enough time to complete its backup. Without doing this, it is likely your backup will be unfinished and corrupt. The longer your server has been running the bigger your backup will become which increases the time needed to backup the server. See the [Backup On Container Stop - Docker Timeout Considerations](https://github.com/Johnny-Knighten/ark-sa-server/wiki/Backups#backup-on-container-stop---docker-timeout-considerations) section of the wiki for more details.

### Config Files

Configuration files are primarily used to adjust settings such as such as XP/Gathering/Taming rates and player stats. The config files are located in the `/ark-server/server/ShooterGame/Saved/Config/WindowsServer` directory inside the container and the primary file you will modify is `GameUserSettings.ini`.

This container has two primary ways to manage config files.
* [Environment Variables](https://github.com/Johnny-Knighten/ark-sa-server/wiki/Config-Files#managing-config-files-via-environment-variables) - Recommended
* [Manually](https://github.com/Johnny-Knighten/ark-sa-server/wiki/Config-Files#managing-the-config-files-manually)

You should not mix and match these methods (it is possible but you need to understand how both are handled inside the container). If you wish to manage the config files manually, you must set `MANUAL_CONFIG=True` to prevent the container from generating/overwriting any config files.

Despite setting `MANUAL_CONFIG=True`, if the `GameUserSettings.ini` file is missing a minimal config will be generated using the following variables:
* `SERVER_NAME`
* `SERVER_PASSWORD`
* `ADMIN_PASSWORD`
* `MAX_PLAYERS`
* `ENABLE_PVE`
* `ENABLE_RCON`
* `RCON_PORT`

For more info see the [Config Files](https://github.com/Johnny-Knighten/ark-sa-server/wiki/Config-Files) wiki page.

### Mods

Mods are handled via the `MOD_LIST` environment variable. The variable is a comma separated list of mod ids to install. The mod ids list need to be wrapped in quotes, and white space is allowed before/after commas since all whitespace in the quotes will be removed. Right now, if you are lucky, the mod author will put the id in there mod description. An alternative way to get mod ids is by installing them on your local machine then going to `PATH_TO_STEAM\Steam\steamapps\common\ARK Survival Ascended\ShooterGame\Binaries\Win64\ShooterGame\Mods\RANDOM#` and look at the subdirectories' name. The first number before the `_` in the subdirectories name is the mod id. 

## Deployment

See the [Deployment Examples](https://github.com/Johnny-Knighten/ark-sa-server/wiki/Deployment-Examples) section of the wiki for more deployment option examples.

## Server Clustering

This container supports server clustering via the `CLUSTER_ID` and `CLUSTER_DIR` environment variables. If you set `CLUSTER_ID`, the server will join a cluster with that ID. If you are attempting to make a cluster, make sure all your containers use the same ID. The `CLUSTER_DIR` variable allows you to specify where the cluster data is stored, which defaults to `/ark-server/cluster`.

If you are running all servers on the same host, then you should set the `CLUSTER_DIR` to a shared volume that all servers can access. This allows the servers to share cluster data and allows players to transfer items and creatures between servers in the cluster. For an example of how to set this up, see the the following docker compose example: [deployment-examples/cluster-example/docker-compose.yaml](https://github.com/Johnny-Knighten/ark-sa-server/blob/main/deployment-examples/cluster-example/docker-compose.yaml).

Things are a little more complicated if you are running the servers on different hosts. In this case, you will need to set the `CLUSTER_DIR` to a shared volume that all servers can access. This can be done using some type of network share storage such as NFS or SMB. This setup has not been tested yet, but it should work as long as the servers can access the same cluster data directory.

Clustering is an advanced feature and is more nuanced than a single server setup. Take extra care when setting up your cluster and ensure that all servers are configured correctly. For instance, there can be issues if you have different mods or configs on different servers in the cluster. For more details you can look [here](https://ark.wiki.gg/wiki/Server_configuration#Cross-ARK_Data_Transfer).
## Tags

Tags used in this project are focused on the version of the GitHub release and the execution environment it uses. It is not based on the game/server version or mod versions.

### Container Tags

Currently the only execution environment is `wine`, which runs the Windows version of the game server in a Linux container via the wine compatibility layer. More specifically it uses [GloriousEggroll's build of wine](https://github.com/GloriousEggroll/wine-ge-custom) that's based on Valves's [Proton experimental wine repo](https://github.com/ValveSoftware/wine). In the future depending on the direction of this project and the release of the Linux version of the game server, there may be a `linux` and `windows` execution environment.

| Tag | Description | Examples |
| ---| --- | :---: |
| latest | latest build from `main` branch, defaults to the `wine` execution environment| `latest` |
| latest-{execution environment} | latest build from `main` branch for a specific execution environment | `latest-wine` |
| major.minor.fix | semantic versioned releases, defaults to the `wine` execution environment  | `1.0.0` |
| major.minor.fix-{execution environment} | semantic versioned releases for a specific execution environment | `1.0.0-wine` |

There are also pre-release tags that are built from the `next` branch. These are used for testing and are not recommended for production use.

## Shout Outs

* GloryousEggroll - For their [wine-ge-custom](https://github.com/GloriousEggroll/wine-ge-custom) used in this image
* chatdargent - For their [ASA_Linux_Server repo](https://github.com/chatdargent/ASA_Linux_Server) that introduced me to the wine-ge-custom repo
  * Before this I had struggled running this with vanilla wine
* lloesche - For giving me a great project to model mine after
  * Their [valheim-server-docker](https://github.com/lloesche/valheim-server-docker/tree/main) project has been one of the best and full featured containerized game servers I have used

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to contribute to this project.
