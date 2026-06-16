#!/usr/bin/env bash
#
# start.sh - boot the Northwind Coffee Co. staging site.
#
#   1) cp .env.example .env   (done automatically if missing)
#   2) ./start.sh
#
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

command -v docker >/dev/null  || { echo "ERROR: Docker is required."; exit 1; }
docker compose version >/dev/null 2>&1 || { echo "ERROR: Docker Compose v2 is required."; exit 1; }

[ -f .env ] || { echo "==> Creating .env from .env.example"; cp .env.example .env; }
# shellcheck disable=SC1091
set -a; source .env; set +a

if [ ! -f nginx/certs/newsite.crt ]; then
  echo "==> Generating a self-signed TLS certificate for newsite.com (via Docker, no host openssl needed)"
  docker run --rm -v "$(pwd)/nginx/certs:/certs" --entrypoint openssl wordpress:6.7-php8.2-apache \
    req -x509 -nodes -newkey rsa:2048 -days 825 \
    -keyout /certs/newsite.key \
    -out    /certs/newsite.crt \
    -subj   "/CN=newsite.com" \
    -addext "subjectAltName=DNS:newsite.com,DNS:oldsite.com" \
    -addext "basicConstraints=critical,CA:TRUE" \
    -addext "keyUsage=critical,digitalSignature,keyCertSign" \
    -addext "extendedKeyUsage=serverAuth"
fi

echo "==> Starting containers (first run pulls images + imports the database)"
docker compose up -d

HTTPS_PORT="${HTTPS_PORT:-443}"
HTTP_PORT="${HTTP_PORT:-80}"
MAILPIT_PORT="${MAILPIT_PORT:-8025}"
if [ "${HTTPS_PORT}" = "443" ]; then SITE="https://newsite.com"; else SITE="https://newsite.com:${HTTPS_PORT}"; fi
cat <<EOF

============================================================
  Northwind Coffee Co. - staging
============================================================
  Site:   ${SITE}
  Admin:  ${SITE}/wp-admin
  Mail:   http://localhost:${MAILPIT_PORT}   (inbox for email the site sends)

  First, map the hostname to your machine (one time, needs sudo):
      echo "127.0.0.1 newsite.com oldsite.com" | sudo tee -a /etc/hosts

  The site uses a self-signed certificate. For a clean padlock:
    - macOS:   run ./trust-cert.sh
    - Windows: run .\\trust-cert.ps1 (Administrator)
  Or bypass: Chrome/Edge type  thisisunsafe  on the warning; Safari -> Show
  Details -> visit this website.

  See scenario-brief.md for your task.
============================================================
EOF
