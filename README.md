# Single-cell Tuto R

Ce projet propose un environnement reproductible pour l'analyse de données single-cell avec **Seurat** et **Azimuth**, géré avec `renv` dans R et configuré pour fonctionner sous **WSL2** (Ubuntu).

## 📂 Contenu

- `renv.lock` : fige toutes les dépendances R du projet.
- `renv/activate.R` : active l'environnement `renv` au lancement de R.
- `setup_sc_env.sh` : script bash pour initialiser proprement l'environnement.

## ⚙️ Prérequis

- R >= 4.5.1
- WSL2 avec Ubuntu 22.04
- `git`, `curl`, `gcc`, `libgsl0-dev`, `libfftw3-dev`, `liblapack-dev`, etc.
- [micromamba](https://mamba.readthedocs.io/en/latest/micromamba.html) ou un environnement Python préactivé si besoin

## 🔧 Installation

Depuis WSL, clone le projet et lance le script d'installation R :

```bash
# Clone du repo
cd ~/Documents/R_for_WSL
git clone https://github.com/Koryums/singlecell_tuto_R.git
cd singlecell_tuto_R

# (Optionnel) Active ton environnement micromamba
micromamba activate sc  # ou autre selon ton setup

# Exécute le setup R (installation des packages R, renv, Azimuth...)
bash setup_sc_env.sh
```

## 📚 Notes

- Le projet utilise `renv` pour éviter les conflits de versions de packages.
- Le package **Azimuth** est installé manuellement via GitHub et ses dépendances Bioconductor sont gérées automatiquement.
- Si besoin de relancer une session R :

```r
renv::activate()
library(Seurat)
library(presto)
library(Azimuth)
sessionInfo()
```

## ✉️ Contact

Pour toute question : [@Koryums](https://github.com/Koryums)

---

© Altograph 2025

