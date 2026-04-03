#!/usr/bin/env bash
set -euo pipefail

set +e
docker compose exec vault vault status
status_code=$?
set -e

if [[ "$status_code" -ne 0 && "$status_code" -ne 2 ]]; then
  exit "$status_code"
fi
