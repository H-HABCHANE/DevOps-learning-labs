resource "local_file" "menu" {
  filename             = "${path.module}/sortie/menu.txt"
  content              = "Menu de ${var.nom_restaurant}\n${join("\n", var.plats)}\n"
  file_permission      = "0644"
  directory_permission = "0755"
}
