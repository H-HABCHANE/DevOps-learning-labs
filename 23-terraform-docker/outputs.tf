output "url" {
  description = "Adresse du site"
  value       = module.accueil.url
}

output "id_conteneur" {
  description = "ID du conteneur créé par Docker"
  value       = module.accueil.id_conteneur
}

output "url_promo" {
  description = "Adresse du site promo"
  value       = module.promo.url
}
