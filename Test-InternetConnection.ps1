# Test-InternetConnection.ps1
# Step-by-step connectivity check for "no internet": gateway first, then a
# public IP, then DNS. Read-only - it only tests, it changes nothing.
# Each step tells you exactly where the connection breaks.

$gateway = (Get-NetRoute -DestinationPrefix '0.0.0.0/0' -ErrorAction SilentlyContinue |
            Select-Object -First 1).NextHop

Write-Host "`n=== Step 1: Router / gateway ($gateway) ===" -ForegroundColor Cyan
if ($gateway) {
    if (Test-Connection -ComputerName $gateway -Count 2 -Quiet) {
        Write-Host "OK - the PC can reach the router." -ForegroundColor Green
    } else {
        Write-Host "FAIL - no answer from the router. Check Wi-Fi/LAN and restart the router." -ForegroundColor Red
    }
} else {
    Write-Host "FAIL - no default gateway. The PC has no network connection at all." -ForegroundColor Red
}

Write-Host "`n=== Step 2: Internet (1.1.1.1) ===" -ForegroundColor Cyan
if (Test-Connection -ComputerName 1.1.1.1 -Count 2 -Quiet) {
    Write-Host "OK - the internet itself is reachable." -ForegroundColor Green
} else {
    Write-Host "FAIL - router reached but no internet. Likely a provider or router problem." -ForegroundColor Red
}

Write-Host "`n=== Step 3: DNS (name lookup) ===" -ForegroundColor Cyan
try {
    Resolve-DnsName microsoft.com -ErrorAction Stop | Out-Null
    Write-Host "OK - DNS names resolve. If only one app fails, the app is the problem." -ForegroundColor Green
} catch {
    Write-Host "FAIL - DNS lookup failed. Try ipconfig /flushdns, or Reset-Network.ps1 from this toolkit." -ForegroundColor Red
}
