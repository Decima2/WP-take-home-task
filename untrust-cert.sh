#!/usr/bin/env bash
#
# untrust-cert.sh (macOS) - remove the staging self-signed certificate from the
# System keychain when you are finished.
#
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

if [[ "$(uname)" != "Darwin" ]]; then
  echo "macOS-only helper."
  exit 1
fi

echo "==> Removing the newsite.com certificate from the System keychain (sudo)"
sudo security delete-certificate -c newsite.com /Library/Keychains/System.keychain || \
  echo "    (no matching certificate found)"
echo "==> Done."
