locals {
  # define some local variables
  resource_group_name = format("rg-%s-%s-%s-%s", local.name, var.environment, local.location, local.random)
  app_service_plan    = format("plan-%s-%s-%s-%s", local.name, var.environment, local.location, local.random)
  app_service_name    = format("app-%s-%s-%s-%s", local.name, var.environment, local.location, local.random)
  name                = "frontend"
  location            = "uksouth"
  random              = random_id.this.hex
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
  sku_name            = "B1"
  tags                = local.tags
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
    health_check_path                 = "/index.html"
    health_check_eviction_time_in_min = 2
  }
  tags = local.tags
}