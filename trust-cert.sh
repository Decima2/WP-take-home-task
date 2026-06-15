#!/usr/bin/env bash
#
# trust-cert.sh (macOS) - trust the staging self-signed certificate so the
# browser loads https://newsite.com without warnings and the site renders
# with its stylesheet.
#
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

CERT="nginx/certs/newsite.crt"
if [ ! -f "$CERT" ]; then
  echo "ERROR: $CERT not found. Run ./start.sh first."
  exit 1
fi

if [[ "$(uname)" != "Darwin" ]]; then
  echo "macOS-only helper. On Linux/Windows, import nginx/certs/newsite.crt into"
  echo "your browser's trust store, or bypass the warning in the browser."
  exit 1
fi

echo "==> Trusting $CERT in the System keychain (you'll be prompted for sudo)"
sudo security add-trusted-cert -d -r trustRoot \
  -k /Library/Keychains/System.keychain \
  "$(pwd)/$CERT"

echo "==> Done. Fully quit and reopen your browser, then visit https://newsite.com"
