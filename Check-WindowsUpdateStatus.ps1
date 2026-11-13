# Check-WindowsUpdateStatus.ps1
# Answers the three questions support always asks about updates: which were
# installed last, which update failed, and is a restart still pending?
# Read-only - it installs nothing.

Write-Host "`n=== Last 10 installed updates ===" -ForegroundColor Cyan
Get-HotFix | Sort-Object InstalledOn -Descending |
    Select-Object -First 10 HotFixID, Description, InstalledOn |
    Format-Table -AutoSize

Write-Host "`n=== Recent update results (2 = success, 3 = success with warnings, 4 = failed) ===" -ForegroundColor Cyan
$session = New-Object -ComObject Microsoft.Update.Session
$history = $session.QueryHistory("", 0, 10, $true)
$history | Select-Object Date,
    @{Name = 'Result'; Expression = { $_.ResultCode } },
    Title | Format-Table -AutoSize -Wrap

Write-Host "`n=== Restart pending? ===" -ForegroundColor Cyan
$pending = (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired') -or
           (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending')
if ($pending) {
    Write-Host "YES - a restart is still pending. Restart the PC (do not just shut down)." -ForegroundColor Yellow
} else {
    Write-Host "No restart pending." -ForegroundColor Green
}
