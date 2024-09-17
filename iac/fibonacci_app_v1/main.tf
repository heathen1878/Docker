locals {
  # define some local variables
  resource_group_name     = format("rg-%s-%s-%s-%s", local.name, var.environment, local.location, local.random)
  app_service_plan        = format("plan-%s-%s-%s-%s", local.name, var.environment, local.location, local.random)
  client_app_service_name = format("app-client-%s-%s-%s-%s", local.name, var.environment, local.location, local.random)
  api_app_service_name    = format("app-api-%s-%s-%s-%s", local.name, var.environment, local.location, local.random)
  worker_app_service_name = format("app-worker-%s-%s-%s-%s", local.name, var.environment, local.location, local.random)
  redis_cache             = format("redis-%s-%s-%s-%s", local.name, var.environment, local.location, local.random)
  postgresql              = format("psql-%s-%s-%s-%s", local.name, var.environment, local.location, local.random)
  name                    = "frontend"
  location                = "uksouth"
  random                  = random_id.this.hex
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




resource "azurerm_service_plan" "this" {
  name                = local.app_service_plan
  location            = local.location
  resource_group_name = azurerm_resource_group.this.name
  os_type             = "Linux"
  sku_name            = "P0v3"
  tags                = local.tags
}

