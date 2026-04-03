#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUNTIME_DIR="$ROOT_DIR/.runtime/local"
PID_FILE="$RUNTIME_DIR/vault.pid"
LOG_FILE="$RUNTIME_DIR/vault.log"
CONFIG_FILE="$ROOT_DIR/config/local/vault.hcl"

mkdir -p "$RUNTIME_DIR" "$ROOT_DIR/.local/raft"

if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
  echo "Vault local est deja demarre (PID $(cat "$PID_FILE"))."
  exit 0
fi

setsid bash -lc "
  cd \"$ROOT_DIR\"
  exec vault server -config='$CONFIG_FILE' >'$LOG_FILE' 2>&1
" &

sleep 1
PID="$(pgrep -f "vault server -config=$CONFIG_FILE" | tail -n1)"

if [[ -z "${PID:-}" ]]; then
  echo "Impossible de trouver le processus Vault local."
  exit 1
fi

echo "$PID" >"$PID_FILE"
sleep 2

echo "Vault local demarre."
echo "VAULT_ADDR=http://127.0.0.1:8200"
echo "Log: $LOG_FILE"
echo "Etape suivante: make local-init"
