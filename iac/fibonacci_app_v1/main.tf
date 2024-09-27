locals {
  # define some local variables
  resource_group_name            = format("rg-%s-%s-%s-%s", local.name, var.environment, local.location_short_code, local.random)
  virtual_network_name           = format("vnet-%s-%s-%s-%s", local.name, var.environment, local.location_short_code, local.random)
  cae_infra_resource_group_name  = format("rg-cae-infra-%s-%s-%s-%s", local.name, var.environment, local.location_short_code, local.random)
  postgresql_server_name         = format("psql-%s-%s-%s-%s", local.name, var.environment, local.location_short_code, local.random)
  redis_cache_name               = format("redis-%s-%s-%s-%s", local.name, var.environment, local.location_short_code, local.random)
  container_app_environment_name = format("cae-%s-%s-%s-%s", local.name, var.environment, local.location_short_code, local.random)
  api_container_app              = format("ca-api-%s-%s-%s-%s", local.name, var.environment, local.location_short_code, local.random)
  client_container_app           = format("ca-client-%s-%s-%s-%s", local.name, var.environment, local.location_short_code, local.random)
  nginx_container_app            = format("ca-nginx-%s-%s-%s-%s", local.name, var.environment, local.location_short_code, local.random)
  worker_container_app           = format("ca-worker-%s-%s-%s-%s", local.name, var.environment, local.location_short_code, local.random)
  api_docker_image               = format("index.docker.io/heathen1878/api:%s", var.docker_image_tag)
  client_docker_image            = format("index.docker.io/heathen1878/client:%s", var.docker_image_tag)
  nginx_docker_image             = format("index.docker.io/heathen1878/nginx:%s", var.docker_image_tag)
  worker_docker_image            = format("index.docker.io/heathen1878/worker:%s", var.docker_image_tag)
  redis_cache                    = format("redis-%s-%s-%s-%s", local.name, var.environment, local.location_short_code, local.random)
  postgresql                     = format("psql-%s-%s-%s-%s", local.name, var.environment, local.location_short_code, local.random)
  name                           = "fb"
  location                       = "uksouth"
  location_short_code            = "uks"
  random                         = random_id.this.hex
  tags = {
    managedby   = "Terraform"
    pipeline    = "Github Actions"
    environment = var.environment
  }

  # values from the Docker build task
  docker_image_name   = format("%s/%s:%s", var.docker_username, var.docker_image_name, var.docker_image_tag)
  docker_registry_url = "https://index.docker.io"
}

resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = local.location
  tags = merge(local.tags,
    {
      service = "Container App Environment"
    }
  )
}

resource "azurerm_virtual_network" "this" {
  name                = local.virtual_network_name
  location            = local.location
  resource_group_name = azurerm_resource_group.this.name
  address_space = [
    "192.168.0.0/16"
  ]
  tags = merge(local.tags,
    {
      service = "Networking"
    }
  )
}

