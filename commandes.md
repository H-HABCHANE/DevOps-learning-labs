# Commandes — CI/CD et DevOps

Toutes les commandes utilisées, avec leur rôle. Dossier de travail : `~/CI&CD` (le `&` s'écrit `\&` dans le shell).

## Shell (bash)
```bash
mkdir -p 02-appli-python/app          # créer un dossier et ses parents ; pas d'erreur s'il existe déjà
cmd1 && cmd2                          # lancer cmd2 seulement si cmd1 réussit (code de sortie 0)
cmd1 ; cmd2                           # lancer cmd2 dans tous les cas
echo "Code de sortie : $?"            # afficher le code de sortie de la dernière commande (0 = succès)
printf 'ligne1\nligne2\n' > fichier   # écrire du texte dans un fichier ; > ÉCRASE (vide d'abord le fichier)
printf 'ligne\n' >> fichier           # AJOUTER à la fin du fichier sans l'écraser
cat fichier                           # afficher le contenu d'un fichier
cat > fichier <<'EOF'                 # heredoc : écrire plusieurs lignes dans un fichier jusqu'à EOF
...                                   #   'EOF' entre guillemets : texte copié tel quel ($ non interprété)
EOF
sed -i 's/ancien/nouveau/' fichier    # remplacer du texte directement dans le fichier (-i = in place)
sed -i '1i texte' fichier             # insérer une ligne avant la ligne 1
mv "nom avec espaces.png" ~/Pictures/ # déplacer un fichier ; guillemets obligatoires si espaces
ls -a                                 # lister, y compris les fichiers cachés (.venv, .git, .gitignore)
du -sh .venv                          # taille totale d'un dossier
cd ~/CI\&CD                           # \& : le & fait partie du nom (sinon = lancer en arrière-plan)
```

## Python : environnement, tests, lint
```bash
python3 -m venv .venv                                   # créer un environnement Python isolé dans .venv/
.venv/bin/pip install pytest ruff                       # installer des paquets DANS le venv (sans activation)
.venv/bin/pip install -r requirements-dev.txt           # installer la liste exacte des outils (versions épinglées)
cd 02-appli-python && ~/CI\&CD/.venv/bin/python -m pytest -v
                                                        # lancer les tests ; -m ajoute le dossier courant aux imports ;
                                                        # -v = un test par ligne ; chemin absolu = pas de warning
python -m pytest -q                                     # sortie courte (résumé seulement)
ruff check .                                            # lint : vérifier sans modifier (usage CI)
ruff check --fix .                                      # corriger automatiquement les erreurs [*] (usage local)
```
Codes de sortie pytest : `0` tout passe · `1` au moins un échec · `5` aucun test trouvé.

## Git : dépôt local
```bash
git init -b main                                  # créer le dépôt (.git/) avec main comme branche principale
printf 'CLAUDE.md\n.claude/\n' >> .git/info/exclude   # exclusion locale, jamais envoyée sur GitHub
git status --short                                # état court : ?? non suivi · A ajouté · M modifié
git status --short -uall                          # idem, en détaillant le contenu des dossiers non suivis
git add <fichier>                                 # préparer un fichier précis pour le prochain commit
git add .                                         # préparer tout le dossier (fichiers ignorés exclus)
git commit -m "message"                           # enregistrer la photo des fichiers préparés
git commit -am "message"                          # add + commit de TOUS les fichiers suivis modifiés (aveugle ;
                                                  #   ignore les nouveaux fichiers)
git log --oneline                                 # historique, un commit par ligne (hash court + message)
git log --oneline --graph -6                      # historique dessiné avec les branches (6 derniers commits)
git show --stat --oneline HEAD                    # fichiers modifiés par le dernier commit
```

## Git : GitHub et branches
```bash
git remote add origin git@github.com:H-HABCHANE/DevOps-learning-labs.git
                                                  # relier le dépôt local à GitHub (adresse SSH, clé ~/.ssh)
git push -u origin main                           # premier envoi ; -u mémorise la branche suivie
git push                                          # envoyer les nouveaux commits (branche déjà suivie)
git branch --show-current                         # afficher la branche courante
git switch -c test-pr                             # créer une branche et s'y placer
git switch main                                   # revenir sur main
git pull                                          # récupérer les nouveaux commits de GitHub (ex. après un merge)
git branch -d test-pr                             # supprimer une branche locale (refuse si non fusionnée)
git push origin --delete test-pr                  # supprimer une branche sur GitHub
git push -u origin notes-etape3                   # envoyer une nouvelle branche
git ls-remote --heads origin                      # lister les branches présentes sur GitHub
```

## Cycle de travail avec CI et main protégée
```bash
git switch main && git pull                       # 1. partir d'un main à jour
git switch -c ma-branche                          # 2. créer une branche
# ... modifications ...
git add <fichiers> && git status --short          # 3. préparer et RELIRE
git commit -m "..." && git push -u origin ma-branche   # 4. commit + push
# 5. GitHub : Create pull request → attendre le check ✅ → Merge → Delete branch
git switch main && git pull && git branch -d ma-branche   # 6. remettre le PC à jour
```

## GitHub (interface web)
| Où | Rôle |
|---|---|
| `github.com/new` | Créer un dépôt (ne rien cocher si un dépôt local existe déjà) |
| Onglet **Actions** | Voir les runs : event, branche, durée, logs de chaque step |
| `.../compare/main...<branche>` | Comparer une branche à main et créer une PR |
| PR → **Details** du check | Logs du run de la PR |
| **Settings → Rules → Rulesets** | Protéger main : *Require status checks to pass* (`tests`) |
