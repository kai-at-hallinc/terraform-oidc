provider "azurerm" {
  alias                      = "secondary"
  use_oidc                   = true
  skip_provider_registration = true
  features {}
}

provider "tls" {}
