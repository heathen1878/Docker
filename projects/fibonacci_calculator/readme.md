# Project

## Local Testing

Tests can be run either by connecting stdin to an already existing container...

```shell
docker run container

# New tab
docker exec -it container
npm run test
```

### Using Docker Compose locally

`docker compose up`

The [docker-compose.yml](./docker-compose.yml) uses secrets passed from the command line. If you have to `sudo` to run docker then append `-E` to the command to pass the environment variables from your session. e.g. `sudo -E docker compose up -d`. Use [create_environment_variables.sh](./scripts/create_environment_variables.sh) to set environment variables sourced from Key Vault or Git Hub.

### Redis

You may need to run `sysctl vm.overcommit_memory=1` in your console.
