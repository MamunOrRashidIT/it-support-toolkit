# Reset-Network.ps1
# Basic network refresh for "connected but no internet": releases and renews
# the IP address, flushes the DNS cache, then shows the new configuration.
# Run in PowerShell as Administrator. The connection drops for a few seconds.

Write-Host "Releasing the current IP address..." -ForegroundColor Cyan
ipconfig /release

Write-Host "Renewing the IP address..." -ForegroundColor Cyan
ipconfig /renew

Write-Host "Flushing the DNS cache..." -ForegroundColor Cyan
ipconfig /flushdns

Write-Host "`n=== Current configuration ===" -ForegroundColor Cyan
ipconfig

Write-Host "`nDone. If there is still no internet, restart the router and the PC." -ForegroundColor Green
