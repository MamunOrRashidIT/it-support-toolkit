# Clear-PrintQueue.ps1
# Clears stuck print jobs: stops the Print Spooler service, deletes queued
# job files, and restarts the service. Safe and reversible - no drivers or
# printer settings are touched.
# Run in PowerShell as Administrator.

Write-Host "Stopping the Print Spooler service..." -ForegroundColor Cyan
Stop-Service -Name Spooler -Force -ErrorAction Stop

$spoolPath = "$env:SystemRoot\System32\spool\PRINTERS"
Write-Host "Clearing queued jobs in $spoolPath ..."
Get-ChildItem -Path $spoolPath -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue

Write-Host "Starting the Print Spooler service..." -ForegroundColor Cyan
Start-Service -Name Spooler

Write-Host "Done. Please try printing a test page." -ForegroundColor Green
