# Docker Compose Examples

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

### Launch Compose Stack With Detached Log 
```bash
$ docker compose -f basic-docker-compose.yml up -d
```

#### View Detached Log
View all logs generated.
```bash
$ docker compose -f basic-docker-compose.yml logs
```

View last N log entries, N=10 in example below.
```bash
$ docker compose -f basic-docker-compose.yml logs -n 10
```

View all logs generated then follow new log entries.
```bash
$ docker compose -f basic-docker-compose.yml logs -f
```

Press `CTRL+C` to stop following.

View last N log entries, then follow new log entries.
```bash
$ docker compose -f basic-docker-compose.yml logs -n 10 -f
```

#### Restart Compose Stack
```bash
$ docker compose -f basic-docker-compose.yml restart
```

#### Stop Compose Stack
Stop the stack.
```bash
$ docker compose -f basic-docker-compose.yml down
```

## Advanced Example

This example has more configuration options set via environment variables than the above example. This reflects a more robust configuration that would be used in a live server.

See [advanced-docker-compose.yml](advanced-docker-compose.yml) for the full docker compose file.

### Launch Compose Stack With Log Displayed
```bash
$ docker compose -f advanced-docker-compose.yml up
```

Press `CTRL+C` to stop the stack.

### Launch Compose Stack With Detached Log 
```bash
$ docker compose -f advanced-docker-compose.yml up -d
```

#### View Detached Log
View all logs generated.
```bash
$ docker compose -f advanced-docker-compose.yml logs
```

View last N log entries, N=10 in example below.
```bash
$ docker compose -f advanced-docker-compose.yml logs -n 10
```

View all logs generated then follow new log entries.
```bash
$ docker compose -f advanced-docker-compose.yml logs -f
```

Press `CTRL+C` to stop following.

View last N log entries, then follow new log entries.
```bash
$ docker compose -f advanced-docker-compose.yml logs -n 10 -f
```

#### Restart Compose Stack
```bash
$ docker compose -f advanced-docker-compose.yml restart
```

#### Stop Compose Stack
Stop the stack.
```bash
$ docker compose -f advanced-docker-compose.yml down
```

## Note About Volumes

In the two above examples a docker volume called `ark-files` will be created and store all server files.  This volume will persist even if the container is removed.  This allows the container to be removed and re-created without losing any server data.

Depending on your preference, you may prefer bind mounts to a directory on your computer instead of using a docker volume. To do this, replace the the bottom `volumes` section of the docker compose file and then update the `volumes` section under `ark-sa` with the path to the directory you want to use. See the example below.

```yaml
version: '3'
services:
  ark-sa:
    ... # all other config before the volumes section
    volumes:
      - '/desired/directory/to/store/ark/files:/ark-server'
    ...
# removed or commented out
#volumes:
  #ark-files:
```

## Note About Server Updates

If you have `ARK_PREVENT_AUTO_UPDATE` set to `True`, then the container will not download any updates via [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD) and will continue to use the files in the supplied volume/bind mount. Whenever you are ready to perform an update, set ARK_PREVENT_AUTO_UPDATE to `False ` and restart the container.  The container will then download the latest version of the server files and update the server.  Once the update is complete, set `ARK_PREVENT_AUTO_UPDATE` back to `True` and restart the container.  The container will then use the updated files for the server and go back to not updating on restarts.