resource "azurerm_user_assigned_identity" "oidc" {
  location            = var.location
  name                = "${var.prefix}-${var.environment}"
  resource_group_name = azurerm_resource_group.dev.name
}

resource "azurerm_federated_identity_credential" "oidc" {
  name                = "${var.github_organisation_target}-${var.github_repo_target}-${var.environment}"
  resource_group_name = azurerm_resource_group.dev.name
  audience            = [local.default_audience_name]
  issuer              = local.github_issuer_url
  parent_id           = azurerm_user_assigned_identity.oidc.id
  subject             = "repo:${var.github_organisation_target}/${var.github_repo_target}:environment:${var.environment}"
}