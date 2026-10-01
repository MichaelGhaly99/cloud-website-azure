output "website_url" {
  description = "Öffentliche Adresse der statischen Website (Storage Account)."
  value       = azurerm_storage_account.web.primary_web_endpoint
}

output "resource_group" {
  description = "Name der erstellten Ressourcengruppe."
  value       = azurerm_resource_group.rg.name
}
