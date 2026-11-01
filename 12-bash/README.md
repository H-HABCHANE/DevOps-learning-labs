# verifier-service.sh : diagnostiquer un service couche par couche

Script Bash qui répond à la question « pourquoi mon site ne répond pas ? » en testant dans l'ordre :

```
1. DNS   : le nom donne-t-il une adresse IP ?     (getent)   → code de sortie 1 si non
2. Port  : un programme écoute-t-il ?             (nc -z)    → code de sortie 2 si non
3. HTTP  : le service répond-il 2xx ou 3xx ?      (curl)     → code de sortie 3 si non
                                                               code 0 : tout va bien
```

## Utilisation

```bash
./verifier-service.sh <hôte> <port> [chemin]
./verifier-service.sh localhost 8080 /
DELAI_PORT=5 ./verifier-service.sh mon-serveur.example 80 /health   # délai du test de port (2 s par défaut)
```

Exemple de sortie :

```
🔎 Vérification de http://localhost:8080/
✅ DNS  : localhost → 127.0.0.1
✅ Port : 8080 ouvert
✅ HTTP : code 200
🎉 Service opérationnel
```

## Choix de conception

- `set -euo pipefail` : le script s'arrête à la première erreur, refuse les variables non définies et n'ignore pas les
  échecs au milieu d'un pipe.
- Arguments obligatoires vérifiés (`${1:?Usage…}`), variables toujours entre guillemets.
- **Un code de sortie par couche** : un autre script, une CI ou une supervision peut réagir automatiquement.
- Un conseil de diagnostic est affiché à chaque échec (`ss -tlnp`, lire les logs).

## Ce que ce lab démontre

- La méthode de dépannage réseau du bas vers le haut, utilisée ensuite sur une instance EC2 et dans un exercice
  « service inaccessible » (processus imposteur sur le port, permissions, écoute sur 127.0.0.1, faute de frappe DNS).
- Travail Git en équipe : la variable `DELAI_PORT` est née de la **résolution d'un conflit** entre deux branches
  (rebase, `--force-with-lease`), avant fusion par PR.
- Ce script est l'ancêtre de la **sonde boîte noire** du lab de supervision ([`26-prometheus`](../26-prometheus/)).
