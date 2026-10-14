variable "resource_group_name" {
  description = "Name der Ressourcengruppe, in der das Modul die Ressourcen anlegt."
  type        = string
}

variable "location" {
  description = "Azure-Region für die Ressourcen des Moduls."
  type        = string
}

variable "website_path" {
  description = "Pfad zum Ordner mit den statischen Seiten (index.html, 404.html)."
  type        = string
}

variable "tags" {
  description = "Tags für die Ressourcen des Moduls."
  type        = map(string)
  default     = {}
}
