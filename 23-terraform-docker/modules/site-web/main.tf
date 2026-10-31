terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

resource "docker_network" "reseau" {
  name = "${var.nom_site}-reseau"
}

resource "docker_image" "nginx" {
  name         = "nginx:1.27-alpine"
  keep_locally = true
}

resource "docker_container" "web" {
  name    = var.nom_site
  image   = docker_image.nginx.image_id
  restart = "unless-stopped"

  ports {
    internal = 80
    external = var.port_web
  }

  networks_advanced {
    name = docker_network.reseau.name
  }

  upload {
    content = "<h1>${var.message}</h1>\n"
    file    = "/usr/share/nginx/html/index.html"
  }
}
