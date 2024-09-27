output "usage" {
  value = "The client and api url need adding to the nginx default.conf file."
}

output "client" {
  value     = azurerm_container_app.client
  sensitive = true
}

output "api" {
  value     = azurerm_container_app.api
  sensitive = true
}

output "redis" {
  value     = azurerm_container_app.redis
  sensitive = true
}