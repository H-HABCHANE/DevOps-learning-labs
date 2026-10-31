module "accueil" {
  source = "./modules/site-web"

  nom_site = var.nom_site
  port_web = var.port_web
  message  = var.message
}

module "promo" {
  source = "./modules/site-web"

  nom_site = "promo-labo"
  port_web = 8081
  message  = "Promo : couscous à moitié prix"
}

# Les ressources existantes changent d'adresse : on le dit à Terraform au lieu de détruire et recréer.
moved {
  from = docker_network.reseau
  to   = module.accueil.docker_network.reseau
}

moved {
  from = docker_image.nginx
  to   = module.accueil.docker_image.nginx
}

moved {
  from = docker_container.web
  to   = module.accueil.docker_container.web
}
