locals {
  # define some local variables
  resource_group_name = format("rg-%s-%s-%s", local.name, local.location, local.random)
  app_service_plan    = format("plan-%s-%s-%s", local.name, local.location, local.random)
  app_service_name    = format("app-%s-%s-%s", local.name, local.location, local.random)
  name                = "frontend"
  location            = "uksouth"
  random              = random_id.this.hex
  tags = {
    managedby = "Terraform"
    pipeline  = "Github Actions"
  }

  # values from the Docker build task
  docker_image_name   = "frontend"
  docker_registry_url = "https://index.docker.io"
}

resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = local.location
  tags = local.tags
}

resource "azurerm_service_plan" "this" {
  name                = local.app_service_plan
  location            = local.location
  resource_group_name = azurerm_resource_group.this.name
  os_type             = "Linux"
  sku_name            = "P0v3"
}

resource "azurerm_linux_web_app" "this" {
  name                = local.app_service_name
  location            = local.location
  resource_group_name = azurerm_resource_group.this.name
  service_plan_id     = azurerm_service_plan.this.id

  site_config {
    application_stack {
      docker_image_name   = local.docker_image_name
      docker_registry_url = local.docker_registry_url
    }
  }
}