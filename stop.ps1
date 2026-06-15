<#
  stop.ps1 - stop the staging site on Windows. Your changes are preserved.

  For a full reset back to the original handover state:
      docker compose down -v
      .\start.ps1
#>
$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot
docker compose down
Write-Host "==> Stopped. Run .\start.ps1 to bring it back up (your changes are kept)."
