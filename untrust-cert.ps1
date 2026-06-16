<#
  untrust-cert.ps1 (Windows) - remove the staging self-signed certificate from
  the Trusted Root store when you are finished.

  Run in an ELEVATED (Administrator) PowerShell from this folder:
      .\untrust-cert.ps1
#>
$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

$removed = $false
Get-ChildItem "Cert:\LocalMachine\Root" |
    Where-Object { $_.Subject -like "*newsite.com*" } |
    ForEach-Object {
        Write-Host "==> Removing $($_.Thumbprint)  $($_.Subject)"
        Remove-Item -Path ("Cert:\LocalMachine\Root\" + $_.Thumbprint) -Force
        $removed = $true
    }
if (-not $removed) { Write-Host "    (no matching certificate found)" }
Write-Host "==> Done."
