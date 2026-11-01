# Supervision : Prometheus, Grafana, Alertmanager et sonde boîte noire

Labo de supervision complet en Docker Compose : collecte des métriques, tableaux de bord, alertes envoyées à une
astreinte, et surveillance de la disponibilité vue par un client. Un incident a été simulé puis analysé.

## Architecture

```
            ┌──────────── scraping toutes les 15 s ────────────┐
            ▼                        ▼                         ▼
     node-exporter            blackbox-exporter ──teste──► site (nginx) / Grafana
     (CPU, mémoire du PC)     (la page répond-elle ?)
            │                        │
            └──────────► Prometheus ◄┘ ──règles──► Alertmanager ──webhook──► récepteur (astreinte)
                             │
                             └──► Grafana (dashboards)
```

| Service | Image | Rôle |
|---|---|---|
| prometheus | `prom/prometheus:v3.15.0` | collecte, stockage (volume), règles d'alerte, rechargement à chaud |
| node-exporter | `prom/node-exporter:v1.12.1` | métriques de la machine hôte |
| grafana | `grafana/grafana:13.2.4` | tableaux de bord ; source de données **provisionnée** par fichier |
| alertmanager | `prom/alertmanager:v0.34.1` | regroupement, répétition, notification de résolution |
| recepteur | `python:3.14-slim` | faux téléphone d'astreinte : affiche chaque notification reçue |
| blackbox | `prom/blackbox-exporter:v0.29.0` | sonde HTTP « client mystère » |
| site | `nginx:1.27-alpine` | le service surveillé, système de fichiers en **lecture seule** |

Tous les ports sont publiés sur `127.0.0.1` uniquement.

## Règles d'alerte (`alertes.yml`)

| Alerte | Condition | Durée | Gravité |
|---|---|---|---|
| CibleDown | `up == 0` | 1 min | critical |
| SiteIndisponible | `probe_success == 0` | 1 min | critical |
| CPUHaut | CPU > 80 % | 2 min | warning |
| MemoireBasse | mémoire libre < 10 % | 2 min | warning |

## Lancer

```bash
promtool check config prometheus.yml        # (via l'image prom/prometheus) avant d'appliquer
docker compose up -d && docker compose ps
# Prometheus : http://localhost:9090   Grafana : http://localhost:3000   Alertmanager : http://localhost:9093
docker compose stop site                    # simuler une panne...
docker logs recepteur                       # ...et lire les notifications FIRING puis RESOLVED
```

## Ce que ce lab démontre

- **Boîte blanche vs boîte noire** : site arrêté, `up` reste à 1 (la sonde répond) alors que `probe_success` tombe à 0.
  Alerter sur `up` n'aurait rien détecté.
- **Cycle complet d'une alerte** : Pending → Firing → notification → Resolved, avec un délai de détection mesuré
  (environ 1 min 30) et expliqué.
- **Incident simulé et post-mortem sans reproche** : site en 403 ; cause trouvée en croisant trois sources à la seconde
  près (métrique de la sonde, logs nginx `Permission denied`, `docker events` montrant un `chmod 000`), fausse piste
  CPU écartée, faux « résolu » après une mise en veille démenti par l'état réel, preuves sauvegardées puis réparation
  par recréation du conteneur.
- **Préventions appliquées et testées** : conteneur en `read_only` (l'attaque rejouée échoue : « Read-only file
  system ») et panel Grafana « Site disponible » (OK / EN PANNE) au lieu d'un tableau de bord resté vert.
- Pièges réels rencontrés : fichier de configuration monté seul (le conteneur gardait l'ancienne version), résolveur
  DNS minimal de busybox, données périmées dans un éditeur de dashboard.
