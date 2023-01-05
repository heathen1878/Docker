# Docker

This repo currently contains docker files which build docker images. Purely used for learning. The Docker files are used by Docker build in the pipelines [repo](https://github.com/heathen1878/azdo_pipelines)

## Base Linux Images

This example [docker_build.yml](https://raw.githubusercontent.com/heathen1878/Docker/master/base_linux_image/docker_build.yml) file build an Docker Image and deploys to to an Azure Container Registry tagged with the build ID.

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