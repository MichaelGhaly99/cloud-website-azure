output "website_url" {
  description = "Öffentliche Adresse der statischen Website."
  value       = azurerm_storage_account.web.primary_web_endpoint
}

output "storage_account_name" {
  description = "Name des erzeugten Storage Accounts."
  value       = azurerm_storage_account.web.name
}

output "key_vault_name" {
  description = "Name des erzeugten Key Vault."
  value       = azurerm_key_vault.kv.name
}
