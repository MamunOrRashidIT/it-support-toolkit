# Check-DiskSpace.ps1
# Shows free space on every local drive, then lists the largest folders in
# the current user profile. Read-only - it changes nothing.
# Run in PowerShell (no admin needed for the profile part).

Write-Host "`n=== Drive space ===" -ForegroundColor Cyan
Get-PSDrive -PSProvider FileSystem |
    Select-Object Name,
        @{Name = 'Used (GB)';  Expression = { [math]::Round($_.Used / 1GB, 1) } },
        @{Name = 'Free (GB)';  Expression = { [math]::Round($_.Free / 1GB, 1) } } |
    Format-Table -AutoSize

Write-Host "`n=== Largest folders in $env:USERPROFILE (top 10) ===" -ForegroundColor Cyan
Get-ChildItem -Path $env:USERPROFILE -Directory -ErrorAction SilentlyContinue |
    ForEach-Object {
        $size = (Get-ChildItem -Path $_.FullName -Recurse -File -ErrorAction SilentlyContinue |
                 Measure-Object -Property Length -Sum).Sum
        [PSCustomObject]@{ Folder = $_.Name; 'Size (GB)' = [math]::Round($size / 1GB, 2) }
    } |
    Sort-Object 'Size (GB)' -Descending |
    Select-Object -First 10 |
    Format-Table -AutoSize

Write-Host "Tip: a system drive with less than 10% free space will feel slow." -ForegroundColor Yellow
