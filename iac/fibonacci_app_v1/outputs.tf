output "usage" {
  value = "The client and api url need adding to the nginx default.conf file."
}

output "client" {
  value = azurerm_container_app.client
}

output "api" {
  value = azurerm_container_app.api
}