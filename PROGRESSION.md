# Progression — Programme DevOps (Jours 3 à 10)

Jours 1 et 2 (Kubernetes) : validés, voir `~/kubernetes/PROGRESSION_DEVOPS.md`.
Légende : [ ] à faire · [~] en cours · [x] validé

## Jour 3 — GitHub Actions et CI/CD  [~]
- [x] Étape 1 : vocabulaire — workflow, event, job, step, runner (01-vocabulaire/)
- [x] Étape 2 : petite appli Python + tests (pytest) + lint (ruff), en local (02-appli-python/)
- [x] Étape 3 : dépôt GitHub + premier `.github/workflows/ci.yml` (push et pull request) (03-premier-workflow/)
- [~] Étape 4 : build et push d'image vers Docker Hub, seulement sur la branche principale
- [ ] Étape 5 : secrets GitHub, permissions minimales, gestion des échecs
- [ ] Étape 6 : réparer un pipeline cassé volontairement
- [ ] Défi du Jour 3
Validation : un push déclenche les tests et la publication conditionnelle.

## Jour 4 — Linux, Git, Bash et réseau  [ ]
## Jour 5 — AWS : IAM, VPC, EC2 et S3  [ ]
## Jour 6 — Terraform  [ ]
## Jour 7 — Prometheus, Grafana et diagnostic  [ ]
## Jour 8 — Projet final : API, CI et Kubernetes  [ ]
## Jour 9 — Projet final : AWS, monitoring, documentation  [ ]
## Jour 10 — Entretiens blancs et révisions  [ ]
(Détail des points de chaque jour : `~/kubernetes/PROGRESSION_DEVOPS.md`.)

## Journal
- 27/10/2026 : dossier CI&CD créé. Début du Jour 3, étape 1 (vocabulaire GitHub Actions).
- 27/10 : étape 1 validée (job/step, checkout obligatoire, needs). Début étape 2.
- 27/10 : étape 2 validée (venv, requirements-dev épinglé, 3 tests pytest, codes de sortie 0/1/5, ruff F401/I001, --fix local vs check en CI). Début étape 3.
- 27/10 : dépôt GitHub H-HABCHANE/DevOps-learning-labs créé et poussé (653b52d). Workflow .github/workflows/ci.yml (0c20cc2) : premier run ✅ en 25 s, 3 PASSED. Reste dans l'étape 3 : déclencheur pull_request (branche + PR avec test cassé).
- 27/10 : étape 3 validée. PR #1 (test cassé puis corrigé) fusionnée → merge c263f42, run push main ✅. Ruleset protection-main actif (status check tests requis) : désormais tout passe par branche + PR. Début étape 4 (Docker Hub).
- 27/10 : pause. commandes.md créé (toutes les commandes commentées), questions complétées dans les README 02 et 03. REPRISE : commande 21 (ranger la capture, branche notes-etape3, PR, merge), puis question sur paths:, puis étape 4 Docker Hub.
