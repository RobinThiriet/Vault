#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INIT_FILE="$ROOT_DIR/.local/keys/init.txt"

export VAULT_ADDR="${VAULT_ADDR:-http://127.0.0.1:8200}"

if [[ ! -f "$INIT_FILE" ]]; then
  echo "Fichier d'initialisation introuvable: $INIT_FILE"
  echo "Lance d'abord: make local-init"
  exit 1
fi

ROOT_TOKEN="$(awk -F': ' '/Initial Root Token/ {print $2}' "$INIT_FILE")"

if [[ -z "$ROOT_TOKEN" ]]; then
  echo "Impossible de lire le root token."
  exit 1
fi

vault login "$ROOT_TOKEN"

