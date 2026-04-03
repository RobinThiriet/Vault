#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
KEYS_DIR="$ROOT_DIR/.local/keys"
INIT_FILE="$KEYS_DIR/init.txt"

export VAULT_ADDR="${VAULT_ADDR:-http://127.0.0.1:8200}"

mkdir -p "$KEYS_DIR"

if vault status >/tmp/vault-status.txt 2>&1 && grep -q "Initialized.*true" /tmp/vault-status.txt; then
  echo "Vault est deja initialise."
  echo "Details: $INIT_FILE"
  exit 0
fi

vault operator init -key-shares=1 -key-threshold=1 >"$INIT_FILE"
echo "Initialisation terminee."
echo "Clés et token stockes dans: $INIT_FILE"
echo "Etape suivante: make local-unseal"

