# Terraform : un site web avec le provider Docker, puis un module réutilisable

Terraform pilote ici le **démon Docker local** (provider `kreuzwerker/docker` 4.6) pour déployer des sites nginx.
C'est le même raisonnement qu'avec un cloud (réseau → image → serveur), sans compte ni facture.

## Architecture

```
module "accueil"  (port 8080, « Bonjour depuis Terraform »)
module "promo"    (port 8081, « Promo : couscous à moitié prix »)
        │  chaque appel crée :
        ├── docker_network.reseau
        ├── docker_image.nginx        (nginx:1.27-alpine, keep_locally)
        └── docker_container.web      (port publié, page d'accueil injectée par upload)
```

| Fichier | Rôle |
|---|---|
| `modules/site-web/` | le module : variables d'entrée, 3 ressources, sorties (URL, identifiant du conteneur) |
| `main.tf` | deux appels du module + blocs `moved` |
| `variables.tf` | `port_web` avec une **validation** (1024-65535) : une valeur invalide est refusée dès le plan |

## Lancer

```bash
terraform init && terraform plan -out=site.tfplan && terraform apply site.tfplan
curl -s localhost:8080 ; curl -s localhost:8081
terraform plan -destroy -out=destroy.tfplan && terraform apply destroy.tfplan
```

## Ce que ce lab démontre

- **Graphe de dépendances** : l'image et le réseau sont créés en parallèle, puis le conteneur ; à la destruction,
  l'ordre est inversé automatiquement.
- **Drift** : un conteneur arrêté à la main est détecté au plan suivant et remplacé pour revenir à l'état décrit.
- **State** : fichier JSON en clair (permissions resserrées à `600`) ; en équipe, backend distant avec verrou.
- **Refactoring sans casse** : déplacer les ressources dans un module avec des blocs `moved` donne `0 to destroy`
  au lieu de tout détruire et recréer.
- **Reproductibilité** : après une destruction accidentelle (un `cd` raté suivi de `;`), tout a été recréé en une
  commande. Leçons retenues : enchaîner avec `&&`, appliquer un plan relu, `prevent_destroy` sur les ressources
  critiques.
