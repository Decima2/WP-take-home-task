#!/usr/bin/env bash
#
# stop.sh - stop the staging site. Your changes are preserved (volumes kept).
#
# For a full reset back to the original handover state, run:
#   docker compose down -v && ./start.sh
#
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
docker compose down
echo "==> Stopped. Run ./start.sh to bring it back up (your changes are kept)."
