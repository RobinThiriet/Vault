#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
KEYS_DIR="$ROOT_DIR/.local/keys"
INIT_FILE="$KEYS_DIR/init.txt"

mkdir -p "$KEYS_DIR"

if [[ -f "$INIT_FILE" ]]; then
  echo "Vault semble deja initialise."
  echo "Fichier: $INIT_FILE"
  exit 0
fi

docker compose exec -T vault sh -lc \
  "export VAULT_ADDR=http://127.0.0.1:8200 && vault operator init -key-shares=1 -key-threshold=1" \
  >"$INIT_FILE"

echo "Initialisation terminee."
echo "Cles et token stockes dans: $INIT_FILE"
echo "Etape suivante: make unseal"

