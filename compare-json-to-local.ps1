# PowerShell script to compare JSON list to local folder and show missing files

# Path to your JSON file
$jsonPath = "C:\Users\talex\Documents\Websites\galleries\public\data\wearingofthegreen2026-images.json"
# Path to your local images folder
$localFolder = "C:\Users\talex\Pictures\Wearing of the Green 2026"

# Read JSON filenames
$jsonFilenames = Get-Content $jsonPath | ConvertFrom-Json
# Get local filenames
$localFilenames = Get-ChildItem -Path $localFolder -File | Select-Object -ExpandProperty Name

# Find files in JSON but not in local folder
$missingLocally = $jsonFilenames | Where-Object { $_ -notin $localFilenames }

if ($missingLocally) {
    Write-Host "Files in JSON but missing locally:" -ForegroundColor Yellow
    $missingLocally | ForEach-Object { Write-Host $_ }
} else {
    Write-Host "All JSON files exist in your local folder!" -ForegroundColor Green
}
