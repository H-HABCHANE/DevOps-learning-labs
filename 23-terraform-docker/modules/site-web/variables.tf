variable "nom_site" {
  description = "Nom du conteneur et du réseau"
  type        = string
}

variable "port_web" {
  description = "Port de mon PC qui mène au nginx du conteneur"
  type        = number

  validation {
    condition     = var.port_web >= 1024 && var.port_web <= 65535
    error_message = "Le port doit être entre 1024 et 65535 (en dessous, il faut être root)."
  }
}

variable "message" {
  description = "Titre affiché sur la page d'accueil"
  type        = string
}
