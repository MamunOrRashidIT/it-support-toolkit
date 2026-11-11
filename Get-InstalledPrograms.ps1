# Get-InstalledPrograms.ps1
# Lists installed desktop programs with version and install date, sorted by
# name, and saves the list as a CSV file on the Desktop for support tickets.
# Read-only - nothing is installed or removed.

$paths = @(
    'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
    'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
)

$programs = Get-ItemProperty $paths -ErrorAction SilentlyContinue |
    Where-Object { $_.DisplayName } |
    Select-Object DisplayName, DisplayVersion, Publisher, InstallDate |
    Sort-Object DisplayName -Unique

$programs | Format-Table -AutoSize

$outFile = Join-Path ([Environment]::GetFolderPath('Desktop')) 'installed-programs.csv'
$programs | Export-Csv -Path $outFile -NoTypeInformation -Encoding UTF8
Write-Host "`n$($programs.Count) programs listed. Saved to $outFile" -ForegroundColor Green
