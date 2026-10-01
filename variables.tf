variable "location" {
  description = "Azure-Region, in der die Ressourcen erstellt werden."
  type        = string
  default     = "belgiumcentral"
}

variable "resource_group_name" {
  description = "Name der Ressourcengruppe, die alle Ressourcen der Website klammert."
  type        = string
  default     = "rg-studien-website"
}

variable "tags" {
  description = "Tags, die an allen Ressourcen gesetzt werden."
  type        = map(string)
  default = {
    projekt  = "studien-website"
    kurs     = "cloud-programming"
    umgebung = "portfolio"
  }
}
