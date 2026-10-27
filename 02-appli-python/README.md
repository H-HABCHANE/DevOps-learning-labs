# Étape 2 — Appli Python, tests et lint en local

Principe : la CI refait automatiquement ce qu'on sait faire à la main. On valide donc tout en local d'abord.

## Structure
```
02-appli-python/
├── app/calcul.py           # prix_ttc(prix_ht, tva=0.10)
├── tests/test_calcul.py    # 3 tests pytest
└── requirements-dev.txt    # outils de vérification, versions épinglées
```

## Commandes
| Commande | Rôle |
|---|---|
| `python3 -m venv .venv` | Environnement Python isolé |
| `.venv/bin/pip install -r requirements-dev.txt` | Installer les outils aux versions exactes |
| `python -m pytest -v` (depuis `02-appli-python/`) | Lancer les tests ; `-m` ajoute le dossier courant aux imports |
| `ruff check .` | Lint : vérifier sans modifier (usage CI) |
| `ruff check --fix .` | Corriger automatiquement (usage local) |
| `echo $?` | Code de sortie de la dernière commande |

## À retenir
- GitHub Actions ne lit que le **code de sortie** : `0` → step réussie, autre chose → step en échec, job rouge, steps suivantes sautées.
- pytest : `0` = tout passe, `1` = au moins un test échoue, `5` = aucun test trouvé (évite un faux vert).
- Lecture d'un échec pytest : `F..` (une lettre par test), ligne `>` = assertion fautive, ligne `E` = valeur obtenue vs attendue, `fichier:ligne`.
- Un test rouge ne veut pas dire que le code est faux : le test lui-même peut être erroné.
- ruff : `F401` import inutilisé (Pyflakes), `I001` imports mal organisés (isort) ; `[*]` = corrigeable par `--fix`.
- `&&` enchaîne seulement si la commande précédente réussit ; `;` enchaîne toujours.

### Questions
**Faut-il refaire le `pip install` à chaque exécution du workflow ?**
→ Oui : le runner est neuf à chaque fois. Le cache (`actions/setup-python` avec `cache: pip`) accélère le téléchargement mais l'installation se refait.

**Pourquoi épingler les versions ?**
→ Build reproductible : même code + mêmes versions = même résultat en local et en CI. Sans épinglage, une nouvelle version d'un outil peut casser le pipeline sans changement de code.

**`no tests ran` en CI : vert ou rouge ?**
→ Rouge (code 5). C'est voulu : pas de tests = aucune preuve, on évite un faux vert.

**En CI : `ruff check --fix .` ou `ruff check .` ?**
→ `ruff check .`. La correction faite sur le runner serait perdue à sa destruction, et la CI doit signaler le problème, pas le masquer. On corrige en local avec `--fix`.
