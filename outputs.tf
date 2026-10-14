output "website_url" {
  description = "Öffentliche Adresse der statischen Website."
  value       = module.static_website.website_url
}

output "resource_group" {
  description = "Name der erstellten Ressourcengruppe."
  value       = azurerm_resource_group.rg.name
}
