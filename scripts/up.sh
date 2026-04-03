#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mkdir -p "$ROOT_DIR/.local/keys" "$ROOT_DIR/vault-data"

docker compose up -d

for _ in $(seq 1 30); do
  if docker compose exec -T vault sh -lc \
    "export VAULT_ADDR=http://127.0.0.1:8200 && vault status >/dev/null 2>&1; code=\$?; [ \"\$code\" = 0 ] || [ \"\$code\" = 2 ]" \
    >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

echo "Vault demarre dans Docker."
echo "UI/API: http://127.0.0.1:8200"
echo "Etape suivante: make init"
