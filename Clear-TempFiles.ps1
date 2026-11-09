# Clear-TempFiles.ps1
# Shows how much space the user temp folder and Windows temp folder use,
# then asks BEFORE deleting anything. Only temp files are touched - never
# documents, downloads or the Recycle Bin.
# Run in PowerShell (admin needed only for the Windows temp folder).

function Get-FolderSizeGB($path) {
    $bytes = (Get-ChildItem -Path $path -Recurse -File -Force -ErrorAction SilentlyContinue |
              Measure-Object -Property Length -Sum).Sum
    return [math]::Round($bytes / 1GB, 2)
}

$folders = @($env:TEMP, "$env:SystemRoot\Temp")
foreach ($folder in $folders) {
    $size = Get-FolderSizeGB $folder
    Write-Host "$folder uses $size GB" -ForegroundColor Cyan
}

$answer = Read-Host "Delete the files inside these temp folders now? Type YES to continue"
if ($answer -eq 'YES') {
    foreach ($folder in $folders) {
        Get-ChildItem -Path $folder -Force -ErrorAction SilentlyContinue |
            Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    }
    Write-Host "Done. Files that were in use were skipped automatically - that is normal." -ForegroundColor Green
} else {
    Write-Host "Nothing was deleted." -ForegroundColor Yellow
}
