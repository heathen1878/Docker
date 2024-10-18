# DevOps Directive Docker Course

## Development

```shell
docker compose -f docker-compose-dev.yml up
```

The [docker-compose.yml](./docker-compose-dev.yml) uses secrets passed from the command line. If you have to `sudo` to run docker then append `-E` to the command to pass the environment variables from your session. e.g. `sudo -E docker compose -f docker-compose-dev.yml up -d`.

Use [create_environment_variables.sh](../../scripts/create_environment_variables.sh) to set environment variables sourced from Key Vault or Git Hub.

### Debugging

You can attach vs code to the Node API container using port 9229 and Go API container using Delve and port 4000.

```shell
docker compose -f docker-compose-dev.yml -f docker-compose-debug.yml up
```

## Test

...

## Prod

...
