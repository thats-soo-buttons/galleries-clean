$bucket = "wearingofthegreen026"  # Replace with your exact bucket name
$localFolder = "C:\Users\talex\Pictures\Wearing of the Green 2026"
$jsonPath = "C:\Users\talex\Documents\Websites\galleries\public\data\wearingofthegreen2026-images.json"
$maxParallel = 5  # Number of parallel uploads

$fileList = Get-Content $jsonPath | ConvertFrom-Json

$jobs = @()
foreach ($file in $fileList) {
    $filePath = Join-Path $localFolder $file
    if (Test-Path $filePath) {
        $jobs += Start-Job -ScriptBlock {
            param($bucket, $file, $filePath)
            wrangler r2 object put "$bucket/$file" --file "$filePath" --remote
            Write-Host "Uploaded: $file"
        } -ArgumentList $bucket, $file, $filePath
        while ($jobs.Count -ge $maxParallel) {
            $finished = Wait-Job -Job $jobs -Any | Where-Object { $_.State -eq 'Completed' }
            $jobs = $jobs | Where-Object { $_.State -ne 'Completed' }
        }
    } else {
        Write-Host "Missing locally, not uploaded: $file"
    }
}
Wait-Job -Job $jobs
Receive-Job -Job $jobs | Out-Host