# Multi Tier App

Contains two containers....a backend and a frontend...

We use docker compose...to build the containers and setup port redirection...


 Docker compose always looks for a `docker-compose.yml` in the working directory, if you pass `--build` as an argument then docker compose will rebuild the images too.

```shell
docker-compose --project-directory ./projects/multi_tier_app/ up
# or
docker-compose up

# rebuild
docker-compose up --build
```
