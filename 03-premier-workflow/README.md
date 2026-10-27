# Étape 3 — Dépôt GitHub et premier workflow

Dépôt : https://github.com/H-HABCHANE/DevOps-learning-labs
Workflow : `.github/workflows/ci.yml`

## Le workflow
```yaml
name: CI

on:
  push:
    branches: [main]      # push : seulement sur main
  pull_request:           # toute PR (opened, synchronize, reopened)

permissions:
  contents: read          # moindre privilège : lecture seule

jobs:
  tests:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: 02-appli-python
    steps:
      - name: Récupérer le code
        uses: actions/checkout@v5
      - name: Installer Python
        uses: actions/setup-python@v6
        with:
          python-version: "3.14"
          cache: pip
          cache-dependency-path: 02-appli-python/requirements-dev.txt
      - name: Installer les outils
        run: pip install -r requirements-dev.txt
      - name: Lint (ruff)
        run: ruff check .
      - name: Tests (pytest)
        run: python -m pytest -v
```

## Commandes git
| Commande | Rôle |
|---|---|
| `git init -b main` | Créer le dépôt avec `main` comme branche principale |
| `.git/info/exclude` | Liste d'exclusion locale, jamais publiée |
| `git add <fichier>` puis `git status --short` | Préparer précisément et relire avant de commiter |
| `git commit -am "..."` | Raccourci : embarque **tous** les fichiers suivis modifiés (aveugle) |
| `git remote add origin git@github.com:...` | Relier le dépôt local à GitHub (SSH) |
| `git push -u origin main` | Premier push, mémorise la branche suivie |
| `git switch -c <branche>` | Créer une branche et s'y placer |
| `git switch main && git pull` | Repartir d'un `main` à jour avant chaque nouvelle branche |
| `git push origin --delete <branche>` | Supprimer une branche sur GitHub |
| `git log --oneline --graph` | Historique avec embranchements |

## Le cycle de travail
```
branche → commit → push → PR → CI ❌ → correction → CI ✅ → merge → CI sur main ✅
```
- Un push sur une branche autre que `main` ne déclenche rien (filtre `branches: [main]`).
- Ouvrir une PR ou pousser sur sa branche déclenche `pull_request` (`opened`, `synchronize`).
- Le merge crée un commit sur `main` → event `push` sur `main`.
- Ruleset `protection-main` (Settings → Rules → Rulesets) : *Require status checks to pass* (`tests`) sur la branche par défaut.
  Sans lui, un check rouge n'empêche pas le merge. Avec lui, push direct sur `main` refusé.
- Une PR montre la différence **finale** entre les branches ; l'onglet Commits montre le chemin.
- `Your branch is up to date with 'origin/main'` compare à la dernière copie connue : seul `fetch`/`pull` interroge GitHub.
- Cache pip : 1er run `Cache not found`, sauvegarde en fin de job (step *Post*), puis `Cache restored`.
  La clé contient une empreinte de `requirements-dev.txt`.

### Questions
**Pourquoi ne pas pousser `.venv/` ?**
→ Lié au système et aux chemins de la machine, lourd (52 Mo), non portable. Il se reconstruit depuis `requirements-dev.txt`.

**Pourquoi relire `git status` avant un commit ?**
→ Un secret commité reste dans l'historique même s'il est supprimé ensuite. S'il a été poussé : le considérer compromis
et le révoquer immédiatement.

**Pourquoi ne rien cocher (README, licence) à la création du dépôt GitHub ?**
→ GitHub créerait un commit sans ancêtre commun avec le dépôt local : le push serait refusé.

**Pourquoi ruff avant pytest ?**
→ Fail fast : les vérifications rapides d'abord, retour plus rapide ; si ruff échoue, pytest est sauté.

**Le workflow se lance-t-il avant le push ?**
→ Non : GitHub ne voit que ce qui a été poussé.

**Un check rouge bloque-t-il le merge ?**
→ Non par défaut, il est informatif. C'est la protection de branche (ruleset, status check requis) qui bloque.

**Pourquoi `git pull` avant de créer une branche ?**
→ Sinon la branche part d'un `main` périmé : code ancien et conflits au moment de la PR.

**Que montrera `git status --short` après `git init` ?**
→ `.gitignore`, `PROGRESSION.md`, `01-vocabulaire/`, `02-appli-python/` ; pas `.venv/` (`.gitignore`) ni `CLAUDE.md`
(`.git/info/exclude`). Un dossier entièrement nouveau est résumé en une ligne (`-uall` pour le détail).

**Le premier run : quel résultat, quelle durée ?**
→ ✅ en environ 25 s, 3 PASSED.

**Pousser une branche `test-pr` déclenche-t-il le workflow ?**
→ Non : l'event `push` est filtré sur `branches: [main]`. Le run démarre à l'ouverture de la PR.
Le filtre évite deux runs identiques (push + pull_request) pour chaque commit d'une PR.

**Que fait la PR avec un test cassé ? Le merge est-il bloqué ?**
→ Check ❌ (`assert 11.0 == 11.5` dans la step Tests), mais le merge reste possible sans protection de branche.

**Avec le ruleset, comment fusionner la PR ?**
→ Corriger sur la même branche et pousser : la PR suit sa branche, la CI se relance (`synchronize`), ✅ → merge débloqué.

**Pousser la correction sur `test-pr` déclenche-t-il un run ?**
→ Oui : event `pull_request`, type `synchronize`.

**Après le merge, quel run apparaît et pourquoi, sans `git push` ?**
→ Event `push` sur `main` : le merge crée un commit sur `main`, ce qui est un push sur `main`.
