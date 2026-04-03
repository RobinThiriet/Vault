#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUNTIME_DIR="$ROOT_DIR/.runtime/dev"
PID_FILE="$RUNTIME_DIR/vault.pid"
LOG_FILE="$RUNTIME_DIR/vault.log"

mkdir -p "$RUNTIME_DIR"

if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
  echo "Vault dev est deja demarre (PID $(cat "$PID_FILE"))."
  exit 0
fi

setsid bash -lc "
  cd \"$ROOT_DIR\"
  exec vault server \
    -dev \
    -dev-root-token-id='root' \
    -dev-listen-address='127.0.0.1:8200' \
    >'$LOG_FILE' 2>&1
" &

sleep 1
PID="$(pgrep -f "vault server -dev -dev-root-token-id=root -dev-listen-address=127.0.0.1:8200" | tail -n1)"

if [[ -z "${PID:-}" ]]; then
  echo "Impossible de trouver le processus Vault dev."
  exit 1
fi

echo "$PID" >"$PID_FILE"
sleep 2

echo "Vault dev demarre."
echo "VAULT_ADDR=http://127.0.0.1:8200"
echo "VAULT_TOKEN=root"
echo "Log: $LOG_FILE"
