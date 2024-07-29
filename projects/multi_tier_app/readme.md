# Multi Tier App

Contains two containers....a backend and a frontend...

We use docker compose...to build the containers and setup port redirection...

Docker compose __always__ looks for a `docker-compose.yml` in the working directory, if you pass `--build` as an argument then docker compose will rebuild the images too.

```shell
docker-compose --project-directory ./projects/multi_tier_app/ up
# or
docker-compose up

# rebuild
docker-compose up --build
# or
docker-compose --project-directory ./projects/multi_tier_app/ up --build
```

## Detached

`docker-compose` supports `-d` detached...

```text
$dom in ../Docker on  master [ 📝 ] 
8m58s bash $ ➜ sudo docker-compose --project-directory ./projects/multi_tier_app/ up -d
Creating network "multi_tier_app_default" with the default driver
Creating multi_tier_app_redis-server_1 ... done
Creating multi_tier_app_node-app_1     ... done
```

## Stopping docker compose containers

`docker-compose down` basically the opposite of `up`...

```text
dom in ../Docker on  master [ 📝 ] 
615ms bash $ ✘ sudo docker-compose --project-directory ./projects/multi_tier_app/ down
Stopping multi_tier_app_redis-server_1 ... done
Stopping multi_tier_app_node-app_1     ... done
Removing multi_tier_app_redis-server_1 ... done
Removing multi_tier_app_node-app_1     ... done
Removing network multi_tier_app_default
```

## Restarting crashed containers

Use the restart policy...

## Get their status

To get the status of the docker compose containers use `docker-compose ps`.
