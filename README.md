# ARK Survival Ascended Server - Docker Containers

Docker container images for running an ARK Survival Ascended dedicated server.

## Features

* Simple automated installation of ARK Survival Ascended (SA) dedicated server
* Configuration via environment variables and config files
* Automatic updating of server, but can be frozen to a specific version thats already downloaded
* Automatic mod deployment, management, and updating
* Multiple container builds based upon different execution environments
  * Linux Containers
    * Windows ARK SA server Via Wine (Available Now)
    * Linux ARK SA server (if a Linux Server is ever released)
  * Windows Containers
    * Windows ARK SA server (Planned)

## Automated Builds

Automated builds are made upon successful Pull Requests merges on the `main` and `next` branches via Github Actions. Container images are published to [Docker Hub](https://hub.docker.com/r/johnnyknighten/ark-sa-server).

## Tags

Tags used in this project are focused on the version of the Github release and the execution environment it uses. It is not based on the game/server version or mod versions.

Currently the only execution environment is `wine`, which runs the Windows version of the game server in a Linux container via the wine compatibility layer. More specifically it uses [GloriousEggroll's build of wine](https://github.com/GloriousEggroll/wine-ge-custom) that's based on Valves's [Proton experimental wine repo](https://github.com/ValveSoftware/wine).

| Tag | Description | Examples |
| ---| --- | :---: |
| latest | latest build from `main` branch, defaults to the `wine` execution environment| `latest` |
| latest-{execution environment} | latest build from `main` branch for a specific execution environment | `latest-wine` |
| major.minor.fix | semantic versioned releases, defaults to the `wine` execution environment  | `1.0.0` |
| major.minor.fix-{execution environment} | semantic versioned releases for a specific execution environment | `1.0.0-wine` |

There are also pre-release tags that are built from the `next` branch. These are used for testing and are not recommended for production use.

## Quick Start

The commands below will run the latest version of the ARK SA Server in a Linux container using `wine`. It will expose the default ports needed for the game server and RCON. It will also set the server name and admin password. 

**Note - I do not recommend using this approach unless you just want something quick and dirty. See the [Deployment](#deployment) section for more details on how to deploy the server in a more production ready manner. I highly recommend docker compose for its simplicity.**

### Linux Host

The ark server data in this example will be stored in the current users home directory under `/home/USER/ark-data`. 

```bash
# written for bash, but should work in other shells
# may require Sudo depending on your docker setup
$ docker run -d \
  --name ark-sa-server \
  -p 7777:7777/udp \
  -p 7778:7778/udp \
  -p 27015:27015/udp \
  -p 27020:27020/tcp \
  -e ARK_SERVER_NAME="\"Simple ARK SA Server\"" \
  -e ARK_SERVER_ADMIN_PASSWORD=secretpassword \
  -v $HOME/ark-data:/ark-server \
  ark-sa-server:latest
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

Note - When setting `ARK_SERVER_NAME` in the docker run command, you must escape the quotes with a backslash. This is because the value is passed to the server as a command line argument and the quotes are needed to keep the name together. When using docker compose, the escaped quotes are not needed and standard quotes are good enough.

### Windows Host

This code is written for PowerShell, but assumes you are running Docker via WSL. If you installed Docker via Docker Desktop recently then you should be good to go. The volume mount path is written in context of a Linux shell in WSL, so you will need to adjust it to match your system.

For instance if you want to use `C:\Users\johnny\ark-data` then the WSL path should be `/mnt/c/Users/johnny/ark-data`. In general `/mnt/c` is the root of your C drive in WSL, and `/mnt/d` is the root of your D drive in WSL and so on.

```powershell
# written for powershell, but should work in other shells
docker run -d `
  --name ark-sa-server `
  -p 8888:8888/udp `
  -p 8889:8889/udp `
  -p 27016:27016/udp `
  -p 27021:27021/tcp `
  -e ARK_SERVER_NAME="Simple ARK SA Server" `
  -e ARK_SERVER_ADMIN_PASSWORD=secretpassword `
  -e ARK_GAME_PORT=8888 `
  -e ARK_QUERY_PORT=27016 `
  -e ARK_RCON_PORT=27021 `
  -v /mnt/c/Users/USER/ark-data:/ark-server `
  ark-sa-server:latest
```

To view the container logs:

```bash
docker logs ark-sa-server -f
```

Press `CTRL+C` to exit the logs output.

To stop the container:
  
```bash
docker stop ark-sa-server
```

## System Requirements

You should consider running this on another device besides your gaming PC, unless you have RAM to spare.

General Minimum Spec Recommendation (For Server Only):
* 16GB of RAM
* 4 Cores Modern CPU
* 20GB of Storage (SSD Recommended)

### Performance Testing

Currently the image has been tested with these two setups:

* Setup 1
  * Windows 11 Pro
  * CPU - AMD Ryzen 9 3950X
  * RAM - 64GB DDR4 @ 3200Mhz
  * Storage - 2TB PCIe 3.0 NVMe SSD
* Setup 2
  * ProxMox Host
    * Test VM Ubuntu 22.04
  * CPU - 2x Intel Xeon Gold 6146
    * Test VM Assigned 4 Host Cores
  * RAM - 768GB DDR4 @ 3200Mhz
    * Test VM Assigned 32GB
  * VM Storage - 8 x 512GB SATA SSDs in 
    * 4 Mirrored VDEVs That Are Then Striped (2TB Usable)
    * Test VM Assigned 60GB

In both setups an empty server (no players) consumes about 12GB of RAM. With about 6 players (with only 20hrs played - so minimal number of buildings/bases/tamed dinos) I saw RAM usage float around 14GB. For a small private server I think 16GB of RAM would be a good starting place. For a larger server with more players and more time played, I could easily see RAM usage creep up to 20-30+GB.

In terms of CPU I didn't see any major CPU usage besides the initial server setup/launch. I would assume a modern CPU with 4 cores should be good enough for a small private server. I cant truly project what large servers would need with the testing performed so far. From the research I have done Ark Survival Evolved benefited from a higher CPU frequency rather than more cores, so I assume the same will be true for Ark Survival Ascended.

Storage wise the wine based image is roughly 1.64GB and the docker volume created is about 9.1GB without any mods or backups. I have only tested on SATA and PCIe 3.0 NVMEs SSD drives, so I cant speak to the performance of spinning rust. In my testing there were no noticeable performance difference between SATA and NVME SSDs. Be prepared to use about 12GB of storage minimum, and plan for more for future server updates, mods, and backups.

Note - All performance testing has been highly informal and based off of my own personal experience with some performance metrics collected over time. Treat these as suggestions rather than hard rules.

## Game/Server Configs

### Environment Variables

Environment variables are the primary way to configure the server itself. For configurations such as XP/Gathering/Taming rates and player stats, you will need to use config files. See the [Config Files](#config-files) section for more details.

The table below shows all the available environment variables and their default values.

| Variable | Description | Default |
| --- | --- | :---: |
| `STEAMCMD_SKIP_VALIDATION` | Skips SteamCMD validation of the server files. Can speed up server start time, but could risk not detecting corrupted files. | `False` |
| `ARK_PREVENT_AUTO_UPDATE` | Prevents the server from automatically updating. If you do need to update after having this set to `True`, then flip the Value to `False` then restart the container. Afterwards, set it back to `True` and restart again to prevent any further updates. | `False` |
| `ARK_SERVER_NAME` | Name of the server that appears in the server list. If the name contains a space wrap the name in quotes, depending on your system you may need to add escaped quotes `\"`. | `"ARK SA Server"` |
| `ARK_SERVER_PASSWORD` | Password to login to the server. Defaults to no password aka a public server. **Do not put spaces in your password.** | EMPTY |
| `ARK_SERVER_ADMIN_PASSWORD `| Password for the server admin. Also used for RCON access. **Do not put spaces in your password.** | `adminpassword` |
| `ARK_GAME_PORT` | Primary game port. This port +1 will also be used. | `7777` |
| `ARK_QUERY_PORT` | Steam query port. | `27015` |
| `ARK_RCON_ENABLED` | Enable RCON on the server. | `True` |
| `ARK_RCON_PORT`| RCON port for the server. | `27020` |
| `ARK_MAP` | Map launched on the server. | `TheIsland_WP` |
| `ARK_MAX_PLAYERS`| Maximum number of players allowed on the server. | `70` |
| `ARK_ENABLE_PVE`| Enable PvE mode, otherwise it is a PvPvE. |`False`|
| `ARK_NO_BATTLEYE` | Disables BattlEye on the server. | `True` |
| `ARK_EXTRA_LAUNCH_OPTIONS`  | Extra launch options for the server. Allows additional flags that do not have an environment variable provided yet. | EMPTY |
| `ARK_MOD_LIST` | Comma separated list of mod ids to install. Needs to be wrapped in quotes and whitespace can appear before or after commas. | EMPTY |
| `ARK_EPIC_PUBLIC_IP` | Public IP address of the server, used by Epic game clients. | EMPTY |
| `ARK_MULTI_HOME_SERVER` | Provide your public IP address when hosting multiple servers on the same machine. | EMPTY |

### Config Files

Configuration files are primarily used to adjust settings such as such as XP/Gathering/Taming rates and player stats.  The config files are located in the `/ark-server/ShooterGame/Saved/Config/WindowsServer` directory inside the container and the primary file you will modify is `GameUserSettings.ini`. The config files are generated on container start, so if you need to make changes to them you will need to restart the container. If you delete the config file a new one will be generated on server start using default values.

#### Using Bind Mounts

If you use a bind mount to attach to /ark-server, you can modify the config files directly on the host.

**I recommend this approach for those not experienced with Docker. It will allow you to modify files directly with applications such as notepad.**

Bind mounts are when you mount a directory from your host and map it to a directory inside of the container. From a Windows perspective, this is like picking a folder on your computer to store you server data and mapping that folder into the container.

Below is an example of using a bind mount with docker run. This is mapping the `C:\Users\johnny\ark-data ` folder to the containers /ark-server directory:

```bash
$ docker run -d \
  ...
  -v /mnt/c/Users/johnny/ark-data:/ark-server \
  ...
```

In docker compose it would look like:
```yaml
---
version: '3'
services:
  ark-sa:
    container_name: ark
    image: ark-sa-server
    ...
    volumes:
      - '/mnt/c/Users/johnny/ark-data:/ark-server'
    ...
```
#### Using Docker Volumes

When using Docker Volumes you have a few options:
* If using Docker Desktop
  * You can use the Docker Desktop UI to manage the volume
    * Find the container then go to the files section and modify files from there (right click Edit File)
* If using Bash/Powershell
  * You will need to copy the config files out of the volume, make your changes, and then copy them back in (will not show an example of this)
  * Another alternative for docker volume usage is to open a bash shell in the container while it is running, install a text editor (current builds don't have them preinstalled), modify the files from there, and then restart the container.

Here is an example example of installing nano in the container and modifying the config file as it runs:

```bash
# Open a bash shell in the container (below assumes a single docker container for ARK SA is running) otherwise use `docker ps` to get the container id
$ docker exec -it $(docker ps -q --filter "ancestor=ark-sa-server") bash

# Now your inside the container
root@CONTAINER_ID:/ark-server$ apt-get update && apt-get install nano
root@CONTAINER_ID:/ark-server$ nano ./server/ShooterGame/Saved/Config/WindowsServer/GameUserSettings.ini
root@CONTAINER_ID:/ark-server$ exit

# Now restart the container
$ docker restart $(docker ps -q --filter "ancestor=ark-sa-server")
```

#### Finding Config Settings You Want To Change

An easy way to find what config files you want to modify/set is to start a single player ARK SA game and configure it as you would want your dedicated server to be setup. Then go to `PATH_TO_STEAM\Steam\steamapps\common\ARK Survival Ascended\ShooterGame\Saved\Config\Windows` and take a look through the .ini files in that directory. The main file of interest will be `GameUserSettings.ini`. You can also look at the other .ini files to see what other settings are available to you. Then either copy entire ini files into your server config folder or just copy the specific settings you want to change.

Note - Some of the environment variable settings will also be copied into the config files, such as the server name and passwords. If you manually change these fields in the config file, make sure to also update the environment variables to match otherwise you may experience issues.

### Mods

Mods are handled via the `ARK_MOD_LIST` environment variable. The variable is a comma separated list of mod ids to install. The mod ids list need to be wrapped in quotes, and white space is allowed before/after commas since all whitespace in the quotes will be removed. Right now, if you are lucky, the mod author will put the id in there mod description. An alternative way to get mod ids is by installing them on your local machine then going to `PATH_TO_STEAM\Steam\steamapps\common\ARK Survival Ascended\ShooterGame\Binaries\Win64\ShooterGame\Mods\RANDOM#` and look at the subdirectories' name. The first number before the `_` in the subdirectories name is the mod id. 

### Exposed Ports

The table below shows the default ports that are exposed by the container. These can be changed by setting the environment variables `ARK_GAME_PORT`, `ARK_QUERY_PORT`, and `ARK_RCON_PORT`.

| Port | Protocol | Description |
| :---: | :---: | --- |
| 7777 | UDP | Main game port |
| 7778 | UDP | Additional game port that is always one port above the main game port|
| 27015 | UDP | Steam query port |
| 27020 | TCP | RCON Port |

Note - Always ensure that your `-p` port mappings if using docker run and the `ports` section of your docker compose match up to the ports specified via the environment variables. If they do not match up, the server will not be accessible.

#### Port Forwarding

Regardless if you use the default ports or specify custom ones, you must setup port forwarding on your router to allow incoming connections to the server. You may also need to setup firewall rules on your host machine to allow incoming connections to the server.

This [guide](https://www.lifewire.com/how-to-port-forward-4163829) is a very high level overview of port forwarding and may be a good starting point if you are new to port forwarding.

There are too many different routers and firewall setups to provide a single guide for port forwarding. If you need help with port forwarding, I would recommend searching for a guide for your specific router and setup.

**Make sure you understand the security implications of opening ports on your router and firewall. If you are unsure, I would recommend buying hosting instead of taking the risk. When opening ports there is always a chance you could end up exposing your computer to bad actors("hackers").**

### Volumes

Right now only one volume is used by the image. This volume is used to store the server data and mods. 

| Volume | Description |
| --- | --- |
| /ark-server | The directory where the server/mod data is stored |

## Deployment

### Docker Run

Docker run is mainly good for one off deployments or testing. It is not recommended for production deployments by itself, but combined with something like systemd it can be made production ready.

Below is an example of starting an instance of the ARK SA Server using docker run that has more configuration options than the quick start example.

```bash
# written for bash, but should work in other shells
$ docker run -d \
  --name ark-sa-server \
  -p 8888:8888/udp \
  -p 8889:8889/udp \
  -p 27016:27016/udp \
  -p 27021:27021/tcp \
  -v ark-sa-server:/ark-server \
  -e ARK_SERVER_NAME="\"Simple ARK SA Server\"" \
  -e ARK_GAME_PORT=8888 \
  -e ARK_QUERY_PORT=27016 \
  -e ARK_MAX_PLAYERS=20 \
  -e ARK_SERVER_PASSWORD=password2 \
  -e ARK_SERVER_ADMIN_PASSWORD=adminpassword2 \
  -e ARK_ENABLE_PVE=True \
  -e STEAMCMD_SKIP_VALIDATION=True \
  -e ARK_PREVENT_AUTO_UPDATE=True \
  -e ARK_RCON_ENABLED=True \
  -e ARK_RCON_PORT=27021 \
  -e ARK_MOD_LIST="\"927131, 893657\"" \
  ark-sa-server:1.0.0
```

### Docker Run + Systemd

See [deployment-examples\docker-run-with-systemd](deployment-examples\docker-run-with-systemd) details about using docker run with Systemd to run the server as service on a Linux server(that uses Systemd).

### Docker Compose

Below is a minimal example of starting an instance of the ARK SA Server using docker compose. See the [deployment-examples\docker-compose](deployment-examples\docker-compose) folder for more docker compose examples.

```yaml
---
version: '3'
services:
  ark-sa:
    container_name: ark
    image: ark-sa-server
    restart: unless-stopped
    environment:
      - ARK_SERVER_NAME="Simple ARK SA Server"
      - ARK_SERVER_ADMIN_PASSWORD=secretpassword
    volumes:
      - 'ark-files:/ark-server'
    ports:
      - 7777:7777/udp
      - 7778:7778/udp
      - 27015:27015/udp
      - 27020:27020/tcp
volumes:
  ark-files:
```

## Known Issues

* If booting the container with an existing volume/bind mount the original ShooterGame.log will be read initially and displayed before it is converted to a backup log (ShooterGame-backup-DATETIMESTAMP.log). This can be misleading because it will show old server launch configs before the file is truncated and the fresh ShooterGame.log is created. 

## Roadmap/Future Features

* Core Features
  * Automated Server Restarts
  * Automated Server Backups
  * Windows Container
  * Linux Container Running Linux Server (if ever released)
* Additional Features
  * CLI Took For Simple Server Management via RCON
  * Event Hooks To Allow For Custom Scripts Execution On Server Events
    * Such As:
      * Server Pre/Post Start
      * Server Pre/Post Restart
      * Server Pre/Post Backup
      * ...
  * Discord Integration
  * Matrix Integration
* Documentation
  * Deployment
    * Kubernetes
    * AWS ECS
    * AWS Lightsail

## Shout Outs

* GloryousEggroll - For their [wine-ge-custom](https://github.com/GloriousEggroll/wine-ge-custom) used in this image
* chatdargent - For their [ASA_Linux_Server repo](https://github.com/chatdargent/ASA_Linux_Server) that introduced me to the wine-ge-custom repo
  * Before this I had struggled running this with vanilla wine
* lloesche - For giving me a great project to model mine after
  * Their [valheim-server-docker](https://github.com/lloesche/valheim-server-docker/tree/main) project has been one of the best and full featured containerized game servers I have used

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to contribute to this project.
