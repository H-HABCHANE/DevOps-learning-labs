# Terraform : les bases avec le provider `local`

Première configuration Terraform, sans cloud et sans coût : elle génère le **menu du restaurant** dans un fichier.
Le but est de maîtriser le cycle de travail avant de piloter de vraies ressources.

## Contenu

| Fichier | Rôle |
|---|---|
| `versions.tf` | version de Terraform et provider `hashicorp/local` (`~> 2.5`) |
| `variables.tf` | `nom_restaurant` (texte) et `plats` (liste) |
| `main.tf` | ressource `local_file.menu` → `sortie/menu.txt`, permissions explicites `0644` / `0755` |
| `outputs.tf` | chemin du fichier et nombre de plats |
| `.terraform.lock.hcl` | versions et empreintes exactes du provider : même binaire pour toute l'équipe et la CI |

## Cycle de travail

```bash
terraform init                      # télécharge le provider (signé) et crée le fichier de verrouillage
terraform fmt -check && terraform validate
terraform plan -out=menu.tfplan     # relire le plan : + créer, ~ modifier, -/+ remplacer, - détruire
terraform apply menu.tfplan         # appliquer exactement le plan relu
terraform plan                      # « No changes » : idempotence
terraform apply -var 'plats=["couscous","tajine","pastilla"]'   # contenu modifié → forces replacement
terraform destroy
```

## Ce que ce lab démontre

- **Relire un plan avant d'appliquer** : la revue du premier plan a montré une valeur par défaut dangereuse
  (`directory_permission = "0777"`) ; elle a été corrigée en `0755` avant toute création.
- Le **state** fait le lien entre le code et la réalité ; il n'est jamais versionné (il peut contenir des secrets).
- Déclaratif et idempotent : on décrit l'état voulu, Terraform calcule les actions.
