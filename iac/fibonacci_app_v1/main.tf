locals {
  # define some local variables
  resource_group_name            = format("rg-%s-%s-%s-%s", local.name, var.environment, local.location, local.random)
  virtual_network_name           = format("vnet-%s-%s-%s-%s", local.name, var.environment, local.location, local.random)
  cae_infra_resource_group_name  = format("rg-cae-infra-%s-%s-%s-%s", local.name, var.environment, local.location, local.random)
  container_app_environment_name = format("cae-%s-%s-%s-%s", local.name, var.environment, local.location, local.random)
  api_container_app              = format("ca-api-%s-%s-%s-%s", local.name, var.environment, local.location, local.random)
  client_container_app           = format("ca-client-%s-%s-%s-%s", local.name, var.environment, local.location, local.random)
  worker_container_app           = format("ca-worker-%s-%s-%s-%s", local.name, var.environment, local.location, local.random)
  api_docker_image               = format("index.docker.io/heathen1878/api:%s", var.docker_image_tag)
  client_docker_image            = format("index.docker.io/heathen1878/client:%s", var.docker_image_tag)
  worker_docker_image            = format("index.docker.io/heathen1878/worker:%s", var.docker_image_tag)
  redis_cache                    = format("redis-%s-%s-%s-%s", local.name, var.environment, local.location, local.random)
  postgresql                     = format("psql-%s-%s-%s-%s", local.name, var.environment, local.location, local.random)
  name                           = "fibonacci"
  location                       = "uksouth"
  random                         = random_id.this.hex
  tags = {
    managedby   = "Terraform"
    pipeline    = "Github Actions"
    service     = "Frontend App"
    environment = var.environment
  }

  # values from the Docker build task
  docker_image_name   = format("%s/%s:%s", var.docker_username, var.docker_image_name, var.docker_image_tag)
  docker_registry_url = "https://index.docker.io"
}

resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = local.location
  tags     = local.tags
}

resource "azurerm_virtual_network" "this" {
  name                = local.virtual_network_name
  location            = local.location
  resource_group_name = azurerm_resource_group.this.name
  address_space = [
    "192.168.0.0/16"
  ]
}

resource "azurerm_subnet" "cae" {
  name                 = "cae"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes = [
    "192.168.0.0/21"
  ]
}

resource "azurerm_subnet" "pe" {
  name                 = "pe"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes = [
    "192.168.8.0/24"
  ]
}

resource "azurerm_container_app_environment" "this" {
  name                               = local.container_app_environment_name
  location                           = local.location
  resource_group_name                = azurerm_resource_group.this.name
  infrastructure_resource_group_name = local.cae_infra_resource_group_name
  infrastructure_subnet_id           = azurerm_subnet.cae.id
  workload_profile {
    name = "fibonacci"
    workload_profile_type = "consumption"
    minimum_count = 1
    maximum_count = 2
  }
}

resource "azurerm_container_app" "worker" {
  name                         = local.worker_container_app
  container_app_environment_id = azurerm_container_app_environment.this.id
  resource_group_name          = azurerm_resource_group.this.name
  revision_mode                = "single"

  template {
    container {
      name   = "worker"
      image  = local.worker_docker_image
      cpu    = "0.5"
      memory = "1.5"
    }
  }
}

resource "azurerm_container_app" "api" {
  name                         = local.api_container_app
  container_app_environment_id = azurerm_container_app_environment.this.id
  resource_group_name          = azurerm_resource_group.this.name
  revision_mode                = "single"

  template {
    container {
      name   = "api"
      image  = local.api_docker_image
      cpu    = "0.5"
      memory = "1.5"
    }
  }
}

resource "azurerm_container_app" "client" {
  name                         = local.client_container_app
  container_app_environment_id = azurerm_container_app_environment.this.id
  resource_group_name          = azurerm_resource_group.this.name
  revision_mode                = "single"

  template {
    container {
      name   = "client"
      image  = local.client_docker_image
      cpu    = "0.5"
      memory = "1.5"
    }
  }
}