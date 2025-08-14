#!/bin/bash
# Script de (re)construction de l’environnement R + Azimuth
set -e

echo "🔁 Activation de l'environnement R avec renv"

Rscript -e "
if (!file.exists('renv/activate.R')) {
  install.packages('renv', repos='https://cloud.r-project.org');
  renv::init(bare=TRUE);
} else {
  source('renv/activate.R');
}
"

echo "🔁 Restauration des packages depuis renv.lock"
Rscript -e "renv::restore(confirm=FALSE)"

echo "✅ Environnement R reconstruit avec succès."
