#!/usr/bin/env bash
set -euo pipefail

# ===== Config =====

PY_ENV_NAME="sc"
MICROMAMBA_DIR="$HOME/micromamba"
VSCODE_DIR=".vscode"

# ===== Sanity check =====

if ! grep -qiE "Microsoft|WSL" /proc/version; then
echo "[ABORT] Ce script doit être exécuté dans WSL (Ubuntu)." >&2
exit 1
fi

# ===== Système =====

echo "[1/8] Apt update & outils système"
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y r-base build-essential cmake git curl wget unzip libcurl4-openssl-dev libssl-dev libxml2-dev libharfbuzz-dev libfribidi-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev libudunits2-dev libgdal-dev libhdf5-dev

# ===== Micromamba =====

echo "[2/8] Micromamba"
if [ ! -x "$MICROMAMBA_DIR/bin/micromamba" ]; then
mkdir -p "$MICROMAMBA_DIR"
wget -qO /tmp/micromamba.tar.bz2 https://micro.mamba.pm/api/micromamba/linux-64/latest
tar -xvjf /tmp/micromamba.tar.bz2 -C "$MICROMAMBA_DIR" >/dev/null
"$MICROMAMBA_DIR/bin/micromamba" shell init -s bash -r "$MICROMAMBA_DIR" >/dev/null
echo "[info] Relance du shell recommandée après première install micromamba"
fi

Charger le hook micromamba même en script non interactif

if [ -f "$MICROMAMBA_DIR/etc/profile.d/micromamba.sh" ]; then
source "$MICROMAMBA_DIR/etc/profile.d/micromamba.sh"
fi

# ===== Env Python =====

echo "[3/8] Environnement Python ($PY_ENV_NAME)"
if ! micromamba env list | grep -q "^$PY_ENV_NAME\b"; then
micromamba create -y -n "$PY_ENV_NAME" python=3.11
fi
micromamba activate "$PY_ENV_NAME"
python -m pip install --upgrade pip
pip install -U cellbender anndata scanpy jupyterlab radian

# ===== R: renv & packages =====

echo "[4/8] R: renv + packages projet (install dans ~/R)"
mkdir -p "$HOME/R/x86_64-pc-linux-gnu-library"
R_LIBS_USER="$HOME/R/x86_64-pc-linux-gnu-library" Rscript - <<'RSCRIPT'
install.packages("renv", repos = "https://cloud.r-project.org", lib = Sys.getenv("R_LIBS_USER"))
renv::init(bare = TRUE)
renv::install(c(
"Seurat", "Azimuth", "presto", "msigdbr", "fgsea", "UCell", "STACAS",
"httpgd", "languageserver", "styler", "lintr", "SeuratDisk"
))
renv::snapshot()
RSCRIPT

# ===== VS Code settings =====

echo "[5/8] VS Code settings (.vscode/settings.json)"
mkdir -p "$VSCODE_DIR"
cat > "$VSCODE_DIR/settings.json" <<JSON
{
"r.rterm.linux": "$MICROMAMBA_DIR/envs/$PY_ENV_NAME/bin/radian",
"r.bracketedPaste": true,
"r.alwaysUseActiveTerminal": true,
"r.lsp.debug": false,
"r.lsp.diagnostics": true,
"r.rpath.linux": "/usr/bin/R",
"r.sessionWatcher": true,
"jupyter.jupyterServerType": "local",
"python.defaultInterpreterPath": "$MICROMAMBA_DIR/envs/$PY_ENV_NAME/bin/python"
}
JSON

# ===== .Rprofile =====

echo "[6/8] .Rprofile"
if ! grep -q "httpgd" .Rprofile 2>/dev/null; then
cat >> .Rprofile <<'RPROF'

Activer httpgd dans VS Code

try({
if (interactive()) {
options(vsc.viewer = TRUE)
if (!requireNamespace("httpgd", quietly = TRUE)) install.packages("httpgd")
if (Sys.getenv("RSTUDIO") == "") httpgd::hgd()
}
}, silent = TRUE)
RPROF
fi

# ===== Environment.yml =====

echo "[7/8] environment.yml"
cat > environment.yml <<YML
name: $PY_ENV_NAME
channels:

conda-forge
dependencies:

python=3.11

pip

pip:

cellbender

anndata

scanpy

jupyterlab

radian
YML

# ===== Fin =====

echo "[8/8] Done — Activez l'env Python: 'micromamba activate $PY_ENV_NAME'"
echo "[INFO] Pour tester :"
echo "  micromamba activate $PY_ENV_NAME && python -c 'import scanpy; print(scanpy.version)'"
echo "  R -q -e 'library(Seurat); library(Azimuth); sessionInfo()'"

