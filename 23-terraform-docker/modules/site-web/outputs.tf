output "url" {
  description = "Adresse du site"
  value       = "http://localhost:${var.port_web}/"
}

output "id_conteneur" {
  description = "ID du conteneur créé par Docker"
  value       = docker_container.web.id
}
