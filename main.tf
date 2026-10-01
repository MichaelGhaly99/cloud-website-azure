# Eindeutiges Suffix für global eindeutige Namen (Storage Account, Key Vault)
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

# Informationen über den angemeldeten Benutzer bzw. Service Principal
data "azurerm_client_config" "current" {}

# Ressourcengruppe: klammert alle Ressourcen der Website
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# --- Storage Account mit aktivierter statischer Website ---
resource "azurerm_storage_account" "web" {
  name                            = "stweb${random_string.suffix.result}"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  account_kind                    = "StorageV2"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  tags                            = var.tags

  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }
}

# Startseite in den $web-Container hochladen
resource "azurerm_storage_blob" "index" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.web.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source                 = "${path.module}/website/index.html"
}

# Fehlerseite (404) hochladen
resource "azurerm_storage_blob" "error" {
  name                   = "404.html"
  storage_account_name   = azurerm_storage_account.web.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source                 = "${path.module}/website/404.html"
}

# Hinweis: Azure Front Door ist auf einem Studierenden-Konto nicht verfügbar
# und wurde deshalb aus dem Deployment entfernt. In der Architektur bleibt es
# als geplanter globaler Einstiegspunkt bestehen (siehe Konzept und Präsentation).
# Auf einem kostenpflichtigen Konto würde es unverändert vor den Storage Account gesetzt.

# --- Key Vault: verwaltet Geheimnisse getrennt vom Code ---
resource "azurerm_key_vault" "kv" {
  name                     = "kv-web-${random_string.suffix.result}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  tenant_id                = data.azurerm_client_config.current.tenant_id
  sku_name                 = "standard"
  purge_protection_enabled = false
  tags                     = var.tags
}

# Zugriffsrichtlinie für den ausführenden Benutzer bzw. Service Principal
resource "azurerm_key_vault_access_policy" "deployer" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = ["Get", "List", "Set", "Delete", "Purge"]
}

# Der Zugriffsschlüssel des Storage Accounts wird im Key Vault abgelegt und
# bewusst nicht im Code oder in den Ausgaben offengelegt.
resource "azurerm_key_vault_secret" "storage_key" {
  name         = "storage-primary-access-key"
  value        = azurerm_storage_account.web.primary_access_key
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_key_vault_access_policy.deployer]
}
