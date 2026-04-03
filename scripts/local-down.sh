#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PID_FILE="$ROOT_DIR/.runtime/local/vault.pid"

if [[ ! -f "$PID_FILE" ]]; then
  echo "Aucun PID trouve pour Vault local."
  exit 0
fi

PID="$(cat "$PID_FILE")"
if kill -0 "$PID" 2>/dev/null; then
  kill "$PID"
  echo "Vault local arrete (PID $PID)."
else
  echo "Le processus Vault local n'etait plus actif."
fi

rm -f "$PID_FILE"