resource "azurerm_subnet" "cae" {
  name                 = "cae"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes = [
    "192.168.0.0/21"
  ]

  delegation {
    name = "cae"
    service_delegation {
      name    = "Microsoft.App/environments"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_subnet" "pe" {
  name                 = "pe"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes = [
    "192.168.8.0/24"
  ]
}

resource "azurerm_subnet" "psql" {
  name                 = "psql"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes = [
    "192.168.9.0/24"
  ]
  service_endpoints = [
    "Microsoft.Storage"
  ]

  delegation {
    name = "psql"
    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_subnet" "redis" {
  name                 = "redis"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes = [
    "192.168.10.0/24"
  ]
}

resource "azurerm_private_dns_zone" "psql" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone" "redis" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "psql" {
  name                  = "psql"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.psql.name
  virtual_network_id    = azurerm_virtual_network.this.id

  depends_on = [
    azurerm_subnet.psql
  ]
}

resource "azurerm_private_dns_zone_virtual_network_link" "redis" {
  name                  = "redis"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.redis.name
  virtual_network_id    = azurerm_virtual_network.this.id

  depends_on = [
    azurerm_subnet.redis
  ]
}

resource "azurerm_postgresql_flexible_server" "this" {
  name                          = local.postgresql_server_name
  resource_group_name           = azurerm_resource_group.this.name
  location                      = local.location
  version                       = "12"
  delegated_subnet_id           = azurerm_subnet.psql.id
  private_dns_zone_id           = azurerm_private_dns_zone.psql.id
  public_network_access_enabled = false
  administrator_login           = var.psql_admin_username
  administrator_password        = var.psql_admin_password
  storage_mb                    = 32768
  storage_tier                  = "P4"
  sku_name                      = "B_Standard_B1ms"

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.psql
  ]

  // This block is used to ignore changes to the zone and standby_availability_zone
  lifecycle {
    ignore_changes = [
     zone,
     high_availability[0].standby_availability_zone,
    ]
  }
}

resource "azurerm_redis_cache" "this" {
  name                = local.redis_cache_name
  location            = local.location
  resource_group_name = azurerm_resource_group.this.name
  capacity            = 1
  family              = "C"
  sku_name            = "Basic"
  # family              = "P"
  # sku_name            = "Premium"
  minimum_tls_version = "1.2"
  #subnet_id           = azurerm_subnet.redis.id

  redis_configuration {
  }
}

resource "azurerm_container_app_environment" "this" {
  name                               = local.container_app_environment_name
  location                           = local.location
  resource_group_name                = azurerm_resource_group.this.name
  infrastructure_resource_group_name = local.cae_infra_resource_group_name
  infrastructure_subnet_id           = azurerm_subnet.cae.id
  workload_profile {
    name                  = "Dedicated"
    workload_profile_type = "D4"
    minimum_count         = 1
    maximum_count         = 2
  }
  tags = merge(local.tags,
    {
      service = "Container App Environment"
    }
  )
}

resource "azurerm_container_app" "worker" {
  name                         = local.worker_container_app
  container_app_environment_id = azurerm_container_app_environment.this.id
  resource_group_name          = azurerm_resource_group.this.name
  revision_mode                = "Single"
  workload_profile_name = "Dedicated"

  template {
    container {
      env {
        name  = "REDIS_HOST"
        value = azurerm_redis_cache.this.hostname
      }

      env {
        name  = "REDIS_PORT"
        value = "6379"
      }

      name   = "worker"
      image  = local.worker_docker_image
      cpu    = "1.0"
      memory = "2.0Gi"
    }
  }
  tags = merge(local.tags,
    {
      service = "Worker"
    }
  )
}

resource "azurerm_container_app" "api" {
  name                         = local.api_container_app
  container_app_environment_id = azurerm_container_app_environment.this.id
  resource_group_name          = azurerm_resource_group.this.name
  revision_mode                = "Single"
  workload_profile_name = "Dedicated"

  ingress {
    allow_insecure_connections = true
    target_port                = 5000

    traffic_weight {
      latest_revision = true
      percentage      = 100
      #revision_suffix = "primary"
    }
  }

  template {
    container {
      env {
        name  = "REDIS_HOST"
        value = azurerm_redis_cache.this.hostname
      }

      env {
        name  = "REDIS_PORT"
        value = "6379"
      }

      env {
        name  = "PGUSER"
        value = var.psql_admin_username
      }

      env {
        name  = "PGHOST"
        value = azurerm_postgresql_flexible_server.this.fqdn
      }

      env {
        name  = "PGDATABASE"
        value = "postgres"
      }

      env {
        name  = "PGPORT"
        value = "5432"
      }

      env {
        name  = "PGPASSWORD"
        value = var.psql_admin_password
      }

      name   = "api"
      image  = local.api_docker_image
      cpu    = "0.75"
      memory = "1.5Gi"
    }
  }
  tags = merge(local.tags,
    {
      service = "Api"
    }
  )
}

resource "azurerm_container_app" "client" {
  name                         = local.client_container_app
  container_app_environment_id = azurerm_container_app_environment.this.id
  resource_group_name          = azurerm_resource_group.this.name
  revision_mode                = "Single"
  workload_profile_name = "Dedicated"

  ingress {
    allow_insecure_connections = true
    target_port                = 3000

    traffic_weight {
      latest_revision = true
      percentage      = 100
      #revision_suffix = "primary"
    }
  }

  template {
    container {
      name   = "client"
      image  = local.client_docker_image
      cpu    = "0.75"
      memory = "1.5Gi"
    }
  }
  tags = merge(local.tags,
    {
      service = "Client"
    }
  )
  depends_on = [
    azurerm_container_app.api,
    azurerm_container_app.worker
  ]
}

resource "azurerm_container_app" "nginx" {
  name                         = local.nginx_container_app
  container_app_environment_id = azurerm_container_app_environment.this.id
  resource_group_name          = azurerm_resource_group.this.name
  revision_mode                = "Single"
  workload_profile_name = "Dedicated"

  ingress {
    allow_insecure_connections = true
    external_enabled           = true
    target_port                = 80

    traffic_weight {
      latest_revision = true
      percentage      = 100
      #revision_suffix = "primary"
    }
  }

  template {
    container {
      name   = "nginx"
      image  = local.nginx_docker_image
      cpu    = "1.0"
      memory = "2Gi"
    }
  }
  tags = merge(local.tags,
    {
      service = "NGinx"
    }
  )
  depends_on = [
    azurerm_container_app.api,
    azurerm_container_app.client,
    azurerm_container_app.worker
  ]
}