resource "azurerm_resource_group" "dev" {
  name     = "${var.prefix}-rg"
  location = var.location
}

resource "azurerm_role_assignment" "dev" {
  scope                = azurerm_resource_group.dev.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.oidc.principal_id
}