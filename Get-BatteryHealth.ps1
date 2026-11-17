# Get-BatteryHealth.ps1
# Creates the Windows battery report and shows the two numbers that matter:
# design capacity vs full-charge capacity. The wear percentage tells you
# whether a short battery life is age (normal) or a fault worth reporting.
# Read-only - changes nothing.

$reportPath = Join-Path $env:TEMP 'battery-report.html'
powercfg /batteryreport /output $reportPath | Out-Null

$battery = Get-CimInstance -ClassName Win32_Battery -ErrorAction SilentlyContinue
if (-not $battery) {
    Write-Host "No battery found - this looks like a desktop PC." -ForegroundColor Yellow
    return
}

# Full-charge and design capacity come from the battery static data when available
try {
    $static = Get-CimInstance -Namespace 'ROOT\WMI' -ClassName BatteryStaticData -ErrorAction Stop
    $full   = Get-CimInstance -Namespace 'ROOT\WMI' -ClassName BatteryFullChargedCapacity -ErrorAction Stop
    $wear = 100 - [math]::Round(($full.FullChargedCapacity / $static.DesignedCapacity) * 100, 0)
    Write-Host "Design capacity     : $($static.DesignedCapacity) mWh" -ForegroundColor Cyan
    Write-Host "Full-charge capacity: $($full.FullChargedCapacity) mWh" -ForegroundColor Cyan
    Write-Host "Battery wear        : about $wear %" -ForegroundColor Cyan
    if ($wear -ge 30) {
        Write-Host "Wear over 30% - short runtime is age, not a fault. A replacement is a budget question, not a repair." -ForegroundColor Yellow
    }
} catch {
    Write-Host "Could not read detailed capacity here - open the full report instead." -ForegroundColor Yellow
}

Write-Host "`nFull report saved to $reportPath (double-click to open)." -ForegroundColor Green
