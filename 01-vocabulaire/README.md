# Étape 1 — Vocabulaire GitHub Actions

## CI / CD
- **CI** (intégration continue) : à chaque modification, le code est vérifié automatiquement (tests, lint).
- **CD** (livraison / déploiement continu) : si les vérifications passent, on publie ou déploie automatiquement.

## Les mots
| Mot | Rôle | Exemple |
|---|---|---|
| Workflow | Fichier YAML qui décrit l'automatisation | `.github/workflows/ci.yml` |
| Event | Ce qui déclenche le workflow | `push`, `pull_request`, `schedule`, `workflow_dispatch` |
| Job | Groupe de steps exécuté sur **un seul** runner | `tests`, `publier-image` |
| Step | Une commande (`run:`) ou une action toute faite (`uses:`) | `run: pytest`, `uses: actions/checkout@v4` |
| Runner | Machine (VM neuve) qui exécute un job | `runs-on: ubuntu-latest` |

## Règles
1. Le runner est neuf et vide à chaque exécution : il faut `actions/checkout` puis installer les dépendances.
2. Les steps d'un job s'exécutent dans l'ordre et partagent la même machine (fichiers conservés entre steps).
   Une step qui échoue (code de sortie ≠ 0) arrête le job, qui devient rouge.
3. Les jobs tournent en parallèle, chacun sur sa propre machine, sans rien partager par défaut.
   `needs:` impose un ordre et une condition de réussite.

```yaml
name: CI
on: [push, pull_request]
jobs:
  tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: pip install pytest
      - run: pytest
  publier-image:
    needs: tests
    runs-on: ubuntu-latest
    steps:
      - run: echo "publication"
```

### Questions
**Différence entre job et step ?**
→ Un job est un groupe de steps exécuté sur un seul runner. Une step est une seule commande (`run`) ou action (`uses`)
dans ce job. Les steps d'un job partagent la même machine ; deux jobs sont sur deux machines différentes.

**Que se passe-t-il avec seulement `run: pytest`, sans checkout ?**
→ Échec : le runner est une machine neuve qui ne contient pas le code. pytest n'est pas installé
(`command not found`) ; même installé, il ne trouverait aucun test (code de sortie 5).

**Publier l'image seulement si les tests passent ?**
→ Ajouter `needs: tests` dans le job `publier-image` : il attend la réussite de `tests`, sinon il est sauté.
