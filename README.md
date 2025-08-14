# Single-cell Tuto R

Ce projet propose un environnement reproductible pour l'analyse de données single-cell avec **Seurat** et **Azimuth**, géré avec `renv` sous **WSL2 (Ubuntu 22.04)**.

## 📁 Contenu

- `renv.lock` : fige toutes les dépendances R du projet.
- `renv/activate.R` : active l'environnement `renv` au lancement de R.
- `renv/settings.json` : ignore les dépendances de type `Suggests` (comme `JASPAR2020`) pour éviter les erreurs d'installation inutiles.
- `setup_sc_env.sh` : script shell d’installation automatique des paquets R et de l’environnement.

## ⚙️ Prérequis

- R ≥ 4.5.1 (testé avec succès)
- WSL2 avec Ubuntu 22.04
- `git`, `curl`, `gcc`, `make`, `libssl-dev`
- **Dépendances système requises pour Azimuth :**
  - `libgsl0-dev` (pour `DirichletMultinomial`)
  - `libfftw3-dev`
  - `liblapack-dev`
- [micromamba](https://mamba.readthedocs.io/en/latest/micromamba.html) (ou un autre système de gestion d'environnement Python)
- Connexion internet active (pour récupérer les packages CRAN, GitHub et Bioconductor)

💡 **Recommandation Microsoft** : pour de meilleures performances, clone ce projet dans un répertoire Linux (ex. `/home/tonutilisateur/`) au lieu d’un répertoire Windows monté (`/mnt/c/...`).

---

## 🚀 Installation

Depuis WSL, clone le projet et exécute le script :

```bash
# 1. Cloner le repo (dans un répertoire Linux de préférence)
cd ~
git clone https://github.com/Koryums/singlecell_tuto_R.git
cd singlecell_tuto_R

# 2. (Optionnel) Activer ton environnement micromamba (si Python est requis)
micromamba activate sc  # ou conda activate sc

# 3. Exécuter le script shell qui :
# - crée le dossier lib utilisateur
# - installe les dépendances Bioconductor
# - installe Azimuth (en ignorant les Suggests)
bash setup_sc_env.sh
Le script R prend soin de :

forcer l’utilisation de Bioconductor 3.21, compatible avec R 4.5

installer les packages bloquants manuellement (TFBSTools, DirichletMultinomial, etc.)

utiliser remotes::install_github() pour Azimuth

capturer un snapshot propre à la fin avec renv

🧪 Test rapide
Une fois l’installation faite, ouvre une session R :

r
Copier
Modifier
renv::activate()
library(Seurat)
library(presto)
library(Azimuth)
sessionInfo()
Tu devrais voir la version correcte de R, Azimuth, Seurat, et presto chargées sans erreur.

🧷 Astuces
Le script ne déclenche pas de restart de session R automatique, car tout est encapsulé sans toucher aux options globales renv.

Les packages sont installés dans ~/R/x86_64-pc-linux-gnu-library/4.5 pour éviter les conflits avec /usr/local.

✉️ Contact
Pour toute question ou suggestion : @Koryums

© Altograph 2025