# Get-SystemInfo.ps1
# Collects the basic facts a support ticket always needs: Windows version,
# PC name, user, RAM, CPU and disk size. Read-only - changes nothing.
# The output can be pasted straight into a helpdesk ticket.

$os  = Get-CimInstance Win32_OperatingSystem
$cs  = Get-CimInstance Win32_ComputerSystem
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1

Write-Host "`n=== System information ===" -ForegroundColor Cyan
Write-Host "PC name        : $env:COMPUTERNAME"
Write-Host "Signed-in user : $env:USERNAME"
Write-Host "Windows        : $($os.Caption) (build $($os.BuildNumber))"
Write-Host "Installed      : $($os.InstallDate)"
Write-Host "Last restart   : $($os.LastBootUpTime)"
Write-Host "Maker / model  : $($cs.Manufacturer) $($cs.Model)"
Write-Host "CPU            : $($cpu.Name)"
Write-Host "RAM            : $([math]::Round($cs.TotalPhysicalMemory / 1GB, 1)) GB"
Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" |
    ForEach-Object {
        Write-Host "Drive $($_.DeviceID)       : $([math]::Round($_.FreeSpace / 1GB, 1)) GB free of $([math]::Round($_.Size / 1GB, 1)) GB"
    }
