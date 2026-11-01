# Calcul du prix TTC : application testée et livrée par la CI

Petite application Python qui calcule le prix TTC d'un plat (TVA restauration 10 %) et applique une remise.
Elle sert de support au pipeline d'intégration continue du dépôt.

## Contenu

| Fichier | Rôle |
|---|---|
| `app/calcul.py` | `prix_ttc()` et `remise()`, avec validation des entrées (prix négatif, pourcentage hors 0-100) |
| `app/__main__.py` | point d'entrée : `python -m app 42` → `42.0 € HT = 46.2 € TTC` |
| `tests/test_calcul.py` | tests pytest (cas normaux et erreurs) |
| `Dockerfile` | image `python:3.14-slim`, lancée avec `ENTRYPOINT ["python", "-m", "app"]` |
| `requirements-dev.txt` | outils de développement épinglés (pytest, ruff) |

## Le pipeline ([`.github/workflows/ci.yml`](../.github/workflows/ci.yml))

```
tests (ruff + pytest) ──► verifier-image (docker build + run) ──► publier-image (Docker Hub)
        à chaque PR et chaque push                                    seulement sur main
```

- **tests** : lint `ruff check .` puis `pytest -v`, avec cache pip ; résumé d'aide dans la page du run en cas d'échec.
- **verifier-image** : construit l'image et vérifie sa sortie (`10` → `11.0 € TTC`).
- **publier-image** : seulement après fusion sur `main` ; vérifie que les secrets existent, se connecte à Docker Hub et
  pousse deux étiquettes : le **SHA du commit** (traçable, permet un retour arrière précis) et `latest`.
- Permissions minimales (`contents: read`), `timeout-minutes`, `concurrency` pour annuler les runs obsolètes.
- Branche `main` protégée : une PR ne peut être fusionnée que si le check `tests` est vert.

## Lancer en local

```bash
python3 -m venv .venv && .venv/bin/pip install -r requirements-dev.txt
.venv/bin/ruff check . && .venv/bin/python -m pytest -v
docker build -t prix-ttc . && docker run --rm prix-ttc 42
```

## Ce que ce lab démontre

- Un pipeline qui **bloque** le code cassé avant la fusion, et des secrets qui ne sont jamais écrits dans le code.
- Un incident volontaire analysé : un `|| true` qui masquait un test en échec avait laissé passer une image fausse en
  production ; corrigé par un hotfix, puis prévention (interdire `|| true`, revue obligatoire, retour arrière par SHA).
