variable "nom_restaurant" {
  description = "Nom affiché en haut du menu"
  type        = string
  default     = "Chez Hicham"
}

variable "plats" {
  description = "Liste des plats du jour"
  type        = list(string)
  default     = ["couscous", "tajine"]
}
