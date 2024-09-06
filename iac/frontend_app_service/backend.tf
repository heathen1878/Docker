terraform {
  backend "azurerm" {
    storage_account_name = var.state_storage_accounts
    container_name = var.state_storage_container
    key = var.state_file_name
    use_azuread_auth = true
  }
}