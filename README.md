# Studien-Website auf Azure (Infrastructure as Code)

Dieses Terraform-Projekt stellt eine statische Website auf Microsoft Azure bereit. Der Inhalt liegt in einem Storage Account mit aktivierter Funktion "statische Website" und wird über HTTPS ausgeliefert. Die gesamte Infrastruktur wird als Code beschrieben und lässt sich reproduzierbar aufbauen und wieder entfernen.

Portfolio Phase 2, Kurs Cloud Programming.

## Architektur

- Azure Storage Account mit aktivierter Funktion "statische Website" (liefert index.html und 404.html).
- Azure Key Vault verwaltet Geheimnisse (hier der Zugriffsschlüssel des Storage Accounts) getrennt vom Code.
- Zusammengefasst in einer Ressourcengruppe.

Geplant ist zusätzlich Azure Front Door als globaler Einstiegspunkt (Zwischenspeicher weltweit, HTTPS und Web Application Firewall). Auf einem Azure-for-Students-Konto lässt sich Front Door nicht anlegen, daher ist dieser Dienst hier nicht im Deployment enthalten. Auf einem kostenpflichtigen Konto würde Front Door unverändert vor den Storage Account gesetzt.

## Voraussetzungen

- Ein Azure-Konto (zum Beispiel Azure for Students).
- Azure CLI installiert.
- Terraform ab Version 1.5.

## Bereitstellung

```bash
az login
terraform init
terraform plan
terraform apply
```

Nach dem Anlegen werden folgende Werte ausgegeben:

- website_url: die öffentliche Adresse der statischen Website.
- resource_group: der Name der erstellten Ressourcengruppe.

## Abbau

```bash
terraform destroy
```

Damit werden alle erstellten Ressourcen wieder entfernt, sodass keine laufenden Kosten entstehen.

## Sicherheit

- Öffentlicher Zugriff auf einzelne Blobs ist deaktiviert (allow_nested_items_to_be_public = false).
- Es wird ausschließlich Transport Layer Security ab Version 1.2 zugelassen.
- Der Zugriffsschlüssel des Storage Accounts wird im Key Vault gespeichert und nicht im Code oder in den Ausgaben offengelegt.
