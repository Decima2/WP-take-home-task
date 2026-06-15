<#
  start.ps1 - boot the Northwind Coffee Co. staging site on Windows (PowerShell).

  Usage (from this folder):
      .\start.ps1

  Requires Docker Desktop (with the WSL2 backend) running. No other tooling
  needed - the TLS certificate is generated inside a container.
#>
$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Error "Docker Desktop is required and must be running."
    exit 1
}

if (-not (Test-Path ".env")) {
    Write-Host "==> Creating .env from .env.example"
    Copy-Item ".env.example" ".env"
}

# Load HTTP_PORT / HTTPS_PORT from .env for the final message (compose reads it directly).
$httpPort = "8080"; $httpsPort = "8443"
foreach ($line in Get-Content ".env") {
    if ($line -match '^\s*HTTP_PORT\s*=\s*(\d+)')  { $httpPort  = $Matches[1] }
    if ($line -match '^\s*HTTPS_PORT\s*=\s*(\d+)') { $httpsPort = $Matches[1] }
}

if (-not (Test-Path "nginx/certs/newsite.crt")) {
    Write-Host "==> Generating a self-signed TLS certificate for newsite.com (via Docker)"
    docker run --rm -v "${PSScriptRoot}/nginx/certs:/certs" --entrypoint openssl wordpress:6.7-php8.2-apache `
        req -x509 -nodes -newkey rsa:2048 -days 825 `
        -keyout /certs/newsite.key -out /certs/newsite.crt `
        -subj "/CN=newsite.com" -addext "subjectAltName=DNS:newsite.com,DNS:oldsite.com"
}

Write-Host "==> Building and starting containers (first run pulls images + imports the database)"
docker compose up -d --build

Write-Host ""
Write-Host "============================================================"
Write-Host "  Northwind Coffee Co. - staging"
Write-Host "============================================================"
Write-Host "  Site:   https://newsite.com:$httpsPort"
Write-Host "  Admin:  https://newsite.com:$httpsPort/wp-admin"
Write-Host ""
Write-Host "  First, map the hostname (one time, Administrator PowerShell):"
Write-Host '      Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "127.0.0.1 newsite.com oldsite.com"'
Write-Host ""
Write-Host "  Self-signed cert: in Chrome/Edge, click the warning and type  thisisunsafe"
Write-Host ""
Write-Host "  See scenario-brief.md for your task."
Write-Host "============================================================"
