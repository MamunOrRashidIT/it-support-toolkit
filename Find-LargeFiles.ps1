# Find-LargeFiles.ps1
# Finds the largest files in the user profile (default: over 500 MB) so a
# full disk can be cleaned up sensibly. Read-only - deletes nothing.

param(
    [int]$MinSizeMB = 500,
    [string]$Path = $env:USERPROFILE
)

Write-Host "Searching $Path for files over $MinSizeMB MB ..." -ForegroundColor Cyan

Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object { $_.Length -gt ($MinSizeMB * 1MB) } |
    Sort-Object Length -Descending |
    Select-Object -First 25 `
        @{Name = 'Size (GB)'; Expression = { [math]::Round($_.Length / 1GB, 2) } },
        FullName |
    Format-Table -AutoSize -Wrap

Write-Host "Tip: old downloads, ISO files and phone backup folders are the usual space eaters." -ForegroundColor Yellow
