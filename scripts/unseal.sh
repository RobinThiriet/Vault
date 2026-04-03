#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INIT_FILE="$ROOT_DIR/.local/keys/init.txt"

if [[ ! -f "$INIT_FILE" ]]; then
  echo "Fichier d'initialisation introuvable: $INIT_FILE"
  echo "Lance d'abord: make init"
  exit 1
fi

UNSEAL_KEY="$(awk -F': ' '/Unseal Key 1/ {print $2}' "$INIT_FILE")"

if [[ -z "$UNSEAL_KEY" ]]; then
  echo "Impossible de lire la cle de descellement."
  exit 1
fi

docker compose exec vault sh -lc \
  "export VAULT_ADDR=http://127.0.0.1:8200 && vault operator unseal '$UNSEAL_KEY'"

