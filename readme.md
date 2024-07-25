# Docker

## Docker Client
Passes commands to the Docker Server

### Create and run a container from an image
```shell
docker run 
```




## Docker Server

Docker Server will check the image cache for cached copies of the requested image.

### Specifying alternative docker container registries

...

### Container
#### Namespacing...
https://www.toptal.com/linux/separation-anxiety-isolating-your-system-with-linux-namespaces

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

## Base Linux Images

This example [docker_build.yml](https://raw.githubusercontent.com/heathen1878/Docker/master/base_linux_image/docker_build.yml) file builds a Docker Image and deploys it to an Azure Container Registry tagged with the build ID. The template reference can be found [here](https://raw.githubusercontent.com/heathen1878/azdo_pipelines/main/docker_build/docker_build.yml)

## Azure DevOps Agent

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