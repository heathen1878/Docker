# Docker

## Docker Client

Passes commands to the Docker Server

### Create and run a container from an image

```shell
docker run hello-world
```

`docker run` pretty much equals `docker create` and `docker start`

:point_down:

Docker Server will check the image cache for cached copies of the requested image.

```text
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
c1ec31eb5944: Pull complete
...
Status: Downloaded newer image for hello-world:latest
```

then run the container...

```text
To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.
```

### Overriding the startup command

```shell
docker run busybox ls
```

```text
$dom in ../Docker on  master [ 📝 ] 
3s bash $ ➜ sudo docker run busybox ls
bin
dev
etc
home
lib
lib64
proc
root
sys
tmp
usr
var
```

### Running detached

To run a container and have the command prompt returned use `-d` e.g. 

```shell
docker run -d container-id
```

### List running containers

```shell
docker ps
```

#### List all containers

```shell
docker ps --all
```

#### Start

Docker start by default doesn't output STDOUT or STDERR. You can use `docker logs container id` to view the logs from a container

#### Stop

To stop a container you can run `docker stop container id` or `docker kill container id`.

Docker `stop` uses `SIGTERM` a.k.a. a graceful shutdown whereas docker kill uses `SIGKILL` a.k.a. stop now...

If the container doesn't stop after 10 seconds when docker stop was issued then docker will automatically issue docker kill. It can depend on whether the running process understands SIGTERM, if not a SIGKILL will be needed.

#### Volumes

You can connect Docker containers to reference the local filesystem using references e.g.

```shell
docker run -v local_path:/container_path

# You can also bookmark a container path within a path reference e.g
docker run -v container_path/directory_within_container -v local_path:/container_path
```

:point_up: in the example above directory_within_container would not reference the local filesystem even though the root directory references the local filesystem.

__NOTE__
Docker Compose is useful when you need to pass many options to Docker.

#### Clear down containers

`docker system prune` :point_left: deletes stopped containers and cleans up build cache

#### Viewing Logs

`docker logs container id`

#### Running commands within a container

`docker exec -it container id sh | bash`

You can also use `-it` with docker run.

You can also connect to an existing running container using `docker attach containerid`; the limitation of this is, stdin is only connected to the primary process.

## Docker Server

Docker Server will check the image cache for cached copies of the requested image.

Execute image build i.e. `docker build --tag your_docker_id/name:tag_value .`

### Specifying alternative docker container registries

...

### Container

[Dockerfile teardown](./redis_server/teardown.md)

[Docker Example](./redis_server/dockerfile)

```shell
# cd into dockerfile document
docker build --tag your_docker_id/name:tag_value .
```

pass in `--progress=plain` to enable a more verbose...

if for some reason you wanted to disable caching pass in `--no-cache`

#### Manual image

`docker run -it apline` :point_left: grab the ID of this container.

run the commands within the container...

`docker commit -c 'CMD [ "redis-server" ] container-id`

#### Namespacing

[namespacing](https://www.toptal.com/linux/separation-anxiety-isolating-your-system-with-linux-namespaces)

#### Control Groups

Limits amount of resources used per process...

:point_up: specific to Linux
Docker Desktop runs a Linux Virtual Machine...which is where the containers reside and it's that Linux Kernel that controls / isolates access.

```shell
docker --version
```

#### Container process

A running process with access to a given set of resources

process within container -> kernel -> allocated hardware resources

#### Image

Just a file system snapshot with a startup command

### Container instance

A container is an instance of the image running on your local docker instance.

## Projects

### Base Linux Images

This example [docker_build.yml](https://raw.githubusercontent.com/heathen1878/Docker/master/base_linux_image/docker_build.yml) file builds a Docker Image and deploys it to an Azure Container Registry tagged with the build ID. The template reference can be found [here](https://raw.githubusercontent.com/heathen1878/azdo_pipelines/main/docker_build/docker_build.yml)

### Azure DevOps Agent

This example is taken from [here](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops#linux) but uses the base Linux image above rather as a starting point. It does assume the repository name from the base Linux image is named azdodockerbase.

Example variable file

```yaml
variables:
  service_connection: '' # your ACR service connection name
  image_repository: 'azdoagent'
  container_registry: '' # your ACR url...azurecr.io
  dockerfile_path: $(Build.SourcesDirectory)/azdo_self_hosted_linux_agent/Dockerfile
  tags: '233'
```

### Node Js

This is a simple Node Js web app running as a container - see [here](./projects/node_js_web_app/readme.md)

### Multi tier app

This example uses docker compose to build the networking between in each container. See [here](./projects/multi_tier_app/readme.md)

### React App

This example uses Github Actions to build and test and then deploy to Docker Hub. See [here](./projects/production_grade_flow/readme.md)


#### Build Status

Tests

[![Test Frontend Docker Build](https://github.com/heathen1878/Docker/actions/workflows/frontend_test.yaml/badge.svg)](https://github.com/heathen1878/Docker/actions/workflows/frontend_test.yaml)

Push to Docker Hub

[![Push Frontend To Docker Hub](https://github.com/heathen1878/Docker/actions/workflows/push_frontend_to_dh.yaml/badge.svg)](https://github.com/heathen1878/Docker/actions/workflows/push_frontend_to_dh.yaml)

App Service Deployment

[![Deploy Infra](https://github.com/heathen1878/Docker/actions/workflows/deploy_infra.yaml/badge.svg)](https://github.com/heathen1878/Docker/actions/workflows/deploy_infra.yaml)