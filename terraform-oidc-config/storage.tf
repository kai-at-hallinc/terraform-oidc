resource "azurerm_storage_account" "tfstate" {
  name                     = "${lower(replace(var.prefix, "-", ""))}tfstate"
  resource_group_name      = azurerm_resource_group.dev.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tfstate" {
  name                  = var.tfcontainer
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

resource "azurerm_role_assignment" "storage_container" {
  scope                = azurerm_storage_container.tfstate.resource_manager_id
  role_definition_name = "Storage Blob Contributor"
  principal_id         = azurerm_user_assigned_identity.oidc.principal_id
}