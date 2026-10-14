# Studien-Website auf Azure (Infrastructure as Code)

Dieses Terraform-Projekt stellt eine statische Website auf Microsoft Azure bereit. Der Inhalt liegt in einem Storage Account mit aktivierter Funktion "statische Website" und wird über HTTPS ausgeliefert. Die Infrastruktur ist als wiederverwendbares Modul beschrieben und lässt sich reproduzierbar aufbauen und wieder entfernen.

Portfolio Phase 3, Kurs Cloud Programming.

## Projektstruktur

- `main.tf`, `variables.tf`, `outputs.tf`, `providers.tf`: Wurzelkonfiguration. Sie legt die Ressourcengruppe an und ruft das Modul auf.
- `modules/static_website/`: Modul mit Storage Account (statische Website), den hochgeladenen Seiten und dem Key Vault. Es erhält seine Werte ausschließlich über Variablen (`resource_group_name`, `location`, `website_path`, `tags`) und bleibt dadurch wiederverwendbar.
- `website/`: die statischen Seiten `index.html` und `404.html`.

## Architektur

- Azure Storage Account mit aktivierter Funktion "statische Website".
- Azure Key Vault verwaltet Geheimnisse (Zugriffsschlüssel des Storage Accounts) getrennt vom Code.
- Zusammengefasst in einer Ressourcengruppe.

Geplant ist zusätzlich Azure Front Door als globaler Einstiegspunkt. Auf einem Azure-for-Students-Konto lässt sich Front Door nicht anlegen, daher ist dieser Dienst hier nicht enthalten. Auf einem kostenpflichtigen Konto ließe er sich als weiteres Modul vor den Storage Account setzen.

## Voraussetzungen

- Ein Azure-Konto (zum Beispiel Azure for Students), die Azure CLI und Terraform ab Version 1.5.

## Bereitstellung

```bash
az login
terraform init
terraform plan
terraform apply
```

Nach dem Anlegen gibt `website_url` die Adresse der Website aus und `resource_group` den Namen der Ressourcengruppe.

## Abbau

```bash
terraform destroy
```

## Sicherheit

- Öffentlicher Zugriff auf einzelne Blobs ist deaktiviert (`allow_nested_items_to_be_public = false`).
- Es wird ausschließlich Transport Layer Security ab Version 1.2 zugelassen.
- Der Zugriffsschlüssel des Storage Accounts liegt im Key Vault, nicht im Code oder in den Ausgaben.
