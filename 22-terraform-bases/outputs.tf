output "chemin_menu" {
  description = "Où se trouve le menu généré"
  value       = local_file.menu.filename
}

output "nombre_plats" {
  description = "Nombre de plats au menu"
  value       = length(var.plats)
}
