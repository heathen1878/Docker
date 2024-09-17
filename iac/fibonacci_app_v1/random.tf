resource "random_id" "this" {
  keepers = {
    key = data.azurerm_client_config.current.subscription_id
  }

  byte_length = 4
}