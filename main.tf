# Ressourcengruppe: klammert alle Ressourcen der Website
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Das Modul kapselt die statische Website und die Geheimnisverwaltung.
# Es erhält seine Werte ausschließlich über Variablen und bleibt dadurch
# wiederverwendbar.
module "static_website" {
  source = "./modules/static_website"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  website_path        = "${path.root}/website"
  tags                = var.tags
}
