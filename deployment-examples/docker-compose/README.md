# Docker Compose

This README contains examples of using docker compose to launch the ARK: Survival Ascended server container via two different docker compose files.

The basic-docker-compose.yml file will launch a server with minimal configuration, while advanced-docker-compose.yml will launch a server with more robust configuration.

The examples that follow show basic usage of docker compose to launch and manage the ARK: Survival Ascended server container.  For more information on docker compose, please see the [docker compose documentation](https://docs.docker.com/compose/).

## Basic Example

This example only has the server name and admin password set as environment variables.  All other configuration is set to default values.

See [basic-docker-compose.yml](basic-docker-compose.yml) for the full docker compose file.

### Launch Compose Stack With Log Displayed
```bash
$ docker compose -f basic-docker-compose.yml up
```

Press `CTRL+C` to stop the stack.

### Launch Detached Compose Stack   
```bash
$ docker compose -f basic-docker-compose.yml up -d
```

### Viewing Logs When Using A Detached Compose Stack 
#### View all logs generated.
```bash
$ docker compose -f basic-docker-compose.yml logs
```

#### View last N log entries, N=10
```bash
$ docker compose -f basic-docker-compose.yml logs -n 10
```

#### View all logs generated then follow new log entries
```bash
$ docker compose -f basic-docker-compose.yml logs -f
```

Press `CTRL+C` to stop following.

#### View last N log entries, then follow new log entries
```bash
$ docker compose -f basic-docker-compose.yml logs -n 10 -f
```

### Restart Compose Stack
```bash
$ docker compose -f basic-docker-compose.yml restart
```

### Stop Compose Stack
Stop the stack.
```bash
$ docker compose -f basic-docker-compose.yml down
```

### Stop Compose Stack With Timeout (Needed For Large Backups)
Stop the stack and wait up to 10min before killing the container.
```bash
$ docker compose -f advanced-docker-compose.yml down -t 600
```

## Advanced Example

This example has more configuration options set via environment variables than the above example. This reflects a more robust configuration that would be used in a live server.

See [advanced-docker-compose.yml](advanced-docker-compose.yml) for the full docker compose file.

### Launch Compose Stack With Log Displayed
```bash
$ docker compose -f advanced-docker-compose.yml up
```

Press `CTRL+C` to stop the stack.

### Launch Detached Compose Stack 
```bash
$ docker compose -f advanced-docker-compose.yml up -d
```
### Environment File To Store Configs

It is important to note that the advanced example uses an environment file to store the environment variables. If you are going to use a lot of `CONFIG_` environment variables I recommend moving them to an environment file. This will make it easier to manage the config specific variables and prevent you compose file from becoming too long.

You specify the environment file in the `env_file` section of your compose file:
```yaml
version: '3'
services:
  ark-sa:
    container_name: ark
    image: johnnyknighten/ark-sa-server:latest
    restart: unless-stopped
    env_file: 
      - .env
    ...
```

The actual environment file is a simple text file with each environment variable on its own line. 

```env
CONFIG_GameUserSettings_ServerSettings_DifficultyOffset=0.20
CONFIG_GameUserSettings_ServerSettings_PlayerDamageMultiplier=1.0
CONFIG_GameUserSettings_ServerSettings_StructureResistanceMultiplier=1.0
CONFIG_GameUserSettings_ServerSettings_XPMultiplier=5.0
...
```
### Viewing Logs When Using A Detached Compose Stack 
####  View all logs generated.
```bash
$ docker compose -f advanced-docker-compose.yml logs
```

#### View last N log entries, N=10 
```bash
$ docker compose -f advanced-docker-compose.yml logs -n 10
```

#### View all logs generated then follow new log entries
```bash
$ docker compose -f advanced-docker-compose.yml logs -f
```

Press `CTRL+C` to stop following.

#### View last N log entries, then follow new log entries
```bash
$ docker compose -f advanced-docker-compose.yml logs -n 10 -f
```

### Restart Compose Stack
```bash
$ docker compose -f advanced-docker-compose.yml restart
```

### Stop Compose Stack
Stop the stack.
```bash
$ docker compose -f advanced-docker-compose.yml down
```

### Stop Compose Stack With Timeout (Needed For Large Backups)
Stop the stack and wait up to 10min before killing the container.
```bash
$ docker compose -f advanced-docker-compose.yml down -t 600
```

## Note About Volumes

In the two above examples a docker volume called `ark-files` will be created and store all server files.  This volume will persist even if the container is removed.  This allows the container to be removed and re-created without losing any server data.

Depending on your preference, you may prefer bind mounts to a directory on your computer instead of using a docker volume. To do this, replace the bottom `volumes` section of the docker compose file and then update the `volumes` section under `ark-sa` with the path to the directory you want to use. See the example below.

```yaml
version: '3'
services:
  ark-sa:
    ... # all other config before the volumes section
    volumes:
      - '/desired/directory/to/store/ark/server:/ark-server/server'
      - '/desired/directory/to/store/ark/backups:/ark-server/backups'
      - '/desired/directory/to/store/ark/logs:/ark-server/logs'
    ...
# removed or commented out
#volumes:
  #ark-files:
```

## Note About Server Updates

If you have `UPDATE_ON_BOOT` set to `False`, then the container will not download any updates via [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD) and will continue to use the files in the supplied volume/bind mount. Whenever you are ready to perform an update, set `UPDATE_ON_BOOT` to `True ` and restart the container.  The container will then download the latest version of the server files and update the server.  Once the update is complete, set `UPDATE_ON_BOOT` back to `False` and restart the container.  The container will then use the updated files for the server and go back to not updating on restarts.
