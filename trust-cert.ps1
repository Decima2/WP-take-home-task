<#
  trust-cert.ps1 (Windows) - trust the staging self-signed certificate so the
  browser loads https://newsite.com without warnings (clean padlock).

  Run in an ELEVATED (Administrator) PowerShell from this folder:
      .\trust-cert.ps1

  Undo later with:  .\untrust-cert.ps1
#>
$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

$cert = "nginx\certs\newsite.crt"
if (-not (Test-Path $cert)) {
    Write-Error "$cert not found. Run .\start.ps1 first."
    exit 1
}

$current = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $current.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "Please run this in an Administrator PowerShell."
    exit 1
}

Write-Host "==> Importing $cert into LocalMachine\Root (Trusted Root Certification Authorities)"
Import-Certificate -FilePath $cert -CertStoreLocation "Cert:\LocalMachine\Root" | Out-Null

Write-Host "==> Done. Fully quit and reopen your browser, then visit https://newsite.com"
